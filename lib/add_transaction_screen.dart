import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'home_screen.dart';
import 'profile_screen.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});
=======
import 'services/transaction_service.dart';

class AddTransactionScreen extends StatefulWidget {
  // Biến nhận dữ liệu để Sửa (Nếu null thì là Thêm mới)
  final Map<String, dynamic>? transactionToEdit;

  const AddTransactionScreen({super.key, this.transactionToEdit});
>>>>>>> backend-dev

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
<<<<<<< HEAD
  bool _isExpense = true; // true = Chi tiêu, false = Thu nhập
  final TextEditingController _amountController = TextEditingController(text: '0');
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  DateTime _selectedDate = DateTime(2025, 12, 16);
=======

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
>>>>>>> backend-dev

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
<<<<<<< HEAD
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    _contentController.dispose();
    _smsController.dispose();
    super.dispose();
=======

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
>>>>>>> backend-dev
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: const Text(
              'FinPal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF4285F4),
                fontSize: 20,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF4285F4),
                  child: Text(
                    'HQ',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Thêm giao dịch',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF4285F4),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF4285F4),
            tabs: const [
              Tab(text: 'SMS Scan'),
              Tab(text: 'QR Scan'),
              Tab(text: 'Nhập tay'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSMSScanTab(),
                _buildQRScanTab(),
                _buildManualInputTab(),
=======
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
>>>>>>> backend-dev
              ],
            ),
          ),
        ],
      ),
<<<<<<< HEAD
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  Widget _buildSMSScanTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Copy tin nhắn biến động số dư ngân hàng vào đây để AI phân tích',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _smsController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Ví dụ: VCB -50,000 coffee',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Xử lý phân tích text
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đang phân tích tin nhắn...'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285F4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Phân tích Text',
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
    );
  }

  Widget _buildQRScanTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Hướng camera về phía mã QR\n(VietQR, Hóa đơn điện tử)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Xử lý quét QR
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đang mở camera quét QR...'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285F4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Bắt đầu quét Camera',
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
    );
  }

  Widget _buildManualInputTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Loại giao dịch
          const Text(
            'Loại giao dịch',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTransactionTypeButton(
                  'Chi tiêu',
                  true,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTransactionTypeButton(
                  'Thu nhập',
                  false,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Số tiền
          const Text(
            'Số tiền (VND)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Danh mục
          const Text(
            'Danh mục',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Chọn danh mục',
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Nội dung/địa điểm
          const Text(
            'Nội dung/địa điểm',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Ví dụ: Cơm trưa, Grab',
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Ngày
          const Text(
            'Ngày',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Nút Lưu giao dịch
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Xử lý lưu giao dịch
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã lưu giao dịch thành công!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285F4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Lưu giao dịch',
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
    );
  }

  Widget _buildTransactionTypeButton(String label, bool isExpenseType, Color color) {
    final isSelected = _isExpense == isExpenseType;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpense = isExpenseType;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? color : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      elevation: 10,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.grid_view_rounded, color: Color(0xFF4285F4)),
                  Text(
                    'Tổng quan',
                    style: TextStyle(color: Color(0xFF4285F4), fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
            const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chat_bubble_outline, color: Colors.grey),
                Text(
                  'Trợ lý AI',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
=======
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
>>>>>>> backend-dev
      ),
    );
  }
}
<<<<<<< HEAD

=======
>>>>>>> backend-dev
