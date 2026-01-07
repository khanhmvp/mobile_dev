import 'package:flutter/material.dart';
import 'services/transaction_service.dart';

class AddTransactionScreen extends StatefulWidget {
  // Biến nhận dữ liệu để Sửa (Nếu null thì là Thêm mới)
  final Map<String, dynamic>? transactionToEdit;

  const AddTransactionScreen({super.key, this.transactionToEdit});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controller cho Tab Nhập tay
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // Controller cho Tab SMS Scan
  final TextEditingController _smsController = TextEditingController();

  String _selectedType = "Expense";
  String _selectedCategory = "Ăn uống";
  final List<String> _categories = [
    "Ăn uống",
    "Di chuyển",
    "Mua sắm",
    "Lương",
    "Hóa đơn",
    "Khác"
  ];

  bool isAnalyzing = false; // Biến loading

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // --- LOGIC ĐIỀN DỮ LIỆU CŨ KHI SỬA ---
    if (widget.transactionToEdit != null) {
      var item = widget.transactionToEdit!;
      _amountController.text = item['amount'].toString(); // Điền số tiền cũ
      _noteController.text = item['description'] ?? ""; // Điền ghi chú cũ
      _selectedType = item['type']; // Chọn lại Thu/Chi

      // Chọn lại danh mục cũ
      if (_categories.contains(item['category'])) {
        _selectedCategory = item['category'];
      } else {
        _selectedCategory = "Khác";
      }

      // Tự động chuyển sang Tab "Nhập tay" để sửa luôn
      _tabController.index = 2;
    }
  }

  // --- HÀM XỬ LÝ PHÂN TÍCH AI (Giữ nguyên) ---
  void _handleAnalyze() async {
    String text = _smsController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng nhập nội dung tin nhắn!")));
      return;
    }

    setState(() => isAnalyzing = true);

    // Gọi API Backend
    var result = await TransactionService.analyzeText(text);

    setState(() => isAnalyzing = false);

    if (result != null) {
      // API trả về thành công -> Tự động điền dữ liệu sang Tab "Nhập tay"
      setState(() {
        _amountController.text = result['amount'].toString();
        _selectedType = result['type'];
        _noteController.text = result['description'];

        String cat = result['category'];
        if (_categories.contains(cat)) {
          _selectedCategory = cat;
        } else {
          _selectedCategory = "Khác";
        }
      });

      // Chuyển sang Tab "Nhập tay" để kiểm tra
      _tabController.animateTo(2);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Đã phân tích xong! Vui lòng kiểm tra lại."),
          backgroundColor: Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Lỗi phân tích, vui lòng thử lại."),
          backgroundColor: Colors.red));
    }
  }

  // --- HÀM LƯU / CẬP NHẬT ---
  void _handleSave() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng nhập số tiền!")));
      return;
    }

    bool success;
    double amount = double.parse(_amountController.text);

    if (widget.transactionToEdit == null) {
      // A. CHẾ ĐỘ THÊM MỚI
      success = await TransactionService.addTransaction(
        amount: amount,
        category: _selectedCategory,
        type: _selectedType,
        description: _noteController.text,
      );
    } else {
      // B. CHẾ ĐỘ SỬA (UPDATE)
      int id = widget.transactionToEdit!['id'];
      success = await TransactionService.updateTransaction(id, {
        'id': id,
        'userId': widget.transactionToEdit!['userId'], // Giữ nguyên ID User cũ
        'amount': amount,
        'category': _selectedCategory,
        'type': _selectedType,
        'description': _noteController.text,
      });
    }

    if (success) {
      if (mounted) {
        String msg = widget.transactionToEdit == null
            ? "Lưu thành công!"
            : "Cập nhật thành công!";
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: Colors.green));
        Navigator.pop(context); // Quay về Home
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Lỗi khi lưu!"), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.transactionToEdit != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
            isEditing
                ? "Sửa giao dịch"
                : "Thêm giao dịch", // Đổi tên tiêu đề tùy chế độ
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF4285F4),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF4285F4),
          // Nếu đang Sửa thì khóa không cho vuốt sang Tab SMS/QR để tập trung sửa
          physics: isEditing ? const NeverScrollableScrollPhysics() : null,
          tabs: const [
            Tab(text: "SMS Scan"),
            Tab(text: "QR Scan"),
            Tab(text: "Nhập tay"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        // Nếu đang Sửa thì khóa vuốt ngang
        physics: isEditing ? const NeverScrollableScrollPhysics() : null,
        children: [
          // TAB 1: SMS SCAN (Giữ nguyên giao diện đẹp)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                    "Copy tin nhắn biến động số dư ngân hàng vào đây để AI phân tích",
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                TextField(
                  controller: _smsController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Ví dụ: VCB -50,000 coffee",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isAnalyzing ? null : _handleAnalyze,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4285F4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: isAnalyzing
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Phân tích Text",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),

          // TAB 2: QR SCAN
          const Center(
              child: Text("Tính năng QR Scan đang phát triển...",
                  style: TextStyle(color: Colors.grey))),

          // TAB 3: NHẬP TAY (FORM)
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chọn Thu/Chi
                Row(
                  children: [
                    Expanded(
                        child: _buildTypeButton(
                            "Expense", "Chi tiêu (-)", Colors.red)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _buildTypeButton(
                            "Income", "Thu nhập (+)", Colors.green)),
                  ],
                ),
                const SizedBox(height: 20),

                const Text("Số tiền",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      suffixText: "VND",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 20),

                const Text("Danh mục",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val!),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 20),

                const Text("Ghi chú",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _handleSave,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4285F4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: Text(
                        isEditing
                            ? "CẬP NHẬT"
                            : "LƯU GIAO DỊCH", // Đổi tên nút tùy chế độ
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String value, String label, Color color) {
    bool isSelected = _selectedType == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade100,
          border: Border.all(
              color: isSelected ? color : Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: TextStyle(
                color: isSelected ? color : Colors.grey,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
