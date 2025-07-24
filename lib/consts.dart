import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

Color mainColor = Color(0xff3D1E4F);
Color secColor = Color(0xff6C4A80);
Color thirdColor = Color(0xff9B7DB0);
Color forthColor = Color(0xffD2C2E0);
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

final colors = [
  Color(0xFFD7CCC8),
  Color(0xFFFFE0B2),
  Color(0xFFDCEDC8),
  Color(0xFFFFCDD2),
  Color(0xFFB3E5FC),
  Color(0xFFD1C4E9),
  Color(0xFFC8E6C9),
  Color(0xFFB2DFDB),
];

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

var textFontForAppBar = GoogleFonts.raleway(
  fontSize: 25,
  fontWeight: FontWeight.bold,
);
double textFieldHeight = 35;
TextStyle textFieldFontStyle = const TextStyle(
  fontSize: 14,
  color: Colors.black,
);
TextStyle textFieldLabelStyle = TextStyle(
  color: Colors.grey.shade700,
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

var textStyleForCards = const TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: Color(0xffE9F5BE),
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
            style: GoogleFonts.raleway(
              fontSize: fontSize,
              color: color,
              fontWeight: isBold ? FontWeight.bold : null,
            ),
          )
        : Text(
            formattedText,
            maxLines: maxLines,
            // overflow: TextOverflow.fade,
            style: GoogleFonts.raleway(
              fontSize: fontSize,
              color: color,
              fontWeight: isBold ? FontWeight.bold : null,
            ),
          ),
  );
}

SnackbarController showSnackBar({
  required String title,
  required String message,
}) {
  return Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    snackStyle: SnackStyle.FLOATING,
    margin: const EdgeInsets.only(left: 20, bottom: 20),
    borderRadius: 10,
    backgroundColor: Colors.black87,
    colorText: Colors.white,
    duration: const Duration(seconds: 2),
    maxWidth: 300,
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    animationDuration: const Duration(milliseconds: 500),
  );
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
    radius: 12,
    contentPadding: const EdgeInsets.all(20),
    titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    middleTextStyle: const TextStyle(fontSize: 16),
    actions: [
      ElevatedButton.icon(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.cancel, color: Colors.white),
        label: const Text("Cancel"),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.grey[600],
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
