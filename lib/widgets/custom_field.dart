import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      TextFormField(
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
        
        decoration: InputDecoration(
          icon: icon,
          suffixIcon: suffixIcon,
          hintStyle:  TextStyle(color: Colors.grey, fontSize: 14.sp),
          // labelText: labelText,
          alignLabelWithHint: true,

          // hintText: hintText,
          labelStyle: TextStyle(
            color: isEnabled == false
                ? Colors.grey.shade500
                : Colors.grey.shade700,
          ),
          filled: isEnabled == true,
          fillColor: Colors.grey.shade200,
          focusedBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(borderRadius!),
            borderSide: BorderSide(color: Colors.grey, width: 2.0.w),
          ),
          enabledBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.grey, width: 1.0.w),
          ),
          disabledBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0.w),
          ),
          errorBorder:  OutlineInputBorder(
            // borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.red, width: 1.0.w),
          ),
          focusedErrorBorder:  OutlineInputBorder(
            // borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.red, width: 2.0.w),
          ),
          contentPadding:  EdgeInsets.symmetric(
            vertical: 16.h,
            horizontal: 16.w,
          ),
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
    ],
  );
}
