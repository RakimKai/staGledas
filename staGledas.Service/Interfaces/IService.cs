using staGledas.Model.Helpers;
using staGledas.Model.SearchObject;

namespace staGledas.Service.Interfaces
{
    public interface IService<TModel, TSearch> where TSearch : BaseSearchObject
    {
        PagedResult<TModel> GetPaged(TSearch searchObject);
        TModel GetById(int id);
    }
}
