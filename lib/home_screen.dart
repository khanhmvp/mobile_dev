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
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: width * 0.04),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white30,
              child: Text(
                'HQ',
                style: TextStyle(color: Colors.white, fontSize: 10),
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
      padding: EdgeInsets.only(bottom: height * 0.14),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng quan',
                  style: TextStyle(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                    vertical: height * 0.007,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '12/2025',
                        style: TextStyle(fontSize: width * 0.035),
                      ),
                      SizedBox(width: width * 0.02),
                      Icon(
                        Icons.calendar_month,
                        size: width * 0.045,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBalanceCard(width, height),
          SizedBox(height: height * 0.03),
          _buildChartSection(context, width),
        ],
      ),
    );
  }

  // ================= BALANCE CARD =================
  Widget _buildBalanceCard(double width, double height) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.04),
      padding: EdgeInsets.all(width * 0.05),
      decoration: BoxDecoration(
        color: const Color(0xFF4285F4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng số dư hiện tại',
            style: TextStyle(color: Colors.white70, fontSize: width * 0.035),
          ),
          SizedBox(height: height * 0.006),
          Text(
            '29,110,000 VND',
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.065,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: height * 0.015),
          const Divider(color: Colors.white24),
          SizedBox(height: height * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat('Thu', '40,000,000 VND', Colors.greenAccent, width),
              _buildStat('Chi', '10,890,000 VND', Colors.orangeAccent, width),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color, double width) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        SizedBox(width: width * 0.02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.white70, fontSize: width * 0.03),
            ),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.035,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= CHART =================
  Widget _buildChartSection(BuildContext context, double width) {
    final chartSize = width * 0.55;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.04),
      padding: EdgeInsets.all(width * 0.06),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          SizedBox(
            height: chartSize,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: chartSize * 0.2,
                sectionsSpace: 0,
                sections: [
                  PieChartSectionData(
                    color: const Color(0xFFFF6B81),
                    value: 45,
                    radius: chartSize * 0.4,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    color: const Color(0xFFFFD567),
                    value: 30,
                    radius: chartSize * 0.4,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    color: const Color(0xFF42A5F5),
                    value: 25,
                    radius: chartSize * 0.4,
                    showTitle: false,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: width * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _legendItem(const Color(0xFFFFD567), 'Mua sắm', width),
              _legendItem(const Color(0xFF42A5F5), 'Điện nước', width),
              _legendItem(const Color(0xFFFF6B81), 'Ăn uống', width),
            ],
          ),
          SizedBox(height: width * 0.04),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TransactionDetailScreen(),
                ),
              ),
              child: Text(
                'Xem chi tiết',
                style: TextStyle(
                  fontSize: width * 0.035,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String text, double width) {
    return Row(
      children: [
        Container(
          width: width * 0.03,
          height: width * 0.01,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: width * 0.015),
        Text(text, style: TextStyle(fontSize: width * 0.035)),
      ],
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
            SizedBox(width: width * 0.15),
            _bottomItem(
              icon: Icons.chat_bubble_outline,
              label: 'Trợ lý AI',
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
