import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/category_model.dart';

class AddNewItemController extends GetxController {
  TextEditingController amountController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String? selectedCategory;
  late Box<CategoryModel> _box;
  var categories = <CategoryModel>[].obs;

  // List categories = [
  //   'Food',
  //   'Transportations',
  //   'Clothes',
  //   'Bills',
  //   'Entertainment',
  //   'Devices',
  // ];

  @override
  void onInit() async {
    super.onInit();

    _box = Hive.box<CategoryModel>('category_box');
    loadCategories();
    _box.watch().listen((_) => loadCategories());
  }

  void loadCategories() {
    categories.value = _box.values.toList();
  }

  void addCategoryByName(String name) {
    final exists = categories.any(
      (cat) => cat.name.toLowerCase() == name.toLowerCase(),
    );

    if (exists) {
      Get.snackbar(
        'Already Exists',
        'Category "$name" Exists',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[200],
        colorText: Colors.white,
      );
      return;
    }

    final newCategory = CategoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );

    _box.put(newCategory.id, newCategory);
  }
}
