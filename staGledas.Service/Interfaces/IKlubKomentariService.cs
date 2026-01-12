using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;

namespace staGledas.Service.Interfaces
{
    public interface IKlubKomentariService : ICRUDService<KlubKomentari, KlubKomentariSearchObject, KlubKomentariUpsertRequest, KlubKomentariUpsertRequest>
    {
    }
}
