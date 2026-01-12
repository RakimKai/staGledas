using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;
using staGledas.Service.Interfaces;
using System.Security.Claims;

namespace staGledas.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class KlubObjaveController : BaseCRUDController<KlubObjave, KlubObjaveSearchObject, KlubObjaveUpsertRequest, KlubObjaveUpsertRequest>
    {
        public KlubObjaveController(IKlubObjaveService service) : base(service)
        {
        }

        public override KlubObjave Insert([FromBody] KlubObjaveUpsertRequest request)
        {
            request.KorisnikId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            return base.Insert(request);
        }
    }
}
