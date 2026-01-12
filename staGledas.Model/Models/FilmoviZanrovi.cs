namespace staGledas.Model.Models
{
    public class FilmoviZanrovi
    {
        public int Id { get; set; }
        public int FilmId { get; set; }
        public int ZanrId { get; set; }
        public virtual Filmovi? Film { get; set; }
        public virtual Zanrovi? Zanr { get; set; }
    }
}
