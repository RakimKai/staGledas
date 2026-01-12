using MapsterMapper;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;
using staGledas.Service.Database;
using staGledas.Service.Interfaces;

namespace staGledas.Service.Services
{
    public class UlogeService : BaseCRUDService<Model.Models.Uloge, UlogeSearchObject, Database.Uloge, UlogeUpsertRequest, UlogeUpsertRequest>, IUlogeService
    {
        public UlogeService(StaGledasContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
        }

        public override IQueryable<Database.Uloge> AddFilter(UlogeSearchObject searchObject, IQueryable<Database.Uloge> query)
        {
            var filteredQuery = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject?.NazivGTE))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv != null && x.Naziv.StartsWith(searchObject.NazivGTE));
            }

            return filteredQuery;
        }
    }
}
