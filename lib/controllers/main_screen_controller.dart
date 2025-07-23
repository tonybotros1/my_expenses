import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/item_model.dart';

enum DateFilterType { today, thisMonth, thisYear, custom }

class MainScreenController extends GetxController {
  late Box<ItemModel> _itemsBox;
  var items = <ItemModel>[].obs;

  var selectedFilter = DateFilterType.today.obs;
  var customDate = Rxn<DateTime>(); // used if selectedFilter.value == custom

  @override
  void onInit() async {
    // item box
    await Hive.openBox<ItemModel>('item_box');
    _itemsBox = Hive.box<ItemModel>('item_box');

    _itemsBox.watch().listen((_) => loadItems());
    super.onInit();
  }

  void loadItems() {
    final allItems = _itemsBox.values.toList();
    DateTime now = DateTime.now();

    List<ItemModel> filtered = [];

    switch (selectedFilter.value) {
      case DateFilterType.today:
        filtered = allItems.where((item) {
          return item.date.year == now.year &&
              item.date.month == now.month &&
              item.date.day == now.day;
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

      case DateFilterType.custom:
        if (customDate.value != null) {
          final d = customDate.value!;
          filtered = allItems.where((item) {
            return item.date.year == d.year &&
                item.date.month == d.month &&
                item.date.day == d.day;
          }).toList();
        }
        break;
    }

    items.value = filtered;
  }

  void setFilter(DateFilterType filter, [DateTime? date]) {
    selectedFilter.value = filter;
    if (filter == DateFilterType.custom && date != null) {
      customDate.value = date;
    }
    loadItems();
  }
}
