import 'package:hive/hive.dart';
import '../models/category_model.dart';

Future<void> initHive() async {
  Hive.registerAdapter(CategoryModelAdapter());
  await Hive.openBox<CategoryModel>('category_box');
}
