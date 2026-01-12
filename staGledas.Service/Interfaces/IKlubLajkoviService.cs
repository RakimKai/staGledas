using staGledas.Model.Models;
using staGledas.Model.SearchObject;

namespace staGledas.Service.Interfaces
{
    public interface IKlubLajkoviService : IService<KlubLajkovi, KlubLajkoviSearchObject>
    {
        Task<bool> ToggleLike(int korisnikId, int objavaId);
        Task<bool> IsLiked(int korisnikId, int objavaId);
        Task<int> GetLikeCount(int objavaId);
    }
}
