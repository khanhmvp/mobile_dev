import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Format tiền
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'services/auth_service.dart';
import 'services/transaction_service.dart'; // Import để gọi hàm Xóa
import 'add_transaction_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;
  List<dynamic> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Hàm lấy dữ liệu (Đã có logic chống lỗi F5)
  Future<void> _fetchData() async {
    int userId = AuthService.currentUserId;

    if (userId == 0) {
      if (mounted) {
        setState(() => isLoading = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
      return;
    }

    setState(() => isLoading = true);

    try {
      final resSummary = await http.get(
        Uri.parse(
            "${AuthService.baseUrl.replaceAll('/Auth', '/Transaction')}/summary/$userId"),
      );

      final resList = await http.get(
        Uri.parse(
            "${AuthService.baseUrl.replaceAll('/Auth', '/Transaction')}/user/$userId"),
      );

      if (resSummary.statusCode == 200 && resList.statusCode == 200) {
        var summaryData = jsonDecode(resSummary.body);
        var listData = jsonDecode(resList.body);

        if (mounted) {
          setState(() {
            totalBalance = double.parse(summaryData['balance'].toString());
            totalIncome = double.parse(summaryData['income'].toString());
            totalExpense = double.parse(summaryData['expense'].toString());
            transactions = listData;
            isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => isLoading = false);
      }
    } catch (e) {
      print("Lỗi Home: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat("#,###");
    return "${formatter.format(amount)} VND";
  }

  // --- HÀM HIỆN MENU SỬA/XÓA ---
  void _showOptions(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 220,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const Text("Tùy chọn giao dịch",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 20),

            // Nút Sửa
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text("Sửa giao dịch"),
              onTap: () async {
                Navigator.pop(context); // Đóng menu
                // Chuyển sang màn hình Sửa (truyền item vào)
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddTransactionScreen(transactionToEdit: item),
                  ),
                );
                _fetchData(); // Load lại dữ liệu sau khi sửa
              },
            ),

            // Nút Xóa
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Xóa giao dịch"),
              onTap: () {
                Navigator.pop(context); // Đóng menu
                _confirmDelete(item['id']);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Hàm xác nhận xóa
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Bạn có chắc muốn xóa giao dịch này không?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Hủy")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx); // Đóng dialog
              // Gọi API Xóa
              bool success = await TransactionService.deleteTransaction(id);
              if (success) {
                _fetchData(); // Load lại dữ liệu
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Đã xóa thành công!")));
                }
              }
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4285F4),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddTransactionScreen()),
          );
          _fetchData();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.dashboard, color: Color(0xFF4285F4)),
                  Text("Tổng quan",
                      style: TextStyle(fontSize: 10, color: Color(0xFF4285F4))),
                ],
              ),
              const SizedBox(width: 40),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.chat_bubble_outline, color: Colors.grey),
                  Text("Trợ lý AI",
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                // Thêm tính năng kéo xuống để reload
                onRefresh: _fetchData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("FinPal",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF4285F4))),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 4)
                                ]),
                            child: const Icon(Icons.person, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Card Tổng quan
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFF4285F4), Color(0xFF3367D6)]),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 5))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Tổng số dư hiện tại",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14)),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Text("Hiện tại",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(formatCurrency(totalBalance),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: const [
                                        Icon(Icons.arrow_downward,
                                            color: Colors.greenAccent,
                                            size: 16),
                                        SizedBox(width: 4),
                                        Text("Thu",
                                            style: TextStyle(
                                                color: Colors.white70))
                                      ]),
                                      const SizedBox(height: 4),
                                      Text(formatCurrency(totalIncome),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: const [
                                        Icon(Icons.arrow_upward,
                                            color: Colors.orangeAccent,
                                            size: 16),
                                        SizedBox(width: 4),
                                        Text("Chi",
                                            style: TextStyle(
                                                color: Colors.white70))
                                      ]),
                                      const SizedBox(height: 4),
                                      Text(formatCurrency(totalExpense),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Text("Chi tiết giao dịch",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),

                      // Danh sách giao dịch
                      if (transactions.isEmpty)
                        const Center(
                            child: Padding(
                                padding: EdgeInsets.all(40),
                                child: Text("Chưa có giao dịch nào",
                                    style: TextStyle(color: Colors.grey))))
                      else
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            var item = transactions[index];
                            bool isIncome = item['type'] == "Income";

                            // BỌC TRONG GESTURE DETECTOR ĐỂ BẮT SỰ KIỆN BẤM
                            return GestureDetector(
                              onTap: () => _showOptions(
                                  item), // Bấm vào thì hiện menu Sửa/Xóa
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4))
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Icon(
                                        isIncome
                                            ? Icons.account_balance_wallet
                                            : Icons.shopping_bag,
                                        color: isIncome
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item['category'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          Text(item['description'],
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "${isIncome ? '+' : '-'}${formatCurrency(double.parse(item['amount'].toString()))}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: isIncome
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 80), // Khoảng trống cuối cùng
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
