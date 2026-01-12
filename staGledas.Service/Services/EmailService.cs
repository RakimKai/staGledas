using EasyNetQ;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using staGledas.Model.Messages;
using staGledas.Service.Interfaces;

namespace staGledas.Service.Services
{
    public class EmailService : IEmailService
    {
        private readonly string _host;
        private readonly string _username;
        private readonly string _password;
        private readonly string _virtualHost;
        private readonly ILogger<EmailService> _logger;

        public EmailService(IConfiguration configuration, ILogger<EmailService> logger)
        {
            _host = Environment.GetEnvironmentVariable("RABBITMQ_HOST")
                ?? configuration["RabbitMQ:Host"]
                ?? "localhost";
            _username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME")
                ?? configuration["RabbitMQ:Username"]
                ?? "guest";
            _password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD")
                ?? configuration["RabbitMQ:Password"]
                ?? "guest";
            _virtualHost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST")
                ?? configuration["RabbitMQ:VirtualHost"]
                ?? "/";
            _logger = logger;
        }

        public void SendWelcomeEmail(string email, string ime)
        {
            var subject = "Dobrodošli na Šta Gledaš!";
            var body = $@"
                <html>
                <body style='font-family: Arial, sans-serif; background-color: #f5f5f5; padding: 20px;'>
                    <div style='max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 10px;'>
                        <h1 style='color: #4AB3EF;'>Dobrodošli, {ime}!</h1>
                        <p>Hvala vam što ste se pridružili platformi <strong>Šta Gledaš?</strong></p>
                        <p>Sada možete:</p>
                        <ul>
                            <li>Pregledati i ocjenjivati filmove</li>
                            <li>Kreirati svoju listu za gledanje</li>
                            <li>Pratiti druge korisnike</li>
                            <li>Razmjenjivati poruke sa prijateljima</li>
                        </ul>
                        <p>Nadogradite na <strong>Premium</strong> za pristup Movie Clubs i dodatnim funkcionalnostima!</p>
                        <hr style='border: none; border-top: 1px solid #eee; margin: 20px 0;'>
                        <p style='color: #888; font-size: 12px;'>Šta Gledaš? - Vaša filmska zajednica</p>
                    </div>
                </body>
                </html>";

            SendEmail(email, subject, body);
        }

        public void SendPremiumActivatedEmail(string email, string ime)
        {
            var subject = "Premium pretplata aktivirana!";
            var body = $@"
                <html>
                <body style='font-family: Arial, sans-serif; background-color: #f5f5f5; padding: 20px;'>
                    <div style='max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 10px;'>
                        <h1 style='color: #FFD700;'>⭐ Čestitamo, {ime}!</h1>
                        <p>Vaša <strong>Premium pretplata</strong> je uspješno aktivirana!</p>
                        <p>Sada imate pristup:</p>
                        <ul>
                            <li>🎬 Movie Clubs - Kreirajte i pridružite se klubovima</li>
                            <li>💬 Diskusije u klubovima</li>
                            <li>🚫 Iskustvo bez reklama</li>
                            <li>⭐ Ekskluzivne funkcionalnosti</li>
                        </ul>
                        <p>Hvala vam na podršci!</p>
                        <hr style='border: none; border-top: 1px solid #eee; margin: 20px 0;'>
                        <p style='color: #888; font-size: 12px;'>Šta Gledaš? - Vaša filmska zajednica</p>
                    </div>
                </body>
                </html>";

            SendEmail(email, subject, body);
        }

        public void SendEmail(string to, string subject, string body)
        {
            try
            {
                var connectionString = $"host={_host};virtualHost={_virtualHost};username={_username};password={_password}";

                using var bus = RabbitHutch.CreateBus(connectionString);

                var message = new EmailMessage
                {
                    To = to,
                    Subject = subject,
                    Body = body
                };

                bus.PubSub.Publish(message);
            }
            catch (Exception ex)
            {
                _logger.LogError($"[Email] Failed to queue email to {to}: {ex.Message}");
            }
        }
    }
}
