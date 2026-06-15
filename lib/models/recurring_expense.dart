import 'package:intl/intl.dart';

class RecurringExpense {
  RecurringExpense({
    required this.id,
    required this.name,
    required this.category,
    required this.unitPrice,
    required this.quantity,
    required this.note,
    required this.dayOfMonth,
    required this.isActive,
    this.lastCreatedMonth,
  });

  final String id;
  final String name;
  final String category;
  final double unitPrice;
  final int quantity;
  final String note;
  final int dayOfMonth;
  final bool isActive;
  final String? lastCreatedMonth;

  double get totalPrice => unitPrice * quantity;

  bool isDue(DateTime now) {
    return isActive &&
        now.day >= dayOfMonth.clamp(1, 28) &&
        lastCreatedMonth != monthKey(now);
  }

  DateTime nextDueDate(DateTime now) {
    final dueDay = dayOfMonth.clamp(1, 28);
    final thisMonth = DateTime(now.year, now.month, dueDay);
    if (thisMonth.isAfter(now) && lastCreatedMonth != monthKey(now)) {
      return thisMonth;
    }
    return DateTime(now.year, now.month + 1, dueDay);
  }

  RecurringExpense copyWith({
    String? id,
    String? name,
    String? category,
    double? unitPrice,
    int? quantity,
    String? note,
    int? dayOfMonth,
    bool? isActive,
    String? lastCreatedMonth,
  }) {
    return RecurringExpense(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      isActive: isActive ?? this.isActive,
      lastCreatedMonth: lastCreatedMonth ?? this.lastCreatedMonth,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'note': note,
      'dayOfMonth': dayOfMonth,
      'isActive': isActive,
      'lastCreatedMonth': lastCreatedMonth,
    };
  }

  factory RecurringExpense.fromMap(Map<dynamic, dynamic> map) {
    return RecurringExpense(
      id: '${map['id'] ?? ''}',
      name: '${map['name'] ?? ''}',
      category: '${map['category'] ?? ''}',
      unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      note: '${map['note'] ?? ''}',
      dayOfMonth: (map['dayOfMonth'] as num?)?.toInt() ?? 1,
      isActive: map['isActive'] != false,
      lastCreatedMonth: map['lastCreatedMonth'] as String?,
    );
  }

  static String monthKey(DateTime date) => DateFormat('yyyy-MM').format(date);
}
