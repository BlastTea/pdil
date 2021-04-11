part of 'pages.dart';

class InputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Data", style: title24),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          TextContainer(
            judul: "IdPel",
            type: TypeTextContainer.type_b,
          ),
          TextContainer(
            judul: "Nama",
            type: TypeTextContainer.type_b,
          ),
          TextContainer(
            judul: "Alamat",
            type: TypeTextContainer.type_b,
          ),
          TextContainer(
            judul: "Kode RBM",
            type: TypeTextContainer.type_b,
          ),
          TextContainer(
            judul: "Tarip",
            type: TypeTextContainer.type_b,
          ),
          TextContainer(
            judul: "Daya",
            type: TypeTextContainer.type_b,
          ),
        ],
      ),
    );
  }
}
