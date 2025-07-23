import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: GetX<InitScreenController>(
            builder: (controller) {
              return GNav(
                gap: 8,
                activeColor: Colors.white,
                color: Colors.grey[700],
                tabBackgroundColor: mainColor,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
