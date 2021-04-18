part of 'pages.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengaturan", style: title24),
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
            title: Text("Ukuran Font", style: subtitle16.copyWith(fontWeight: FontWeight.w600)),
            subtitle:
                Text("atur ukuran font sesuai dengan keinginan", style: title12.copyWith(fontWeight: FontWeight.w400)),
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Divider(
              thickness: 2,
            ),
          ),
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
            title: Text("Export Data Ke Excel", style: subtitle16.copyWith(color: redColor, fontWeight: FontWeight.w600)),
            subtitle: RichText(
              text: TextSpan(
                text: "Tindakan",
                style: title12.copyWith(fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                    text: " Export Data Ke Excel ",
                    style: title12.copyWith(color: redColor, fontWeight: FontWeight.w400),
                  ),
                  TextSpan(text: "Akan menghapus data dari perangkat ("),
                  TextSpan(
                    text: "database",
                    style: title12.copyWith(color: redColor, fontWeight: FontWeight.w400),
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
    );
  }
}
