namespace staGledas.Model.SearchObject
{
    public class PorukeSearchObject : BaseSearchObject
    {
        public int? PosiljateljId { get; set; }
        public int? PrimateljId { get; set; }
        public bool? Procitano { get; set; }
        public string? OrderBy { get; set; }
        public bool? IsPosiljateljIncluded { get; set; }
        public bool? IsPrimateljIncluded { get; set; }
    }
}
