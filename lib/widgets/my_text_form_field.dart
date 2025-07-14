import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../consts.dart';
import 'capital_letters_field.dart';
import 'date_time_field.dart';
import 'decimal_text_field.dart';
import 'first_letter_from_each_word_capital.dart';

Widget myTextFormFieldWithBorder(
    {String? labelText,
    String? hintText,
    TextEditingController? controller,
    bool? validate,
    bool obscureText = false,
    IconButton? suffixIcon,
    Icon? icon,
    bool? isnumber,
    bool? isDouble,
    bool? isDate,
    bool? isCapitaLetters,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    void Function()? onEditingComplete,
    maxLines = 1,
    // double? borderRadius = 4,
    TextAlign? textAlign = TextAlign.start,
    String? initialValue,
    int? minLines,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
    bool? isEnabled = true}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      labelText != null
          ? Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text(
                  overflow: TextOverflow.ellipsis,
                  labelText,
                  style: textFieldLabelStyle),
            )
          : SizedBox(),
      SizedBox(
        height: maxLines == 1 ? textFieldHeight : null,
        child: TextFormField(
          onEditingComplete: onEditingComplete,
          textInputAction: textInputAction,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          textAlign: textAlign!,
          initialValue: initialValue,
          style: textFieldFontStyle,
          onTap: () {
            if (controller != null) {
              controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller.text.length,
              );
            }
          },
          minLines: minLines,
          maxLines: maxLines,
          onChanged: onChanged,
          inputFormatters: isnumber == true
              ? [FilteringTextInputFormatter.digitsOnly]
              : isDouble == true
                  ? [DecimalTextInputFormatter()]
                  : isDate == true
                      ? [DateTextFormatter()]
                      : isCapitaLetters == true
                          ? [CapitalLettersOnlyFormatter()]
                          : [WordCapitalizationInputFormatter()],
          enabled: isEnabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          controller: controller,
          decoration: InputDecoration(
            contentPadding: maxLines == 1
                ? const EdgeInsets.only(left: 10, right: 10)
                : const EdgeInsets.all(10),
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
          ),
          validator: validate != false
              ? (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter $labelText';
                  }
                  return null;
                }
              : null,
        ),
      ),
    ],
  );
}
