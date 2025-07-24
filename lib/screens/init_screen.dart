import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:my_expenses/consts.dart';
import 'package:my_expenses/controllers/init_screen_controller.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: GetX<InitScreenController>(
        init: InitScreenController(),
        builder: (controller) {
          return controller.pages[controller.selectedIndex.value];
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 10.h),
          child: GetX<InitScreenController>(
            builder: (controller) {
              return GNav(
                gap: 8,
                activeColor: Colors.white,
                color: Colors.grey[700],
                tabBackgroundColor: mainColor,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                selectedIndex: controller.selectedIndex.value,
                onTabChange: (index) {
                  controller.selectedIndex.value = index;
                },
                tabs: const [
                  GButton(icon: Icons.home, text: 'Home'),
                  GButton(icon: Icons.receipt_long, text: 'My Items'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
