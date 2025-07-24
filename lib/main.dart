import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_expenses/screens/settings_screen.dart';
import 'hive_setup/hive_initializer.dart';
import 'screens/add_new_item.dart';
import 'screens/init_screen.dart';
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
    return ScreenUtilInit(
      designSize: Size(430, 932),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1)),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          // home: MainScreen(),
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => InitScreen()),
            GetPage(name: '/addNewItem', page: () => AddNewItem()),
            GetPage(name: '/myCategories', page: () => MyCategories()),
            GetPage(name: '/settings', page: () => SettingsScreen()),
          ],
        );
      },
    );
  }
}
