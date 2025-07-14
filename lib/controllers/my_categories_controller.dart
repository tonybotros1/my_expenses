import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/category_model.dart';

class MyCategoriesController extends GetxController {
  TextEditingController category = TextEditingController();

  late Box<CategoryModel> _box;
  var categories = <CategoryModel>[].obs;
  RxBool isScreenLoading = RxBool(false);
  @override
  void onInit() async {
    super.onInit();

    _box = Hive.isBoxOpen('category_box')
        ? Hive.box<CategoryModel>('category_box')
        : await Hive.openBox<CategoryModel>('category_box');

    loadCategories();
    _box.watch().listen((_) => loadCategories());
  }

  void loadCategories() {
    isScreenLoading.value = true;
    categories.value = _box.values.toList();
    isScreenLoading.value = false;
  }

  void deleteCategoryById(String id) {
    final category = _box.get(id);
    if (category == null) {
      Get.snackbar(
        'Error',
        'Category not found!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueGrey,
        colorText: Colors.white,
      );

      return;
    }

    _box.delete(id);
    Get.back();

    Get.snackbar(
      'Deleted',
      'Category "${category.name}" has been deleted',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
      colorText: Colors.white,
    );
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
