using EasyNetQ;
using staGledas.Model.Messages;

namespace staGledas.RabbitMQ
{
    public class BackgroundWorkerService : BackgroundService
    {
        private readonly IServiceProvider _serviceProvider;
        private readonly IConfiguration _configuration;
        private IBus? _bus;

        public BackgroundWorkerService(IServiceProvider serviceProvider, IConfiguration configuration)
        {
            _serviceProvider = serviceProvider;
            _configuration = configuration;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            var host = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? _configuration["RabbitMQ:Host"] ?? "localhost";
            var username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? _configuration["RabbitMQ:Username"] ?? "guest";
            var password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? _configuration["RabbitMQ:Password"] ?? "guest";

            var connectionString = $"host={host};username={username};password={password}";

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    _bus = RabbitHutch.CreateBus(connectionString);

                    await _bus.PubSub.SubscribeAsync<EmailMessage>("email_queue", async message =>
                    {
                        using var scope = _serviceProvider.CreateScope();
                        var emailSender = scope.ServiceProvider.GetRequiredService<IEmailSender>();

                        Console.WriteLine($"Sending email to: {message.To}");
                        await emailSender.SendEmailAsync(message.To!, message.Subject!, message.Body!);
                        Console.WriteLine($"Email sent successfully to: {message.To}");
                    }, stoppingToken);

                    Console.WriteLine("RabbitMQ connected. Listening for messages...");

                    await Task.Delay(Timeout.Infinite, stoppingToken);
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"RabbitMQ connection error: {ex.Message}. Retrying in 5 seconds...");
                    await Task.Delay(5000, stoppingToken);
                }
            }
        }

        public override void Dispose()
        {
            _bus?.Dispose();
            base.Dispose();
        }
    }
}
