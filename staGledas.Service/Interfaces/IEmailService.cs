namespace staGledas.Service.Interfaces
{
    public interface IEmailService
    {
        void SendWelcomeEmail(string email, string ime);
        void SendPremiumActivatedEmail(string email, string ime);
        void SendEmail(string to, string subject, string body);
    }
}
