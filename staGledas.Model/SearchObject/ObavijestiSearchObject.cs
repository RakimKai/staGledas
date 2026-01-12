namespace staGledas.Model.SearchObject
{
    public class ObavijestiSearchObject : BaseSearchObject
    {
        public int? PrimateljId { get; set; }
        public int? PosiljateljId { get; set; }
        public string? Tip { get; set; }
        public string? Status { get; set; }
        public bool? Procitano { get; set; }
        public int? KlubId { get; set; }
        public bool IsPosiljateljIncluded { get; set; }
        public bool IsKlubIncluded { get; set; }
        public string? OrderBy { get; set; }
    }
}
