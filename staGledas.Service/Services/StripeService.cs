using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using staGledas.Model.DTOs.Stripe;
using staGledas.Model.Exceptions;
using staGledas.Service.Database;
using staGledas.Service.Interfaces;
using Stripe;
using Stripe.Checkout;

namespace staGledas.Service.Services
{
    public class StripeService : IStripeService
    {
        private readonly StaGledasContext _context;
        private readonly IMapper _mapper;
        private readonly IEmailService _emailService;
        private readonly string _secretKey;
        private readonly string _publishableKey;
        private readonly string _webhookSecret;
        private readonly string _priceId;

        public StripeService(StaGledasContext context, IMapper mapper, IConfiguration configuration, IEmailService emailService)
        {
            _context = context;
            _mapper = mapper;
            _emailService = emailService;
            _secretKey = configuration["Stripe:SecretKey"] ?? throw new Exception("Stripe SecretKey not configured");
            _publishableKey = configuration["Stripe:PublishableKey"] ?? throw new Exception("Stripe PublishableKey not configured");
            _webhookSecret = configuration["Stripe:WebhookSecret"] ?? "";
            _priceId = configuration["Stripe:PriceId"] ?? throw new Exception("Stripe PriceId not configured");

            StripeConfiguration.ApiKey = _secretKey;
        }

        public async Task<StripeCheckoutResponse> CreateCheckoutSessionAsync(int korisnikId, string successUrl, string cancelUrl)
        {
            var korisnik = await _context.Korisnici.FindAsync(korisnikId);
            if (korisnik == null)
            {
                throw new UserException("Korisnik ne postoji.");
            }

            if (korisnik.IsPremium == true)
            {
                throw new UserException("Već imate premium pretplatu.");
            }

            var existingPretplata = await _context.Pretplate.FirstOrDefaultAsync(p => p.KorisnikId == korisnikId);
            string customerId;

            if (existingPretplata?.StripeCustomerId != null)
            {
                customerId = existingPretplata.StripeCustomerId;
            }
            else
            {
                var customerService = new CustomerService();
                var customer = await customerService.CreateAsync(new CustomerCreateOptions
                {
                    Email = korisnik.Email,
                    Name = $"{korisnik.Ime} {korisnik.Prezime}",
                    Metadata = new Dictionary<string, string>
                    {
                        { "korisnikId", korisnikId.ToString() }
                    }
                });
                customerId = customer.Id;

                if (existingPretplata == null)
                {
                    existingPretplata = new Database.Pretplate
                    {
                        KorisnikId = korisnikId,
                        StripeCustomerId = customerId,
                        Status = "inactive",
                        DatumKreiranja = DateTime.Now
                    };
                    _context.Pretplate.Add(existingPretplata);
                }
                else
                {
                    existingPretplata.StripeCustomerId = customerId;
                }
                await _context.SaveChangesAsync();
            }

            var sessionService = new SessionService();
            var session = await sessionService.CreateAsync(new SessionCreateOptions
            {
                Customer = customerId,
                PaymentMethodTypes = new List<string> { "card" },
                LineItems = new List<SessionLineItemOptions>
                {
                    new SessionLineItemOptions
                    {
                        Price = _priceId,
                        Quantity = 1
                    }
                },
                Mode = "subscription",
                SuccessUrl = successUrl + "?session_id={CHECKOUT_SESSION_ID}",
                CancelUrl = cancelUrl,
                Metadata = new Dictionary<string, string>
                {
                    { "korisnikId", korisnikId.ToString() }
                }
            });

            return new StripeCheckoutResponse
            {
                SessionId = session.Id,
                Url = session.Url
            };
        }

