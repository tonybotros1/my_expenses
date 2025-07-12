import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

Color mainColor = Color(0xff3D1E4F);
var textFontForAppBar = GoogleFonts.pacifico(fontSize: 50);

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
