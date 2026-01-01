import 'package:flutter/material.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  // Khai báo các bộ điều khiển để lấy dữ liệu từ ô nhập
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _currentAmountController =
      TextEditingController();

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi không sử dụng
    _goalController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trợ lí FinPal',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Luôn theo dõi sức khỏe tài chính của bạn',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          _buildAIHintCard(
            'Cẩn trọng với chi phí di chuyển',
            'Khoản chi 55,000 cho "Di chuyển" là cao nhất...',
            const Color(0xFFFFF8E1),
            Colors.orange,
          ),
          _buildAIHintCard(
            'Quản lí tài chính xuất sắc',
            'Bạn đang làm rất tốt! Với thu nhập 40 triệu...',
            const Color(0xFFE8F5E9),
            Colors.green,
          ),
          _buildAIHintCard(
            'Mẹo nhỏ cho ví tiền to',
            'Với khoản tiền dư đáng kể, hãy nghĩ đến việc tiết kiệm...',
            const Color(0xFFE3F2FD),
            Colors.blue,
          ),

          const SizedBox(height: 20),

          // Form mục tiêu tiết kiệm đã sửa thành TextField
          _buildSavingGoalForm(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSavingGoalForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mục tiêu tiết kiệm',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Chỉnh sửa',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Sử dụng hàm _buildInputField mới để nhập dữ liệu
          _buildInputField(
            'Mục tiêu tiết kiệm',
            _goalController,
            TextInputType.text,
          ),
          _buildInputField(
            'Số tiền cần tiết kiệm',
            _targetAmountController,
            TextInputType.number,
          ),
          _buildInputField(
            'Số tiền đã có',
            _currentAmountController,
            TextInputType.number,
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Xóa trắng các ô nhập khi bấm Hủy
                    _goalController.clear();
                    _targetAmountController.clear();
                    _currentAmountController.clear();
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Hủy',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Xử lý dữ liệu khi bấm Lưu
                    print('Mục tiêu: ${_goalController.text}');
                    print('Cần có: ${_targetAmountController.text}');
                    print('Hiện có: ${_currentAmountController.text}');

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã lưu mục tiêu tiết kiệm!'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Lưu',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Hàm tạo ô nhập dữ liệu (TextField)
  Widget _buildInputField(
    String hint,
    TextEditingController controller,
    TextInputType type,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF4A4A4A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70, fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          border: InputBorder.none, // Ẩn đường viền mặc định của TextField
        ),
      ),
    );
  }

  Widget _buildAIHintCard(
    String title,
    String content,
    Color bg,
    Color textCol,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textCol.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: textCol),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
