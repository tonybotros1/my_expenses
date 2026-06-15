import 'dart:async';

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
  final selectedCategoryValue = RxnString();
  late Box<CategoryModel> _box;
  late Box<ItemModel> _itemsBox;
  StreamSubscription<BoxEvent>? _categorySubscription;
  var categories = <CategoryModel>[].obs;
  DateFormat formatter = DateFormat('dd-MM-yyyy');
  RxBool isinEditMode = RxBool(false);
  RxString itemid = RxString('');

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

    _categorySubscription = _box.watch().listen((_) => loadCategories());
    if (Get.arguments != null) {
      isinEditMode.value = true;
      ItemModel arguments = Get.arguments;
      final quantity = arguments.quantity <= 0 ? 1 : arguments.quantity;
      itemid.value = arguments.id;
      itemNameController.text = arguments.name;
      quantityController.text = quantity.toString();
      priceController.text = _formatPriceForInput(arguments.price / quantity);
      dateController.text = textToDate(arguments.date);
      selectedCategory = arguments.category;
      selectedCategoryValue.value = getCategoryByIdSync(
        arguments.category,
      )?.name;
      noteController.text = arguments.note;
    }
  }

  @override
  void onClose() {
    _categorySubscription?.cancel();
    itemNameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    categoryController.dispose();
    dateController.dispose();
    noteController.dispose();
    super.onClose();
  }

  loadCategories() async {
    categories.value = _box.values.toList();
  }

  // this function is to add new category
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
    selectedCategory = newCategory.id;
    selectedCategoryValue.value = newCategory.name;
    showSnackBar(title: 'Category Added', message: 'Category "$trimmedName"');

    _box.put(newCategory.id, newCategory);
  }

  // this functios is to add new item
  void addNewItem() async {
    try {
      if (itemNameController.text.isEmpty ||
          dateController.text.isEmpty ||
          selectedCategory == null ||
          quantityController.text.isEmpty ||
          priceController.text.isEmpty) {
        showSnackBar(
          title: 'Error',
          message: 'Please fill all required fields.',
        );
        return;
      }

      DateTime parsedDate;
      try {
        parsedDate = formatter.parse(dateController.text);
      } catch (e) {
        showSnackBar(title: 'Error', message: 'Invalid date format.');
        return;
      }

      final quantity = int.tryParse(quantityController.text.trim()) ?? 0;
      final unitPrice = double.tryParse(priceController.text.trim()) ?? -1;

      if (quantity <= 0 || unitPrice < 0) {
        showSnackBar(
          title: 'Error',
          message: 'Quantity and price must be valid numbers.',
        );
        return;
      }

      final newItem = ItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: itemNameController.text.trim(),
        category: selectedCategory!,
        date: parsedDate,
        note: noteController.text.trim(),
        price: unitPrice * quantity,
        quantity: quantity,
      );

      await _itemsBox.put(newItem.id, newItem);

      clearForm();
      Get.back();
      showSnackBar(title: 'Done', message: 'Item added successfully');
    } catch (e) {
      showSnackBar(title: 'Error', message: 'Failed to add item.');
    }
  }

  void editItem(String id) async {
    try {
      if (itemNameController.text.isEmpty ||
          dateController.text.isEmpty ||
          selectedCategory == null ||
          quantityController.text.isEmpty ||
          priceController.text.isEmpty) {
        showSnackBar(
          title: 'Error',
          message: 'Please fill all required fields.',
        );
        return;
      }

      DateTime parsedDate;
      try {
        parsedDate = formatter.parse(dateController.text);
      } catch (e) {
        showSnackBar(title: 'Error', message: 'Invalid date format.');
        return;
      }

      final quantity = int.tryParse(quantityController.text.trim()) ?? 0;
      final unitPrice = double.tryParse(priceController.text.trim()) ?? -1;

      if (quantity <= 0 || unitPrice < 0) {
        showSnackBar(
          title: 'Error',
          message: 'Quantity and price must be valid numbers.',
        );
        return;
      }

      final existingItem = _itemsBox.get(id);
      if (existingItem == null) {
        showSnackBar(title: 'Error', message: 'Item not found.');
        return;
      }

      final updatedItem = ItemModel(
        id: id,
        name: itemNameController.text.trim(),
        category: selectedCategory!,
        date: parsedDate,
        note: noteController.text.trim(),
        price: unitPrice * quantity,
        quantity: quantity,
      );

      await _itemsBox.put(id, updatedItem);

      clearForm();
      isinEditMode.value = false;
      Get.back();
      showSnackBar(title: 'Done', message: 'Item updated successfully');
    } catch (e) {
      showSnackBar(title: 'Error', message: 'Failed to update item.');
    }
  }

  CategoryModel? getCategoryByIdSync(String id) {
    try {
      return _box.values.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  void clearForm() {
    itemNameController.clear();
    quantityController.text = '1';
    priceController.clear();
    categoryController.clear();
    dateController.text = textToDate(DateTime.now());
    noteController.clear();
    selectedCategory = null;
    selectedCategoryValue.value = null;
    itemid.value = '';
  }

  String _formatPriceForInput(double value) {
    if (value % 1 == 0) return value.toStringAsFixed(0);
    return value.toStringAsFixed(2);
  }
}
