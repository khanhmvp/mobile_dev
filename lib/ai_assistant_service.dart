import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_assistant_model.dart';

class AIAssistantService {
  // Thay địa chỉ IP này bằng IP máy tính của bạn nếu dùng máy thật
  static const String baseUrl = "http://10.0.2.2:5000/api";

  // Lấy danh sách gợi ý tài chính
  Future<List<AIHint>> fetchInsights(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/insights/$userId'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((item) => AIHint.fromJson(item)).toList();
      }
    } catch (e) {
      print("Lỗi fetchInsights: $e");
    }
    return [];
  }

  // Gửi mục tiêu tiết kiệm lên server
  Future<bool> saveSavingGoal(int userId, SavingGoalModel goal) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/save-goal/$userId'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(goal.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
