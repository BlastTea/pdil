import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// default style nothing customization
TextStyle defaultStyle = GoogleFonts.poppins().copyWith();

/// title 24 with black color default size 20
TextStyle title = defaultStyle.copyWith(
  fontSize: 20,
);

TextStyle subtitle = defaultStyle.copyWith(
  fontSize: title.fontSize - 2,
);

TextStyle body = defaultStyle.copyWith(
  fontSize: subtitle.fontSize - 2,
);

const String loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at lobortis arcu, sed vulputate metus. Aliquam sodales dapibus erat, ut ultricies dolor imperdiet a. Fusce nec purus quis ipsum ultrices consectetur. Praesent quis risus tempor, vestibulum tellus id, euismod mauris. Vestibulum dapibus ullamcorper massa vel eleifend. Nulla sed ornare est. Quisque ullamcorper eu odio sit amet lobortis. Quisque vel eleifend diam, ac ornare augue. Sed eu dui eu velit malesuada tincidunt. Morbi quam risus, cursus non dictum id, maximus pulvinar enim.";

showMySnackBar(
  BuildContext context, {
  @required String text,
  Duration duration,
  Function onPressed,
}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: body.copyWith(color: whiteColor),
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
