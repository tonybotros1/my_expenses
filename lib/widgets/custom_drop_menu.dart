import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customDropdown({
  required String label,
  required String? value,
  required List<String> items,
  required void Function(String?) onChanged,
  bool? isEnabled = true,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.w,
          color: Colors.grey.shade700,
        ),
      ),
      SizedBox(height: 6.w),
      DropdownButtonFormField2(
        value: value,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.w),
          alignLabelWithHint: true,
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
          errorBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.red, width: 1.0.w),
          ),
          focusedErrorBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.red, width: 2.0.w),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.w,
            horizontal: 16.w,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.w),
            borderSide: BorderSide.none,
          ),
        ),

        isExpanded: true,
        items: items
            .map(
              (item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)),
            )
            .toList(),
        onChanged: onChanged,
      ),
    ],
  );
}
