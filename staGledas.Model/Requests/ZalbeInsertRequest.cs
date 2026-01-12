namespace staGledas.Model.Requests
{
    public class ZalbeInsertRequest
    {
        public int RecenzijaId { get; set; }
        public string? Razlog { get; set; }
        public string? Opis { get; set; }
    }
}
