using Microsoft.AspNetCore.Mvc;
using staGledas.Model.Models;
using staGledas.Model.Requests;
using staGledas.Model.SearchObject;
using staGledas.Service.Interfaces;

namespace staGledas.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UlogeController : BaseCRUDController<Uloge, UlogeSearchObject, UlogeUpsertRequest, UlogeUpsertRequest>
    {
        public UlogeController(IUlogeService service) : base(service)
        {
        }
    }
}
