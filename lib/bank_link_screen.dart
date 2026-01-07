import 'package:flutter/material.dart';
import 'home_screen.dart'; // Đảm bảo bạn đã import màn hình chính

class BankLinkScreen extends StatefulWidget {
  const BankLinkScreen({super.key});

  @override
  State<BankLinkScreen> createState() => _BankLinkScreenState();
}

class _BankLinkScreenState extends State<BankLinkScreen> {
  String? _selectedBank; // Lưu tên ngân hàng được chọn

  // --- HÀM XỬ LÝ LIÊN KẾT GIẢ LẬP (QUAN TRỌNG) ---
  void _handleConnect() async {
    // 1. Kiểm tra xem người dùng đã chọn ngân hàng chưa
    if (_selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn một ngân hàng!")),
      );
      return;
    }

    // 2. Hiển thị vòng tròn loading (Giả vờ đang kết nối API ngân hàng)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    // 3. Đợi 2 giây cho giống thật
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context); // Tắt loading

      // 4. Thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Kết nối $_selectedBank thành công! Đã đồng bộ dữ liệu.",
          ),
          backgroundColor: Colors.green,
        ),
      );

      // 5. Chuyển sang màn hình chính (Xóa lịch sử để không quay lại được)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  // Hàm bỏ qua bước này
  void _skip() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  // Hàm chọn ngân hàng
  void _selectBank(String bankName) {
    setState(() {
      _selectedBank = bankName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Liên kết ngân hàng',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Chọn ngân hàng chính của bạn để FinPal tự động đồng bộ hóa giao dịch',
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 32),

              // --- DANH SÁCH NGÂN HÀNG (GRID VIEW ĐẸP MẮT) ---
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2, // 2 Cột
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildBankItem(
                      'MB Bank',
                      Icons.stars_rounded,
                      Colors.blue.shade900,
                    ),
                    _buildBankItem(
                      'VietinBank',
                      Icons.account_balance,
                      Colors.blue,
                    ),
                    _buildBankItem('VietcomBank', Icons.eco, Colors.green),
                    _buildAddBankItem(),
                  ],
                ),
              ),

              // --- NÚT KẾT NỐI ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleConnect, // Gọi hàm xử lý giả lập
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Kết nối ngay',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Nút "Để sau"
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _skip,
                  child: const Text(
                    'Để sau',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget hiển thị từng ô ngân hàng
  Widget _buildBankItem(String name, IconData icon, Color color) {
    final isSelected = _selectedBank == name;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _selectBank(name),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.white,
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(height: 8),
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Widget dấu cộng (Thêm ngân hàng khác)
  Widget _buildAddBankItem() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.add, color: Colors.grey.shade400, size: 32),
    );
  }
}
