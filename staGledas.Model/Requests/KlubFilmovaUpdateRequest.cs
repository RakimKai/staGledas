namespace staGledas.Model.Requests
{
    public class KlubFilmovaUpdateRequest
    {
        public string? Naziv { get; set; }
        public string? Opis { get; set; }
        public byte[]? Slika { get; set; }
        public bool? IsPrivate { get; set; }
        public int? MaxClanova { get; set; }
    }
}
