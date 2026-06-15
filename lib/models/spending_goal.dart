class SpendingGoal {
  SpendingGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.dueDate,
    required this.createdAt,
  });

  final String id;
  final String name;
  final double targetAmount;
  final double savedAmount;
  final DateTime? dueDate;
  final DateTime createdAt;

  double get progress {
    if (targetAmount <= 0) return 0;
    return (savedAmount / targetAmount).clamp(0, 1);
  }

  double get remaining => targetAmount - savedAmount;

  SpendingGoal copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? savedAmount,
    DateTime? dueDate,
    DateTime? createdAt,
  }) {
    return SpendingGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SpendingGoal.fromMap(Map<dynamic, dynamic> map) {
    return SpendingGoal(
      id: '${map['id'] ?? ''}',
      name: '${map['name'] ?? ''}',
      targetAmount: (map['targetAmount'] as num?)?.toDouble() ?? 0,
      savedAmount: (map['savedAmount'] as num?)?.toDouble() ?? 0,
      dueDate: DateTime.tryParse('${map['dueDate'] ?? ''}'),
      createdAt:
          DateTime.tryParse('${map['createdAt'] ?? ''}') ?? DateTime.now(),
    );
  }
}
