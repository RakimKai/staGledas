using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;

namespace staGledas.Service.Interfaces
{
    public interface INovostiService : ICRUDService<Novosti, NovostiSearchObject, NovostiUpsertRequest, NovostiUpsertRequest>
    {
    }
}
