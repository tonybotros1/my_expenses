import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          fontSize: 15,
          color: Colors.grey.shade700,
        ),
      ),
      const SizedBox(height: 6),
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
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
        validator: isRequired
            ? (value) =>
                  value == null || value.isEmpty ? 'Please Enter Value' : null
            : null,
      ),
    ],
  );
}
