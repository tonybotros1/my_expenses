import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/models/pie_chart_model.dart';

import '../models/category_model.dart';
import '../models/item_model.dart';

enum DateFilterType { all, today, thisWeek, thisMonth, thisYear, custom }

class MainScreenController extends GetxController {
  Rx<TextEditingController> dateController = TextEditingController().obs;

  late Box<ItemModel> _itemsBox;
  var items = <ItemModel>[].obs;
  var selectedFilter = DateFilterType.today.obs;
  var customDate = Rxn<DateTime>();
  RxDouble allExpenses = RxDouble(0.0);
  late Box<CategoryModel> _box;
  StreamSubscription<BoxEvent>? _itemsSubscription;
  StreamSubscription<BoxEvent>? _categorySubscription;
  var categories = <CategoryModel>[].obs;

  @override
  void onInit() async {
    await loadCategories();
    // item box
    await Hive.openBox<ItemModel>('item_box');
    _itemsBox = Hive.box<ItemModel>('item_box');
    loadItems();
    _itemsSubscription = _itemsBox.watch().listen((_) => loadItems());
    _categorySubscription = _box.watch().listen((_) {
      loadCategories();
      loadItems();
    });

    dateController.value.addListener(() {
      selectedFilter.value = DateFilterType.custom;
      loadItems();
    });

    super.onInit();
  }

  @override
  void onClose() {
    _itemsSubscription?.cancel();
    _categorySubscription?.cancel();
    dateController.value.dispose();
    super.onClose();
  }

  loadCategories() async {
    await Hive.openBox<CategoryModel>('category_box');
    _box = Hive.box<CategoryModel>('category_box');
    categories.value = _box.values.toList();
  }

  void loadItems() {
    final allItems = _itemsBox.values.toList();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    List<ItemModel> filtered = [];

    DateTime? customDate;
    if (dateController.value.text.isNotEmpty) {
      try {
        customDate = DateFormat(
          'dd-MM-yyyy',
        ).parseStrict(dateController.value.text);
      } catch (_) {
        customDate = null; // invalid format fallback
      }
    }

    if (customDate != null) {
      // Filter by this custom date exactly (year, month, day)
      filtered = allItems.where((item) {
        return item.date.year == customDate!.year &&
            item.date.month == customDate.month &&
            item.date.day == customDate.day;
      }).toList();
    } else {
      switch (selectedFilter.value) {
        case DateFilterType.today:
          filtered = allItems.where((item) {
            return _isSameDay(item.date, today);
          }).toList();
          break;

        case DateFilterType.thisMonth:
          filtered = allItems.where((item) {
            return item.date.year == now.year && item.date.month == now.month;
          }).toList();
          break;

        case DateFilterType.thisYear:
          filtered = allItems.where((item) {
            return item.date.year == now.year;
          }).toList();
          break;

        case DateFilterType.all:
          filtered = allItems;
          break;

        case DateFilterType.custom:
          break;
        case DateFilterType.thisWeek:
          final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 7));

          filtered = allItems.where((item) {
            final date = DateTime(
              item.date.year,
              item.date.month,
              item.date.day,
            );
            return !date.isBefore(startOfWeek) && date.isBefore(endOfWeek);
          }).toList();
          break;
      }
    }

    items.value = filtered;
    calculateAllExpenses();
  }

  calculateAllExpenses() {
    allExpenses.value = 0.0;
    for (var element in items) {
      allExpenses.value += element.price;
    }
  }

  void setFilter(DateFilterType filter) {
    selectedFilter.value = filter;
    loadItems();
  }

  List<PieChartModel> getChartData(List<ItemModel> items) {
    Map<String, double> dataMap = {};

    for (var item in items) {
      String category = getCategoryNameById(item.category)?.name ?? 'Unknown';
      dataMap[category] = (dataMap[category] ?? 0) + item.price;
    }

    return dataMap.entries.map((e) => PieChartModel(e.key, e.value)).toList();
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  CategoryModel? getCategoryNameById(String id) {
    try {
      return _box.values.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }
}
