using staGledas.Model.DTOs.Stripe;
using staGledas.Model.Models;

namespace staGledas.Service.Interfaces
{
    public interface IStripeService
    {
        Task<StripeCheckoutResponse> CreateCheckoutSessionAsync(int korisnikId, string successUrl, string cancelUrl);
        Task<PaymentSheetResponse> CreatePaymentSheetAsync(int korisnikId);
        Task<bool> ConfirmSubscriptionAsync(int korisnikId);
        Task<Pretplate> HandleWebhookAsync(string json, string signature);
        Task<Pretplate?> GetSubscriptionAsync(int korisnikId);
        Task<bool> CancelSubscriptionAsync(int korisnikId);
        Task<bool> SyncSubscriptionAsync(int korisnikId);
    }
}
