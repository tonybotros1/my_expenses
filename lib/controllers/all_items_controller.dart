import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../consts.dart';
import '../models/category_model.dart';
import '../models/item_model.dart';

class AllItemsController extends GetxController {
  late Box<ItemModel> _itemsBox;
  late Box<CategoryModel> _box;
  StreamSubscription<BoxEvent>? _itemsSubscription;
  StreamSubscription<BoxEvent>? _categorySubscription;
  var allItems = <ItemModel>[].obs;
  final _sourceItems = <ItemModel>[];
  RxBool isScreenLoading = RxBool(false);
  var categories = <CategoryModel>[].obs;
  final searchController = TextEditingController();
  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();
  final categoryFilter = RxnString();
  final dateFilter = 'all'.obs;
  final filterRevision = 0.obs;

  RxBool isSelectionMode = false.obs;
  RxBool canSelectByOneClick = false.obs;
  RxList<int> selectedItems = <int>[].obs;
  RxList<ItemModel> selectedItemsDetails = <ItemModel>[].obs;
  Map<int, Color> itemColors = {};

  @override
  void onInit() async {
    await loadCategories();
    await loadItems();
    _itemsSubscription = _itemsBox.watch().listen((_) => loadItems());
    _categorySubscription = _box.watch().listen((_) {
      loadCategories();
      applyFilters();
    });
    searchController.addListener(applyFilters);
    minPriceController.addListener(applyFilters);
    maxPriceController.addListener(applyFilters);
    super.onInit();
  }

  @override
  void onClose() {
    _itemsSubscription?.cancel();
    _categorySubscription?.cancel();
    searchController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    super.onClose();
  }

  void enterSelectionMode(int index, ItemModel item) async {
    isSelectionMode.value = true;
    canSelectByOneClick.value = true;
    await toggleSelection(index, item);
  }

  void exitSelectionMode() {
    isSelectionMode.value = false;
    canSelectByOneClick.value = false;
    selectedItemsDetails.clear();
    selectedItems.clear();
  }

  toggleSelection(int index, ItemModel item) {
    if (selectedItems.contains(index)) {
      selectedItems.remove(index);
      selectedItemsDetails.removeWhere((selected) => selected.id == item.id);
      if (selectedItems.isEmpty) {
        isSelectionMode.value = false;
      }
    } else {
      selectedItems.add(index);
      selectedItemsDetails.add(item);
    }
  }

  Color getColorForItem(int index, List<Color> colors) {
    if (!itemColors.containsKey(index)) {
      itemColors[index] = colors[Random().nextInt(colors.length)];
    }
    return itemColors[index]!;
  }

  loadCategories() async {
    await Hive.openBox<CategoryModel>('category_box');
    _box = Hive.box<CategoryModel>('category_box');
    categories.value = _box.values.toList();
  }

  loadItems() async {
    try {
      isScreenLoading.value = true;
      await Hive.openBox<ItemModel>('item_box');
      _itemsBox = Hive.box<ItemModel>('item_box');
      _sourceItems
        ..clear()
        ..addAll(_itemsBox.values.toList())
        ..sort((a, b) => b.date.compareTo(a.date));
      applyFilters();
      isScreenLoading.value = false;
    } catch (e) {
      isScreenLoading.value = false;
      allItems.value = [];
    }
  }

  void applyFilters() {
    final query = searchController.text.trim().toLowerCase();
    final minPrice = double.tryParse(minPriceController.text.trim());
    final maxPrice = double.tryParse(maxPriceController.text.trim());
    final categoryId = categoryFilter.value;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    allItems.value = _sourceItems.where((item) {
      final categoryName = getCategoryByIdSync(item.category)?.name ?? '';
      final searchable = '${item.name} ${item.note} $categoryName'
          .toLowerCase();
      final matchesQuery = query.isEmpty || searchable.contains(query);
      final matchesCategory = categoryId == null || item.category == categoryId;
      final matchesMin = minPrice == null || item.price >= minPrice;
      final matchesMax = maxPrice == null || item.price <= maxPrice;
      final matchesDate = switch (dateFilter.value) {
        'today' => _isSameDay(item.date, today),
        'week' => _isInCurrentWeek(item.date, today),
        'month' => item.date.year == now.year && item.date.month == now.month,
        _ => true,
      };

      return matchesQuery &&
          matchesCategory &&
          matchesMin &&
          matchesMax &&
          matchesDate;
    }).toList();
    filterRevision.value++;
  }

  void setCategoryFilter(String? categoryId) {
    categoryFilter.value = categoryId;
    applyFilters();
  }

  void setDateFilter(String value) {
    dateFilter.value = value;
    applyFilters();
  }

  void clearFilters() {
    searchController.clear();
    minPriceController.clear();
    maxPriceController.clear();
    categoryFilter.value = null;
    dateFilter.value = 'all';
    applyFilters();
  }

  int get activeFilterCount {
    var count = 0;
    if (searchController.text.trim().isNotEmpty) count++;
    if (minPriceController.text.trim().isNotEmpty) count++;
    if (maxPriceController.text.trim().isNotEmpty) count++;
    if (categoryFilter.value != null) count++;
    if (dateFilter.value != 'all') count++;
    return count;
  }

  CategoryModel? getCategoryByIdSync(String id) {
    try {
      return _box.values.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<ItemModel>> deleteItemById() async {
    final deletedItems = selectedItemsDetails.toList();
    final ids = deletedItems.map((item) => item.id).toList();
    if (ids.isEmpty) {
      showSnackBar(title: 'Error', message: 'No items selected.');
      return [];
    }

    final missingIds = ids.where((id) => !_itemsBox.containsKey(id)).toList();
    if (missingIds.isNotEmpty) {
      showSnackBar(
        title: 'Error',
        message: 'Some selected items no longer exist.',
      );
      return [];
    }

    await _itemsBox.deleteAll(ids);
    return deletedItems;
  }

  Future<void> restoreItems(List<ItemModel> deletedItems) async {
    for (final item in deletedItems) {
      await _itemsBox.put(item.id, item);
    }
    showSnackBar(title: 'Restored', message: 'Deleted items were restored.');
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  bool _isInCurrentWeek(DateTime date, DateTime today) {
    final start = today.subtract(Duration(days: today.weekday - 1));
    final end = start.add(const Duration(days: 7));
    final normalized = DateTime(date.year, date.month, date.day);
    return !normalized.isBefore(start) && normalized.isBefore(end);
  }
}
