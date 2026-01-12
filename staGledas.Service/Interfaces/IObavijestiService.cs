using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;

namespace staGledas.Service.Interfaces
{
    public interface IObavijestiService : IService<Obavijesti, ObavijestiSearchObject>
    {
        Obavijesti Insert(ObavijestiInsertRequest request);
        Obavijesti Approve(int id, int approvedById);
        Obavijesti Reject(int id, int rejectedById);
        Obavijesti MarkAsRead(int id);
        int GetUnreadCount(int korisnikId);
    }
}
