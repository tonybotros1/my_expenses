import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'hive_setup/hive_initializer.dart';
import 'screens/add_new_item.dart';
import 'screens/main_screen.dart';
import 'screens/my_categories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter("my_expenses");
  await initHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // home: MainScreen(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => MainScreen()),
        GetPage(name: '/addNewItem', page: () => AddNewItem()),
        GetPage(name: '/myCategories', page: () => MyCategories()),
      ],
    );
  }
}
