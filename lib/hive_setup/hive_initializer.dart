import 'package:hive/hive.dart';
import '../models/category_model.dart';
import '../models/item_model.dart';

Future<void> initHive() async {
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(ItemModelAdapter());

  // await Hive.openBox<CategoryModel>('category_box');
}
