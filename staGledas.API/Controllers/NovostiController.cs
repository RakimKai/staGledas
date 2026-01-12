using Microsoft.AspNetCore.Mvc;
using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;
using staGledas.Service.Interfaces;

namespace staGledas.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NovostiController : BaseCRUDController<Novosti, NovostiSearchObject, NovostiUpsertRequest, NovostiUpsertRequest>
    {
        public NovostiController(INovostiService service) : base(service)
        {
        }

        public override Novosti Insert(NovostiUpsertRequest request)
        {
            request.AutorId = GetCurrentUserId();
            return base.Insert(request);
        }
    }
}
