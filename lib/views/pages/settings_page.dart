part of 'pages.dart';

class SettingsPage extends StatefulWidget {
  final bool isImport;
  final Changing? data;
  SettingsPage({this.isImport = false, this.data});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _controllerExportData = TextEditingController();

  bool _isPasca = true;
  bool _isExportBoth = false;

  DbPasca _dbPasca = DbPasca();
  DbPra _dbPra = DbPra();

  Sheet? sheetPasca;
  Sheet? sheetPra;

  @override
  Widget build(BuildContext context) {
    return _secondVersion(context);

    // return BlocBuilder<FontSizeBloc, FontSizeState>(
    //   builder: (_, stateFontSize) => (stateFontSize is FontSizeResult)
    //       ? Scaffold(
    //           appBar: AppBar(
    //             title: Text("Pengaturan",
    //                 style: stateFontSize.title.copyWith(color: whiteColor, fontWeight: FontWeight.w600)),
    //           ),
    //           body: ListView(
    //             children: [
    //               ListTile(
    //                 leading: Stack(
    //                   children: [
    //                     ClipPath.shape(
    //                       shape: CircleBorder(),
    //                       child: Container(
    //                         width: 30,
    //                         height: 30,
    //                         color: greenColor,
    //                       ),
    //                     ),
    //                     SvgPicture.asset(
    //                       "assets/icons/TextAa.svg",
    //                       width: 18,
    //                       height: 18,
    //                     ),
    //                   ],
    //                 ),
    //                 title: Text("Ukuran Font", style: stateFontSize.subtitle.copyWith(fontWeight: FontWeight.w600)),
    //                 // subtitle: Text("atur ukuran font sesuai dengan keinginan", style: stateFontSize.body),
    //                 onTap: () async {
    //                   double value = await FontSizeServices.getFontSize() ?? 0;
    //                   if (value != 0) {
    //                     value = (value - 20) / 2;
    //                   }
    //                   NavigationHelper.to(MaterialPageRoute(builder: (_) => FontSizePage(sliderValue: value ?? 0)));
    //                 },
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.symmetric(horizontal: 25),
    //                 child: Divider(
    //                   thickness: 2,
    //                 ),
    //               ),
    //               if (!widget.isImport) ...[
    //                 ListTile(
    //                   leading: Stack(
    //                     children: [
    //                       Image.asset(
    //                         "assets/images/ExportExcel.png",
    //                         width: 30,
    //                         height: 30,
    //                       ),
    //                     ],
    //                   ),
    //                   title: Text("Simpan", style: stateFontSize.subtitle.copyWith(fontWeight: FontWeight.w600)),
    //                   onTap: () {
    //                     NavigationHelper.to(MaterialPageRoute(builder: (_) => ExportPage(true)));
    //                   },
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.symmetric(horizontal: 25),
    //                   child: Divider(
    //                     thickness: 2,
    //                   ),
    //                 ),
    //                 ListTile(
    //                   leading: Stack(
    //                     children: [
    //                       Image.asset(
    //                         "assets/images/ExportExcel.png",
    //                         width: 30,
    //                         height: 30,
    //                       ),
    //                     ],
    //                   ),
    //                   title: Text("Export Data Ke Excel",
    //                       style: stateFontSize.subtitle.copyWith(color: redColor, fontWeight: FontWeight.w600)),
    //                   onTap: () {
    //                     NavigationHelper.to(MaterialPageRoute(builder: (_) => ExportPage(false)));
    //                   },
    //                 ),
    //               ]
    //             ],
    //           ),
    //         )
    //       : Container(),
    // );
  }

