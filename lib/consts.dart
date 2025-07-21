import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

Color mainColor = Color(0xff3D1E4F);
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
  bool isSelectable = true,
  bool formatDouble = true, // New parameter with default true
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
            maxLines: 1,
            style: GoogleFonts.raleway(
              fontSize: fontSize,
              color: color,
              fontWeight: isBold ? FontWeight.bold : null,
            ),
          )
        : Text(
            formattedText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
