import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdil/utils/utils.dart';

class ProgressBar extends StatelessWidget {
  final double width;
  int progress;

  ProgressBar({this.width, this.progress});

  @override
  Widget build(BuildContext context) {
    double rasio = (progress / 100);
    return Stack(
      children: [
        Container(
          width: width ?? double.infinity,
          height: 6,
          decoration: BoxDecoration(
            color: greyColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Container(
          width: width * rasio,
          height: 6,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }
}
