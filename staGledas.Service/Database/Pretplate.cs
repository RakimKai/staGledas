using System;

namespace staGledas.Service.Database
{
    public class Pretplate
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public string? StripeCustomerId { get; set; }
        public string? StripeSubscriptionId { get; set; }
        public string? StripePriceId { get; set; }
        public string Status { get; set; } = "inactive"; // active, inactive, cancelled, past_due
        public DateTime? DatumPocetka { get; set; }
        public DateTime? DatumIsteka { get; set; }
        public DateTime DatumKreiranja { get; set; }
        public DateTime? DatumIzmjene { get; set; }
        public virtual Korisnici? Korisnik { get; set; }
    }
}
