import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../consts.dart';
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

  @override
  void onClose() {
    // if (Hive.isBoxOpen('category_box')) {
    //   Hive.box<CategoryModel>('items').close();
    // }
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

  void deleteCategoryById(String id) {
    final category = _box.get(id);
    if (category == null) {
      showSnackBar(title: 'Error', message: 'Category not found!');

      return;
    }

    _box.delete(id).whenComplete(() {
      showSnackBar(
        title: 'Deleted',
        message: 'Category "${category.name}" has been deleted',
      );
    });
  }

  void addCategoryByName(String name) {
    final exists = categories.any(
      (cat) => cat.name.toLowerCase() == name.toLowerCase(),
    );

    if (exists) {
      showSnackBar(title: 'Already Exists', message: 'Category "$name" Exists');

      return;
    }
    Get.back();

    final newCategory = CategoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );
    showSnackBar(title: 'Category Added', message: 'Category "$name"');

    _box.put(newCategory.id, newCategory);
  }

  void editCategoryName(String id, String newName) {
    // تأكد إنو الاسم الجديد ما بيتكرر
    final exists = categories.any(
      (cat) =>
          cat.name.toLowerCase() == newName.toLowerCase() &&
          cat.id != id, // تجاهل العنصر الجاري تعديله
    );

    if (exists) {
      showSnackBar(
        title: 'Already Exists',
        message: 'Another category with the name "$newName" already exists.',
      );
      return;
    }
    Get.back();

    final category = _box.get(id);
    if (category != null) {
      final updatedCategory = category.copyWith(name: newName);
      _box.put(id, updatedCategory);

      showSnackBar(
        title: 'Category Updated',
        message: 'The category has been renamed to "$newName".',
      );
    } else {
      showSnackBar(title: 'Error', message: 'Category not found.');
    }
  }
}
