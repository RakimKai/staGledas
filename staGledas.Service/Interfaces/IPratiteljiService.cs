using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;

namespace staGledas.Service.Interfaces
{
    public interface IPratiteljiService : ICRUDService<Pratitelji, PratiteljiSearchObject, PratiteljiInsertRequest, PratiteljiInsertRequest>
    {
        Pratitelji Insert(PratiteljiInsertRequest request, int pratiteljId);
    }
}