  _secondVersion(BuildContext context) => BlocBuilder<FontSizeBloc, FontSizeState>(builder: (_, stateFontSize) {
        if (stateFontSize is FontSizeResult) {
          return BlocBuilder<ImportBloc, ImportState>(
            builder: (_, stateImport) {
              return CusScrollFold(
                isCustomerDataPage: false,
                title: 'Pengaturan',
                children: [
                  _listFontSize(context, stateFontSize),
                  _divider(context),
                  if (stateImport is! ImportBothImported) ...[
                    _listImport(context, stateFontSize),
                    _divider(context),
                  ],
                  _listExport(context, stateFontSize, isExport: false),
                  _divider(context),
                  _listExport(context, stateFontSize, isExport: true),
                ],
              );
            },
          );
        }
        return Container();
      });

  _divider(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Divider(
          thickness: 2,
        ),
      );

  _listFontSize(BuildContext context, FontSizeResult stateFontSize) => ListTile(
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
        title: Text("Ukuran Font", style: stateFontSize.subtitle!.copyWith(fontWeight: FontWeight.w600)),
        onTap: () async {
          double value = await FontSizeServices.getFontSize() ?? 0;
          if (value != 0) {
            value = (value - 24) / 2;
          }
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (_) => Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: MySlider(value: value),
            ),
          );
        },
      );

  _listImport(BuildContext context, FontSizeResult stateFontSize) => ListTile(
        leading: Stack(
          children: [
            Image.asset(
              "assets/images/ExportExcel.png",
              width: 30,
              height: 30,
            ),
          ],
        ),
        title: Text(
          'Import',
          style: stateFontSize.subtitle!.copyWith(fontWeight: FontWeight.w600),
        ),
        onTap: () {
          NavigationHelper.to(
            PageRouteBuilder(
              barrierColor: blackColor.withOpacity(0.5),
              barrierDismissible: false,
              opaque: false,
              pageBuilder: (_, __, ___) => ImportPage(),
            ),
          );
        },
      );

  _listExport(BuildContext context, FontSizeResult stateFontSize, {bool isExport = true}) => ListTile(
        leading: Stack(
          children: [
            Image.asset(
              "assets/images/ExportExcel.png",
              width: 30,
              height: 30,
            ),
          ],
        ),
        title: Text(
          isExport ? 'Export Data Ke Excel' : "Simpan",
          style: stateFontSize.subtitle!.copyWith(color: isExport ? redColor : blackColor, fontWeight: FontWeight.w600),
        ),
        onTap: () {
          _exportDialog(context, stateFontSize, isExport: isExport);
        },
      );

  _exportDialog(BuildContext context, FontSizeResult stateFontSize, {bool isExport = true}) => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => Container(
          padding: const EdgeInsets.fromLTRB(defaultPadding, 20, defaultPadding, 20),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isExport ? 'Export' : 'Simpan', style: stateFontSize.title),
              if (isExport) ...[
                CheckboxIsExportBoth(
                  isExportBoth: _isExportBoth,
                  onChanged: (newValue) {
                    _isExportBoth = newValue!;
                  },
                  stateFontSize: stateFontSize,
                ),
                MyToggleButton(
                  toggleButtonSlot: ToggleButtonSlot.export,
                  onTap: (isPasca) {
                    _isPasca = isPasca;
                  },
                ),
              ],
              SizedBox(height: 5),
              CurrentTextField(
                controller: _controllerExportData,
                label: 'Nama File',
                onCancelTap: () {
                  _controllerExportData.text = '';
                },
                onChanged: (value) {},
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CurrentTextButton(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    text: 'Batal',
                    textStyle: stateFontSize.subtitle!.copyWith(color: primaryColor),
                    decoration: cardDecoration.copyWith(
                      border: Border.all(color: primaryColor),
                    ),
                    onTap: () {
                      NavigationHelper.back();
                    },
                  ),
                  CurrentTextButton(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    text: isExport ? 'Export' : 'Simpan',
                    onTap: () {
                      if (_controllerExportData.text != '') if (!isExport) {
                        _exportData(context, stateFontSize, _controllerExportData.text, isExport);
                      } else
                        showDialog(
                            useRootNavigator: true,
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text("Apakah Anda yakin ?",
                                      style: stateFontSize.title!.copyWith(color: blackColor, fontWeight: FontWeight.w600)),
                                  content: Text("Tindakan ini tidak dapat di undo", style: stateFontSize.body1),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        NavigationHelper.back();
                                        _exportData(context, stateFontSize, _controllerExportData.text, isExport);
                                      },
                                      child: Text(
                                        "Ya",
                                        style: stateFontSize.body1,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        NavigationHelper.back();
                                      },
                                      child: Text(
                                        "Tidak",
                                        style: stateFontSize.body1,
                                      ),
                                    ),
                                  ],
                                ));
                      else
                        Fluttertoast.showToast(msg: 'Silahkan kasih nama file terlebih dahulu');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  _exportData(BuildContext context, FontSizeResult stateFontSize, String namaFile, bool isExport) async {
    try {
      var excel = Excel.createExcel();

      sheetPasca = null;
      sheetPra = null;

      List<Pdil> pdilPasca;
      List<Pdil> pdilPra;

      List<String> pascaRow = [
        'NOMOR',
        'IDPEL',
        'NAMA',
        'ALAMAT',
        'TARIF',
        'DAYA',
        'NOHP',
        'NIK',
        'NPWP',
        'EMAIL',
        'CATATAN',
        'TANGGALBACA',
      ];

      List<String> praRow = pascaRow..insert(2, 'NO METER');

      _loadingExport(context: context, stateFontSize: stateFontSize, isExport: isExport);

      if (_isExportBoth) {
        sheetPasca = excel['Pascabayar'];
        sheetPra = excel['Prabayar'];

        print('mengambil data...Both');
        pdilPasca = (await _dbPasca.getPdilList())!;
        pdilPra = (await _dbPra.getPdilList())!;

        print('mengeksport data...Both');
        _appendPasca(context, pdilPasca: pdilPasca, pascaRow: pascaRow);
        _appendPra(context, pdilPra: pdilPra, praRow: praRow);
      } else if (_isPasca) {
        sheetPasca = excel['Pascabayar'];
        print('mengambil data...Pascabayar');
        pdilPasca = (await _dbPasca.getPdilList())!;
        print('mengeksport data...Pascabayar');
        _appendPasca(context, pdilPasca: pdilPasca, pascaRow: pascaRow);
      } else if (!_isPasca) {
        sheetPra = excel['Prabayar'];
        print('mengambil data...prabayar');
        pdilPra = (await _dbPra.getPdilList())!;
        print('mengeksport data...prabayar');
        _appendPra(context, pdilPra: pdilPra, praRow: praRow);
      }

      List<Directory>? listDirectory = await getExternalStorageDirectories(type: StorageDirectory.downloads);

      // excel.encode().then((value) async {
      //   var file = File(listDirectory[0].path + '/$namaFile.xlsx');

      //   await file.create(recursive: true);

      //   file.writeAsBytesSync(value);
      // });

      var data = await excel.save();
    } catch (_) {} finally {}
  }

  _loadingExport({required BuildContext context, required FontSizeResult stateFontSize, required bool isExport}) => NavigationHelper.to(
        PageRouteBuilder(
          barrierColor: blackColor.withOpacity(0.5),
          barrierDismissible: false,
          opaque: false,
          pageBuilder: (_, __, ___) => AlertDialog(
            content: BlocBuilder<ExportDataBloc, ExportDataState>(
              builder: (_, exportDataState) {
                if (exportDataState is ExportDataProgress) {
                  int persentase = int.parse((exportDataState.progress * 100).toString().split('.')[0]);
                  if (persentase == 100) {
                    Future.delayed(const Duration(milliseconds: 500)).then((value) async {
                      NavigationHelper.back();
                      NavigationHelper.back();
                      if (!isExport) {
                        Fluttertoast.showToast(msg: 'Data telah di simpan');
                      } else {
                        context.read<ImportBloc>().add(ImportConfirm(await _getImportBloc(context)));
                      }
                    });
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 6,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              width: MediaQuery.of(context).size.width / 2 * exportDataState.progress,
                              height: 6,
                              color: exportDataState.progress < 0.5
                                  ? redColor
                                  : exportDataState.progress < 0.7
                                      ? yellowColor
                                      : greenColor,
                            ),
                          ),
                          SizedBox(width: 10),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(),
                              Text('${int.parse((exportDataState.progress * 100).toString().split(".")[0])}%', style: stateFontSize.body2),
                            ],
                          ),
                        ],
                      ),
                      Text(exportDataState.message, style: stateFontSize.body2),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      );

  Future<Import> _getImportBloc(BuildContext context) async {
    Import currentImport = await ImportServices.getCurrentImport();
    switch (currentImport) {
      case Import.bothImported:
        if (_isExportBoth) {
          return Import.bothNotImported;
        } else if (_isPasca) {
          return Import.prabayarImported;
        } else if (!_isPasca) {
          return Import.pascabayarImported;
        }
        break;
      case Import.bothNotImported:
        return Import.bothNotImported;
      case Import.pascabayarImported:
        if (_isPasca) {
          return Import.bothNotImported;
        }
        break;
      case Import.prabayarImported:
        if (!_isPasca) {
          return Import.bothNotImported;
        }
        break;
    }
    return Import.bothNotImported;
  }

  _appendPasca(BuildContext context, {required List<Pdil> pdilPasca, required List<String> pascaRow}) {
    int counterPasca = 0;
    pdilPasca.forEach((row) {
      if (counterPasca < 1) {
        sheetPasca!.appendRow(pascaRow);
      }
      counterPasca++;
      context.read<ExportDataBloc>().add(ExportDataExport(row: counterPasca, maxRow: pdilPasca.length, message: 'Mengeksport Pascabayar'));

      sheetPasca!.appendRow(
        row.toList(isPasca: true),
      );
    });
  }

  _appendPra(BuildContext context, {required List<Pdil> pdilPra, required List<String> praRow}) {
    int counterPra = 0;
    pdilPra.forEach((row) {
      if (counterPra < 1) {
        sheetPra!.appendRow(praRow);
      }
      counterPra++;
      context.read<ExportDataBloc>().add(ExportDataExport(row: counterPra, maxRow: pdilPra.length, message: 'Mengeksport Prabayar'));

      sheetPra!.appendRow(
        row.toList(isPasca: false),
      );
    });
  }
}

