import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

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
          fontSize: 15,
          color: Colors.grey.shade700,
        ),
      ),
      const SizedBox(height: 6),
      DropdownButtonFormField2(
        value: value,
        decoration: InputDecoration(
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          disabledBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
          ),
          errorBorder: const OutlineInputBorder(
            // borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            // borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
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
