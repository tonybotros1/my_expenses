import 'package:flutter/material.dart';

Widget customLabeledTextField({
  required String label,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  bool isRequired = true,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.grey.shade700,
        ),
      ),
      const SizedBox(height: 6),
      TextFormField(
        maxLines: maxLines,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade300,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
        ),
        validator: isRequired
            ? (value) => value == null || value.isEmpty ? 'Please Enter Value' : null
            : null,
      ),
    ],
  );
}
