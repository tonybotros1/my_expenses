import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

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
          child: GetBuilder<AddNewItemController>(
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
                  customDropdown(
                    label: "Category",
                    value: controller.selectedCategory,
                    items: ["أكل", "مواصلات", "ملابس", "فواتير", "تسلية"],
                    onChanged: (val) => controller.selectedCategory = val,
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
