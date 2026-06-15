import 'package:hive/hive.dart';
import '../models/category_model.dart';
import '../models/item_model.dart';

Future<void> initHive() async {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ItemModelAdapter());
  }
}
