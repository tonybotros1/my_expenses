import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/consts.dart';

class CustomFilterField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final IconButton? suffixIcon;

  const CustomFilterField({
    super.key,
    this.controller,
    required this.hintText,
    this.onChanged,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: textFieldHeight,

      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        
        readOnly: true,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          hintStyle: TextStyle(color: Colors.grey),
          hintText: hintText,
          border: InputBorder.none,
          // isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