class MySlider extends StatefulWidget {
  double? value;

  MySlider({
    this.value,
  });

  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  double defaultValue = 24;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform(
          transform: Matrix4.translationValues(0.0, 25.0, 0.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('A', style: body2),
                Text('A', style: title.copyWith(fontSize: title.fontSize! + 10)),
              ],
            ),
          ),
        ),
        Slider(
          value: widget.value!,
          min: 0,
          max: 4,
          divisions: 4,
          label: '${(defaultValue + widget.value! * 2).toString().split(".")[0]}',
          onChanged: (_value) {
            setState(() {
              widget.value = _value;

              context.read<FontSizeBloc>().add(SaveFontSize(defaultValue + _value * 2));
            });
          },
        ),
      ],
    );
  }
}

class CheckboxIsExportBoth extends StatefulWidget {
  bool? isExportBoth;
  Function(bool? newValue) onChanged;
  FontSizeResult? stateFontSize;

  CheckboxIsExportBoth({required this.isExportBoth, required this.onChanged, this.stateFontSize});

  @override
  _CheckboxIsExportBothState createState() => _CheckboxIsExportBothState();
}

class _CheckboxIsExportBothState extends State<CheckboxIsExportBoth> {
  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(-12.0, 0.0, 0.0),
      child: Row(
        children: [
          Checkbox(
            value: widget.isExportBoth,
            onChanged: (newValue) {
              setState(() {
                widget.isExportBoth = newValue;
                widget.onChanged(newValue);
              });
            },
          ),
          Text('Export keduanya', style: widget.stateFontSize!.body1),
        ],
      ),
    );
  }
}
