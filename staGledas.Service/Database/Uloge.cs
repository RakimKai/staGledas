using System.Collections.Generic;

namespace staGledas.Service.Database
{
    public class Uloge
    {
        public int Id { get; set; }
        public string? Naziv { get; set; }
        public string? Opis { get; set; }
        public virtual ICollection<KorisniciUloge> KorisniciUloge { get; set; } = new List<KorisniciUloge>();
    }
}
