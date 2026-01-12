using Mapster;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using staGledas.API;
using staGledas.API.Filters;
using staGledas.API.Hubs;
using staGledas.Service.Database;
using staGledas.Service.Interfaces;
using staGledas.Service.Services;
using staGledas.Service.ZalbeStateMachine;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddTransient<IKorisniciService, KorisniciService>();
builder.Services.AddTransient<IFilmoviService, FilmoviService>();
builder.Services.AddTransient<IUlogeService, UlogeService>();

builder.Services.AddTransient<IRecenzijeService, RecenzijeService>();
builder.Services.AddTransient<IWatchlistService, WatchlistService>();
builder.Services.AddTransient<IPratiteljiService, PratiteljiService>();
builder.Services.AddTransient<IPorukeService, PorukeService>();
builder.Services.AddTransient<INovostiService, NovostiService>();

builder.Services.AddHttpClient<ITMDbService, TMDbService>();
builder.Services.AddTransient<IRecommenderService, RecommenderService>();
builder.Services.AddTransient<IZalbeService, ZalbeService>();
builder.Services.AddTransient<IKlubFilmovaService, KlubFilmovaService>();
builder.Services.AddTransient<IStripeService, StripeService>();
builder.Services.AddTransient<IReportsService, ReportsService>();
builder.Services.AddTransient<IPdfReportService, PdfReportService>();

builder.Services.AddTransient<IFavoritiService, FavoritiService>();
builder.Services.AddTransient<IFilmoviLajkoviService, FilmoviLajkoviService>();
builder.Services.AddTransient<IKlubObjaveService, KlubObjaveService>();
builder.Services.AddTransient<IKlubKomentariService, KlubKomentariService>();
builder.Services.AddTransient<IKlubLajkoviService, KlubLajkoviService>();
builder.Services.AddTransient<IObavijestiService, ObavijestiService>();

builder.Services.AddTransient<IEmailService, EmailService>();

builder.Services.AddTransient<IChatNotificationService, staGledas.API.Services.ChatNotificationService>();

builder.Services.AddTransient<BaseZalbeState>();
builder.Services.AddTransient<InitialZalbeState>();
builder.Services.AddTransient<PendingZalbeState>();
builder.Services.AddTransient<ApprovedZalbeState>();
builder.Services.AddTransient<RejectedZalbeState>();

builder.Services.AddControllers(x => x.Filters.Add<ExceptionFilter>());
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSignalR()
    .AddJsonProtocol(options =>
    {
        options.PayloadSerializerOptions.PropertyNamingPolicy = System.Text.Json.JsonNamingPolicy.CamelCase;
    });

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.SetIsOriginAllowed(_ => true)
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials();
    });
});

builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new OpenApiSecurityScheme()
    {
        Type = SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "basicAuth" }
            },
            new string[] { }
        }
    });
});

var connectionString = builder.Configuration.GetConnectionString("staGledas");
builder.Services.AddDbContext<StaGledasContext>(options =>
    options.UseSqlServer(connectionString).EnableDetailedErrors().EnableSensitiveDataLogging());

builder.Services.AddMapster();
MappingConfig.RegisterMappings();
builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseCors("AllowAll");

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.MapHub<ChatHub>("/chatHub").RequireAuthorization();

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<StaGledasContext>();
    dataContext.Database.Migrate();
}

app.Run();