        public async Task<PaymentSheetResponse> CreatePaymentSheetAsync(int korisnikId)
        {
            var korisnik = await _context.Korisnici.FindAsync(korisnikId);
            if (korisnik == null)
            {
                throw new UserException("Korisnik ne postoji.");
            }

            if (korisnik.IsPremium == true)
            {
                throw new UserException("Već imate premium pretplatu.");
            }

            var pretplata = await _context.Pretplate.FirstOrDefaultAsync(p => p.KorisnikId == korisnikId);
            string customerId;

            if (pretplata?.StripeCustomerId != null)
            {
                customerId = pretplata.StripeCustomerId;
            }
            else
            {
                var customerService = new CustomerService();
                var customer = await customerService.CreateAsync(new CustomerCreateOptions
                {
                    Email = korisnik.Email,
                    Name = $"{korisnik.Ime} {korisnik.Prezime}",
                    Metadata = new Dictionary<string, string>
                    {
                        { "korisnikId", korisnikId.ToString() }
                    }
                });
                customerId = customer.Id;

                if (pretplata == null)
                {
                    pretplata = new Database.Pretplate
                    {
                        KorisnikId = korisnikId,
                        StripeCustomerId = customerId,
                        Status = "incomplete",
                        DatumKreiranja = DateTime.Now
                    };
                    _context.Pretplate.Add(pretplata);
                }
                else
                {
                    pretplata.StripeCustomerId = customerId;
                }
                await _context.SaveChangesAsync();
            }

            var subscriptionService = new SubscriptionService();
            var subscription = await subscriptionService.CreateAsync(new SubscriptionCreateOptions
            {
                Customer = customerId,
                Items = new List<SubscriptionItemOptions>
                {
                    new SubscriptionItemOptions { Price = _priceId }
                },
                PaymentBehavior = "default_incomplete",
                PaymentSettings = new SubscriptionPaymentSettingsOptions
                {
                    SaveDefaultPaymentMethod = "on_subscription"
                },
                Expand = new List<string> { "latest_invoice.payment_intent" }
            });

            pretplata.StripeSubscriptionId = subscription.Id;
            pretplata.Status = "incomplete";
            await _context.SaveChangesAsync();

            var ephemeralKeyService = new EphemeralKeyService();
            var ephemeralKey = await ephemeralKeyService.CreateAsync(new EphemeralKeyCreateOptions
            {
                Customer = customerId,
                StripeVersion = "2024-04-10"
            });

            var invoice = subscription.LatestInvoice;
            var paymentIntent = invoice?.PaymentIntent;

            return new PaymentSheetResponse
            {
                PaymentIntent = paymentIntent?.ClientSecret,
                EphemeralKey = ephemeralKey.Secret,
                Customer = customerId,
                PublishableKey = _publishableKey
            };
        }

        public async Task<bool> ConfirmSubscriptionAsync(int korisnikId)
        {
            var pretplata = await _context.Pretplate.FirstOrDefaultAsync(p => p.KorisnikId == korisnikId);
            if (pretplata == null || string.IsNullOrEmpty(pretplata.StripeSubscriptionId))
            {
                return false;
            }

            var subscriptionService = new SubscriptionService();
            var subscription = await subscriptionService.GetAsync(pretplata.StripeSubscriptionId);

            if (subscription.Status == "active")
            {
                pretplata.Status = "active";
                pretplata.DatumPocetka = subscription.CurrentPeriodStart;
                pretplata.DatumIsteka = subscription.CurrentPeriodEnd;
                pretplata.DatumIzmjene = DateTime.Now;

                var korisnik = await _context.Korisnici.FindAsync(korisnikId);
                if (korisnik != null)
                {
                    korisnik.IsPremium = true;
                    korisnik.DatumIzmjene = DateTime.Now;

                    if (!string.IsNullOrWhiteSpace(korisnik.Email))
                    {
                        _emailService.SendPremiumActivatedEmail(korisnik.Email, korisnik.Ime ?? korisnik.KorisnickoIme ?? "Korisniče");
                    }
                }

                await _context.SaveChangesAsync();
                return true;
            }

            return false;
        }

        public async Task<Model.Models.Pretplate> HandleWebhookAsync(string json, string signature)
        {
            Event stripeEvent;
            try
            {
                stripeEvent = EventUtility.ConstructEvent(json, signature, _webhookSecret);
            }
            catch (StripeException)
            {
                throw new UserException("Invalid webhook signature.");
            }

            Database.Pretplate? pretplata = null;

            switch (stripeEvent.Type)
            {
                case "checkout.session.completed":
                    var session = stripeEvent.Data.Object as Session;
                    if (session != null)
                    {
                        pretplata = await HandleCheckoutCompleted(session);
                    }
                    break;

                case "customer.subscription.updated":
                case "customer.subscription.deleted":
                    var subscription = stripeEvent.Data.Object as Subscription;
                    if (subscription != null)
                    {
                        pretplata = await HandleSubscriptionUpdated(subscription);
                    }
                    break;

                case "invoice.payment_failed":
                    var invoice = stripeEvent.Data.Object as Invoice;
                    if (invoice != null)
                    {
                        pretplata = await HandlePaymentFailed(invoice);
                    }
                    break;
            }

            return _mapper.Map<Model.Models.Pretplate>(pretplata);
        }

