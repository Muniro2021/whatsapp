import 'package:flutter/material.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.maxLines,
  });
  final TextEditingController controller;
  final String label;
  final String hintText;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontFamily: 'Unna'),
      controller: controller,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.top,
      maxLines: maxLines ?? 1,
      validator: (val) =>
          val != null && val.isNotEmpty ? null : 'Required Field',
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: primaryLightColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: primaryLightColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: primaryLightColor,
          ),
        ),
        fillColor: primaryLightColor,
        hintText: hintText,
        label: Text(
          label,
          style: const TextStyle(color: primaryLightColor),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
