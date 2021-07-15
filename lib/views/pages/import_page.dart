part of 'pages.dart';

class ImportPage extends StatefulWidget {
  factory ImportPage.design() = _ImportPageDesign;

  ImportPage({Key? key}) : super(key: key);

  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<Offset> _animation;

  bool _isPasca = true;
  bool isImportBoth = false;

  DateTime? _currentBackPressTime;

  FilePickerResult? result;

  String directory = "";

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
    ['TANGGALBACA', 'TANGGAL BACA']
  ];
  List<String> formatRows = [];
  List<int> formatIndexs = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)).animate(_animationController);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Import currentImport = await ImportServices.getCurrentImport();
        DateTime now = DateTime.now();
        if (currentImport == Import.bothNotImported) {
          if (_currentBackPressTime == null || now.difference(_currentBackPressTime!) > Duration(seconds: 2)) {
            _currentBackPressTime = now;
            Fluttertoast.showToast(
              msg: 'Tekan sekali lagi untuk keluar',
            );
            return Future.value(false);
          } else if (_currentBackPressTime == null || now.difference(_currentBackPressTime!) < Duration(seconds: 2)) {
            _animationController.reverse();
            SystemNavigator.pop();
            return Future.value(true);
          }
          return Future.value(false);
        }
        _animationController.reverse();
        return Future.value(true);
      },
      child: BlocBuilder<FontSizeBloc, FontSizeState>(
        builder: (_, stateFontSize) {
          if (stateFontSize is FontSizeResult) {
            return AnimatedBuilder(
              animation: _animationController,
              builder: (_, child) {
                return SlideTransition(
                  position: _animation,
                  child: child,
                );
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: design(context, stateFontSize),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  design(BuildContext context, FontSizeResult stateFontSize) => ClipPath(
        clipper: ImportClipper(),
        child: Container(
          width: double.infinity,
          color: whiteColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _circleOpenFolder(context),
                SizedBox(height: 5),
                CheckBoxImportBoth(
                  isImportBoth: isImportBoth,
                  isPasca: _isPasca,
                  onCheckBoxTap: (isImportBoth) {
                    this.isImportBoth = isImportBoth;
                  },
                  onToggleButtonTap: (isPasca) {
                    _isPasca = isPasca;
                  },
                  formatChecks: formatChecks,
                  stateFontSize: stateFontSize,
                ),
                SizedBox(height: 8),
                Material(
                  color: Colors.transparent,
                  child: CurrentTextField(
                    controller: TextEditingController(text: directory),
                    label: 'Nama File',
                    readOnly: true,
                  ),
                ),
                SizedBox(height: 8),
                _prosesButton(context, stateFontSize),
                SizedBox(height: 17),
              ],
            ),
          ),
        ),
      );

  _circleOpenFolder(BuildContext context) => Container(
        width: 74,
        height: 74,
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: blackColor.withOpacity(0.25),
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(74 / 2),
          child: InkWell(
            borderRadius: BorderRadius.circular(74 / 2),
            hoverColor: inkWellSplashColor.withOpacity(0.5),
            splashColor: inkWellSplashColor,
            onTap: () {
              _pickFile(context);
            },
            child: Icon(
              Icons.folder_open,
              color: whiteColor,
              size: 30,
            ),
          ),
        ),
      );

  _prosesButton(BuildContext context, FontSizeResult stateFontSize) => CurrentTextButton(
        text: 'Proses',
        onTap: () {
          if (directory != "")
            showDialog(
                barrierDismissible: false,
                useRootNavigator: true,
                context: context,
                builder: (_) => AlertDialog(
                      title: Text("Apakah Anda yakin ?", style: stateFontSize.title!.copyWith(color: blackColor, fontWeight: FontWeight.w600)),
                      content: Text("Tindakan ini tidak dapat di undo", style: stateFontSize.body1),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            NavigationHelper.back();
                            _loadingScreen(context, stateFontSize);
                            _inputDataToDatabase(context);
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
            Fluttertoast.showToast(msg: 'Silahkan pilih file terlebih dahulu');
        },
      );

  _loadingScreen(BuildContext context, FontSizeResult stateFontSize) => NavigationHelper.to(
        PageRouteBuilder(
          barrierColor: blackColor.withOpacity(0.5),
          barrierDismissible: false,
          opaque: false,
          pageBuilder: (_, __, ___) => AlertDialog(
            content: BlocBuilder<InputDataBloc, InputDataState>(
              builder: (_, inputDataState) {
                if (inputDataState is InputDataProgress) {
                  int persentase = int.parse((inputDataState.progress * 100).toString().split(".")[0]);
                  if (persentase == 100) {
                    Future.delayed(Duration(milliseconds: 500)).then((value) {
                      NavigationHelper.back();
                      NavigationHelper.back();

                      Future.delayed(const Duration(milliseconds: 200)).then((value) {
                        context.read<InputDataBloc>().add(InputDataInit());
                      });
                    });
                  }
                  return Row(
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
                            width: MediaQuery.of(context).size.width / 2 * inputDataState.progress,
                            height: 6,
                            decoration: BoxDecoration(
                              color: inputDataState.progress < 0.5
                                  ? redColor
                                  : inputDataState.progress < 0.7
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
                          Text('${int.parse((inputDataState.progress * 100).toString().split(".")[0])}%', style: stateFontSize.body2),
                        ],
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      );

  _pickFile(BuildContext context) async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xltx', 'xls'],
      allowMultiple: false,
    );

    context.read<ErrorCheckBloc>().add(ErrorCheckClear());
    setState(() {
      directory = "";
    });

    if (result != null) {
      List files = result!.files.single.path!.split("/");
      setState(() {
        directory = files[files.length - 1];
      });
    }
  }

  _inputDataToDatabase(BuildContext context) async {
    var file = result!.files.single.path!;
    var bytes = File(file).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    int counter = 0;

    for (var table in excel.tables.keys) {
      if (isImportBoth && (table.toLowerCase() == tablePascabayar.toLowerCase() || table.toLowerCase() == tablePrabayar.toLowerCase())) {
        int maxPasca = 0;
        int maxPra = 0;
        excel.tables.forEach((key, value) {
          if (key.toLowerCase() == tablePascabayar.toLowerCase()) {
            maxPasca = value.maxRows;
          } else if (key.toLowerCase() == tablePrabayar.toLowerCase()) {
            maxPra = value.maxRows;
          }
        });
        counter = await _saveRowToDatabase(context, excel, table, counter, maxPasca: maxPasca, maxPra: maxPra);
      } else if (_isPasca && table.toLowerCase() == tablePascabayar.toLowerCase() || _isPasca) {
        counter = 0;
        await _saveRowToDatabase(context, excel, table, counter);
      } else if (!_isPasca && table.toLowerCase() == tablePrabayar.toLowerCase() || !_isPasca) {
        counter = 0;
        await _saveRowToDatabase(context, excel, table, counter);
      }
    }
  }

  Future<int> _saveRowToDatabase(BuildContext context, Excel excel, String table, int counter, {int? maxPasca, int? maxPra}) {
    for (var row in excel.tables[table]!.rows) {
      Pdil pdilExcel;
      if (row[0]!.rowIndex == 1) {
        context.read<ImportBloc>().add(
              ImportConfirm(
                isImportBoth
                    ? Import.bothImported
                    : _isPasca
                        ? Import.pascabayarImported
                        : Import.prabayarImported,
                prefixIdPelPasca: table.toLowerCase() == tablePascabayar.toLowerCase() || (isImportBoth ? false : _isPasca) ? row[formatIndexs[0]]?.value.toString().substring(0, 5) : null,
                prefixIdpelPra: table.toLowerCase() == tablePrabayar.toLowerCase() || !_isPasca ? row[formatIndexs[0]]?.value.toString().substring(0, 5) : null,
              ),
            );
      }
      if (row[0]!.rowIndex > 0) {
        pdilExcel = Pdil(
          idPel: row[formatIndexs[0]]?.value.toString(),
          noMeter: table.toLowerCase() == tablePrabayar.toLowerCase() || !_isPasca ? row[formatIndexs[1]]?.value.toString() : null,
          nama: row[formatIndexs[table.toLowerCase() == tablePascabayar.toLowerCase() || (isImportBoth ? false : _isPasca) ? 1 : 2]]?.value.toString(),
          alamat: row[formatIndexs[table.toLowerCase() == tablePascabayar.toLowerCase() || (isImportBoth ? false : _isPasca) ? 2 : 3]]?.value.toString(),
          tarip: row[formatIndexs[table.toLowerCase() == tablePascabayar.toLowerCase() || (isImportBoth ? false : _isPasca) ? 3 : 4]]?.value.toString(),
          daya: row[formatIndexs[table.toLowerCase() == tablePascabayar.toLowerCase() || (isImportBoth ? false : _isPasca) ? 4 : 5]]?.value.toString().split(".")[0],
          noHp: _getValueFromRow(context: context, column: formatChecks[table.toLowerCase() == tablePascabayar.toLowerCase() || (isImportBoth ? false : _isPasca) ? 5 : 6][0], row: row),
          nik: _getValueFromRow(context: context, column: formatChecks[table.toLowerCase() == tablePascabayar.toLowerCase() || (isImportBoth ? false : _isPasca) ? 6 : 7][0], row: row),
          npwp: _getValueFromRow(context: context, column: formatChecks[table.toLowerCase() == tablePascabayar.toLowerCase() || (isImportBoth ? false : _isPasca) ? 7 : 8][0], row: row),
          catatan: _getValueFromRow(context: context, column: formatChecks[table.toLowerCase() == tablePascabayar.toLowerCase() || (isImportBoth ? false : _isPasca) ? 8 : 9][0], row: row),
          tanggalBaca: _getValueFromRow(context: context, column: formatChecks[table.toLowerCase() == tablePascabayar.toLowerCase() || (isImportBoth ? false : _isPasca) ? 9 : 10][0], row: row),
          isKoreksi: false,
        );
        context.read<InputDataBloc>().add(InputDataAdd(
              data: pdilExcel,
              row: counter + 1,
              maxRow: isImportBoth && maxPasca != null && maxPra != null ? (maxPasca + maxPra) : excel.tables[table]?.maxRows,
              table: table,
              isPasca: isImportBoth ? false : _isPasca,
              isImportBoth: isImportBoth,
              context: context,
            ));
      } else if (row[0]?.rowIndex == 0) {
        formatRows = [];
        formatIndexs = [];
        if ((table.toLowerCase() == tablePrabayar.toLowerCase() || !_isPasca) && formatChecks.length == 10) {
          formatChecks.insert(1, ['NO METER']);
        } else if (formatChecks.length > 10) {
          formatChecks.removeAt(1);
        }
        for (int i = 0; i < row.length; i++) {
          formatChecksLoop:
          for (int j = 0; j < formatChecks.length; j++) {
            for (int k = 0; k < formatChecks[j].length; k++) {
              if (row[i]?.value == formatChecks[j][k]) {
                formatIndexs.add(i);
                formatRows.add(formatChecks[j][k]);
                break formatChecksLoop;
              }
            }
          }
        }
      }
      counter++;
    }
    return Future.value(counter);
  }

  String? _getValueFromRow({required BuildContext context, required String column, required List<Data?> row}) {
    int? indexRow = _getIndexFromFormatRows(context, column);
    if (indexRow != null) {
      return row[formatIndexs[indexRow]]?.value.toString();
    }
    return null;
  }

  int? _getIndexFromFormatRows(BuildContext context, String column) {
    for (int i = 0; i < formatRows.length; i++) {
      if (column == formatRows[i]) {
        return i;
      }
    }
    return null;
  }
}

class CheckBoxImportBoth extends StatefulWidget {
  CheckBoxImportBoth({
    Key? key,
    required this.isImportBoth,
    required this.isPasca,
    required this.onCheckBoxTap,
    required this.onToggleButtonTap,
    required this.formatChecks,
    required this.stateFontSize,
  }) : super(key: key);

  bool isImportBoth;
  bool isPasca;
  Function(bool) onCheckBoxTap;
  Function(bool) onToggleButtonTap;
  List<List<String>> formatChecks;
  FontSizeResult stateFontSize;

  @override
  CheckBoxImportBothState createState() => CheckBoxImportBothState();
}

class CheckBoxImportBothState extends State<CheckBoxImportBoth> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImportBloc, ImportState>(
      builder: (_, importState) {
        return Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (importState is ImportBothNotImported)
                Transform(
                  transform: Matrix4.translationValues(-12.0, 0.0, 0.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: widget.isImportBoth,
                        onChanged: (newValue) {
                          setState(() {
                            widget.isImportBoth = newValue!;
                            widget.onCheckBoxTap(newValue);
                          });
                        },
                      ),
                      Text('Import keduanya', style: widget.stateFontSize.body1),
                    ],
                  ),
                ),
              if (!widget.isImportBoth)
                MyToggleButton(
                  toggleButtonSlot: ToggleButtonSlot.import,
                  onTap: (_isPasca) {
                    widget.isPasca = _isPasca;
                    if (!_isPasca) {
                      widget.formatChecks.insert(1, ['NO METER']);
                    } else if (widget.formatChecks.length > 10) {
                      widget.formatChecks.removeAt(1);
                    }
                    widget.onToggleButtonTap(_isPasca);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ImportPageDesign extends ImportPage {
  _ImportPageDesign({Key? key}) : super(key: key);

  @override
  _ImportPageState createState() => _ImportPageDesignState();
}

class _ImportPageDesignState extends _ImportPageState {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) {
        if (stateFontSize is FontSizeResult) {
          return super.design(context, stateFontSize);
        }
        return Container();
      },
    );
  }
}
