part of 'pages.dart';

class ImportPage extends StatefulWidget {
  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  Animation<Offset> _animation;

  bool _isPasca = true;

  DateTime _currentBackPressTime;

  FilePickerResult result;
  String directory = "";
  String message;
  DbPasca dbHelper = DbPasca();
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
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)).animate(_animationController);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
          if (_currentBackPressTime == null || now.difference(_currentBackPressTime) > Duration(seconds: 2)) {
            _currentBackPressTime = now;
            Fluttertoast.showToast(
              msg: 'Tekan sekali lagi untuk keluar',
            );
            return Future.value(false);
          } else if (_currentBackPressTime == null || now.difference(_currentBackPressTime) < Duration(seconds: 2)) {
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
                child: ClipPath(
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
                          MyToggleButton(
                            toggleButtonSlot: ToggleButtonSlot.import,
                            onTap: (_isPasca) {
                              if (!_isPasca) {
                                this._isPasca = _isPasca;
                                formatChecks.insert(1, ['NO METER']);
                              }
                            },
                          ),
                          SizedBox(height: 8),
                          Material(
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
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

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
                      title: Text("Apakah Anda yakin ?", style: stateFontSize.title.copyWith(color: blackColor, fontWeight: FontWeight.w600)),
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

                        if (_isPasca) {
                          context.read<CustomerDataBloc>().add(UpdateCustomerDataPasca());
                        } else if (!_isPasca) {
                          context.read<CustomerDataBloc>().add(UpdateCustomerDataPra());
                        }
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
    }
  }

  _inputDataToDatabase(BuildContext context) async {
    var file = result.files.single.path;
    var bytes = File(file).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    int counter = 0;

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table].rows) {
        // print("pdil Row : $row");
        Pdil pdilExcel;
        if (counter > 0 && counter < 2) {
          context.read<ImportBloc>().add(ImportConfirm(_isPasca ? Import.pascabayarImported : Import.prabayarImported, prefixIdPel: row[1].toString().substring(0, 5)));
        }
        if (counter > 0) {
          pdilExcel = Pdil(
            idPel: row[formatIndexs[0]].toString(),
            noMeter: !_isPasca ? row[formatIndexs[1]].toString() : null,
            nama: _isPasca ? row[formatIndexs[1]].toString() : row[formatIndexs[2]].toString(),
            alamat: _isPasca ? row[formatIndexs[2]].toString() : row[formatIndexs[3]].toString(),
            tarip: _isPasca ? row[formatIndexs[3]].toString() : row[formatIndexs[4]].toString(),
            daya: _isPasca ? row[formatIndexs[4]].toString() : row[formatIndexs[5]].toString().split(".")[0],
            noHp: formatIndexs.length == 10
                ? _isPasca
                    ? row[formatIndexs[5]]
                    : row[formatIndexs[6]]
                : null,
            nik: formatIndexs.length == 10
                ? _isPasca
                    ? row[formatIndexs[6]]
                    : row[formatIndexs[7]]
                : null,
            npwp: formatIndexs.length == 10
                ? _isPasca
                    ? row[formatIndexs[7]]
                    : row[formatIndexs[8]]
                : null,
            catatan: formatIndexs.length == 10
                ? _isPasca
                    ? row[formatIndexs[8]]
                    : row[formatIndexs[9]]
                : null,
            tanggalBaca: formatIndexs.length == 10
                ? _isPasca
                    ? row[formatIndexs[9]]
                    : row[formatIndexs[10]]
                : null,
            isKoreksi: false,
          );
          context.read<InputDataBloc>().add(InputDataAdd(
                data: pdilExcel,
                row: counter + 1,
                maxRow: excel.tables[table].maxRows,
                isPasca: _isPasca,
              ));
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
