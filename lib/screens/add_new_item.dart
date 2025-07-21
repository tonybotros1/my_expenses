import 'package:flutter/material.dart';
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
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.done))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return Column(
              spacing: 20,
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
                        value: _addNewItemController.selectedCategory,
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
                      onPressed: () {
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
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
                customLabeledTextField(
                  label: "Price",
                  controller: _addNewItemController.priceController,
                  keyboardType: TextInputType.number,
                ),

                customLabeledTextField(
                  label: "Date",
                  controller: _addNewItemController.dateController,
                  keyboardType: TextInputType.datetime,
                ),
                customLabeledTextField(
                  label: "Note",
                  maxLines: 10,
                  controller: _addNewItemController.noteController,
                  keyboardType: TextInputType.datetime,
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
        padding: EdgeInsets.all(16),
        height: 200,
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
