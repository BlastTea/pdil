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
            _message(context, message),
            _confirmToInput(context),
          ],
        ),
      ),
    );
  }

  _importContainer(BuildContext context) => Padding(
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
              height: 45,
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
                  ),
                ),
              ),
            )
          ],
        ),
      );

  _message(BuildContext context, String message) => BlocBuilder<ErrorCheckBloc, ErrorCheckState>(
        builder: (_, state) => (state is ErrorCheckResult)
            ? RichText(
                text: TextSpan(
                  text: "Kolom tidak valid dengan format, silahkan edit :\n",
                  style: title12.copyWith(color: redColor),
                  children: [
                    ...List.generate(
                      state.data.length ?? 0,
                      (index) => TextSpan(
                        text: "Kolom ",
                        style: title12.copyWith(color: redColor),
                        children: [
                          TextSpan(
                            text: state.data[index].check,
                            style: title12.copyWith(color: primaryColor),
                          ),
                          TextSpan(
                            text: " dengan ",
                            style: title12.copyWith(color: redColor),
                          ),
                          TextSpan(
                            text: state.data[index].target + (index < state.data.length - 1 ? "\n" : ""),
                            style: title12.copyWith(color: primaryColor),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : (state is ErrorCheckSucessfulState)
                ? Text("Kolom dan Data Valid!", style: title12.copyWith(color: greenColor))
                : Container(),
      );

  _confirmToInput(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (directory != "")
          showDialog(
              useRootNavigator: true,
              context: context,
              builder: (_) => AlertDialog(
                    title: Text("Apakah Anda yakin ?", style: title24.copyWith(color: blackColor)),
                    content: Text("Tindakan ini tidak dapat di undo", style: title12),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          NavigationHelper.back();
                          _inputDataToDatabase(context);
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
          showMySnackBar(context, text: "Silahkan Pilih File terlebih dahulu !!!");
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Selanjutnya"),
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
        Pdil pdilExcel;
        if (counter > 0 && counter < 2) {
          context.read<ImportBloc>().add(ImportConfirm(true, prefixIdPel: row[1].toString().substring(0, 5)));
        }
        if (counter > 0) {
          pdilExcel = Pdil(
            idPel: row[1].toString(),
            nama: row[3].toString(),
            alamat: row[4].toString(),
            tarip: row[5].toString(),
            daya: row[6].toString().split(".")[0],
            isKoreksi: false,
          );
          context.read<InputDataBloc>().add(
                InputDataAdd(pdilExcel, counter + 1, excel.tables[table].maxRows),
              );
        }
        counter++;
      }
    }
  }
}
