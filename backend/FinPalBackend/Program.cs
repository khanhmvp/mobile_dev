using FinPalBackend.Data;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

// --- 1. CẤU HÌNH CORS (Cho phép Web/Chrome gọi vào) ---
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()  // Chấp nhận mọi nguồn (localhost, web, mobile...)
              .AllowAnyMethod()  // Chấp nhận mọi phương thức (GET, POST...)
              .AllowAnyHeader(); // Chấp nhận mọi Header
    });
});
// -----------------------------------------------------

// --- CẤU HÌNH DATABASE ---
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(connectionString));
// -------------------------

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// --- QUAN TRỌNG: TẠM KHÓA DÒNG NÀY ---
// app.UseHttpsRedirection(); 
// Lý do: Để tránh việc Server tự động chuyển từ HTTP (5259) sang HTTPS (7055) gây lỗi bảo mật trên Chrome
// -------------------------------------

// --- 2. BẬT CORS (Phải đặt TRƯỚC UseAuthorization) ---
app.UseCors("AllowAll");
// -----------------------------------------------------

app.UseAuthorization();

app.MapControllers();

app.Run();