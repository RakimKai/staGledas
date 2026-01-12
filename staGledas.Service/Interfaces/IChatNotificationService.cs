using staGledas.Model.Models;

namespace staGledas.Service.Interfaces
{
    public interface IChatNotificationService
    {
        Task NotifyNewMessage(Poruke message);
        Task NotifyMessagesRead(int posiljateljId, int primateljId);
        Task NotifyNewNotification(Obavijesti notification);
    }
}
