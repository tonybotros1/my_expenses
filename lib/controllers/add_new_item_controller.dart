import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../consts.dart';
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

  // this function is to add new category
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

  // this functios is to add new item
  addNewItem(){
    
  }
}
