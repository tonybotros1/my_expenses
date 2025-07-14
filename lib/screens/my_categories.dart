import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../consts.dart';
import '../controllers/my_categories_controller.dart';
import 'add_new_item.dart';

class MyCategories extends StatelessWidget {
  const MyCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GetBuilder<MyCategoriesController>(
        init: MyCategoriesController(),

        builder: (controller) {
          return FloatingActionButton(
            backgroundColor: mainColor,
            foregroundColor: Colors.white,
            onPressed: () {
              addCategory(
                controller: controller.category,
                onPressed: () {
                  controller.addCategoryByName(controller.category.text);
                },
              );
            },
            child: Icon(Icons.add),
          );
        },
      ),
      appBar: AppBar(
        title: Text('My Categories', style: textFontForAppBar),
        centerTitle: true,
      ),
      body: GetX<MyCategoriesController>(
        builder: (controller) {
          return controller.categories.isNotEmpty
              ? GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: controller.categories.length,
                  itemBuilder: (_, i) {
                    final category = controller.categories[i];
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFE0F7F4),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Center(
                            child: Text(
                              category.name,
                              style: textStyleForCards.copyWith(
                                color: Color(0xFF00695C),
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                title: "Delete Category",
                                middleText:
                                    'Are you sure you want to delete "${category.name}"?',
                                radius: 12,
                                contentPadding: const EdgeInsets.all(20),
                                titleStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                middleTextStyle: const TextStyle(fontSize: 16),
                                actions: [
                                  ElevatedButton.icon(
                                    onPressed: () => Get.back(),
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                    ),
                                    label: const Text("Cancel"),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,

                                      backgroundColor: Colors.grey[600],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      controller.deleteCategoryById(
                                        category.id,
                                      );
                                      Get.back();
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    label: const Text("Delete"),

                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red[600],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            icon: Icon(Icons.close),
                          ),
                        ),
                      ],
                    );
                  },
                )
              : controller.categories.isEmpty &&
                    controller.isScreenLoading.isTrue
              ? Center(child: CircularProgressIndicator())
              : Center(child: Text('No Categories Yet'));
        },
      ),
    );
  }
}
