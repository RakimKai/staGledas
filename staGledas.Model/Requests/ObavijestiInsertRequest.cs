namespace staGledas.Model.Requests
{
    public class ObavijestiInsertRequest
    {
        public string Tip { get; set; } = null!;
        public int PosiljateljId { get; set; }
        public int PrimateljId { get; set; }
        public int? KlubId { get; set; }
        public string? Poruka { get; set; }
    }
}
