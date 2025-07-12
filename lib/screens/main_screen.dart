import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_expenses/screens/add_new_item.dart';

import '../consts.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hi', style: textFontForAppBar)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        onPressed: () {
          Get.to(() => AddNewItem());
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 16,
                  ),
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
                            customText(
                              text: '3000000',
                              fontSize: 50,
                              maxWidth: null,
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
              ],
            );
          },
        ),
      ),
    );
  }
}
