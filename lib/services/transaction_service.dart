import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class TransactionService {
  // Lấy baseUrl từ AuthService và đổi đuôi thành /Transaction
  // Ví dụ: http://localhost:5259/api/Transaction
  static String get apiUrl =>
      "${AuthService.baseUrl.replaceAll('/Auth', '/Transaction')}";

  // ================== 1. THÊM GIAO DỊCH ==================
  static Future<bool> addTransaction({
    required double amount,
    required String category,
    required String type,
    String description = "",
  }) async {
    final url = Uri.parse(apiUrl);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': AuthService.currentUserId,
          'amount': amount,
          'category': category,
          'type': type,
          'description': description,
          'transactionDate': DateTime.now().toIso8601String(),
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Lỗi thêm transaction: $e");
      return false;
    }
  }

  // ================== 2. PHÂN TÍCH TEXT (AI) ==================
  static Future<Map<String, dynamic>?> analyzeText(String content) async {
    final url = Uri.parse("$apiUrl/analyze");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'content': content}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Trả về kết quả phân tích
      } else {
        print("Lỗi phân tích: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Lỗi kết nối Analyze: $e");
      return null;
    }
  }

  // ================== 3. XÓA GIAO DỊCH (MỚI) ==================
  static Future<bool> deleteTransaction(int id) async {
    final url = Uri.parse("$apiUrl/$id");
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print("Đã xóa giao dịch ID: $id");
        return true;
      } else {
        print("Lỗi xóa: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Lỗi kết nối Delete: $e");
      return false;
    }
  }

  // ================== 4. SỬA GIAO DỊCH (MỚI) ==================
  static Future<bool> updateTransaction(
      int id, Map<String, dynamic> data) async {
    final url = Uri.parse("$apiUrl/$id");
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Đã cập nhật giao dịch ID: $id");
        return true;
      } else {
        print("Lỗi cập nhật: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Lỗi kết nối Update: $e");
      return false;
    }
  }
}
