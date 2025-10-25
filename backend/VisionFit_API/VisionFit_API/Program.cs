using Microsoft.EntityFrameworkCore;
using VisionFit_API.Data;
using VisionFit_API.Data.VisionFit_API.Data;

var builder = WebApplication.CreateBuilder(args);

// Veritabaný baðlantýsýný ekleyelim
builder.Services.AddDbContext<VisionFitDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("VisionFitDB")));

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        policy => policy.AllowAnyOrigin()
                        .AllowAnyMethod()
                        .AllowAnyHeader());
});


var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");

app.UseHttpsRedirection();

// Authentication & Authorization Middleware kaldýrýldý

app.MapControllers();

app.Run();
