import 'package:flutter/material.dart';
import 'login_screen.dart';

class ResetSuccessScreen extends StatefulWidget {
  const ResetSuccessScreen({super.key});

  @override
  State<ResetSuccessScreen> createState() => _ResetSuccessScreenState();
}

class _ResetSuccessScreenState extends State<ResetSuccessScreen> {
  bool _isSuccess = false; // Biến để kiểm soát trạng thái hiển thị

  @override
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
        child: SingleChildScrollView(
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
                const SizedBox(height: 24),

                // Nếu chưa bấm xác nhận mật khẩu, hiện Form nhập
                if (!_isSuccess) ...[
                  _buildLabel('Mật khẩu mới'),
                  const SizedBox(height: 8),
                  _buildTextField(obscureText: true),
                  const SizedBox(height: 20),
                  _buildLabel('Xác nhận mật khẩu mới'),
                  const SizedBox(height: 8),
                  _buildTextField(obscureText: true),
                  const SizedBox(height: 40),
                ]
                // Nếu đã bấm xác nhận, hiện Icon thành công
                else ...[
                  const Icon(
                    Icons.check_circle,
                    size: 100,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Xác nhận thành công',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Bạn có thể tiếp tục đăng nhập',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                ],

                // Nút bấm thay đổi chức năng dựa trên trạng thái
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_isSuccess) {
                        // Bước 1: Hiện thông báo thành công
                        setState(() {
                          _isSuccess = true;
                        });
                      } else {
                        // Bước 2: Quay về trang Login
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4285F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _isSuccess ? 'Quay về đăng nhập' : 'Xác nhận',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildTextField({bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
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
