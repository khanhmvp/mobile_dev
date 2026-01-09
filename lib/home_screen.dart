import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'transaction_detail_screen.dart';
import 'add_transaction_screen.dart';
import 'profile_screen.dart';
import 'ai_assistant_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(width),
      body: _currentIndex == 0
          ? _buildOverviewTab(context, width, height)
          : const AIAssistantScreen(),
      floatingActionButton: _buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomBar(width),
    );
  }

  // ================= APP BAR =================
  AppBar _buildAppBar(double width) {
    return AppBar(
      backgroundColor: const Color(0xFF4285F4),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text(
        'FinPal',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white30,
              child: Text(
                'HQ',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= OVERVIEW TAB =================
  Widget _buildOverviewTab(BuildContext context, double width, double height) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 80),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng quan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Text('12/2025', style: TextStyle(fontSize: 14)),
                      SizedBox(width: 8),
                      Icon(Icons.calendar_month, size: 18, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBalanceCard(width, height),
          const SizedBox(height: 24),
          _buildTransactionListSection(context, width, height),
        ],
      ),
    );
  }

  // ================= BALANCE CARD =================
  Widget _buildBalanceCard(double width, double height) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4285F4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tổng số dư hiện tại',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            '29,110,000 VND',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat('Thu', '40,000,000 VND', Colors.green),
              _buildStat('Chi', '1,890,000 VND', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= TRANSACTION LIST =================
  Widget _buildTransactionListSection(
    BuildContext context,
    double width,
    double height,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Chi tiết giao dịch',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        _buildTransactionItem(
          'Di chuyển',
          'Grab 30/12',
          '-55,000 VND',
          Colors.red,
        ),
        _buildTransactionItem(
          'Ăn uống',
          'Hadilao 17/12',
          '-1,200,000 VND',
          Colors.red,
        ),
        _buildTransactionItem(
          'Tiền lương',
          'Công ty A 15/12',
          '+40,000,000 VND',
          Colors.green,
        ),
        _buildTransactionItem(
          'Mua sắm',
          'Uniqlo 13/12',
          '-3,000,000 VND',
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    String category,
    String description,
    String amount,
    Color amountColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }

  // ================= FAB =================
  FloatingActionButton _buildFAB(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF4285F4),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
      ),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  // ================= BOTTOM BAR =================
  Widget _buildBottomBar(double width) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomItem(
              icon: Icons.grid_view_rounded,
              label: 'Tổng quan',
              active: _currentIndex == 0,
              onTap: () => setState(() => _currentIndex = 0),
            ),
            const SizedBox(width: 60),
            _bottomItem(
              icon: Icons.chat_bubble_outline,
              label: 'Trợ lý AI',
              active: _currentIndex == 1,
              onTap: () => setState(() => _currentIndex = 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomItem({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: active ? const Color(0xFF4285F4) : Colors.grey.shade400,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: active ? const Color(0xFF4285F4) : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
