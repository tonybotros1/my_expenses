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

  final colors = [
    Color(0xFFFFF3E0),
    Color(0xFFE1F5FE),
    Color(0xFFF3E5F5),
    Color(0xFFE8F5E9),
    Color(0xFFFFEBEE),
    Color(0xFFFFFDE7),
    Color(0xFFE0F7FA),
    Color(0xFFFBE9E7),
    Color(0xFFEDE7F6),
    Color(0xFFF1F8E9),
    Color(0xFFFFF8E1),
    Color(0xFFF9FBE7),
    Color(0xFFE3F2FD),
    Color(0xFFFCE4EC),
    Color(0xFFD7CCC8),
    Color(0xFFF5F5F5),
    Color(0xFFE0F2F1),
    Color(0xFFFFE0B2),
    Color(0xFFDCEDC8),
    Color(0xFFFFCDD2),
    Color(0xFFB3E5FC),
    Color(0xFFD1C4E9),
    Color(0xFFFFF9C4),
    Color(0xFFFFE0E0),
    Color(0xFFC8E6C9),
    Color(0xFFB2DFDB),
    Color(0xFFFFF3F0),
    Color(0xFFFFDDEE),
    Color(0xFFE4F0E2),
    Color(0xFFF2F2FF),
    Color(0xFFEBF6FF),
    Color(0xFFFFF7EC),
    Color(0xFFEDF7F6),
    Color(0xFFE9F5E1),
    Color(0xFFF5EBF7),
    Color(0xFFFDECEA),
    Color(0xFFE8F0FE),
    Color(0xFFFDF1FF),
    Color(0xFFFFF2E6),
    Color(0xFFF6FFF8),
    Color(0xFFF9F3F3),
    Color(0xFFECF8F8),
    Color(0xFFFFF4F4),
    Color(0xFFE7FFF2),
    Color(0xFFF3FFFD),
    Color(0xFFF6F3FF),
    Color(0xFFFEEFFB),
    Color(0xFFEFFBFF),
    Color(0xFFF1FFF0),
    Color(0xFFFFEFFF),
  ];

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
    if (Hive.isBoxOpen('category_box')) {
      Hive.box<CategoryModel>('items').close();
    }
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
