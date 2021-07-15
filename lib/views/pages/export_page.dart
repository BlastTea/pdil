part of 'pages.dart';

class ExportPage extends StatefulWidget {
  ExportPage({Key? key, required this.isExport}) : super(key: key);

  final bool isExport;

  @override
  _ExportPageState createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  final List<String> pascaRow = [
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

  final List<String> praRow = [
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

  TextEditingController _controllerExportData = TextEditingController();
  TextEditingController _controllerDateExport = TextEditingController();

  Sheet? sheetPasca;
  Sheet? sheetPra;

  DateTimeRange? dateRangeResult;

  bool _isExportBoth = false;
  bool _isPasca = true;

  DbPasca _dbPasca = DbPasca();
  DbPra _dbPra = DbPra();

  CustomerDataBloc? _customerDataBloc;

  @override
  void dispose() { 
    _customerDataBloc?.add(FetchCustomerData(isSetIsExpandNull: true));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _customerDataBloc = context.read<CustomerDataBloc>();
    return _design(context);
  }

  Widget _design(BuildContext context) => BlocBuilder<FontSizeBloc, FontSizeState>(
        builder: (_, stateFontSize) {
          if (stateFontSize is FontSizeResult) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 100),
              padding: MediaQuery.of(_).viewInsets,
              curve: Curves.decelerate,
              child: Container(
                padding: const EdgeInsets.fromLTRB(defaultPadding, 20, defaultPadding, 20),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.isExport ? 'Export' : 'Simpan', style: stateFontSize.title),
                    if (widget.isExport) ...[
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
                    if (!widget.isExport)
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
                                      width: MediaQuery.of(_).size.width - 115,
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
                                              context: _,
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
                      onTap: () {},
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CurrentTextButton(
                          width: MediaQuery.of(_).size.width / 2 - 30,
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
                          width: MediaQuery.of(_).size.width / 2 - 30,
                          text: widget.isExport ? 'Export' : 'Simpan',
                          onTap: () async {
                            if (_controllerExportData.text != '') if (!widget.isExport) {
                              _exportData(context: context, stateFontSize: stateFontSize, namaFile: _controllerExportData.text, isExport: widget.isExport);
                            } else
                              showDialog(
                                  useRootNavigator: true,
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: Text("Apakah Anda yakin ?", style: stateFontSize.title!.copyWith(color: blackColor, fontWeight: FontWeight.w600)),
                                        content: Text("Tindakan ini tidak dapat di undo", style: stateFontSize.body1),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              NavigationHelper.back();
                                              _exportData(context: context, stateFontSize: stateFontSize, namaFile: _controllerExportData.text, isExport: widget.isExport);
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
          }
          return Container();
        },
      );

  _exportData({required BuildContext context, required FontSizeResult stateFontSize, required String namaFile, required bool isExport}) async {
    try {
      var excel = Excel.createExcel();

      List<Pdil> pdilPasca;
      List<Pdil> pdilPra;

      _loadingExport(context: context, stateFontSize: stateFontSize, isExport: widget.isExport);

      if (!widget.isExport) {
        pdilPasca = (await _dbPasca.getPdilList())!;
        if (dateRangeResult != null && _controllerDateExport.text != '') {
          pdilPasca = pdilPasca.where((pdil) {
            if (pdil.tanggalBaca == null) {
              return false;
            }
            DateTime? timeTanggalBaca;
            try {
              timeTanggalBaca = DateTime.parse(pdil.tanggalBaca!.substring(0, 10));
            } catch (exception) {
              return false;
            }
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
            DateTime? timeTanggalBaca;
            try {
              timeTanggalBaca = DateTime.parse(pdil.tanggalBaca!.substring(0, 10));
            } catch (exception) {
              return false;
            }
            return (timeTanggalBaca.isAfter(dateRangeResult?.start as DateTime) || timeTanggalBaca.isAtSameMomentAs(dateRangeResult?.start as DateTime)) && (timeTanggalBaca.isBefore(dateRangeResult?.end as DateTime) || timeTanggalBaca.isAtSameMomentAs(dateRangeResult?.end as DateTime));
          }).toList();
        }
        if (pdilPra.length != 0) {
          sheetPra = excel['Prabayar'];
        }

        int counter = 0;

        counter = _appendRow(context: context, pdil: pdilPasca, isPasca: true, counter: counter, maxCounter: pdilPasca.length + pdilPra.length, isExport: widget.isExport, excel: excel, namaFile: namaFile);
        _appendRow(context: context, pdil: pdilPra, isPasca: false, counter: counter, maxCounter: pdilPasca.length + pdilPra.length, isExport: widget.isExport, excel: excel, namaFile: namaFile);
      } else if (_isExportBoth) {
        sheetPasca = excel['Pascabayar'];
        sheetPra = excel['Prabayar'];

        pdilPasca = (await _dbPasca.getPdilList())!;
        pdilPra = (await _dbPra.getPdilList())!;

        int counter = 0;

        counter = _appendRow(context: context, pdil: pdilPasca, isPasca: true, counter: counter, maxCounter: pdilPasca.length + pdilPra.length, isExport: widget.isExport, excel: excel, namaFile: namaFile);
        _appendRow(context: context, pdil: pdilPra, isPasca: false, counter: counter, maxCounter: pdilPasca.length + pdilPra.length, isExport: widget.isExport, excel: excel, namaFile: namaFile);
      } else if (_isPasca) {
        sheetPasca = excel['Pascabayar'];
        pdilPasca = (await _dbPasca.getPdilList())!;

        int counter = 0;
        _appendRow(context: context, pdil: pdilPasca, isPasca: true, counter: counter, maxCounter: pdilPasca.length, isExport: widget.isExport, excel: excel, namaFile: namaFile);
      } else if (!_isPasca) {
        sheetPra = excel['Prabayar'];
        pdilPra = (await _dbPra.getPdilList())!;
        int counter = 0;
        _appendRow(context: context, pdil: pdilPra, isPasca: false, counter: counter, maxCounter: pdilPra.length, isExport: widget.isExport, excel: excel, namaFile: namaFile);
      }
    } catch (_) {}
  }

  int _appendRow({
    required BuildContext context,
    required List<Pdil> pdil,
    required bool isPasca,
    required int counter,
    required int maxCounter,
    required bool isExport,
    required Excel excel,
    required String namaFile,
  }) {
    int appendCounter = 0;
    pdil.forEach((row) async {
      if (appendCounter < 1) {
        isPasca ? sheetPasca?.appendRow(pascaRow) : sheetPra?.appendRow(praRow);
      }
      appendCounter++;
      counter++;
      double persentase = counter / maxCounter;
      context.read<ExportDataBloc>().add(
            ExportDataExport(
              persentase: persentase,
              message: isPasca ? 'Mengeksport Pascabayar' : 'Mengeksport Prabayar',
              context: context,
              isExport: widget.isExport,
              isExportBoth: _isExportBoth,
              isPasca: _isPasca,
              excel: excel,
              namaFile: namaFile,
            ),
          );
      isPasca
          ? sheetPasca?.appendRow(
              row.toList(isPasca: isPasca)..insert(0, appendCounter.toString()),
            )
          : sheetPra?.appendRow(
              row.toList(isPasca: isPasca)..insert(0, appendCounter.toString()),
            );
    });
    return counter;
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
                        if (!exportDataState.isExport) {
                          Fluttertoast.showToast(msg: 'Data telah di simpan');
                        } else {
                          if (exportDataState.isExportBoth) {
                            int pascaCount = await _dbPasca.deleteAll();
                            int praCount = await _dbPra.deleteAll();
                            if (pascaCount > 0 && praCount > 0) {
                              Fluttertoast.showToast(msg: 'Data Telah Di Export');
                            }
                          } else if (exportDataState.isPasca) {
                            int pascaCount = await _dbPasca.deleteAll();
                            if (pascaCount > 0) {
                              Fluttertoast.showToast(msg: 'Data Telah Di Export');
                            }
                          } else if (!exportDataState.isPasca) {
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
}
