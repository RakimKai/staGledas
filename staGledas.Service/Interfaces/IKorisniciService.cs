using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;

namespace staGledas.Service.Interfaces
{
    public interface IKorisniciService : ICRUDService<Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        Korisnici? Login(string username, string password);
        Task<UserProfile> GetProfile(int id);
        Task<UserStatistics> GetStatistics(int id);
        Task<List<Filmovi>> GetFavoriti(int id);
        Task<List<Filmovi>> GetLajkovi(int id);
        Task<List<Filmovi>> GetNedavnoPogledano(int id);
        Task<OnboardingResponse> ProcessOnboarding(int korisnikId, OnboardingRequest request);
        Task<bool> ChangePassword(int korisnikId, ChangePasswordRequest request);
        Task<bool> DeleteAccount(int korisnikId, string password);
    }
}
