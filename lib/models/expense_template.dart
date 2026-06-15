class ExpenseTemplate {
  ExpenseTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.unitPrice,
    required this.quantity,
    required this.note,
    required this.isFavorite,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String category;
  final double unitPrice;
  final int quantity;
  final String note;
  final bool isFavorite;
  final DateTime updatedAt;

  double get totalPrice => unitPrice * quantity;

  ExpenseTemplate copyWith({
    String? id,
    String? name,
    String? category,
    double? unitPrice,
    int? quantity,
    String? note,
    bool? isFavorite,
    DateTime? updatedAt,
  }) {
    return ExpenseTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      isFavorite: isFavorite ?? this.isFavorite,
      updatedAt: updatedAt ?? this.updatedAt,
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
      'isFavorite': isFavorite,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ExpenseTemplate.fromMap(Map<dynamic, dynamic> map) {
    return ExpenseTemplate(
      id: '${map['id'] ?? ''}',
      name: '${map['name'] ?? ''}',
      category: '${map['category'] ?? ''}',
      unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      note: '${map['note'] ?? ''}',
      isFavorite: map['isFavorite'] == true,
      updatedAt:
          DateTime.tryParse('${map['updatedAt'] ?? ''}') ?? DateTime.now(),
    );
  }
}
