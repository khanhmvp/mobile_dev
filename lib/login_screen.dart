import 'package:flutter/material.dart';
// Đảm bảo các file này đã tồn tại trong dự án của bạn
import '../services/auth_service.dart';
import 'forgot_password_screen.dart'; // Nếu chưa có file này thì comment dòng này lại
import 'home_screen.dart';
import 'bank_link_screen.dart'; // Nếu bạn tách file thì import, nếu để chung thì không cần

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true; // Trạng thái: true = Đăng nhập, false = Đăng ký
  bool isLoading = false; // Trạng thái loading khi gọi API

  // Khai báo các Controller để lấy dữ liệu nhập vào
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _nameController =
      TextEditingController(); // Chỉ dùng khi Đăng ký
  final TextEditingController _confirmPassController = TextEditingController();

  // Giải phóng bộ nhớ khi thoát màn hình
  @override
  void dispose() {
    _phoneController.dispose();
    _passController.dispose();
    _nameController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  // --- HÀM XỬ LÝ CHÍNH (GỌI API) ---
  void _handleMainButton() async {
    // 1. Lấy dữ liệu và xóa khoảng trắng thừa
    String phone = _phoneController.text.trim();
    String password = _passController.text.trim();
    String name = _nameController.text.trim();

    // 2. Kiểm tra dữ liệu rỗng
    if (phone.isEmpty || password.isEmpty) {
      _showSnackBar('Vui lòng nhập đầy đủ thông tin!', Colors.red);
      return;
    }

    if (!isLogin) {
      // Logic riêng cho Đăng ký
      if (name.isEmpty) {
        _showSnackBar('Vui lòng nhập Họ và tên!', Colors.red);
        return;
      }
      if (password != _confirmPassController.text.trim()) {
        _showSnackBar('Mật khẩu xác nhận không khớp!', Colors.red);
        return;
      }
    }

    // 3. Bắt đầu gọi API -> Bật loading
    setState(() => isLoading = true);

    if (isLogin) {
      // --- XỬ LÝ ĐĂNG NHẬP ---
      var user = await AuthService.login(phone, password);

      setState(() => isLoading = false); // Tắt loading

      if (user != null) {
        // Thành công -> Chuyển sang màn hình Liên kết ngân hàng
        print("Đăng nhập thành công: ${user['fullName']}");

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BankLinkScreen()),
          );
        }
      } else {
        _showSnackBar('Sai số điện thoại hoặc mật khẩu!', Colors.red);
      }
    } else {
      // --- XỬ LÝ ĐĂNG KÝ ---
      bool success = await AuthService.register(name, phone, password);

      setState(() => isLoading = false); // Tắt loading

      if (success) {
        _showSnackBar('Đăng ký thành công! Hãy đăng nhập.', Colors.green);

        // Chuyển tab về Đăng nhập và tự điền SĐT, xóa mật khẩu cũ
        setState(() {
          isLogin = true;
          _passController.clear();
          _confirmPassController.clear();
        });
      } else {
        _showSnackBar('Đăng ký thất bại (SĐT có thể đã tồn tại).', Colors.red);
      }
    }
  }

  // Hàm hiển thị thông báo (SnackBar)
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
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
              // Logo
              Image.asset(
                'assets/images/money_icon.png',
                height: 100,
                errorBuilder: (c, o, s) => const Icon(
                  Icons.account_balance_wallet,
                  size: 80,
                  color: Color(0xFF4285F4),
                ),
              ),
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

              // Tabs (Đăng nhập / Đăng ký)
              _buildTabs(),

              const SizedBox(height: 24),

              // Form nhập liệu
              if (isLogin) ..._loginForm() else ..._registerForm(),

              const SizedBox(height: 32),

              // Nút bấm chính
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleMainButton,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
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
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
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
      _inputField(label: 'Số điện thoại', controller: _phoneController),
      const SizedBox(height: 16),
      _inputField(
        label: 'Mật khẩu',
        obscureText: true,
        controller: _passController,
      ),
      const SizedBox(height: 12),
      Align(
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            // Đảm bảo bạn có file forgot_password_screen.dart hoặc comment lại
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
      _inputField(label: 'Họ và tên', controller: _nameController),
      const SizedBox(height: 16),
      _inputField(label: 'Số điện thoại', controller: _phoneController),
      const SizedBox(height: 16),
      _inputField(
        label: 'Mật khẩu',
        obscureText: true,
        controller: _passController,
      ),
      const SizedBox(height: 16),
      _inputField(
        label: 'Xác nhận mật khẩu',
        obscureText: true,
        controller: _confirmPassController,
      ),
    ];
  }

  Widget _inputField({
    required String label,
    bool obscureText = false,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
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

// ================= MÀN HÌNH LIÊN KẾT NGÂN HÀNG =================
// (Bạn có thể để chung trong file này hoặc tách ra file bank_link_screen.dart tùy ý)

class BankLinkScreen extends StatefulWidget {
  const BankLinkScreen({super.key});

  @override
  State<BankLinkScreen> createState() => _BankLinkScreenState();
}

class _BankLinkScreenState extends State<BankLinkScreen> {
  String? _selectedBank;

  // Hàm chuyển sang màn hình chính
  void _goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false, // Xóa lịch sử để không quay lại Login được
    );
  }

  void _selectBank(String bankName) {
    setState(() {
      _selectedBank = bankName;
    });
    // Có thể gọi API lưu ngân hàng ở đây nếu cần
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
                  onPressed: () => _goToHome(context),
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
                  onPressed: () => _goToHome(context),
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
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _selectBank(name),
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
