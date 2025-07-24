import 'package:flutter/material.dart';
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
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(
                      'T',
                      style: TextStyle(fontSize: 24, color: mainColor),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tony',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
                // Get.toNamed('/settings');
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(
                    () => Row(
                      spacing: 20,
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
                        Expanded(
                          child: CustomFilterField(
                            controller:
                                _mainScreenController.dateController.value,
                            hintText: 'Custom Date',
                            suffixIcon: IconButton(
                              iconSize: 20,
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
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(35),
                        width: constraints.maxWidth,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: mainColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText(
                              text: 'My Expenses',
                              fontSize: 20,
                              isBold: true,
                            ),
                            Obx(
                              () => customText(
                                text: _mainScreenController.allExpenses.value
                                    .toString(),
                                fontSize: 50,
                                maxWidth: null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 30,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 10,
                        right: 20,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        top: 20,
                        right: 20,
                        child: Container(
                          width: 35,
                          height: 35,
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
                    height: 500,

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
