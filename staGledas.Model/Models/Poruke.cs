using System;

namespace staGledas.Model.Models
{
    public class Poruke
    {
        public int Id { get; set; }
        public int PosiljateljId { get; set; }
        public int PrimateljId { get; set; }
        public string? Sadrzaj { get; set; }
        public bool Procitano { get; set; }
        public DateTime DatumSlanja { get; set; }
        public DateTime? DatumCitanja { get; set; }
        public virtual Korisnici? Posiljatelj { get; set; }
        public virtual Korisnici? Primatelj { get; set; }
    }
}
