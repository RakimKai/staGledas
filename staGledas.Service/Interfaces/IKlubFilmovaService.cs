using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;

namespace staGledas.Service.Interfaces
{
    public interface IKlubFilmovaService : ICRUDService<KlubFilmova, KlubFilmovaSearchObject, KlubFilmovaInsertRequest, KlubFilmovaUpdateRequest>
    {
        KlubFilmova Join(int klubId, int korisnikId);
        KlubFilmova Leave(int klubId, int korisnikId);
        List<KlubFilmovaClanovi> GetMembers(int klubId);
        void DeleteClub(int klubId, int korisnikId);
        void KickMember(int klubId, int memberId, int ownerId);
    }
}
