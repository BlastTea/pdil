import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdil/blocs/blocs.dart';

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
  final Function(String text) onChanged;
  final TextInputAction textInputAction;
  final String prefixText;

  CurrentTextField({
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
    this.onChanged,
  });

  TextStyle theStyle = body;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) => (stateFontSize is FontSizeResult)
          ? Container(
              width: width,
              height: 40 + (stateFontSize.title.fontSize - 20),
              child: TextField(
                textInputAction: textInputAction,
                onSubmitted: onSubmitted,
                onChanged: onChanged,
                keyboardType: keyboardType,
                scrollController: scrollController,
                controller: controller,
                readOnly: readOnly ?? false,
                style: stateFontSize.body,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  prefixText: prefixText,
                  labelText: label,
                  labelStyle: stateFontSize.subtitle.copyWith(
                    color: primaryColor,
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
            )
          : Container(),
    );
  }
}
