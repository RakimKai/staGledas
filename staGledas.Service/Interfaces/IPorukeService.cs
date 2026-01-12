using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;

namespace staGledas.Service.Interfaces
{
    public interface IPorukeService : ICRUDService<Poruke, PorukeSearchObject, PorukeInsertRequest, PorukeInsertRequest>
    {
        Poruke Insert(PorukeInsertRequest request, int posiljateljId);
        Poruke MarkAsRead(int id);
    }
}
