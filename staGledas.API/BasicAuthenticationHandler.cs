using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;
using staGledas.Service.Interfaces;

namespace staGledas.API
{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        private readonly IKorisniciService _korisniciService;

        public BasicAuthenticationHandler(
            IOptionsMonitor<AuthenticationSchemeOptions> options,
            ILoggerFactory logger,
            UrlEncoder encoder,
            IKorisniciService korisniciService) : base(options, logger, encoder)
        {
            _korisniciService = korisniciService;
        }

        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            string? authParameter = null;

            if (Request.Headers.ContainsKey("Authorization"))
            {
                var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]!);
                authParameter = authHeader.Parameter;
            }
            else if (Request.Query.ContainsKey("access_token"))
            {
                authParameter = Request.Query["access_token"];
            }

            if (string.IsNullOrEmpty(authParameter))
            {
                return AuthenticateResult.Fail("Missing Authorization header");
            }

            var credentialsBytes = Convert.FromBase64String(authParameter);
            var credentials = Encoding.UTF8.GetString(credentialsBytes).Split(':');

            if (credentials.Length != 2)
            {
                return AuthenticateResult.Fail("Invalid credentials format");
            }

            var username = credentials[0];
            var password = credentials[1];

            var user = _korisniciService.Login(username, password);

            if (user == null)
            {
                return AuthenticateResult.Fail("Invalid username or password");
            }

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Name, user.KorisnickoIme!)
            };

            if (user.Uloge != null)
            {
                foreach (var uloga in user.Uloge)
                {
                    claims.Add(new Claim(ClaimTypes.Role, uloga.Naziv!));
                }
            }

            var identity = new ClaimsIdentity(claims, Scheme.Name);
            var principal = new ClaimsPrincipal(identity);
            var ticket = new AuthenticationTicket(principal, Scheme.Name);

            return AuthenticateResult.Success(ticket);
        }
    }
}
