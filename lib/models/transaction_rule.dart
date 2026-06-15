class TransactionRule {
  TransactionRule({
    required this.id,
    required this.keyword,
    required this.category,
    required this.isActive,
  });

  final String id;
  final String keyword;
  final String category;
  final bool isActive;

  TransactionRule copyWith({
    String? id,
    String? keyword,
    String? category,
    bool? isActive,
  }) {
    return TransactionRule(
      id: id ?? this.id,
      keyword: keyword ?? this.keyword,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'keyword': keyword,
      'category': category,
      'isActive': isActive,
    };
  }

  factory TransactionRule.fromMap(Map<dynamic, dynamic> map) {
    return TransactionRule(
      id: '${map['id'] ?? ''}',
      keyword: '${map['keyword'] ?? ''}',
      category: '${map['category'] ?? ''}',
      isActive: map['isActive'] != false,
    );
  }
}
