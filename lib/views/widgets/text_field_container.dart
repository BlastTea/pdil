import 'package:flutter/material.dart';
import 'package:pdil/utils/utils.dart';

class TextFieldContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      )),
    );
  }
}
