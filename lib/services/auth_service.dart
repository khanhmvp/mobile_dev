import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // 1. BIẾN LƯU TRỮ ID NGƯỜI DÙNG
  static int currentUserId = 0;

  // 2. CẤU HÌNH ĐỊA CHỈ SERVER
  // Đảm bảo cổng 5259 khớp với Backend đang chạy
  static const String baseUrl = "http://localhost:5259/api/Auth";

  // --- HÀM ĐĂNG KÝ ---
  static Future<bool> register(
    String fullName,
    String phone,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'phoneNumber': phone,
          'password': password,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Lỗi Register: $e");
      return false;
    }
  }

  // --- HÀM ĐĂNG NHẬP ---
  static Future<Map<String, dynamic>?> login(
    String phone,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': phone, 'password': password}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['userId'] != null) {
          currentUserId = data['userId'];
        }
        return data;
      }
      return null;
    } catch (e) {
      print("Lỗi Login: $e");
      return null;
    }
  }

  // --- HÀM GỬI OTP (Mới thêm) ---
  static Future<bool> sendOtp(String phone) async {
    final url = Uri.parse('$baseUrl/send-otp');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': phone}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Lỗi OTP: $e");
      return false;
    }
  }

  // --- HÀM ĐỔI MẬT KHẨU (Mới thêm) ---
  static Future<bool> resetPassword(
    String phone,
    String otp,
    String newPass,
  ) async {
    final url = Uri.parse('$baseUrl/reset-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phone,
          'otp': otp,
          'newPassword': newPass,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Lỗi Reset Pass: $e");
      return false;
    }
  }
}
