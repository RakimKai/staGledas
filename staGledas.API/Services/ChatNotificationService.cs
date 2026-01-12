using Microsoft.AspNetCore.SignalR;
using staGledas.API.Hubs;
using staGledas.Model.Models;
using staGledas.Service.Interfaces;

namespace staGledas.API.Services
{
    public class ChatNotificationService : IChatNotificationService
    {
        private readonly IHubContext<ChatHub> _hubContext;

        public ChatNotificationService(IHubContext<ChatHub> hubContext)
        {
            _hubContext = hubContext;
        }

        public async Task NotifyNewMessage(Poruke message)
        {
            await _hubContext.Clients.Group($"user_{message.PrimateljId}")
                .SendAsync("ReceiveMessage", message);

            await _hubContext.Clients.Group($"user_{message.PosiljateljId}")
                .SendAsync("MessageSent", message);
        }

        public async Task NotifyMessagesRead(int posiljateljId, int primateljId)
        {
            await _hubContext.Clients.Group($"user_{posiljateljId}")
                .SendAsync("MessagesRead", new
                {
                    PrimateljId = primateljId,
                    ReadAt = DateTime.Now
                });
        }

        public async Task NotifyNewNotification(Obavijesti notification)
        {
            await _hubContext.Clients.Group($"user_{notification.PrimateljId}")
                .SendAsync("ReceiveNotification", notification);
        }
    }
}
