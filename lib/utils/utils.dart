import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// default style nothing customization
TextStyle defaultStyle = GoogleFonts.poppins().copyWith();

/// title 24 with black color default size 20
TextStyle title24 = defaultStyle.copyWith(
  fontSize: 20,
  color: Colors.white,
  fontWeight: FontWeight.w600,
);

TextStyle title12 = defaultStyle.copyWith(
  fontSize: 12,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);
