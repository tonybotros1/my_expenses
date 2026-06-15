enum MoneyMovementType { income, expense, transfer, goal }

class MoneyMovement {
  MoneyMovement({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.note,
    this.walletId,
    this.toWalletId,
    this.linkedItemId,
    this.goalId,
  });

  final String id;
  final MoneyMovementType type;
  final double amount;
  final DateTime date;
  final String note;
  final String? walletId;
  final String? toWalletId;
  final String? linkedItemId;
  final String? goalId;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
      'walletId': walletId,
      'toWalletId': toWalletId,
      'linkedItemId': linkedItemId,
      'goalId': goalId,
    };
  }

  factory MoneyMovement.fromMap(Map<dynamic, dynamic> map) {
    return MoneyMovement(
      id: '${map['id'] ?? ''}',
      type: MoneyMovementType.values.firstWhere(
        (type) => type.name == map['type'],
        orElse: () => MoneyMovementType.expense,
      ),
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      date: DateTime.tryParse('${map['date'] ?? ''}') ?? DateTime.now(),
      note: '${map['note'] ?? ''}',
      walletId: map['walletId'] as String?,
      toWalletId: map['toWalletId'] as String?,
      linkedItemId: map['linkedItemId'] as String?,
      goalId: map['goalId'] as String?,
    );
  }
}
