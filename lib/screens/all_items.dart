import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),

        child: Obx(
          () => _allItemsController.isSelectionMode.value
              ? AppBar(
                  title: Text(
                    "${_allItemsController.selectedItems.length} selected",
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => _allItemsController.exitSelectionMode(),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // delete selected logic
                      },
                    ),

                    _allItemsController.selectedItems.length > 1
                        ? SizedBox()
                        : IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // edit logic
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
        child: Icon(Icons.add),
      ),
      body: Obx(() {
        return _allItemsController.allItems.isEmpty &&
                _allItemsController.isScreenLoading.isTrue
            ? Center(child: CircularProgressIndicator())
            : _allItemsController.allItems.isEmpty &&
                  _allItemsController.isScreenLoading.isFalse
            ? Center(child: Text('No Date'))
            : ListView.builder(
                itemCount: _allItemsController.allItems.length,
                itemBuilder: (context, i) {
                  ItemModel item = _allItemsController.allItems[i];
                  final bgColor = _allItemsController.getColorForItem(
                    i,
                    colors,
                  );

                  return Obx(() {
                    final textColor = getTextColor(bgColor);
                    bool isSelected = _allItemsController.selectedItems
                        .contains(i);
                    return GestureDetector(
                      onLongPress: () {
                        _allItemsController.enterSelectionMode(i,item.id);
                      },
                      onTap: _allItemsController.canSelectByOneClick.isFalse
                          ? null
                          : () {
                              _allItemsController.enterSelectionMode(i,item.id);
                            },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.grey.shade200
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            spacing: 30,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: customText(
                                      text:
                                          '${_allItemsController.getCategoryByIdSync(item.category)}',
                                      color: textColor,
                                      fontSize: 14,
                                      isBold: true,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: Colors.blueGrey,
                                      ),
                                      const SizedBox(width: 4),
                                      customText(
                                        text: DateFormat.yMMMMd().format(
                                          item.date,
                                        ),
                                        color: Colors.blueGrey,
                                        fontSize: 13,
                                        isBold: true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: customText(
                                      text: '${item.name} x${item.quantity}',
                                      isBold: true,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  customText(
                                    text: item.price.toStringAsFixed(2),
                                    isBold: true,
                                    fontSize: 20,
                                    color: textColor,
                                    formatDouble: true,
                                  ),
                                ],
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
    );
  }
}
