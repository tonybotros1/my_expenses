import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../consts.dart';
import 'capital_letters_field.dart';
import 'date_time_field.dart';
import 'decimal_text_field.dart';
import 'first_letter_from_each_word_capital.dart';

Widget customLabeledTextField({
  required String label,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  bool isRequired = true,
  bool? isnumber,
  bool? isDouble,
  bool? isDate,
  bool? isCapitaLetters,
  IconButton? suffixIcon,
  Icon? icon,
  bool? isEnabled = true,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.sp,
          color: Colors.grey.shade700,
        ),
      ),
      SizedBox(height: 6.h),
      SizedBox(
        height: maxLines == 1 ? textFieldHeight : null,
        child: TextFormField(
          textCapitalization: TextCapitalization.words,
          style: TextStyle(fontSize: 15.w, color: Colors.black),
          inputFormatters: isnumber == true
              ? [FilteringTextInputFormatter.digitsOnly]
              : isDouble == true
              ? [DecimalTextInputFormatter()]
              : isDate == true
              ? [DateTextFormatter()]
              : isCapitaLetters == true
              ? [CapitalLettersOnlyFormatter()]
              : [WordCapitalizationInputFormatter()],
          maxLines: maxLines,
          controller: controller,
          keyboardType: keyboardType,
          enabled: isEnabled,
          decoration: InputDecoration(
            icon: icon,
            suffixIcon: suffixIcon,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
            alignLabelWithHint: true,
            labelStyle: TextStyle(
              color: isEnabled == false
                  ? Colors.grey.shade500
                  : Colors.grey.shade700,
            ),
            filled: isEnabled == true,
            fillColor: Colors.grey.shade200,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2.0.w),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0.w),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0.w),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0.w),
            ),
            contentPadding: maxLines > 1
                ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16)
                : EdgeInsets.symmetric(horizontal: 16.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide.none,
            ),
          ),
          validator: isRequired
              ? (value) =>
                    value == null || value.isEmpty ? 'Please Enter Value' : null
              : null,
        ),
      ),
    ],
  );
}
