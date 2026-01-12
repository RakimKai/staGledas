using staGledas.Model.Models;
using staGledas.Model.SearchObject;

namespace staGledas.Service.Interfaces
{
    public interface IFilmoviLajkoviService : IService<FilmoviLajkovi, FilmoviLajkoviSearchObject>
    {
        Task<bool> ToggleLike(int korisnikId, int filmId);
        Task<bool> IsLiked(int korisnikId, int filmId);
        Task<int> GetLikeCount(int filmId);
    }
}
