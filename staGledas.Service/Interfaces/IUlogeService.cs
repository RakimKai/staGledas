using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;

namespace staGledas.Service.Interfaces
{
    public interface IUlogeService : ICRUDService<Uloge, UlogeSearchObject, UlogeUpsertRequest, UlogeUpsertRequest>
    {
    }
}
