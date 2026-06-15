import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../consts.dart';
import '../controllers/daily_tools_controller.dart';
import '../controllers/my_categories_controller.dart';
import '../models/category_model.dart';
import 'add_new_item.dart';

class MyCategories extends StatelessWidget {
  MyCategories({super.key});

  final MyCategoriesController myCategoriesController = Get.put(
    MyCategoriesController(),
  );
  final DailyToolsController dailyToolsController =
      Get.isRegistered<DailyToolsController>()
      ? Get.find<DailyToolsController>()
      : Get.put(DailyToolsController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
      appBar: AppBar(title: Text('My Categories', style: textFontForAppBar)),
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

                  final color = dailyToolsController.categoryColor(category, i);
                  final icon = dailyToolsController.categoryIcon(category);

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
                                color: Colors.grey.shade800,
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
                                onPressed: () async {
                                  Get.back();
                                  await myCategoriesController
                                      .deleteCategoryById(category.id);
                                },
                              );
                            } else if (value == 'style') {
                              _showCategoryStyleDialog(
                                context,
                                category,
                                color,
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'style',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.palette_outlined,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text('Style'),
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
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Text(
                  'No Categories Yet',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              );
      }),
    );
  }

  Future<void> _showCategoryStyleDialog(
    BuildContext context,
    CategoryModel category,
    Color currentColor,
  ) {
    final selectedColor = currentColor.obs;
    final selectedIcon = dailyToolsController.categoryIconLabel(category).obs;
    final colorScheme = Theme.of(context).colorScheme;

    return Get.dialog(
      Dialog(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: categoryStyleColors.map((color) {
                    final isSelected = selectedColor.value == color;
                    return InkWell(
                      borderRadius: BorderRadius.circular(99),
                      onTap: () => selectedColor.value = color,
                      child: Container(
                        width: 38.w,
                        height: 38.w,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? mainColor : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  initialValue: selectedIcon.value,
                  decoration: const InputDecoration(labelText: 'Icon'),
                  items: allCategoriesIcons.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Row(
                            children: [
                              Icon(entry.value, size: 20.sp),
                              SizedBox(width: 10.w),
                              Text(entry.key),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) selectedIcon.value = value;
                  },
                ),
                SizedBox(height: 18.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      await dailyToolsController.setCategoryStyle(
                        categoryId: category.id,
                        color: selectedColor.value,
                        icon: selectedIcon.value,
                      );
                      Get.back();
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
