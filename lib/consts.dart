import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

const Color mainColor = Color(0xff3D1E4F);
const Color secColor = Color(0xff6C4A80);
const Color thirdColor = Color(0xff9B7DB0);
const Color forthColor = Color(0xffD2C2E0);
// final colors = [
//   Color(0xFFE1F5FE),
//   Color(0xFFF3E5F5),
//   Color(0xFFE8F5E9),
//   Color(0xFFFFEBEE),
//   Color(0xFFFFFDE7),
//   Color(0xFFE0F7FA),
//   Color(0xFFFBE9E7),
//   Color(0xFFEDE7F6),
//   Color(0xFFF1F8E9),
//   Color(0xFFFFF8E1),
//   Color(0xFFF9FBE7),
//   Color(0xFFE3F2FD),
//   Color(0xFFFCE4EC),
//   Color(0xFFD7CCC8),
//   Color(0xFFF5F5F5),
//   Color(0xFFE0F2F1),
//   Color(0xFFFFE0B2),
//   Color(0xFFDCEDC8),
//   Color(0xFFFFCDD2),
//   Color(0xFFB3E5FC),
//   Color(0xFFD1C4E9),
//   Color(0xFFFFF9C4),
//   Color(0xFFFFE0E0),
//   Color(0xFFC8E6C9),
//   Color(0xFFB2DFDB),
//   Color(0xFFFFF3F0),
//   Color(0xFFFFDDEE),
//   Color(0xFFE4F0E2),
//   Color(0xFFF2F2FF),
//   Color(0xFFEBF6FF),
//   Color(0xFFFFF7EC),
//   Color(0xFFEDF7F6),
//   Color(0xFFE9F5E1),
//   Color(0xFFF5EBF7),
//   Color(0xFFFDECEA),
//   Color(0xFFE8F0FE),
//   Color(0xFFFDF1FF),
//   Color(0xFFFFF2E6),
//   Color(0xFFF6FFF8),
//   Color(0xFFF9F3F3),
//   Color(0xFFECF8F8),
//   Color(0xFFFFF4F4),
//   Color(0xFFE7FFF2),
//   Color(0xFFF3FFFD),
//   Color(0xFFF6F3FF),
//   Color(0xFFFEEFFB),
//   Color(0xFFEFFBFF),
//   Color(0xFFF1FFF0),
//   Color(0xFFFFEFFF),
//   Color(0xFFFFF3E0),
// ];

const colors = [
  Color(0xFFD7CCC8),
  Color(0xFFFFE0B2),
  Color(0xFFDCEDC8),
  Color(0xFFFFCDD2),
  Color(0xFFB3E5FC),
  Color(0xFFD1C4E9),
  Color(0xFFC8E6C9),
  Color(0xFFB2DFDB),
];

ThemeData buildAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: mainColor,
    brightness: brightness,
  );
  final scaffoldColor = isDark ? const Color(0xff121018) : Colors.white;
  final surfaceColor = isDark ? const Color(0xff1b1724) : Colors.white;
  final fieldColor = isDark ? const Color(0xff282131) : Colors.grey.shade100;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme.copyWith(
      primary: mainColor,
      secondary: secColor,
      surface: surfaceColor,
    ),
    scaffoldBackgroundColor: scaffoldColor,
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: scaffoldColor,
      foregroundColor: isDark ? Colors.white : Colors.black87,
      surfaceTintColor: Colors.transparent,
    ),
    drawerTheme: DrawerThemeData(backgroundColor: surfaceColor),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: mainColor,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardThemeData(color: surfaceColor),
    dividerTheme: DividerThemeData(
      color: isDark ? Colors.white12 : Colors.black12,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: fieldColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: isDark ? Colors.white24 : Colors.grey.shade400,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: isDark ? forthColor : mainColor,
          width: 2,
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.black87,
      contentTextStyle: const TextStyle(color: Colors.white),
    ),
  );
}

final Map<String, IconData> allCategoriesIcons = {
  "Food": Icons.fastfood,
  "Drinks": Icons.local_drink,
  "Groceries": Icons.shopping_cart,
  "Transport": Icons.directions_car,
  "Fuel": Icons.local_gas_station,
  "Bills": Icons.receipt,
  "Rent": Icons.house,
  "Health": Icons.health_and_safety,
  "Fitness": Icons.fitness_center,
  "Clothing": Icons.checkroom,
  "Education": Icons.school,
  "Entertainment": Icons.movie,
  "Subscriptions": Icons.subscriptions,
  "Travel": Icons.airplanemode_active,
  "Gifts": Icons.card_giftcard,
  "Donations": Icons.volunteer_activism,
  "Savings": Icons.savings,
  "Pets": Icons.pets,
  "Insurance": Icons.security,
  "Internet": Icons.wifi,
  "Phone": Icons.phone_android,
  "Kids": Icons.child_friendly,
  "Beauty": Icons.brush,
  "Home": Icons.chair,
  "Maintenance": Icons.build,
  "Business": Icons.business_center,
  "Other": Icons.more_horiz,
  "Hookah": Icons.smoking_rooms,
};

