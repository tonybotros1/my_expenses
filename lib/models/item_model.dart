import 'package:hive/hive.dart';

part 'item_model.g.dart';

@HiveType(typeId: 1)
class ItemModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String note;

  ItemModel copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    DateTime? date,
    String? note,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.name,
    );
  }

  ItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.note,
    required this.price,
  });
}
