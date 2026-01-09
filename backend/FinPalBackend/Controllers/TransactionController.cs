using Microsoft.AspNetCore.Mvc;
using FinPalBackend.Data;
using FinPalBackend.Models;
using Microsoft.EntityFrameworkCore;
using System.Text.RegularExpressions; // Thư viện xử lý văn bản

namespace FinPalBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TransactionController : ControllerBase
    {
        private readonly AppDbContext _context;

        public TransactionController(AppDbContext context)
        {
            _context = context;
        }

        // ================== 1. LẤY DANH SÁCH GIAO DỊCH ==================
        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetTransactions(int userId)
        {
            var list = await _context.Transactions
                                     .Where(t => t.UserId == userId)
                                     .OrderByDescending(t => t.TransactionDate)
                                     .ToListAsync();
            return Ok(list);
        }

        // ================== 2. LẤY TỔNG QUAN (SỐ DƯ) ==================
        [HttpGet("summary/{userId}")]
        public async Task<IActionResult> GetSummary(int userId)
        {
            var transactions = await _context.Transactions.Where(t => t.UserId == userId).ToListAsync();

            decimal totalIncome = transactions.Where(t => t.Type == "Income").Sum(t => t.Amount);
            decimal totalExpense = transactions.Where(t => t.Type == "Expense").Sum(t => t.Amount);
            decimal balance = totalIncome - totalExpense;

            return Ok(new
            {
                balance = balance,
                income = totalIncome,
                expense = totalExpense
            });
        }

        // ================== 3. THÊM GIAO DỊCH MỚI ==================
        [HttpPost]
        public async Task<IActionResult> AddTransaction([FromBody] Transaction transaction)
        {
            if (transaction == null) return BadRequest();

            if (transaction.TransactionDate == DateTime.MinValue)
                transaction.TransactionDate = DateTime.Now;

            _context.Transactions.Add(transaction);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Thêm thành công!", data = transaction });
        }

        // ================== 4. PHÂN TÍCH TEXT (AI FAKE) ==================
        [HttpPost("analyze")]
        public IActionResult AnalyzeText([FromBody] FinPalBackend.DTOs.AnalyzeDto request)
        {
            if (string.IsNullOrEmpty(request.Content))
            {
                return BadRequest("Vui lòng nhập nội dung tin nhắn!");
            }

            string text = request.Content.ToLower();

            // A. DỰ ĐOÁN LOẠI GIAO DỊCH
            string type = "Expense";
            if (text.Contains("+") || text.Contains("nhan tien") || text.Contains("cong") || text.Contains("nhận"))
            {
                type = "Income";
            }

            // B. TÁCH SỐ TIỀN
            decimal amount = 0;
            var numberMatches = Regex.Matches(request.Content, @"[\d,.]+");
            foreach (Match match in numberMatches)
            {
                string cleanNumber = match.Value.Replace(",", "").Replace(".", "");
                if (decimal.TryParse(cleanNumber, out decimal val))
                {
                    if (val > amount && val > 1000) amount = val;
                }
            }

            // C. DỰ ĐOÁN DANH MỤC
            string category = "Khác";
            if (text.Contains("grab") || text.Contains("be") || text.Contains("xang")) category = "Di chuyển";
            else if (text.Contains("coffee") || text.Contains("cafe") || text.Contains("an")) category = "Ăn uống";
            else if (text.Contains("luong") || text.Contains("thưởng")) category = "Lương";
            else if (text.Contains("shopee") || text.Contains("mua")) category = "Mua sắm";
            else if (text.Contains("dien") || text.Contains("nuoc") || text.Contains("bill")) category = "Hóa đơn";

            // D. TRẢ KẾT QUẢ
            return Ok(new
            {
                amount = amount,
                type = type,
                category = category,
                description = request.Content
            });
        }

        // ================== 5. SỬA GIAO DỊCH (MỚI THÊM) ==================
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateTransaction(int id, [FromBody] Transaction updatedData)
        {
            var transaction = await _context.Transactions.FindAsync(id);
            if (transaction == null) return NotFound("Không tìm thấy giao dịch!");

            // Cập nhật dữ liệu mới
            transaction.Amount = updatedData.Amount;
            transaction.Category = updatedData.Category;
            transaction.Type = updatedData.Type;
            transaction.Description = updatedData.Description;
            // transaction.TransactionDate = updatedData.TransactionDate; // Có thể mở dòng này nếu muốn sửa cả ngày

            await _context.SaveChangesAsync();
            return Ok(new { message = "Cập nhật thành công!" });
        }

        // ================== 6. XÓA GIAO DỊCH (MỚI THÊM) ==================
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTransaction(int id)
        {
            var transaction = await _context.Transactions.FindAsync(id);
            if (transaction == null) return NotFound("Không tìm thấy giao dịch!");

            _context.Transactions.Remove(transaction);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Đã xóa thành công!" });
        }
    }
}