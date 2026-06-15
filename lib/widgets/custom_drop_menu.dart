import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../consts.dart';

Widget customDropdown({
  required String label,
  required String? value,
  required List<String> items,
  required void Function(String?) onChanged,
  bool? isEnabled = true,
}) {
  final context = Get.context;
  final theme = context != null ? Theme.of(context) : ThemeData.light();
  final colorScheme = theme.colorScheme;
  final fillColor =
      theme.inputDecorationTheme.fillColor ?? Colors.grey.shade200;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.sp,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      SizedBox(height: 6.h),
      SizedBox(
        height: textFieldHeight,
        child: DropdownButtonFormField2(
          value: items.contains(value) ? value : null,
          style: TextStyle(fontSize: 15.sp, color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
            contentPadding: EdgeInsets.all(0.r),
            alignLabelWithHint: true,
            labelStyle: TextStyle(
              color: isEnabled == false
                  ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
                  : colorScheme.onSurfaceVariant,
            ),
            filled: isEnabled == true,
            fillColor: fillColor,
            focusedBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(borderRadius!),
              borderSide: BorderSide(color: colorScheme.primary, width: 2.0.w),
            ),
            enabledBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
                width: 1.0.w,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
                width: 1.0.w,
              ),
            ),
            errorBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.red, width: 1.0.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.red, width: 2.0.w),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.w),
              borderSide: BorderSide.none,
            ),
          ),

          isExpanded: true,
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          items: items
              .map(
                (item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    ],
  );
}
