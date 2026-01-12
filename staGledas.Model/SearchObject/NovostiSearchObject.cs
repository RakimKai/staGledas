namespace staGledas.Model.SearchObject
{
    public class NovostiSearchObject : BaseSearchObject
    {
        public string? NaslovGTE { get; set; }
        public int? AutorId { get; set; }
        public string? OrderBy { get; set; }
        public bool? IsAutorIncluded { get; set; }
    }
}
