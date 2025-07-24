import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
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
          border: InputBorder.none, // Remove default underline
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
