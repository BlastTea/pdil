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

TextStyle subtitle16 = defaultStyle.copyWith(
  fontSize: 16,
);

TextStyle title12 = defaultStyle.copyWith(
  fontSize: 12,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

showMySnackBar(BuildContext context, {
  @required String text,
  Duration duration,
  Function onPressed,
}) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: title12.copyWith(color: whiteColor),
        ),
        duration: duration ?? Duration(seconds: 5),
        action: SnackBarAction(
          label: "Ok",
          onPressed: onPressed ?? () {},
        ),
      ),
    );

const String tablePdil = 'Pdil';
const String columnIdPel = 'IdPel';
const String columnNama = 'Nama';
const String columnAlamat = 'Alamat';
const String columnTarip = 'Tarip';
const String columnDaya = 'Daya';
const String columnNoHp = 'NoHp';
const String columnNik = 'Nik';
const String columnNpwp = 'Npwp';
const String columnIsKoreksi = 'Koreksi';

const Color primaryColor = Color(0xFF3090B3);
const Color whiteColor = Color(0xFFFFFFFF);
const Color redColor = Color(0xFFFF0000);
const Color greenColor = Color(0xFF42CF47);
const Color blackColor = Color(0xFF000000);
const Color greyColor = Color(0xFFC4C4C4);
