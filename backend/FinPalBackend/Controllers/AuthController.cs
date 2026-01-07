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

        // Bộ nhớ tạm để lưu OTP (Dùng Dictionary cho nhanh, thực tế nên dùng Redis/Database)
        // Key: Số điện thoại, Value: Mã OTP
        public static Dictionary<string, string> OtpStore = new Dictionary<string, string>();

        public AuthController(AppDbContext context)
        {
            _context = context;
        }

        // ================== 1. ĐĂNG KÝ ==================
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

        // ================== 2. ĐĂNG NHẬP ==================
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

        // ================== 3. GỬI OTP (QUÊN MẬT KHẨU) ==================
        [HttpPost("send-otp")]
        public async Task<IActionResult> SendOtp([FromBody] Dictionary<string, string> request)
        {
            // Kiểm tra đầu vào
            if (!request.ContainsKey("phoneNumber")) return BadRequest("Thiếu số điện thoại");

            string phone = request["phoneNumber"];

            // Kiểm tra xem SĐT có tồn tại trong hệ thống không
            var user = await _context.Users.FirstOrDefaultAsync(u => u.PhoneNumber == phone);
            if (user == null)
            {
                return BadRequest("Số điện thoại chưa đăng ký tài khoản!");
            }

            // Tạo mã OTP giả định (Để test dễ dàng là 123456)
            // Trong thực tế bạn sẽ dùng thư viện Random để tạo số ngẫu nhiên
            string otp = "123456";

            // Lưu OTP vào bộ nhớ tạm
            if (OtpStore.ContainsKey(phone))
            {
                OtpStore[phone] = otp; // Nếu đã có thì cập nhật lại mã mới
            }
            else
            {
                OtpStore.Add(phone, otp); // Nếu chưa có thì thêm mới
            }

            // Trả về OTP luôn để tiện test (Thực tế không nên trả về mà phải gửi SMS)
            return Ok(new { message = "Mã OTP đã được gửi!", devOtp = otp });
        }

        // ================== 4. ĐỔI MẬT KHẨU MỚI ==================
        [HttpPost("reset-password")]
        public async Task<IActionResult> ResetPassword([FromBody] Dictionary<string, string> request)
        {
            // Lấy dữ liệu từ Client gửi lên
            if (!request.ContainsKey("phoneNumber") || !request.ContainsKey("otp") || !request.ContainsKey("newPassword"))
            {
                return BadRequest("Vui lòng nhập đầy đủ thông tin!");
            }

            string phone = request["phoneNumber"];
            string otp = request["otp"];
            string newPassword = request["newPassword"];

            // 1. Kiểm tra OTP có đúng không
            if (!OtpStore.ContainsKey(phone) || OtpStore[phone] != otp)
            {
                return BadRequest("Mã OTP không chính xác hoặc đã hết hạn!");
            }

            // 2. Tìm user trong database
            var user = await _context.Users.FirstOrDefaultAsync(u => u.PhoneNumber == phone);
            if (user != null)
            {
                // 3. Mã hóa mật khẩu mới và lưu vào DB
                user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(newPassword);
                await _context.SaveChangesAsync();

                // 4. Xóa OTP sau khi dùng xong để bảo mật
                OtpStore.Remove(phone);

                return Ok(new { message = "Đổi mật khẩu thành công! Hãy đăng nhập lại." });
            }

            return BadRequest("Lỗi hệ thống: Không tìm thấy người dùng.");
        }
    }
}