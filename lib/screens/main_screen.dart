import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_expenses/controllers/main_screen_controller.dart';
import '../consts.dart';
import '../widgets/filtering_drop_down_menu.dart';
import '../widgets/filtering_text_field.dart';
import '../widgets/pie_chart.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final MainScreenController _mainScreenController = Get.put(
    MainScreenController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Hi', style: textFontForAppBar),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: mainColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: Colors.white,
                    child: Text(
                      'T',
                      style: TextStyle(fontSize: 24.sp, color: mainColor),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Tony',
                    style: TextStyle(fontSize: 18.sp, color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.category_outlined),
              title: Text("My Categories"),
              onTap: () {
                Get.back();
                Get.toNamed('/myCategories');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Get.toNamed('/settings');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: DateFilterDropdown(
                            selectedFilter:
                                _mainScreenController.selectedFilter.value,
                            onChanged: (filter) {
                              _mainScreenController.dateController.value
                                  .clear();
                              _mainScreenController.setFilter(filter!);
                            },
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: CustomFilterField(
                            controller:
                                _mainScreenController.dateController.value,
                            hintText: 'Custom Date',
                            suffixIcon: IconButton(
                              iconSize: 20.sp,
                              color: Colors.grey.shade700,
                              onPressed: () {
                                selectDateContext(
                                  context,
                                  _mainScreenController.dateController.value,
                                );
                              },
                              icon: Icon(Icons.date_range_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h),
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(35.w),
                        width: constraints.maxWidth,
                        height: 220.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.r),
                          color: mainColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText(
                              text: 'My Expenses',
                              fontSize: 20.sp,
                              isBold: true,
                            ),
                            Obx(
                              () => customText(
                                text: _mainScreenController.allExpenses.value
                                    .toString(),
                                fontSize: 50.sp,
                                maxWidth: null,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// ✅ top = vertical = .h
                      Positioned(
                        top: 20.h,
                        right: 30.w,
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      /// ✅ bottom = vertical = .h
                      Positioned(
                        bottom: 10.h,
                        right: 20.w,
                        child: Container(
                          width: 25.w,
                          height: 25.h,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      /// ✅ top & bottom = vertical = .h
                      Positioned(
                        top: 20.h,
                        bottom: 5.h,
                        right: 20.w,
                        child: Container(
                          width: 35.w,
                          height: 35.h,
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  return SizedBox(
                    height: 400.h,
                    child: ExpensePieChart(
                      data: _mainScreenController.getChartData(
                        _mainScreenController.items,
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
