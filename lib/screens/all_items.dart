import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/controllers/all_items_controller.dart';
import 'package:my_expenses/controllers/daily_tools_controller.dart';
import '../consts.dart';
import '../models/item_model.dart';

class AllItems extends StatelessWidget {
  AllItems({super.key});

  final AllItemsController _allItemsController = Get.put(AllItemsController());
  final DailyToolsController _toolsController =
      Get.isRegistered<DailyToolsController>()
      ? Get.find<DailyToolsController>()
      : Get.put(DailyToolsController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !_allItemsController.isSelectionMode.value,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop && _allItemsController.isSelectionMode.value) {
          _allItemsController.exitSelectionMode();
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight.h),
          child: Obx(
            () => _allItemsController.isSelectionMode.value
                ? AppBar(
                    title: Text(
                      "${_allItemsController.selectedItems.length} selected",
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.close, size: 24.sp),
                      onPressed: () => _allItemsController.exitSelectionMode(),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.delete, size: 24.sp),
                        onPressed: () {
                          alertDialog(
                            middleText:
                                'Selected items will be deleted permanently',
                            title: 'Delete Items',
                            onPressed: () async {
                              Get.back();
                              final deletedItems = await _allItemsController
                                  .deleteItemById();
                              if (deletedItems.isNotEmpty) {
                                _allItemsController.exitSelectionMode();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${deletedItems.length} item(s) deleted',
                                        ),
                                        action: SnackBarAction(
                                          label: 'Undo',
                                          onPressed: () => _allItemsController
                                              .restoreItems(deletedItems),
                                        ),
                                      ),
                                    );
                                }
                              }
                            },
                          );
                        },
                      ),
                      _allItemsController.selectedItems.length > 1
                          ? SizedBox()
                          : IconButton(
                              icon: Icon(Icons.edit, size: 24.sp),
                              onPressed: () {
                                Get.toNamed(
                                  '/addNewItem',
                                  arguments: ItemModel(
                                    id: _allItemsController
                                        .selectedItemsDetails
                                        .first
                                        .id,
                                    name: _allItemsController
                                        .selectedItemsDetails
                                        .first
                                        .name,
                                    category: _allItemsController
                                        .selectedItemsDetails
                                        .first
                                        .category,
                                    date: _allItemsController
                                        .selectedItemsDetails
                                        .first
                                        .date,
                                    note: _allItemsController
                                        .selectedItemsDetails
                                        .first
                                        .note,
                                    price: _allItemsController
                                        .selectedItemsDetails
                                        .first
                                        .price,
                                    quantity: _allItemsController
                                        .selectedItemsDetails
                                        .first
                                        .quantity,
                                  ),
                                );
                                _allItemsController.exitSelectionMode();
                              },
                            ),
                    ],
                  )
                : AppBar(
                    centerTitle: true,
                    title: Text("My Items", style: textFontForAppBar),
                  ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed('/addNewItem');
          },
          child: Icon(Icons.add, size: 24.sp),
        ),
        body: Column(
          children: [
            _filterPanel(context),
            Expanded(
              child: Obx(() {
                return _allItemsController.allItems.isEmpty &&
                        _allItemsController.isScreenLoading.isTrue
                    ? const Center(child: CircularProgressIndicator())
                    : _allItemsController.allItems.isEmpty &&
                          _allItemsController.isScreenLoading.isFalse
                    ? Center(
                        child: Text(
                          'No Items',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _allItemsController.allItems.length,
                        itemBuilder: (context, i) {
                          ItemModel item = _allItemsController.allItems[i];
                          final category = _allItemsController
                              .getCategoryByIdSync(item.category);
                          final bgColor = category == null
                              ? _allItemsController.getColorForItem(i, colors)
                              : _toolsController.categoryColor(category, i);
                          final icon = _toolsController.categoryIcon(category);

                          return Obx(() {
                            final textColor = getTextColor(bgColor);
                            final isSelected = _allItemsController.selectedItems
                                .contains(i);

                            return GestureDetector(
                              onLongPress: () {
                                _allItemsController.enterSelectionMode(i, item);
                              },
                              onTap:
                                  _allItemsController
                                      .canSelectByOneClick
                                      .isFalse
                                  ? null
                                  : () {
                                      _allItemsController.enterSelectionMode(
                                        i,
                                        item,
                                      );
                                    },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                margin: EdgeInsets.only(
                                  bottom: 16.h,
                                  left: 12.w,
                                  right: 12.w,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? colorScheme.primary.withValues(
                                          alpha: 0.14,
                                        )
                                      : colorScheme.surface,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.08,
                                      ),
                                      blurRadius: 10.r,
                                      offset: Offset(0, 5.h),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.r),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                icon,
                                                size: 25.sp,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(width: 10.w),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 6.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: bgColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        20.r,
                                                      ),
                                                ),
                                                child: customText(
                                                  text:
                                                      _allItemsController
                                                          .getCategoryByIdSync(
                                                            item.category,
                                                          )
                                                          ?.name ??
                                                      '',
                                                  color: textColor,
                                                  fontSize: 14.sp,
                                                  isBold: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 14.sp,
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                              SizedBox(width: 4.w),
                                              customText(
                                                text: DateFormat.yMMMMd()
                                                    .format(item.date),
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                                fontSize: 13.sp,
                                                isBold: true,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: customText(
                                              text:
                                                  '${item.name} x${item.quantity}',
                                              isBold: true,
                                              fontSize: 18.sp,
                                              color: colorScheme.onSurface,
                                              maxLines: 3,
                                            ),
                                          ),
                                          customText(
                                            text: item.price.toStringAsFixed(2),
                                            isBold: true,
                                            fontSize: 20.sp,
                                            color: textColor,
                                            formatDouble: true,
                                          ),
                                          IconButton(
                                            onPressed: () => _toolsController
                                                .createTemplateFromItem(item),
                                            icon: Icon(
                                              Icons.star_border,
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                            tooltip: 'Save as favorite',
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      customText(
                                        text: item.note,
                                        fontSize: 14.sp,
                                        color: colorScheme.onSurfaceVariant,
                                        isBold: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterPanel(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(() {
      _allItemsController.filterRevision.value;

      return Container(
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      controller: _allItemsController.searchController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search expenses',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Badge(
                  isLabelVisible: _allItemsController.activeFilterCount > 0,
                  label: Text('${_allItemsController.activeFilterCount}'),
                  child: IconButton.filledTonal(
                    onPressed: () => _showFilterSheet(context),
                    icon: const Icon(Icons.tune),
                    tooltip: 'Filters',
                  ),
                ),
                if (_allItemsController.activeFilterCount > 0) ...[
                  SizedBox(width: 4.w),
                  IconButton(
                    onPressed: _allItemsController.clearFilters,
                    icon: const Icon(Icons.close),
                    tooltip: 'Clear filters',
                  ),
                ],
              ],
            ),
            if (_allItemsController.activeFilterCount > 0) ...[
              SizedBox(height: 8.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: _activeFilterChips(context)),
              ),
            ],
          ],
        ),
      );
    });
  }

  List<Widget> _activeFilterChips(BuildContext context) {
    _allItemsController.filterRevision.value;
    final chips = <Widget>[];
    final categoryId = _allItemsController.categoryFilter.value;
    final categoryName = categoryId == null
        ? null
        : _allItemsController.getCategoryByIdSync(categoryId)?.name;

    void addChip(String label, VoidCallback onDeleted) {
      chips.add(
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: InputChip(label: Text(label), onDeleted: onDeleted),
        ),
      );
    }

    if (_allItemsController.searchController.text.trim().isNotEmpty) {
      addChip('Search', () {
        _allItemsController.searchController.clear();
      });
    }
    if (_allItemsController.dateFilter.value != 'all') {
      addChip(_allItemsController.dateFilter.value.capitalizeFirst!, () {
        _allItemsController.setDateFilter('all');
      });
    }
    if (categoryName != null) {
      addChip(categoryName, () {
        _allItemsController.setCategoryFilter(null);
      });
    }
    if (_allItemsController.minPriceController.text.trim().isNotEmpty) {
      addChip('Min ${_allItemsController.minPriceController.text.trim()}', () {
        _allItemsController.minPriceController.clear();
      });
    }
    if (_allItemsController.maxPriceController.text.trim().isNotEmpty) {
      addChip('Max ${_allItemsController.maxPriceController.text.trim()}', () {
        _allItemsController.maxPriceController.clear();
      });
    }

    return chips;
  }

  Future<void> _showFilterSheet(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SafeArea(
          top: false,
          child: Obx(
            () => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Filters',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _allItemsController.clearFilters,
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Date',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _dateChip('All', 'all'),
                      _dateChip('Today', 'today'),
                      _dateChip('Week', 'week'),
                      _dateChip('Month', 'month'),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'Category',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      ChoiceChip(
                        label: const Text('All Categories'),
                        selected:
                            _allItemsController.categoryFilter.value == null,
                        onSelected: (_) =>
                            _allItemsController.setCategoryFilter(null),
                      ),
                      ..._allItemsController.categories.map(
                        (category) => ChoiceChip(
                          avatar: Icon(
                            _toolsController.categoryIcon(category),
                            size: 18.sp,
                          ),
                          label: Text(category.name),
                          selected:
                              _allItemsController.categoryFilter.value ==
                              category.id,
                          onSelected: (_) => _allItemsController
                              .setCategoryFilter(category.id),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'Price',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _allItemsController.minPriceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Min',
                            prefixIcon: Icon(Icons.arrow_downward),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextField(
                          controller: _allItemsController.maxPriceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Max',
                            prefixIcon: Icon(Icons.arrow_upward),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.done),
                      label: const Text('Apply'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _dateChip(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: ChoiceChip(
        label: Text(label),
        selected: _allItemsController.dateFilter.value == value,
        onSelected: (_) => _allItemsController.setDateFilter(value),
      ),
    );
  }
}
