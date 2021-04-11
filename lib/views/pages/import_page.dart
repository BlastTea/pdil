part of 'pages.dart';

class ImportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Import",
          style: title24,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _importContainer(context),
            _confirmToInput,
          ],
        ),
      ),
    );
  }

  Widget _importContainer(BuildContext context) => Row(
        children: [
          TextContainer(data: "Isi dari Text yang panjaaaaaaaang banget"),
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
              child: InkWell(
                hoverColor: Colors.lightBlue,
                borderRadius: BorderRadius.circular(10),
                onTap: () {},
                child: Icon(
                  Icons.folder_open,
                  color: Colors.blue,
                ),
              ),
            ),
          )
        ],
      );

  Widget _confirmToInput = RaisedButton(
    color: Colors.blue,
    shape: StadiumBorder(),
    onPressed: () => Get.to(InputPage()),
    child: Text("Selanjutnya"),
  );
}
