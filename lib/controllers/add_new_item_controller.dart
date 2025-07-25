import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:my_expenses/models/item_model.dart';
import 'package:intl/intl.dart';
import '../consts.dart';
import '../models/category_model.dart';

class AddNewItemController extends GetxController {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController(text: '1');
  TextEditingController priceController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController(
    text: textToDate(DateTime.now()),
  );
  TextEditingController noteController = TextEditingController();
  String? selectedCategory;
  String? selectedCategoryValue;
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
    loadCategories();

    // item box
    await Hive.openBox<ItemModel>('item_box');
    _itemsBox = Hive.box<ItemModel>('item_box');

    _box.watch().listen((_) => loadCategories());
    if (Get.arguments != null) {
      ItemModel arguments = Get.arguments;
      itemNameController.text = arguments.name;
      quantityController.text = arguments.quantity.toString();
      priceController.text = arguments.price.toString();
      dateController.text = textToDate(arguments.date);
      selectedCategory = arguments.category;
      selectedCategoryValue =
          '${getCategoryByIdSync(arguments.category)?.name}';
      noteController.text = arguments.note;
    }
  }

  @override
  void onClose() {
    // if (Hive.isBoxOpen('category_box')) {
    //   Hive.box<CategoryModel>('category_box').close();
    // }
    // if (Hive.isBoxOpen('item_box')) {
    //   Hive.box<ItemModel>('item_box').close();
    // }
    super.onClose();
  }

  loadCategories() async {
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
          selectedCategory == null ||
          quantityController.text.isEmpty) {
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
        category: selectedCategory!,
        date: parsedDate,
        note: noteController.text.trim(),
        price:
            (double.tryParse(priceController.text.trim()) ?? 0.0) *
            (int.tryParse(quantityController.text) ?? 1),
        quantity: int.tryParse(quantityController.text) ?? 1,
      );

      // Add to Hive box
      await _itemsBox.put(newItem.id, newItem);

      // Success feedback
      showSnackBar(title: 'Done', message: 'Item added successfully');
    } catch (e) {
      // print('Add item error: $e');
      showSnackBar(title: 'Error', message: 'Failed to add item.');
    }
  }

  CategoryModel? getCategoryByIdSync(String id) {
    try {
      return _box.values.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }
}
