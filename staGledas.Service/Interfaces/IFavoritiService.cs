using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;

namespace staGledas.Service.Interfaces
{
    public interface IFavoritiService : ICRUDService<Favoriti, FavoritiSearchObject, FavoritiUpsertRequest, FavoritiUpsertRequest>
    {
        Task<bool> ToggleFavorit(int korisnikId, int filmId);
        Task<bool> IsFavorit(int korisnikId, int filmId);
    }
}
