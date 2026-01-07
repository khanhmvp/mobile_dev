using Microsoft.AspNetCore.Mvc;
using FinPalBackend.Data;
using FinPalBackend.Models;
using FinPalBackend.DTOs;
using Microsoft.EntityFrameworkCore;
using BCrypt.Net;

namespace FinPalBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AuthController(AppDbContext context)
        {
            _context = context;
        }

        // API Đăng ký
        [HttpPost("register")]
        public async Task<IActionResult> Register(RegisterDto request)
        {
            if (await _context.Users.AnyAsync(u => u.PhoneNumber == request.PhoneNumber))
            {
                return BadRequest("Số điện thoại này đã được sử dụng!");
            }

            string passwordHash = BCrypt.Net.BCrypt.HashPassword(request.Password);

            var user = new User
            {
                PhoneNumber = request.PhoneNumber,
                FullName = request.FullName,
                PasswordHash = passwordHash,
                CreatedAt = DateTime.Now
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Đăng ký thành công!", userId = user.Id });
        }

        // API Đăng nhập
        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginDto request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.PhoneNumber == request.PhoneNumber);

            if (user == null || !BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
            {
                return BadRequest("Sai số điện thoại hoặc mật khẩu.");
            }

            return Ok(new { message = "Đăng nhập thành công!", userId = user.Id, fullName = user.FullName });
        }
    }
}