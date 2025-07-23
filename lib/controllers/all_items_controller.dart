import 'dart:math';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../consts.dart';
import '../models/category_model.dart';
import '../models/item_model.dart';

class AllItemsController extends GetxController {
  late Box<ItemModel> _itemsBox;
  late Box<CategoryModel> _box;
  var allItems = <ItemModel>[].obs;
  RxBool isScreenLoading = RxBool(false);
  var categories = <CategoryModel>[].obs;

  RxBool isSelectionMode = false.obs;
  RxBool canSelectByOneClick = false.obs;
  RxList<int> selectedItems = <int>[].obs;
  RxList<ItemModel> selectedItemsDetails = <ItemModel>[].obs;
  Map<int, Color> itemColors = {};

  @override
  void onInit() async {
    await loadCategories();
    await loadItems();
    _itemsBox.watch().listen((_) => loadItems());
    super.onInit();
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
      selectedItemsDetails.remove(item);
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
      allItems.value = _itemsBox.values.toList();
      isScreenLoading.value = false;
    } catch (e) {
      isScreenLoading.value = false;
      allItems.value = [];
    }
  }

  CategoryModel? getCategoryByIdSync(String id) {
    try {
      return _box.values.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  deleteItemById() async {
    for (ItemModel itemId in selectedItemsDetails) {
      final item = _itemsBox.get(itemId.id);
      if (item == null) {
        showSnackBar(title: 'Error', message: 'Item not found!');

        return;
      }
      Get.back();
      await _itemsBox.delete(itemId.id);
    }
    showSnackBar(title: 'Deleted', message: 'Selected Items has been deleted');
  }
}
