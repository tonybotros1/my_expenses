import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../consts.dart';
import '../controllers/my_categories_controller.dart';
import 'add_new_item.dart';

class MyCategories extends StatelessWidget {
  MyCategories({super.key});

  final MyCategoriesController myCategoriesController = Get.put(
    MyCategoriesController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        onPressed: () {
          addOrEditCategory(
            controller: myCategoriesController.category,
            onPressed: () {
              myCategoriesController.addCategoryByName(
                myCategoriesController.category.text,
              );
            },
            isEdit: false,
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('My Categories', style: textFontForAppBar),
        centerTitle: true,
      ),
      body: Obx(() {
        return myCategoriesController.categories.isNotEmpty
            ? GridView.builder(
                padding: const EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                itemCount: myCategoriesController.categories.length,
                itemBuilder: (_, i) {
                  final category = myCategoriesController.categories[i];

                  final color = colors[i % colors.length];

                  return Stack(
                    children: [
                      Material(
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Center(
                            child: Text(
                              category.name,
                              style: textStyleForCards.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: PopupMenuButton<String>(
                          onSelected: (value) {
                            // تصرّف عند اختيار عنصر من القائمة
                            if (value == 'edit') {
                              myCategoriesController.category.text =
                                  category.name;
                              addOrEditCategory(
                                isEdit: true,
                                controller: myCategoriesController.category,
                                onPressed: () {
                                  myCategoriesController.editCategoryName(
                                    category.id,
                                    myCategoriesController.category.text,
                                  );
                                },
                              );
                            } else if (value == 'delete') {
                              alertDialog(
                                middleText:
                                    'Are you sure you want to delete "${category.name}"?',
                                title: 'Delete Category',
                                onPressed: () {
                                  myCategoriesController.deleteCategoryById(
                                    category.id,
                                  );
                                  Get.back();
                                },
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.black54),
                                  SizedBox(width: 10),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 10),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          ],
                          icon: Icon(Icons.more_vert), // ← زر 3 نقاط
                        ),

                        //  IconButton(
                        //   onPressed: () {
                        //     alertDialog(
                        //       controller: controller,
                        //       title: 'Delete Category',
                        //       categoryName: category.name,
                        //       categoryId: category.id,
                        //     );
                        //   },
                        //   icon: Icon(Icons.close, color: Colors.grey[700]),
                        // ),
                      ),
                    ],
                  );
                },
              )
            : myCategoriesController.categories.isEmpty &&
                  myCategoriesController.isScreenLoading.isTrue
            ? Center(child: CircularProgressIndicator())
            : Center(child: Text('No Categories Yet'));
      }),
    );
  }
}
