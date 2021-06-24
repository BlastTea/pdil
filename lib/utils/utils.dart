import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// default style nothing customization
TextStyle defaultStyle = GoogleFonts.poppins().copyWith();

/// title 24 with black color default size 20
TextStyle title = defaultStyle.copyWith(
  fontSize: 24,
);

TextStyle subtitle = defaultStyle.copyWith(
  fontSize: title.fontSize! - 6,
);

TextStyle body1 = defaultStyle.copyWith(
  fontSize: subtitle.fontSize! - 4,
);

TextStyle body2 = defaultStyle.copyWith(
  fontSize: subtitle.fontSize! - 2,
);

const String loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at lobortis arcu, sed vulputate metus. Aliquam sodales dapibus erat, ut ultricies dolor imperdiet a. Fusce nec purus quis ipsum ultrices consectetur. Praesent quis risus tempor, vestibulum tellus id, euismod mauris. Vestibulum dapibus ullamcorper massa vel eleifend. Nulla sed ornare est. Quisque ullamcorper eu odio sit amet lobortis. Quisque vel eleifend diam, ac ornare augue. Sed eu dui eu velit malesuada tincidunt. Morbi quam risus, cursus non dictum id, maximus pulvinar enim.";

showMySnackBar(
  BuildContext context, {
  required String text,
  Duration? duration,
  Function? onPressed,
}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: body1.copyWith(color: whiteColor),
        ),
        duration: duration ?? Duration(seconds: 5),
        action: SnackBarAction(
          label: "Ok",
          onPressed: onPressed as void Function()? ?? () {},
        ),
      ),
    );

const String tablePascabayar = 'Pascabayar';
const String tablePrabayar = 'Prabayar';
const String columnIdPel = 'IdPel';
const String columnNoMeter = 'NoMeter';
const String columnNama = 'Nama';
const String columnAlamat = 'Alamat';
const String columnTarip = 'Tarip';
const String columnDaya = 'Daya';
const String columnNoHp = 'NoHp';
const String columnNik = 'Nik';
const String columnNpwp = 'Npwp';
const String columnEmail = 'Email';
const String columnCatatan = 'Catatan';
const String columnIsKoreksi = 'Koreksi';
const String columnTanggalBaca = 'TanggalBaca';

const double defaultPadding = 25.0;

const Color primaryColor = Color(0xFF5AC4FF);
const Color whiteColor = Color(0xFFFFFFFF);
const Color redColor = Color(0xFFFF0000);
const Color greenColor = Color(0xFF42CF47);
const Color blackColor = Color(0xFF000000);
const Color greyColor = Color(0xFFC4C4C4);
const Color yellowColor = Color(0xFFF2F542);
const Color purpleColor = Colors.purple;
const Color inkWellSplashColor = purpleColor;

const shimmerGradient = LinearGradient(
  colors: [
    Colors.transparent,
    Color(0xFFF4F4F4),
    Colors.transparent,
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);

String currentTime() {
  DateTime time = DateTime.now();

  int tanggal = time.day;
  int bulan = time.month;
  int tahun = time.year;

  int jam = time.hour;
  int minute = time.minute;

  return '$tanggal/$bulan/$tahun $jam:$minute';
}

BoxDecoration cardDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(5),
  color: whiteColor,
  boxShadow: [
    BoxShadow(
      color: blackColor.withOpacity(0.25),
      blurRadius: 4,
      offset: Offset(0, 4),
    )
  ],
);
