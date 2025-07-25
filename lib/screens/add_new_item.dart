import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_expenses/models/category_model.dart';
import '../consts.dart';
import '../controllers/add_new_item_controller.dart';
import '../widgets/custom_drop_menu.dart';
import '../widgets/custom_field.dart';

class AddNewItem extends StatelessWidget {
  AddNewItem({super.key});

  final AddNewItemController _addNewItemController = Get.put(
    AddNewItemController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('New Item', style: textFontForAppBar),
        actions: [
          IconButton(
            onPressed: () {
              _addNewItemController.addNewItem();
            },
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.r),
          child: Obx(() {
            return Column(
              spacing: 20.w,
              children: [
                customLabeledTextField(
                  label: "Item Name",
                  controller: _addNewItemController.itemNameController,
                  keyboardType: TextInputType.text,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: customDropdown(
                        label: "Category",
                        value: _addNewItemController.selectedCategoryValue,
                        items: _addNewItemController.categories.isEmpty
                            ? []
                            : _addNewItemController.categories
                                  .map((value) => value.name)
                                  .toList(),
                        onChanged: (val) {
                          final selected = _addNewItemController.categories
                              .firstWhere(
                                (cat) => cat.name == val,
                                orElse: () => CategoryModel(id: '', name: ''),
                              );

                          _addNewItemController.selectedCategory = selected.id;
                        },
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.all(8.r),
                      constraints: BoxConstraints(
                        minWidth: 20.w,
                        minHeight: 20.h,
                      ),
                      onPressed: () {
                        _addNewItemController.categoryController.clear();
                        addOrEditCategory(
                          isEdit: false,
                          controller: _addNewItemController.categoryController,
                          onPressed: () async {
                            _addNewItemController.addCategoryByName(
                              _addNewItemController.categoryController.text,
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.add, size: 24.sp),
                    ),
                  ],
                ),
                customLabeledTextField(
                  isnumber: true,
                  label: "Quantity",
                  controller: _addNewItemController.quantityController,
                  keyboardType: TextInputType.number,
                ),
                customLabeledTextField(
                  isDouble: true,
                  label: "Price",
                  controller: _addNewItemController.priceController,
                  keyboardType: TextInputType.number,
                ),

                customLabeledTextField(
                  suffixIcon: IconButton(
                    onPressed: () {
                      selectDateContext(
                        context,
                        _addNewItemController.dateController,
                      );
                    },
                    icon: Icon(Icons.date_range_outlined),
                  ),
                  isDate: true,
                  label: "Date",
                  controller: _addNewItemController.dateController,
                  keyboardType: TextInputType.datetime,
                ),
                customLabeledTextField(
                  label: "Note",
                  maxLines: 10,
                  controller: _addNewItemController.noteController,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

Future<dynamic> addOrEditCategory({
  required TextEditingController controller,
  required void Function()? onPressed,
  required bool isEdit,
}) {
  return Get.dialog(
    Dialog(
      child: Container(
        padding: EdgeInsets.all(16.r),
        height: 180.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            customLabeledTextField(
              label: "Category",
              controller: controller,
              keyboardType: TextInputType.text,
            ),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(isEdit ? 'Save' : 'Add'),
            ),
          ],
        ),
      ),
    ),
  );
}
