part of 'pages.dart';

class SettingsPage extends StatefulWidget {
  final bool isImport;

  SettingsPage({this.isImport = false});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) => (stateFontSize is FontSizeResult)
          ? Scaffold(
              appBar: AppBar(
                title: Text("Pengaturan",
                    style: stateFontSize.title.copyWith(color: whiteColor, fontWeight: FontWeight.w600)),
              ),
              body: ListView(
                children: [
                  ListTile(
                    leading: Stack(
                      children: [
                        ClipPath.shape(
                          shape: CircleBorder(),
                          child: Container(
                            width: 30,
                            height: 30,
                            color: greenColor,
                          ),
                        ),
                        SvgPicture.asset(
                          "assets/icons/TextAa.svg",
                          width: 18,
                          height: 18,
                        ),
                      ],
                    ),
                    title: Text("Ukuran Font", style: stateFontSize.subtitle.copyWith(fontWeight: FontWeight.w600)),
                    subtitle: Text("atur ukuran font sesuai dengan keinginan", style: stateFontSize.body),
                    onTap: () async {
                      double value = await FontSizeServices.getFontSize() ?? 0;
                      if (value != 0) {
                        value = (value - 20) / 2;
                      }
                      NavigationHelper.to(MaterialPageRoute(builder: (_) => FontSizePage(sliderValue: value ?? 0)));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                  if (!widget.isImport)
                    ListTile(
                      leading: Stack(
                        children: [
                          Image.asset(
                            "assets/images/ExportExcel.png",
                            width: 30,
                            height: 30,
                          ),
                        ],
                      ),
                      title: Text("Export Data Ke Excel",
                          style: stateFontSize.subtitle.copyWith(color: redColor, fontWeight: FontWeight.w600)),
                      subtitle: RichText(
                        text: TextSpan(
                          text: "Tindakan",
                          style: stateFontSize.body.copyWith(color: blackColor.withOpacity(0.6)),
                          children: [
                            TextSpan(
                              text: " Export Data Ke Excel ",
                              style: stateFontSize.body.copyWith(color: redColor),
                            ),
                            TextSpan(text: "Akan menghapus data dari perangkat ("),
                            TextSpan(
                              text: "database",
                              style: stateFontSize.body.copyWith(color: redColor),
                            ),
                            TextSpan(text: ")"),
                          ],
                        ),
                      ),
                      onTap: () {
                        NavigationHelper.to(MaterialPageRoute(builder: (_) => ExportPage()));
                      },
                    ),
                ],
              ),
            )
          : Container(),
    );
  }
}
