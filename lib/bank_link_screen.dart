import 'package:flutter/material.dart';
import 'home_screen.dart';

class BankLinkScreen extends StatefulWidget {
  const BankLinkScreen({super.key});

  @override
  State<BankLinkScreen> createState() => _BankLinkScreenState();
}

class _BankLinkScreenState extends State<BankLinkScreen> {
  String? _selectedBank;

  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  void _selectBank(String bankName) {
    setState(() {
      _selectedBank = bankName;
    });
    print("Đã chọn ngân hàng: $bankName");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Liên kết ngân hàng",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Vui lòng click vào một trong các ô dưới đây:"),
              const SizedBox(height: 20),
              _buildSimpleTile("MB Bank", Colors.blue.shade900),
              _buildSimpleTile("VietinBank", Colors.blue),
              _buildSimpleTile("VietcomBank", Colors.green),
              if (_selectedBank != null) ...[
                const SizedBox(height: 20),
                Text(
                  "Đã chọn: $_selectedBank",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleTile(String name, Color color) {
    final isSelected = _selectedBank == name;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: MouseRegion(
        cursor: SystemMouseCursors.click, // Đổi con trỏ thành bàn tay khi hover
        child: GestureDetector(
          onTap: () {
            _selectBank(name);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withOpacity(0.3)
                  : color.withOpacity(0.1),
              border: Border.all(color: color, width: isSelected ? 3 : 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.check_circle, color: Colors.green, size: 24),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
