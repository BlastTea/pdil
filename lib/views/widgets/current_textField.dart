import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class CurrentTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool enable;
  final double width;
  final BorderRadiusGeometry borderRadius;
  final ScrollController scrollController;

  CurrentTextField(
      {this.controller,
      this.label,
      this.enable,
      this.width,
      this.borderRadius,
      this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 40,
      child: TextField(
        scrollController: scrollController,
        controller: controller,
        enabled: enable ?? true,
        style: title12.copyWith(fontWeight: FontWeight.w400),
        decoration: InputDecoration(
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
