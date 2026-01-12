using System;

namespace staGledas.Model.Models
{
    public class Pretplate
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public string? StripeCustomerId { get; set; }
        public string? StripeSubscriptionId { get; set; }
        public string? Status { get; set; }
        public DateTime? DatumPocetka { get; set; }
        public DateTime? DatumIsteka { get; set; }
        public DateTime DatumKreiranja { get; set; }
        public virtual Korisnici? Korisnik { get; set; }
    }
}
