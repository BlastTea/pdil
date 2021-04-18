part of 'pages.dart';

class ExportPage extends StatefulWidget {
  @override
  _ExportPageState createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  TextEditingController namaFileController = TextEditingController();

  DbHelper dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Export", style: title24),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CurrentTextField(
                    controller: namaFileController,
                    label: "Nama File",
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("isNull : ${namaFileController.text != null}");
                      print("isEmpty : ${namaFileController.text != ""}");
                      if (namaFileController.text != "" && namaFileController.text != null)
                        showDialog(
                            useRootNavigator: true,
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text("Apakah Anda yakin ?", style: title24.copyWith(color: blackColor)),
                                  content: Text("Tindakan ini tidak dapat di undo", style: title12),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        NavigationHelper.back();
                                        _exportData(context, namaFileController.text);
                                      },
                                      child: Text(
                                        "Ya",
                                        style: title12,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        NavigationHelper.back();
                                      },
                                      child: Text(
                                        "Tidak",
                                        style: title12,
                                      ),
                                    ),
                                  ],
                                ));
                      else
                        showMySnackBar(context, text: "Silahkan kasih nama file terlebih dahulu");
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Export ke Excel"),
                        SizedBox(width: 10),
                        Transform.rotate(
                          angle: pi,
                          child: Icon(
                            Icons.arrow_back,
                            color: whiteColor,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<ExportDataBloc, ExportDataState>(builder: (_, state) {
            if (state is ExportDataProgress) {
              double rasio = (state.progress / 100);
              if (state.progress < 100) {
                return AnimatedContainer(
                  duration: Duration(seconds: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 6,
                            decoration: BoxDecoration(
                              color: greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            width: MediaQuery.of(context).size.width * 0.45 * rasio,
                            height: 6,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 5),
                      Text("${state.progress}/100%"),
                    ],
                  ),
                );
              } else if (state.progress == 100) return Container();
            }
            return Container();
          }),
        ],
      ),
    );
  }

  _exportData(BuildContext context, String namaFile) async {
    var excel = Excel.createExcel();

    var sheet = excel['Sheet1'];

    List<Pdil> pdils = await dbHelper.getPdilList();

    int counter = 0;
    pdils.forEach((row) {
      if (counter < 1) {
        sheet.appendRow([
          'NO',
          'IDPEL',
          'NAMA',
          'ALAMAT',
          'TARIF',
          'DAYA',
          'NO HP',
          'NIK',
          'NPWP',
        ]);
      }
      counter++;
      var rows = [
        counter.toString(),
        ...row.toList(),
      ];
      sheet.appendRow(rows);
      context.read<ExportDataBloc>().add(ExportDataExport(counter, pdils.length));
    });

    List<Directory> listDirectory = await getExternalStorageDirectories(type: StorageDirectory.downloads);

    excel.encode().then((value) async {
      var file = File(listDirectory[0].path + '/$namaFile.xlsx');

      await file.create(recursive: true);

      file.writeAsBytesSync(value);
    });
  }
}
