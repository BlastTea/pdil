part of 'pages.dart';

class ExportPage extends StatelessWidget {
  final TextEditingController namaFileController = TextEditingController();

  final DbHelper dbHelper = DbHelper();

  Stopwatch stopwatchProgress = Stopwatch();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) => (stateFontSize is FontSizeResult)
          ? Scaffold(
              appBar: AppBar(
                title:
                    Text("Export", style: stateFontSize.title.copyWith(fontWeight: FontWeight.w600, color: whiteColor)),
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
                              if (namaFileController.text != "" && namaFileController.text != null)
                                showDialog(
                                    useRootNavigator: true,
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text("Apakah Anda yakin ?",
                                              style: stateFontSize.title
                                                  .copyWith(color: blackColor, fontWeight: FontWeight.w600)),
                                          content: Text("Tindakan ini tidak dapat di undo", style: stateFontSize.body),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                NavigationHelper.back();
                                                _exportData(context, namaFileController.text);
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
                        if (!stopwatchProgress.isRunning) stopwatchProgress.start();
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
                      } else if (state.progress == 100) {
                        stopwatchProgress.stop();
                        print("export time : ${stopwatchProgress.elapsedMilliseconds} ms");
                        return Container();
                      }
                    }
                    return Container();
                  }),
                ],
              ),
            )
          : Container(),
    );
  }

  _exportData(BuildContext context, String namaFile) async {
    try {
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
        context.read<ExportDataBloc>().add(ExportDataExport(counter, pdils.length));
        var rows = [
          counter.toString(),
          ...row.toList(),
        ];
        sheet.appendRow(rows);
      });

      List<Directory> listDirectory = await getExternalStorageDirectories(type: StorageDirectory.downloads);

      excel.encode().then((value) async {
        var file = File(listDirectory[0].path + '/$namaFile.xlsx');

        await file.create(recursive: true);

        file.writeAsBytesSync(value);
      });
    } catch (_) {} finally {
      context.read<ImportBloc>().add(ImportConfirm(false));
    }
  }
}
