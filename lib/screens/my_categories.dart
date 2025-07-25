import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        onPressed: () {
          myCategoriesController.category.clear();
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
                padding: EdgeInsets.all(15.r),
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

                  final icon = getCategoryIcon(category.name);

                  return Stack(
                    children: [
                      Material(
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(10.r),
                        elevation: 4,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                icon,
                                color: Colors.grey.shade700,
                                size: 40.sp,
                              ),
                              Text(
                                category.name,
                                style: textStyleForCards.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5.h,
                        right: 5.w,
                        child: PopupMenuButton<String>(
                          onSelected: (value) {
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
                                  SizedBox(width: 10.w),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 10.w),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          ],
                          icon: Icon(Icons.more_vert),
                        ),
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
