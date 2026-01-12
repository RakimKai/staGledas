using System.Collections.Generic;

namespace staGledas.Model.Helpers
{
    public class PagedResult<T>
    {
        public List<T>? Results { get; set; }
        public int? Count { get; set; }
    }
}
