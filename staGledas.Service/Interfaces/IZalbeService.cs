using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;

namespace staGledas.Service.Interfaces
{
    public interface IZalbeService : ICRUDService<Zalbe, ZalbeSearchObject, ZalbeInsertRequest, ZalbeUpdateRequest>
    {
        Zalbe Insert(ZalbeInsertRequest request, int korisnikId);
        Zalbe Approve(int id, int adminId);
        Zalbe Reject(int id, int adminId);
        List<string> AllowedActions(int id);
    }
}
