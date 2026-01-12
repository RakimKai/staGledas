using System;

namespace staGledas.Service.Database
{
    public class Obavijesti
    {
        public int Id { get; set; }
        public string Tip { get; set; } = null!;
        public int PosiljateljId { get; set; }
        public int PrimateljId { get; set; }
        public int? KlubId { get; set; }
        public string? Poruka { get; set; }
        public string Status { get; set; } = "pending";
        public bool Procitano { get; set; } = false;
        public DateTime DatumKreiranja { get; set; }
        public DateTime? DatumObrade { get; set; }

        public virtual Korisnici Posiljatelj { get; set; } = null!;
        public virtual Korisnici Primatelj { get; set; } = null!;
        public virtual KlubFilmova? Klub { get; set; }
    }
}
