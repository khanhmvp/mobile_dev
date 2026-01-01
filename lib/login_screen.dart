import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;

  // Hàm xử lý khi nhấn nút chính
  void _handleMainButton() {
    if (isLogin) {
      // 1. Logic chuyển sang màn hình Liên kết ngân hàng (Screen 24)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BankLinkScreen()),
      );
    } else {
      // Logic xử lý Đăng ký
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký tài khoản thành công!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          isLogin = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/money_icon.png', height: 150),
              const SizedBox(height: 16),
              const Text(
                'Finpal',
                style: TextStyle(
                  fontSize: 22,
                  color: Color(0xFF4285F4),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Trợ lý tài chính thông minh của bạn',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              _buildTabs(),
              const SizedBox(height: 24),
              if (isLogin) ..._loginForm() else ..._registerForm(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleMainButton,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isLogin ? 'Đăng nhập' : 'Đăng ký',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _tabItem(
            title: 'Đăng nhập',
            active: isLogin,
            onTap: () => setState(() => isLogin = true),
          ),
          _tabItem(
            title: 'Đăng ký',
            active: !isLogin,
            onTap: () => setState(() => isLogin = false),
          ),
        ],
      ),
    );
  }

  Widget _tabItem({
    required String title,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: active ? const Color(0xFF4285F4) : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _loginForm() {
    return [
      _inputField(label: 'Số điện thoại'),
      const SizedBox(height: 16),
      _inputField(label: 'Mật khẩu', obscureText: true),
      const SizedBox(height: 12),
      Align(
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
            );
          },
          child: const Text(
            'Quên mật khẩu ?',
            style: TextStyle(
              color: Color(0xFF4285F4),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _registerForm() {
    return [
      _inputField(label: 'Số điện thoại'),
      const SizedBox(height: 16),
      _inputField(label: 'Mật khẩu', obscureText: true),
      const SizedBox(height: 16),
      _inputField(label: 'Xác nhận mật khẩu', obscureText: true),
    ];
  }

  Widget _inputField({required String label, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

// ================= MÀN HÌNH LIÊN KẾT NGÂN HÀNG (SCREEN 24) =================
// ================= MÀN HÌNH LIÊN KẾT NGÂN HÀNG (SCREEN 24) =================
// Lưu ý: Đảm bảo bạn đã import 'home_screen.dart'; ở đầu file login_screen.dart

class BankLinkScreen extends StatefulWidget {
  const BankLinkScreen({super.key});

  @override
  State<BankLinkScreen> createState() => _BankLinkScreenState();
}

class _BankLinkScreenState extends State<BankLinkScreen> {
  String? _selectedBank;

  // Hàm điều hướng dứt điểm sang Home
  void _goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false, // Xóa sạch lịch sử để không thể quay lại Login
    );
  }

  void _selectBank(String bankName) {
    setState(() {
      _selectedBank = bankName;
    });
    print("Đã chọn ngân hàng: $bankName");
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
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _goToHome(context), // Sửa ở đây
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
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => _goToHome(
                    context,
                  ), // Sửa ở đây: Từ Navigator.pop thành _goToHome
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

  Widget _buildBankItem(String name, IconData icon, Color color) {
    final isSelected = _selectedBank == name;
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Đổi con trỏ thành bàn tay khi hover
      child: GestureDetector(
        onTap: () {
          _selectBank(name);
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              if (isSelected) ...[
                const SizedBox(height: 8),
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

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
