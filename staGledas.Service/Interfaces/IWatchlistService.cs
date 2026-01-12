using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;
using System.Threading.Tasks;

namespace staGledas.Service.Interfaces
{
    public interface IWatchlistService : ICRUDService<Watchlist, WatchlistSearchObject, WatchlistUpsertRequest, WatchlistUpsertRequest>
    {
        Task<bool> ToggleWatchlist(int korisnikId, int filmId);
        Task<bool> IsInWatchlist(int korisnikId, int filmId);
        Task<bool> MarkAsWatched(int korisnikId, int filmId);
        Task<bool> IsWatched(int korisnikId, int filmId);
    }
}
