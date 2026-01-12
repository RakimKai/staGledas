using staGledas.Model.SearchObject;

namespace staGledas.Service.Interfaces
{
    public interface ICRUDService<TModel, TSearch, TInsert, TUpdate> : IService<TModel, TSearch> where TSearch : BaseSearchObject where TModel : class
    {
        TModel Insert(TInsert request);
        TModel Update(int id, TUpdate request);
        TModel Delete(int id);
    }
}
