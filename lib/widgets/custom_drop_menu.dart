import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

Widget customDropdown({
  required String label,
  required String? value,
  required List<String> items,
  required void Function(String?) onChanged,
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
      DropdownButtonFormField2(
        value: value,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade300,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
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
