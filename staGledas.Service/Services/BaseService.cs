using MapsterMapper;
using staGledas.Model.Helpers;
using staGledas.Model.SearchObject;
using staGledas.Service.Database;
using staGledas.Service.Interfaces;

namespace staGledas.Service.Services
{
    public abstract class BaseService<TModel, TSearch, TDbEntity> : IService<TModel, TSearch> where TSearch : BaseSearchObject where TDbEntity : class where TModel : class
    {
        public StaGledasContext Context { get; set; }
        public IMapper Mapper { get; set; }

        public BaseService(StaGledasContext dbContext, IMapper mapper)
        {
            Context = dbContext;
            Mapper = mapper;
        }

        public PagedResult<TModel> GetPaged(TSearch searchObject)
        {
            var query = Context.Set<TDbEntity>().AsQueryable();

            query = AddFilter(searchObject, query);

            int count = query.Count();

            if (searchObject?.Page.HasValue == true && searchObject?.PageSize.HasValue == true)
            {
                int skip = searchObject.Page.Value - 1;
                query = query.Skip(skip * searchObject.PageSize.Value).Take(searchObject.PageSize.Value);
            }

            var list = query.ToList();

            var result = list.Select(entity => MapToModel(entity)).ToList();

            PagedResult<TModel> paged = new PagedResult<TModel>();

            paged.Results = result;
            paged.Count = count;

            return paged;
        }

        public virtual TModel MapToModel(TDbEntity entity)
        {
            return Mapper.Map<TModel>(entity);
        }

        public virtual IQueryable<TDbEntity> AddFilter(TSearch searchObject, IQueryable<TDbEntity> query)
        {
            return query;
        }

        public virtual TModel GetById(int id)
        {
            var entity = Context.Set<TDbEntity>().Find(id);

            if (entity != null)
            {
                return MapToModel(entity);
            }
            else
            {
                return null!;
            }
        }
    }
}
