import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/controllers/all_items_controller.dart';
import '../consts.dart';
import '../models/item_model.dart';

class AllItems extends StatelessWidget {
  AllItems({super.key});

  final AllItemsController _allItemsController = Get.put(AllItemsController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_allItemsController.isSelectionMode.value,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop && _allItemsController.isSelectionMode.value) {
          _allItemsController.exitSelectionMode();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
                              await _allItemsController.deleteItemById();
                              _allItemsController.exitSelectionMode();
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
                                        .name,
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
                    backgroundColor: Colors.white,
                    centerTitle: true,
                    title: Text("My Items", style: textFontForAppBar),
                  ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: mainColor,
          foregroundColor: Colors.white,
          onPressed: () {
            Get.toNamed('/addNewItem');
          },
          child: Icon(Icons.add, size: 24.sp),
        ),
        body: Obx(() {
          return _allItemsController.allItems.isEmpty &&
                  _allItemsController.isScreenLoading.isTrue
              ? Center(child: CircularProgressIndicator())
              : _allItemsController.allItems.isEmpty &&
                    _allItemsController.isScreenLoading.isFalse
              ? Center(
                  child: Text('No Items', style: TextStyle(fontSize: 16.sp)),
                )
              : ListView.builder(
                  itemCount: _allItemsController.allItems.length,
                  itemBuilder: (context, i) {
                    ItemModel item = _allItemsController.allItems[i];
                    final bgColor = _allItemsController.getColorForItem(
                      i,
                      colors,
                    );
                    final icon = getCategoryIcon(
                      _allItemsController
                          .getCategoryByIdSync(item.category)
                          ?.name,
                    );

                    return Obx(() {
                      final textColor = getTextColor(bgColor);
                      final isSelected = _allItemsController.selectedItems
                          .contains(i);

                      return GestureDetector(
                        onLongPress: () {
                          _allItemsController.enterSelectionMode(i, item);
                        },
                        onTap: _allItemsController.canSelectByOneClick.isFalse
                            ? null
                            : () {
                                _allItemsController.enterSelectionMode(i, item);
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
                                ? Colors.grey.shade200
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10.r,
                                offset: Offset(0, 5.h),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                            borderRadius: BorderRadius.circular(
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
                                          color: Colors.blueGrey,
                                        ),
                                        SizedBox(width: 4.w),
                                        customText(
                                          text: DateFormat.yMMMMd().format(
                                            item.date,
                                          ),
                                          color: Colors.blueGrey,
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
                                        text: '${item.name} x${item.quantity}',
                                        isBold: true,
                                        fontSize: 18.sp,
                                        color: Colors.black,
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
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                customText(
                                  text: item.note,
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade700,
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
    );
  }
}
