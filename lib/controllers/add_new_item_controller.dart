import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:my_expenses/models/item_model.dart';
import 'package:intl/intl.dart';
import '../consts.dart';
import '../models/category_model.dart';

class AddNewItemController extends GetxController {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String? selectedCategory;
  late Box<CategoryModel> _box;
  late Box<ItemModel> _itemsBox;
  var categories = <CategoryModel>[].obs;
  DateFormat formatter = DateFormat('dd-MM-yyyy');

  @override
  void onInit() async {
    super.onInit();
    // category box
    await Hive.openBox<CategoryModel>('category_box');
    _box = Hive.box<CategoryModel>('category_box');

    // item box
    await Hive.openBox<ItemModel>('item_box');
    _itemsBox = Hive.box<ItemModel>('item_box');

    loadCategories();
    _box.watch().listen((_) => loadCategories());
  }

  @override
  void onClose() {
    if (Hive.isBoxOpen('category_box')) {
      Hive.box<CategoryModel>('category_box').close();
    }
    if (Hive.isBoxOpen('item_box')) {
      Hive.box<ItemModel>('item_box').close();
    }
    super.onClose();
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
  void addNewItem() async {
    try {
      // Validate required fields
      if (itemNameController.text.isEmpty ||
          dateController.text.isEmpty ||
          selectedCategory == null) {
        showSnackBar(
          title: 'Error',
          message: 'Please fill all required fields.',
        );
        return;
      }

      // Parse the date
      DateTime parsedDate;
      try {
        parsedDate = formatter.parse(dateController.text);
      } catch (e) {
        showSnackBar(title: 'Error', message: 'Invalid date format.');
        return;
      }

      // Create new item
      final newItem = ItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: itemNameController.text.trim(),
        category:
            selectedCategory!, // assuming it's a String or use selectedCategory.name
        date: parsedDate,
        note: noteController.text.trim(),
        price: double.tryParse(priceController.text.trim()) ?? 0.0,
      );

      // Add to Hive box
      await _itemsBox.put(newItem.id, newItem);

      // Success feedback
      showSnackBar(title: 'Done', message: 'Item added successfully');
    } catch (e) {
      print('Add item error: $e');
      showSnackBar(title: 'Error', message: 'Failed to add item.');
    }
  }

  Future<void> selectDateContext(
    BuildContext context,
    TextEditingController date,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      date.text = textToDate(picked.toString());
    }
  }
}
