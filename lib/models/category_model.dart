import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
class CategoryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  CategoryModel copyWith({String? id, String? name}) {
    return CategoryModel(id: id ?? this.id, name: name ?? this.name);
  }

  CategoryModel({required this.id, required this.name});
}
