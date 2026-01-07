import 'package:flutter/material.dart';
// Import màn hình đăng nhập để quay về
import 'login_screen.dart';

class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa màn hình
            children: [
              // 1. Icon thành công
              const Icon(Icons.check_circle, size: 100, color: Colors.green),
              const SizedBox(height: 24),

              // 2. Thông báo chính
              const Text(
                'Đổi mật khẩu thành công!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4285F4), // Màu xanh thương hiệu FinPal
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // 3. Lời nhắn phụ
              const Text(
                'Tài khoản của bạn đã được cập nhật mật khẩu mới.\nHãy đăng nhập lại để tiếp tục sử dụng FinPal.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // 4. Nút quay về Đăng nhập
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Xóa hết lịch sử màn hình cũ và quay về trang Login
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
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
                    'Về trang đăng nhập',
                    style: TextStyle(
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
    );
  }
}
