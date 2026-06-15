class WalletAccount {
  WalletAccount({
    required this.id,
    required this.name,
    required this.balance,
    required this.createdAt,
  });

  final String id;
  final String name;
  final double balance;
  final DateTime createdAt;

  WalletAccount copyWith({
    String? id,
    String? name,
    double? balance,
    DateTime? createdAt,
  }) {
    return WalletAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory WalletAccount.fromMap(Map<dynamic, dynamic> map) {
    return WalletAccount(
      id: '${map['id'] ?? ''}',
      name: '${map['name'] ?? ''}',
      balance: (map['balance'] as num?)?.toDouble() ?? 0,
      createdAt:
          DateTime.tryParse('${map['createdAt'] ?? ''}') ?? DateTime.now(),
    );
  }
}
