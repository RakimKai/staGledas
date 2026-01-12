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
    public class ZalbeController : BaseCRUDController<Zalbe, ZalbeSearchObject, ZalbeInsertRequest, ZalbeUpdateRequest>
    {
        private readonly IZalbeService _zalbeService;

        public ZalbeController(IZalbeService service) : base(service)
        {
            _zalbeService = service;
        }

        [HttpPost]
        public override Zalbe Insert([FromBody] ZalbeInsertRequest request)
        {
            var korisnikId = GetCurrentUserId();
            if (korisnikId == null)
            {
                throw new UnauthorizedAccessException("User not authenticated");
            }
            return _zalbeService.Insert(request, korisnikId.Value);
        }

        [HttpPut("{id}/approve")]
        public Zalbe Approve(int id)
        {
            var adminId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            return _zalbeService.Approve(id, adminId);
        }

        [HttpPut("{id}/reject")]
        public Zalbe Reject(int id)
        {
            var adminId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            return _zalbeService.Reject(id, adminId);
        }

        [HttpGet("{id}/allowed-actions")]
        public List<string> AllowedActions(int id)
        {
            return _zalbeService.AllowedActions(id);
        }
    }
}
