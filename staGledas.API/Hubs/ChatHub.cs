using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using System.Collections.Concurrent;
using System.Security.Claims;

namespace staGledas.API.Hubs
{
    [Authorize]
    public class ChatHub : Hub
    {
        private static readonly ConcurrentDictionary<int, HashSet<string>> _userConnections = new();

        public override async Task OnConnectedAsync()
        {
            var userIdClaim = Context.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (int.TryParse(userIdClaim, out int userId))
            {
                _userConnections.AddOrUpdate(
                    userId,
                    new HashSet<string> { Context.ConnectionId },
                    (key, existingSet) =>
                    {
                        existingSet.Add(Context.ConnectionId);
                        return existingSet;
                    });

                await Groups.AddToGroupAsync(Context.ConnectionId, $"user_{userId}");
            }

            await base.OnConnectedAsync();
        }

        public override async Task OnDisconnectedAsync(Exception? exception)
        {
            var userIdClaim = Context.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (int.TryParse(userIdClaim, out int userId))
            {
                if (_userConnections.TryGetValue(userId, out var connections))
                {
                    connections.Remove(Context.ConnectionId);
                    if (connections.Count == 0)
                    {
                        _userConnections.TryRemove(userId, out _);
                    }
                }

                await Groups.RemoveFromGroupAsync(Context.ConnectionId, $"user_{userId}");
            }

            await base.OnDisconnectedAsync(exception);
        }

        public async Task SendMessage(int primateljId, string sadrzaj)
        {
            var userIdClaim = Context.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (!int.TryParse(userIdClaim, out int posiljateljId))
            {
                throw new HubException("Unauthorized");
            }

            await Clients.Group($"user_{primateljId}").SendAsync("ReceiveMessage", new
            {
                PosiljateljId = posiljateljId,
                PrimateljId = primateljId,
                Sadrzaj = sadrzaj,
                DatumSlanja = DateTime.Now
            });
        }

        public async Task MarkAsRead(int posiljateljId)
        {
            var userIdClaim = Context.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (!int.TryParse(userIdClaim, out int primateljId))
            {
                throw new HubException("Unauthorized");
            }

            await Clients.Group($"user_{posiljateljId}").SendAsync("MessagesRead", new
            {
                PrimateljId = primateljId,
                ReadAt = DateTime.Now
            });
        }

        public static bool IsUserOnline(int userId)
        {
            return _userConnections.ContainsKey(userId);
        }

        public static IEnumerable<string> GetUserConnections(int userId)
        {
            if (_userConnections.TryGetValue(userId, out var connections))
            {
                return connections.ToList();
            }
            return Enumerable.Empty<string>();
        }

        public static async Task SendNotificationToUser(IHubContext<ChatHub> hubContext, int userId, object notification)
        {
            await hubContext.Clients.Group($"user_{userId}").SendAsync("ReceiveNotification", notification);
        }
    }
}
