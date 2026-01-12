namespace staGledas.Model.SearchObject
{
    public class FilmoviSearchObject : BaseSearchObject
    {
        public string? Naslov { get; set; }
        public int? GodinaOd { get; set; }
        public int? GodinaDo { get; set; }
        public int? ZanrId { get; set; }
        public double? MinOcjena { get; set; }
        public string? OrderBy { get; set; }
        public bool? IsZanroviIncluded { get; set; }
    }
}
