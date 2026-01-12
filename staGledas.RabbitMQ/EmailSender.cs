using System.Net;
using System.Net.Mail;

namespace staGledas.RabbitMQ
{
    public class EmailSender : IEmailSender
    {
        private readonly IConfiguration _configuration;

        public EmailSender(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task SendEmailAsync(string to, string subject, string body)
        {
            var smtpHost = _configuration["Smtp:Host"] ?? "smtp.gmail.com";
            var smtpPort = int.Parse(_configuration["Smtp:Port"] ?? "587");
            var smtpUser = _configuration["Smtp:Username"] ?? "";
            var smtpPass = _configuration["Smtp:Password"] ?? "";
            var fromEmail = _configuration["Smtp:FromEmail"] ?? "noreply@stagledas.com";

            using var client = new SmtpClient(smtpHost, smtpPort);
            client.EnableSsl = true;
            client.Credentials = new NetworkCredential(smtpUser, smtpPass);

            var message = new MailMessage(fromEmail, to, subject, body);
            message.IsBodyHtml = true;

            await client.SendMailAsync(message);
        }
    }
}
