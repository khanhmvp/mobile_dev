import 'package:flutter/material.dart';
<<<<<<< HEAD
// QUAN TRỌNG: Phải import màn hình đích vào đây
import 'reset_success_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
=======
// Import file service để gọi API
import 'services/auth_service.dart';
// Import màn hình thông báo thành công
import 'reset_success_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Controller để lấy dữ liệu người dùng nhập
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  // Biến trạng thái để hiện loading hoặc thông báo
  bool isOtpSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // --- 1. HÀM XỬ LÝ GỬI OTP ---
  void _handleSendOtp() async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập số điện thoại"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Gọi API từ AuthService
    bool success = await AuthService.sendOtp(phone);

    if (success) {
      setState(() => isOtpSent = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Đã gửi mã OTP! (Mã test: 123456)"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Lỗi: SĐT chưa đăng ký hoặc lỗi mạng"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- 2. HÀM XỬ LÝ XÁC NHẬN VÀ ĐỔI MẬT KHẨU ---
  void _handleConfirm() {
    String phone = _phoneController.text.trim();
    String otp = _otpController.text.trim();

    if (phone.isEmpty || otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập SĐT và mã OTP"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Hiện hộp thoại nhập mật khẩu mới
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final TextEditingController newPassController = TextEditingController();
        return AlertDialog(
          title: const Text("Đặt lại mật khẩu"),
          content: TextField(
            controller: newPassController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Nhập mật khẩu mới",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Đóng dialog
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () async {
                String newPass = newPassController.text.trim();
                if (newPass.isEmpty) return;

                // Gọi API Đổi mật khẩu
                bool success = await AuthService.resetPassword(
                  phone,
                  otp,
                  newPass,
                );

                Navigator.pop(context); // Đóng dialog nhập pass

                if (success) {
                  // Thành công -> Chuyển sang màn hình thông báo ResetSuccessScreen
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetSuccessScreen(),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Sai mã OTP hoặc lỗi hệ thống!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Lưu thay đổi"),
            ),
          ],
        );
      },
    );
  }

  @override
>>>>>>> backend-dev
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
<<<<<<< HEAD
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Image.asset('assets/images/money_icon.png', height: 120),
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
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Badge Quên Mật Khẩu
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Quên Mật Khẩu',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 32),

              _buildLabel('Số điện thoại'),
              const SizedBox(height: 8),
              _buildTextField(keyboardType: TextInputType.phone),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Gửi mã OTP',
                    style: TextStyle(
                      color: Color(0xFF4285F4),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              _buildLabel('Nhập số OTP vừa được gửi'),
              const SizedBox(height: 8),
              _buildTextField(keyboardType: TextInputType.number),

              const Spacer(),

              // NÚT XÁC NHẬN - CHUYỂN MÀN HÌNH TẠI ĐÂY
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Lệnh điều hướng sang màn hình ResetSuccessScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetSuccessScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
=======
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  'assets/images/money_icon.png',
                  height: 120,
                  errorBuilder: (c, o, s) => const Icon(
                    Icons.lock_reset,
                    size: 100,
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
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 24),

                // Badge Quên Mật Khẩu
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Quên Mật Khẩu',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(height: 32),

                _buildLabel('Số điện thoại'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _handleSendOtp, // Gọi hàm gửi OTP
                    child: const Text(
                      'Gửi mã OTP',
                      style: TextStyle(
                        color: Color(0xFF4285F4),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                _buildLabel('Nhập số OTP vừa được gửi'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 40),

                // NÚT XÁC NHẬN
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _handleConfirm, // Gọi hàm xác nhận
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4285F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
>>>>>>> backend-dev
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildTextField({TextInputType? keyboardType}) {
    return TextField(
=======
  Widget _buildTextField({
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller, // Gắn controller
>>>>>>> backend-dev
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
