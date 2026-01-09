class AIHint {
  final String title;
  final String content;
  final String level; // 'warning', 'good', 'tip'

  AIHint({required this.title, required this.content, required this.level});

  factory AIHint.fromJson(Map<String, dynamic> json) {
    return AIHint(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      level: json['level'] ?? 'tip',
    );
  }
}

class SavingGoalModel {
  final String name;
  final double targetAmount;
  final double currentAmount;

  SavingGoalModel({
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
  });

  Map<String, dynamic> toJson() => {
    'goal_name': name,
    'target_amount': targetAmount,
    'current_amount': currentAmount,
  };
}
