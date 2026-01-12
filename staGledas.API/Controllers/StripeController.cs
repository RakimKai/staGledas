using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using staGledas.Model.DTOs.Stripe;
using staGledas.Model.Models;
using staGledas.Service.Interfaces;
using System.Security.Claims;

namespace staGledas.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StripeController : ControllerBase
    {
        private readonly IStripeService _stripeService;

        public StripeController(IStripeService stripeService)
        {
            _stripeService = stripeService;
        }

        [HttpPost("checkout")]
        [Authorize]
        public async Task<StripeCheckoutResponse> CreateCheckoutSession([FromBody] StripeCheckoutRequest request)
        {
            var korisnikId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            return await _stripeService.CreateCheckoutSessionAsync(
                korisnikId,
                request.SuccessUrl ?? "http://localhost:3000/success",
                request.CancelUrl ?? "http://localhost:3000/cancel"
            );
        }

        [HttpPost("payment-sheet")]
        [Authorize]
        public async Task<PaymentSheetResponse> CreatePaymentSheet()
        {
            var korisnikId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            return await _stripeService.CreatePaymentSheetAsync(korisnikId);
        }

        [HttpPost("confirm")]
        [Authorize]
        public async Task<IActionResult> ConfirmSubscription()
        {
            var korisnikId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            var isPremium = await _stripeService.ConfirmSubscriptionAsync(korisnikId);
            return Ok(new { IsPremium = isPremium });
        }

        [HttpPost("webhook")]
        [AllowAnonymous]
        public async Task<IActionResult> Webhook()
        {
            var json = await new StreamReader(HttpContext.Request.Body).ReadToEndAsync();
            var signature = Request.Headers["Stripe-Signature"];

            try
            {
                await _stripeService.HandleWebhookAsync(json, signature!);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = ex.Message });
            }
        }

        [HttpGet("subscription")]
        [Authorize]
        public async Task<ActionResult<Pretplate>> GetSubscription()
        {
            var korisnikId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            var subscription = await _stripeService.GetSubscriptionAsync(korisnikId);
            if (subscription == null)
            {
                return NotFound();
            }
            return subscription;
        }

        [HttpPost("cancel")]
        [Authorize]
        public async Task<IActionResult> CancelSubscription()
        {
            var korisnikId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            await _stripeService.CancelSubscriptionAsync(korisnikId);
            return Ok(new { message = "Pretplata je otkazana." });
        }

        [HttpPost("sync")]
        [Authorize]
        public async Task<IActionResult> SyncSubscription()
        {
            var korisnikId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "0");
            var isPremium = await _stripeService.SyncSubscriptionAsync(korisnikId);
            return Ok(new { IsPremium = isPremium });
        }
    }
}
