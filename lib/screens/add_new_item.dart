import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../consts.dart';
import '../controllers/add_new_item_controller.dart';
import '../widgets/custom_drop_menu.dart';
import '../widgets/custom_field.dart';

class AddNewItem extends StatelessWidget {
  const AddNewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('New Item', style: textFontForAppBar),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GetX<AddNewItemController>(
            init: AddNewItemController(),
            builder: (controller) {
              return Column(
                spacing: 20,
                children: [
                  customLabeledTextField(
                    label: "Item Name",
                    controller: controller.amountController,
                    keyboardType: TextInputType.text,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: customDropdown(
                          label: "Category",
                          value: controller.selectedCategory,
                          items: controller.categories.isEmpty
                              ? []
                              : controller.categories
                                    .map((value) => value.name)
                                    .toList(),
                          onChanged: (val) => controller.selectedCategory = val,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          addOrEditCategory(
                            isEdit: false,
                            controller: controller.categoryController,
                            onPressed: () async {
                              controller.addCategoryByName(
                                controller.categoryController.text,
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
                    controller: controller.priceController,
                    keyboardType: TextInputType.number,
                  ),

                  customLabeledTextField(
                    label: "Date",
                    controller: controller.dateController,
                    keyboardType: TextInputType.datetime,
                  ),
                  customLabeledTextField(
                    label: "Note",
                    maxLines: 10,
                    controller: controller.noteController,
                    keyboardType: TextInputType.datetime,
                  ),
                ],
              );
            },
          ),
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
