// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SettingsController extends GetxController {
//   RxString userName = RxString('');
//   RxString currency = RxString('');

//   @override
//   void onInit() async {
//     await getUserData();
//     super.onInit();
//   }

//   getUserData() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     userName.value = prefs.getString('user_name') ?? '';
//     currency.value = prefs.getString('user_currency') ?? '';
//   }

//   editUserData() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('user_name', userName.value);
//     await prefs.setString('user_currency', currency.value);
//   }
// }
