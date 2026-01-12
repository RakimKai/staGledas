using System.Security.Claims;
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
    [Authorize]
    public class KlubKomentariController : BaseCRUDController<KlubKomentari, KlubKomentariSearchObject, KlubKomentariUpsertRequest, KlubKomentariUpsertRequest>
    {
        public KlubKomentariController(IKlubKomentariService service) : base(service)
        {
        }

        public override KlubKomentari Insert([FromBody] KlubKomentariUpsertRequest request)
        {
            request.KorisnikId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            return base.Insert(request);
        }
    }
}
