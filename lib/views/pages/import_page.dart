part of 'pages.dart';

class ImportPage extends StatefulWidget {
  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  FilePickerResult result;
  String directory = "";

  

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

  Widget _importContainer(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 76,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: primaryColor,
                ),
                borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Text(
                      directory,
                      style: title12.copyWith(
                        fontWeight: FontWeight.w400,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(5)),
                color: primaryColor,
              ),
              child: Material(
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(5)),
                color: Colors.transparent,
                child: InkWell(
                  hoverColor: Colors.lightBlue,
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(5)),
                  onTap: () async {
                    result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['xlsx', 'xlsm', 'xlsb', 'xltx'],
                      allowMultiple: false,
                    );

                    if (result != null) {
                      print("Directory : ${result.files.single.path}");
                      List files = result.files.single.path.split("/");
                      setState(() {
                        directory = files[files.length - 1];
                      });
                      var file = result.files.single.path;
                      var bytes = File(file).readAsBytesSync();
                      var excel = Excel.decodeBytes(bytes);

                      for (var table in excel.tables.keys) {
                        print(table); //sheet Name
                        print(excel.tables[table].maxCols);
                        print(excel.tables[table].maxRows);
                        for (var row in excel.tables[table].rows) {
                          print("$row");
                        }
                      }
                    }
                  },
                  child: Icon(
                    Icons.folder_open,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      );

  Widget _confirmToInput = ElevatedButton(
    onPressed: () => Get.to(() => InputPage()),
    child: Text("Selanjutnya"),
  );
}
