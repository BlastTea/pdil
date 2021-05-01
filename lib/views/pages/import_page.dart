part of 'pages.dart';

class ImportPage extends StatefulWidget {
  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  FilePickerResult result;
  String directory = "";
  String message;
  DbHelper dbHelper = DbHelper();
  final List<List<String>> formatChecks = [
    ['IDPEL'],
    ['NAMA'],
    ['ALAMAT'],
    ['TARIF', 'TARIP'],
    ['DAYA'],
    ['NOHP'],
    ['NIK'],
    ['NPWP'],
    ['CATATAN'],
    ['TANGGALBACA']
  ];

  List<int> formatIndexs = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) => (stateFontSize is FontSizeResult)
          ? Scaffold(
              appBar: AppBar(
                title: Text(
                  "Import",
                  style: stateFontSize.title.copyWith(color: whiteColor, fontWeight: FontWeight.w600),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.settings, color: whiteColor),
                    onPressed: () {
                      NavigationHelper.to(MaterialPageRoute(builder: (_) => SettingsPage(isImport: true)));
                    },
                  ),
                  SizedBox(width: 10),
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _importContainer(context, stateFontSize),
                    _message(context, message, stateFontSize),
                    _confirmToInput(context, stateFontSize),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }

  _importContainer(BuildContext context, FontSizeResult stateFontSize) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CurrentTextField(
              controller: TextEditingController(text: directory),
              label: "File",
              readOnly: true,
              width: MediaQuery.of(context).size.width - 76,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
            ),
            Container(
              width: 60,
              height: 40 + (stateFontSize.title.fontSize - 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(right: Radius.circular(5)),
                color: primaryColor,
              ),
              child: Material(
                borderRadius: BorderRadius.horizontal(right: Radius.circular(5)),
                color: Colors.transparent,
                child: InkWell(
                  hoverColor: Colors.lightBlue,
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(5)),
                  onTap: () async {
                    result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['xlsx', 'xltx'],
                      allowMultiple: false,
                    );

                    context.read<ErrorCheckBloc>().add(ErrorCheckClear());
                    setState(() {
                      directory = "";
                    });

                    if (result != null) {
                      List files = result.files.single.path.split("/");
                      setState(() {
                        directory = files[files.length - 1];
                      });

                      // var file = result.files.single.path;
                      // var bytes = File(file).readAsBytesSync();
                      // var excel = Excel.decodeBytes(bytes);

                      // for (var table in excel.tables.keys) {
                      // print(table); //sheet Name
                      // print(excel.tables[table].maxCols);
                      // print(excel.tables[table].maxRows);
                      // for (var row in excel.tables[table].rows) {
                      //   print("$row");
                      // }
                      //
                      //
                      // check
                      // for (int i = 0; i < check.length; i++) {
                      //   List columns = excel.tables[table].rows[0];
                      //   if (check[i] == columns[i]) {
                      //     if (i == check.length - 1) {
                      //       context
                      //           .read<ErrorCheckBloc>()
                      //           .add(ErrorCheckSuccessfulEvent());
                      //       isChecked = true;
                      //     }
                      //   } else {
                      //     isChecked = false;
                      //     context.read<ErrorCheckBloc>().add(
                      //         ErrorCheckOnError(ErrorCheck(
                      //             check: columns[i], target: check[i])));
                      //     if (i == check.length - 1) {
                      //       return;
                      //     }
                      //   }
                      // }
                      // }
                    }
                  },
                  child: Icon(
                    Icons.folder_open,
                    color: whiteColor,
                    size: stateFontSize.title.fontSize + 4,
                  ),
                ),
              ),
            )
          ],
        ),
      );

  _message(BuildContext context, String message, FontSizeResult stateFontSize) =>
      BlocBuilder<ErrorCheckBloc, ErrorCheckState>(
        builder: (_, state) => (state is ErrorCheckResult)
            ? RichText(
                text: TextSpan(
                  text: "Kolom tidak valid dengan format, silahkan edit :\n",
                  style: stateFontSize.body.copyWith(color: redColor),
                  children: [
                    ...List.generate(
                      state.data.length ?? 0,
                      (index) => TextSpan(
                        text: "Kolom ",
                        style: stateFontSize.body.copyWith(color: redColor),
                        children: [
                          TextSpan(
                            text: state.data[index].check,
                            style: stateFontSize.body.copyWith(color: primaryColor),
                          ),
                          TextSpan(
                            text: " dengan ",
                            style: stateFontSize.body.copyWith(color: redColor),
                          ),
                          TextSpan(
                            text: state.data[index].target + (index < state.data.length - 1 ? "\n" : ""),
                            style: stateFontSize.body.copyWith(color: primaryColor),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : (state is ErrorCheckSucessfulState)
                ? Text("Kolom dan Data Valid!", style: stateFontSize.body.copyWith(color: greenColor))
                : Container(),
      );

  _confirmToInput(BuildContext context, FontSizeResult stateFontSize) {
    return ElevatedButton(
      onPressed: () async {
        if (directory != "")
          showDialog(
              useRootNavigator: true,
              context: context,
              builder: (_) => AlertDialog(
                    title: Text("Apakah Anda yakin ?",
                        style: stateFontSize.title.copyWith(color: blackColor, fontWeight: FontWeight.w600)),
                    content: Text("Tindakan ini tidak dapat di undo", style: stateFontSize.body),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          NavigationHelper.back();
                          _inputDataToDatabase(context);
                        },
                        child: Text(
                          "Ya",
                          style: stateFontSize.body,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          NavigationHelper.back();
                        },
                        child: Text(
                          "Tidak",
                          style: stateFontSize.body,
                        ),
                      ),
                    ],
                  ));
        else
          showMySnackBar(context, text: "Silahkan Pilih File terlebih dahulu !!!");
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Proses", style: stateFontSize.body.copyWith(color: whiteColor)),
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
    );
  }

  _inputDataToDatabase(BuildContext context) async {
    var file = result.files.single.path;
    var bytes = File(file).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    int counter = 0;

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table].rows) {
        print("pdil Row : $row");
        Pdil pdilExcel;
        if (counter > 0 && counter < 2) {
          context.read<ImportBloc>().add(ImportConfirm(true, prefixIdPel: row[1].toString().substring(0, 5)));
        }
        if (counter > 0) {
          pdilExcel = Pdil(
            idPel: row[formatIndexs[0]].toString(),
            nama: row[formatIndexs[1]].toString(),
            alamat: row[formatIndexs[2]].toString(),
            tarip: row[formatIndexs[3]].toString(),
            daya: row[formatIndexs[4]].toString().split(".")[0],
            noHp: formatIndexs.length == 10 ? row[formatIndexs[5]] : null,
            nik: formatIndexs.length == 10 ? row[formatIndexs[6]] : null,
            npwp: formatIndexs.length == 10 ? row[formatIndexs[7]] : null,
            catatan: formatIndexs.length == 10 ? row[formatIndexs[8]] : null,
            tanggalBaca: formatIndexs.length == 10 ? row[formatIndexs[9]] : null,
            isKoreksi: false,
          );
          context.read<InputDataBloc>().add(
                InputDataAdd(pdilExcel, counter + 1, excel.tables[table].maxRows),
              );
        } else if (counter < 1) {
          for (int i = 0; i < row.length; i++) {
            formatChecksLoop:
            for (int j = 0; j < formatChecks.length; j++) {
              for (int k = 0; k < formatChecks[j].length; k++) {
                if (row[i] == formatChecks[j][k]) {
                  formatIndexs.add(i);
                  break formatChecksLoop;
                }
              }
            }
          }
        }
        counter++;
      }
    }
  }
}
