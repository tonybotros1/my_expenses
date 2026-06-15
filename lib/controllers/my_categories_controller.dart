import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../consts.dart';
import '../models/category_model.dart';

class MyCategoriesController extends GetxController {
  TextEditingController category = TextEditingController();

  late Box<CategoryModel> _box;
  StreamSubscription<BoxEvent>? _categorySubscription;
  var categories = <CategoryModel>[].obs;
  RxBool isScreenLoading = RxBool(false);

  @override
  void onInit() async {
    super.onInit();

    _box = Hive.isBoxOpen('category_box')
        ? Hive.box<CategoryModel>('category_box')
        : await Hive.openBox<CategoryModel>('category_box');

    loadCategories();
    _categorySubscription = _box.watch().listen((_) => loadCategories());
  }

  @override
  void onClose() {
    _categorySubscription?.cancel();
    category.dispose();
    super.onClose();
  }

  void loadCategories() {
    isScreenLoading.value = true;
    categories.value = _box.values.toList();
    // print(categories.map((value){
    //   print(value.name);
    // }));
    isScreenLoading.value = false;
  }

  Future<bool> deleteCategoryById(String id) async {
    final category = _box.get(id);
    if (category == null) {
      showSnackBar(title: 'Error', message: 'Category not found!');

      return false;
    }

    await _box.delete(id);
    showSnackBar(
      title: 'Deleted',
      message: 'Category "${category.name}" has been deleted',
    );
    return true;
  }

  void addCategoryByName(String name) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      showSnackBar(title: 'Error', message: 'Please enter a category name.');
      return;
    }

    final exists = categories.any(
      (cat) => cat.name.toLowerCase() == trimmedName.toLowerCase(),
    );

    if (exists) {
      showSnackBar(
        title: 'Already Exists',
        message: 'Category "$trimmedName" Exists',
      );

      return;
    }
    Get.back();

    final newCategory = CategoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: trimmedName,
    );
    showSnackBar(title: 'Category Added', message: 'Category "$trimmedName"');

    _box.put(newCategory.id, newCategory);
  }

  void editCategoryName(String id, String newName) {
    final trimmedName = newName.trim();
    if (trimmedName.isEmpty) {
      showSnackBar(title: 'Error', message: 'Please enter a category name.');
      return;
    }

    final exists = categories.any(
      (cat) =>
          cat.name.toLowerCase() == trimmedName.toLowerCase() && cat.id != id,
    );

    if (exists) {
      showSnackBar(
        title: 'Already Exists',
        message:
            'Another category with the name "$trimmedName" already exists.',
      );
      return;
    }
    Get.back();

    final category = _box.get(id);
    if (category != null) {
      final updatedCategory = category.copyWith(name: trimmedName);
      _box.put(id, updatedCategory);

      showSnackBar(
        title: 'Category Updated',
        message: 'The category has been renamed to "$trimmedName".',
      );
    } else {
      showSnackBar(title: 'Error', message: 'Category not found.');
    }
  }
}
