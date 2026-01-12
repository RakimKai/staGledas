using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;

namespace staGledas.Service.Interfaces
{
    public interface IRecenzijeService : ICRUDService<Recenzije, RecenzijeSearchObject, RecenzijeUpsertRequest, RecenzijeUpsertRequest>
    {
    }
}
