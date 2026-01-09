using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FinPalBackend.Models
{
    public class Transaction
    {
        [Key]
        public int Id { get; set; }

        public int UserId { get; set; }

        [ForeignKey("UserId")]
        public User? User { get; set; }

        // Đã thêm định dạng chuẩn cho tiền tệ (18 số, 2 số thập phân)
        [Column(TypeName = "decimal(18, 2)")]
        public decimal Amount { get; set; }

        [MaxLength(50)]
        public string Category { get; set; } = string.Empty;

        public string Description { get; set; } = string.Empty;

        public DateTime TransactionDate { get; set; } = DateTime.Now;

        public string Type { get; set; } = "Expense";
    }
}