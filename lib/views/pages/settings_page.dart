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
  TextEditingController _controllerDateExport = TextEditingController();

  bool _isPasca = true;
  bool _isExportBoth = false;

  DbPasca _dbPasca = DbPasca();
  DbPra _dbPra = DbPra();

  Sheet? sheetPasca;
  Sheet? sheetPra;

  DateTimeRange? dateRangeResult;

  @override
  Widget build(BuildContext context) {
    return _secondVersion(context);
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
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (_) {
              return ImportPage.design();
            },
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

  _exportDialog(BuildContext context, FontSizeResult stateFontSize, {bool isExport = true}) async => showModalBottomSheet(
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
                  isPasca: _isPasca,
                  onCheckBoxTap: (newValue) {
                    _isExportBoth = newValue!;
                  },
                  onToggleButtonTap: (isPasca) {
                    _isPasca = isPasca!;
                  },
                  stateFontSize: stateFontSize,
                ),
              ],
              if (!isExport)
                FutureBuilder<String?>(
                  future: DatePickerService.getStartDate(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Column(
                        children: [
                          SizedBox(height: 5),
                          Row(
                            children: [
                              CurrentTextField(
                                controller: _controllerDateExport,
                                width: MediaQuery.of(context).size.width - 115,
                                borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
                                readOnly: true,
                                onCancelTap: () {
                                  _controllerDateExport.text = '';
                                },
                                onChanged: (value) {},
                              ),
                              // Button For show Date
                              Container(
                                width: 65,
                                height: 40 + stateFontSize.width,
                                decoration: cardDecoration.copyWith(
                                  borderRadius: BorderRadius.horizontal(right: Radius.circular(5)),
                                  color: primaryColor,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.horizontal(right: Radius.circular(5)),
                                  child: InkWell(
                                    borderRadius: BorderRadius.horizontal(right: Radius.circular(5)),
                                    splashColor: inkWellSplashColor,
                                    onTap: () async {
                                      dateRangeResult = await showDateRangePicker(
                                        context: context,
                                        firstDate: DateTime.parse(await DatePickerService.getStartDate() ?? currentTime()),
                                        lastDate: DateTime.parse(await DatePickerService.getEndDate() ?? currentTime()),
                                      );
                                      if (dateRangeResult != null) {
                                        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                                          _controllerDateExport.text = '${currentTimeIndonesia(currentTime: dateRangeResult?.start, ignoreTime: true)} - ${currentTimeIndonesia(currentTime: dateRangeResult?.end, ignoreTime: true)}';
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.date_range_rounded,
                                      color: whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
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
                                  title: Text("Apakah Anda yakin ?", style: stateFontSize.title!.copyWith(color: blackColor, fontWeight: FontWeight.w600)),
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

      List<String> praRow = [
        'NOMOR',
        'IDPEL',
        'NO METER',
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

      _loadingExport(context: context, stateFontSize: stateFontSize, isExport: isExport);

      if (!isExport) {
        pdilPasca = (await _dbPasca.getPdilList())!;
        if (dateRangeResult != null && _controllerDateExport.text != '') {
          pdilPasca = pdilPasca.where((pdil) {
            if (pdil.tanggalBaca == null) {
              return false;
            }
            DateTime? timeTanggalBaca = DateTime.parse(pdil.tanggalBaca!.substring(0, 10));
            return (timeTanggalBaca.isAfter(dateRangeResult?.start as DateTime) || timeTanggalBaca.isAtSameMomentAs(dateRangeResult?.start as DateTime)) && (timeTanggalBaca.isBefore(dateRangeResult?.end as DateTime) || timeTanggalBaca.isAtSameMomentAs(dateRangeResult?.end as DateTime));
          }).toList();
        }
        if (pdilPasca.length != 0) {
          sheetPasca = excel['Pascabayar'];
        }

        pdilPra = (await _dbPra.getPdilList())!;
        if (dateRangeResult != null && _controllerDateExport.text != '') {
          pdilPra = pdilPra.where((pdil) {
            if (pdil.tanggalBaca == null) {
              return false;
            }
            DateTime? timeTanggalBaca = DateTime.parse(pdil.tanggalBaca!.substring(0, 10));
            return (timeTanggalBaca.isAfter(dateRangeResult?.start as DateTime) || timeTanggalBaca.isAtSameMomentAs(dateRangeResult?.start as DateTime)) && (timeTanggalBaca.isBefore(dateRangeResult?.end as DateTime) || timeTanggalBaca.isAtSameMomentAs(dateRangeResult?.end as DateTime));
          }).toList();
        }
        if (pdilPra.length != 0) {
          sheetPra = excel['Prabayar'];
        }

        await _appendPasca(context, pdilPasca: pdilPasca, pascaRow: pascaRow, isExport: isExport);
        await _appendPra(context, pdilPra: pdilPra, praRow: praRow, isExport: isExport);
      } else if (_isExportBoth) {
        sheetPasca = excel['Pascabayar'];
        sheetPra = excel['Prabayar'];

        pdilPasca = (await _dbPasca.getPdilList())!;
        pdilPra = (await _dbPra.getPdilList())!;

        await _appendPasca(context, pdilPasca: pdilPasca, pascaRow: pascaRow, isExport: isExport);
        await _appendPra(context, pdilPra: pdilPra, praRow: praRow, isExport: isExport);
      } else if (_isPasca) {
        sheetPasca = excel['Pascabayar'];
        pdilPasca = (await _dbPasca.getPdilList())!;
        await _appendPasca(context, pdilPasca: pdilPasca, pascaRow: pascaRow, isExport: isExport);
      } else if (!_isPasca) {
        sheetPra = excel['Prabayar'];
        pdilPra = (await _dbPra.getPdilList())!;
        await _appendPra(context, pdilPra: pdilPra, praRow: praRow, isExport: isExport);
      }

      List<Directory>? listDirectory = await getExternalStorageDirectories(type: StorageDirectory.downloads);
      var data = excel.save();
      File(join(listDirectory![0].path + '/$namaFile.xlsx'))
        ..createSync(recursive: true)
        ..writeAsBytesSync(data!);
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
                    Future.delayed(const Duration(milliseconds: 500)).then((value) {
                      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
                        if (!isExport) {
                          Fluttertoast.showToast(msg: 'Data telah di simpan');
                        } else {
                          if (_isExportBoth) {
                            int pascaCount = await _dbPasca.deleteAll();
                            int praCount = await _dbPra.deleteAll();
                            if (pascaCount > 0 && praCount > 0) {
                              Fluttertoast.showToast(msg: 'Data Telah Di Export');
                            }
                          } else if (_isPasca) {
                            int pascaCount = await _dbPasca.deleteAll();
                            if (pascaCount > 0) {
                              Fluttertoast.showToast(msg: 'Data Telah Di Export');
                            }
                          } else if (!_isPasca) {
                            int praCount = await _dbPra.deleteAll();
                            if (praCount > 0) {
                              Fluttertoast.showToast(msg: 'Data Telah Di Export');
                            }
                          }
                        }
                        Future.delayed(const Duration(milliseconds: 200)).then((value) {
                          context.read<ExportDataBloc>().add(ExportDataInit());
                        });
                      });
                    });
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 6,
                                decoration: BoxDecoration(color: greyColor, borderRadius: BorderRadius.circular(3)),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                width: MediaQuery.of(context).size.width / 2 * exportDataState.progress,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: exportDataState.progress < 0.5
                                      ? redColor
                                      : exportDataState.progress < 0.7
                                          ? yellowColor
                                          : greenColor,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
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

  _appendPasca(BuildContext context, {required List<Pdil> pdilPasca, required List<String> pascaRow, required bool isExport}) {
    int counterPasca = 0;
    pdilPasca.forEach((row) {
      if (counterPasca < 1) {
        sheetPasca?.appendRow(pascaRow);
      }
      counterPasca++;
      context.read<ExportDataBloc>().add(ExportDataExport(
            row: counterPasca,
            maxRow: pdilPasca.length,
            message: 'Mengeksport Pascabayar',
            context: context,
            isExport: isExport,
            isExportBoth: _isExportBoth,
            isPasca: _isPasca,
          ));

      sheetPasca?.appendRow(
        row.toList(isPasca: true)..insert(0, counterPasca.toString()),
      );
    });
  }

  _appendPra(BuildContext context, {required List<Pdil> pdilPra, required List<String> praRow, required bool isExport}) {
    int counterPra = 0;
    pdilPra.forEach((row) {
      if (counterPra < 1) {
        sheetPra?.appendRow(praRow);
      }
      counterPra++;
      context.read<ExportDataBloc>().add(ExportDataExport(
            row: counterPra,
            maxRow: pdilPra.length,
            message: 'Mengeksport Prabayar',
            context: context,
            isExport: isExport,
            isExportBoth: _isExportBoth,
            isPasca: _isPasca,
          ));

      sheetPra?.appendRow(
        row.toList(isPasca: false)..insert(0, counterPra.toString()),
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
  bool? isPasca;
  Function(bool? newValue) onCheckBoxTap;
  Function(bool? newValue) onToggleButtonTap;
  FontSizeResult? stateFontSize;

  CheckboxIsExportBoth({required this.isExportBoth, required this.isPasca, required this.onCheckBoxTap, required this.onToggleButtonTap, required this.stateFontSize});

  @override
  _CheckboxIsExportBothState createState() => _CheckboxIsExportBothState();
}

class _CheckboxIsExportBothState extends State<CheckboxIsExportBoth> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImportBloc, ImportState>(builder: (_, stateImport) {
      return Column(
        crossAxisAlignment: stateImport is ImportPascabayarImported || stateImport is ImportPrabayarImported ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (stateImport is ImportBothImported)
            Transform(
              transform: Matrix4.translationValues(-12.0, 0.0, 0.0),
              child: Row(
                children: [
                  Checkbox(
                    value: widget.isExportBoth,
                    onChanged: (newValue) {
                      setState(() {
                        widget.isExportBoth = newValue;
                        widget.onCheckBoxTap(newValue);
                      });
                    },
                  ),
                  Text('Export keduanya', style: widget.stateFontSize!.body1),
                ],
              ),
            ),
          if (!widget.isExportBoth! && stateImport is ImportBothImported)
            MyToggleButton(
              toggleButtonSlot: ToggleButtonSlot.export,
              onTap: (isPasca) {
                widget.isPasca = isPasca;
                widget.onToggleButtonTap(isPasca);
              },
            ),
        ],
      );
    });
  }
}
