import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class CurrentTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool readOnly;
  final double width;
  final BorderRadiusGeometry borderRadius;
  final ScrollController scrollController;
  final TextInputType keyboardType;
  final Function(String text) onSubmitted;
  final TextInputAction textInputAction;
  final String prefixText;

  const CurrentTextField({
    this.controller,
    this.label,
    this.readOnly,
    this.width,
    this.borderRadius,
    this.scrollController,
    this.keyboardType,
    this.onSubmitted,
    this.textInputAction,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 45,
      child: TextField(
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        keyboardType: keyboardType,
        scrollController: scrollController,
        controller: controller,
        readOnly: readOnly ?? false,
        style: title12.copyWith(fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          prefixText: prefixText,
          labelText: label,
          labelStyle: subtitle16.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.w400,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(5),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(5),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(5),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(5),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
