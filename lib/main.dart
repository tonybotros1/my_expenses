import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_expenses/consts.dart';
import 'package:my_expenses/controllers/daily_tools_controller.dart';
import 'package:my_expenses/controllers/settings_controller.dart';
import 'package:my_expenses/screens/daily_tools_screen.dart';
import 'package:my_expenses/screens/settings_screen.dart';
import 'hive_setup/hive_initializer.dart';
import 'screens/add_new_item.dart';
import 'screens/init_screen.dart';
import 'screens/my_categories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter("my_expenses");
  await initHive();
  final settingsController = Get.put(SettingsController());
  await settingsController.loadSettings();
  Get.put(DailyToolsController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      builder: (context, child) {
        final settingsController = Get.isRegistered<SettingsController>()
            ? Get.find<SettingsController>()
            : Get.put(SettingsController());
        if (!Get.isRegistered<DailyToolsController>()) {
          Get.put(DailyToolsController(), permanent: true);
        }

        return Obx(
          () => GetMaterialApp(
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(1)),
                child: child!,
              );
            },
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(Brightness.light),
            darkTheme: buildAppTheme(Brightness.dark),
            themeMode: settingsController.themeMode,
            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => const InitScreen()),
              GetPage(name: '/addNewItem', page: () => AddNewItem()),
              GetPage(name: '/dailyTools', page: () => DailyToolsScreen()),
              GetPage(name: '/myCategories', page: () => MyCategories()),
              GetPage(name: '/settings', page: () => const SettingsScreen()),
            ],
          ),
        );
      },
    );
  }
}
