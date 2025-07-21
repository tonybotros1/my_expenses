import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_expenses/screens/main_screen.dart';

import '../screens/all_items.dart';

class InitScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;

  final RxList<Widget> pages = RxList([MainScreen(), AllItems()]);
}
