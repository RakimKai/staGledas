using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;
using staGledas.Service.Interfaces;

namespace staGledas.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RecenzijeController : BaseCRUDController<Recenzije, RecenzijeSearchObject, RecenzijeUpsertRequest, RecenzijeUpsertRequest>
    {
        public RecenzijeController(IRecenzijeService service) : base(service)
        {
        }

        [Authorize]
        public override Recenzije Insert(RecenzijeUpsertRequest request)
        {
            request.KorisnikId = GetCurrentUserId();
            return base.Insert(request);
        }
    }
}