        private async Task<Database.Pretplate?> HandleCheckoutCompleted(Session session)
        {
            var pretplata = await _context.Pretplate.FirstOrDefaultAsync(p => p.StripeCustomerId == session.CustomerId);
            if (pretplata == null) return null;

            pretplata.StripeSubscriptionId = session.SubscriptionId;
            pretplata.Status = "active";
            pretplata.DatumPocetka = DateTime.Now;
            pretplata.DatumIzmjene = DateTime.Now;

            var korisnik = await _context.Korisnici.FindAsync(pretplata.KorisnikId);
            if (korisnik != null)
            {
                korisnik.IsPremium = true;
                korisnik.DatumIzmjene = DateTime.Now;

                if (!string.IsNullOrWhiteSpace(korisnik.Email))
                {
                    _emailService.SendPremiumActivatedEmail(korisnik.Email, korisnik.Ime ?? korisnik.KorisnickoIme ?? "Korisniče");
                }
            }

            await _context.SaveChangesAsync();
            return pretplata;
        }

        private async Task<Database.Pretplate?> HandleSubscriptionUpdated(Subscription subscription)
        {
            var pretplata = await _context.Pretplate.FirstOrDefaultAsync(p => p.StripeSubscriptionId == subscription.Id);
            if (pretplata == null) return null;

            pretplata.Status = subscription.Status;
            pretplata.DatumIzmjene = DateTime.Now;

            if (subscription.CurrentPeriodEnd != null)
            {
                pretplata.DatumIsteka = subscription.CurrentPeriodEnd;
            }

            var korisnik = await _context.Korisnici.FindAsync(pretplata.KorisnikId);
            if (korisnik != null)
            {
                korisnik.IsPremium = subscription.Status == "active";
                korisnik.DatumIzmjene = DateTime.Now;
            }

            await _context.SaveChangesAsync();
            return pretplata;
        }

        private async Task<Database.Pretplate?> HandlePaymentFailed(Invoice invoice)
        {
            var pretplata = await _context.Pretplate.FirstOrDefaultAsync(p => p.StripeSubscriptionId == invoice.SubscriptionId);
            if (pretplata == null) return null;

            pretplata.Status = "past_due";
            pretplata.DatumIzmjene = DateTime.Now;

            await _context.SaveChangesAsync();
            return pretplata;
        }

        public async Task<Model.Models.Pretplate?> GetSubscriptionAsync(int korisnikId)
        {
            var pretplata = await _context.Pretplate
                .Include(p => p.Korisnik)
                .FirstOrDefaultAsync(p => p.KorisnikId == korisnikId);

            return _mapper.Map<Model.Models.Pretplate>(pretplata);
        }

        public async Task<bool> CancelSubscriptionAsync(int korisnikId)
        {
            var pretplata = await _context.Pretplate.FirstOrDefaultAsync(p => p.KorisnikId == korisnikId);
            if (pretplata == null || string.IsNullOrEmpty(pretplata.StripeSubscriptionId))
            {
                throw new UserException("Nemate aktivnu pretplatu.");
            }

            var subscriptionService = new SubscriptionService();
            await subscriptionService.CancelAsync(pretplata.StripeSubscriptionId);

            pretplata.Status = "cancelled";
            pretplata.DatumIzmjene = DateTime.Now;

            var korisnik = await _context.Korisnici.FindAsync(korisnikId);
            if (korisnik != null)
            {
                korisnik.IsPremium = false;
                korisnik.DatumIzmjene = DateTime.Now;
            }

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> SyncSubscriptionAsync(int korisnikId)
        {
            var pretplata = await _context.Pretplate.FirstOrDefaultAsync(p => p.KorisnikId == korisnikId);
            if (pretplata == null || string.IsNullOrEmpty(pretplata.StripeCustomerId))
            {
                return false;
            }

            var subscriptionService = new SubscriptionService();
            var subscriptions = await subscriptionService.ListAsync(new SubscriptionListOptions
            {
                Customer = pretplata.StripeCustomerId,
                Status = "active"
            });

            var korisnik = await _context.Korisnici.FindAsync(korisnikId);

            if (subscriptions.Data.Any())
            {
                var activeSub = subscriptions.Data.First();
                pretplata.StripeSubscriptionId = activeSub.Id;
                pretplata.Status = "active";
                pretplata.DatumPocetka = activeSub.CurrentPeriodStart;
                pretplata.DatumIsteka = activeSub.CurrentPeriodEnd;
                pretplata.DatumIzmjene = DateTime.Now;

                if (korisnik != null)
                {
                    korisnik.IsPremium = true;
                    korisnik.DatumIzmjene = DateTime.Now;
                }

                await _context.SaveChangesAsync();
                return true;
            }
            else
            {
                pretplata.Status = "inactive";
                pretplata.DatumIzmjene = DateTime.Now;

                if (korisnik != null)
                {
                    korisnik.IsPremium = false;
                    korisnik.DatumIzmjene = DateTime.Now;
                }

                await _context.SaveChangesAsync();
                return false;
            }
        }
    }
}