const List<Color> categoryStyleColors = [
  Color(0xFFD7CCC8),
  Color(0xFFFFE0B2),
  Color(0xFFDCEDC8),
  Color(0xFFFFCDD2),
  Color(0xFFB3E5FC),
  Color(0xFFD1C4E9),
  Color(0xFFC8E6C9),
  Color(0xFFB2DFDB),
  Color(0xFFFFF59D),
  Color(0xFFA5D6A7),
  Color(0xFF90CAF9),
  Color(0xFFCE93D8),
];

IconData getIconByLabel(String label) {
  return allCategoriesIcons[label] ?? Icons.more_horiz;
}

String iconLabelForName(String categoryName) {
  final normalized = categoryName.trim().toLowerCase();
  final match = allCategoriesIcons.keys.firstWhere(
    (label) => label.toLowerCase() == normalized,
    orElse: () => 'Other',
  );
  return match;
}

IconData getCategoryIcon(String? categoryName) {
  if (categoryName == null) return Icons.more_horiz;

  final normalized = categoryName.trim().toLowerCase();

  // Try exact match
  final entry = allCategoriesIcons.entries.firstWhere(
    (e) => e.key.toLowerCase() == normalized,
    orElse: () => const MapEntry('', Icons.more_horiz),
  );

  if (entry.key.isNotEmpty) return entry.value;

  // Try singular/plural fallback
  final altEntry = allCategoriesIcons.entries.firstWhere(
    (e) =>
        e.key.toLowerCase() ==
        (normalized.endsWith('s')
            ? normalized.substring(0, normalized.length - 1)
            : '${normalized}s'),
    orElse: () => const MapEntry('Other', Icons.more_horiz),
  );

  return altEntry.value;
}

Color getTextColor(Color bgColor, {double amount = 0.4}) {
  final hsl = HSLColor.fromColor(bgColor);
  final darkerHsl = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return darkerHsl.toColor();
}

TextStyle textFontForAppBar = TextStyle(
  fontSize: 25.sp,
  fontWeight: FontWeight.bold,
);
double textFieldHeight = 45.h;
TextStyle textFieldFontStyle = TextStyle(fontSize: 14.sp);
TextStyle textFieldLabelStyle = TextStyle(
  color: Colors.grey.shade700,
  fontSize: 12.sp,
  fontWeight: FontWeight.bold,
);

TextStyle regTextStyle = TextStyle(fontSize: 15.sp);

TextStyle textStyleForCards = TextStyle(
  fontSize: 22.sp,
  fontWeight: FontWeight.bold,
  color: const Color(0xffE9F5BE),
);
Widget customText({
  required String text,
  double? maxWidth = 150,
  Color? color = Colors.white,
  bool isBold = false,
  double? fontSize,
  bool isSelectable = false,
  bool formatDouble = true,
  int? maxLines = 1,
}) {
  String formattedText = text;

  if (formatDouble) {
    double? parsedValue = double.tryParse(text);
    if (parsedValue != null) {
      formattedText = NumberFormat("#,##0.00").format(parsedValue);
    }
  }

  return Container(
    constraints: maxWidth != null ? BoxConstraints(maxWidth: maxWidth) : null,
    child: isSelectable
        ? SelectableText(
            formattedText,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: fontSize?.sp,
              color: color,
              fontWeight: isBold ? FontWeight.bold : null,
            ),
          )
        : Text(
            formattedText,
            maxLines: maxLines,
            // overflow: TextOverflow.fade,
            style: TextStyle(
              fontSize: fontSize?.sp,
              color: color,
              fontWeight: isBold ? FontWeight.bold : null,
            ),
          ),
  );
}

void showSnackBar({required String title, required String message}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final context = Get.context ?? Get.overlayContext;
    if (context == null) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              Text(message, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
  });
}

String textToDate(dynamic inputDate) {
  // 1) Null or empty
  if (inputDate == null) return '';

  // 3) Dart DateTime
  if (inputDate is DateTime) {
    return DateFormat('dd-MM-yyyy').format(inputDate);
  }

  // 4) String
  if (inputDate is String) {
    final raw = inputDate.trim();
    if (raw.isEmpty) return '';

    // Already in dd-MM-yyyy?
    final ddMMyyyy = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    if (ddMMyyyy.hasMatch(raw)) {
      return raw;
    }

    // Try parsing (e.g. "yyyy-MM-dd", ISO, etc.)
    try {
      final parsed = DateTime.parse(raw);
      return DateFormat('dd-MM-yyyy').format(parsed);
    } catch (_) {
      // Fallback: try strict yyyy-MM-dd
      try {
        final parsedStrict = DateFormat('yyyy-MM-dd').parseStrict(raw);
        return DateFormat('dd-MM-yyyy').format(parsedStrict);
      } catch (e) {
        return '';
      }
    }
  }

  // Unsupported type
  return '';
}

Future<dynamic> alertDialog({
  required String title,
  required String middleText,
  required void Function()? onPressed,
}) {
  return Get.defaultDialog(
    title: title,
    middleText: middleText,
    radius: 12.w,
    contentPadding: EdgeInsets.all(20.r),
    titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
    middleTextStyle: TextStyle(fontSize: 16.sp),
    actions: [
      ElevatedButton.icon(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.cancel, color: Colors.white),
        label: const Text("Cancel"),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.grey[600],
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.delete, color: Colors.white),
        label: const Text("Delete"),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red[600],
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ],
  );
}

Future<void> selectDateContext(
  BuildContext context,
  TextEditingController date,
) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (picked != null) {
    date.text = textToDate(picked.toString());
  }
}
