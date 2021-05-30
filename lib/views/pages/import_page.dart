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
    _animationController.reverse();
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
            SystemNavigator.pop();
            return Future.value(true);
          }
          return Future.value(false);
        }
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
                          MyToggleButton((_isPasca) {
                            if (!_isPasca) {
                              this._isPasca = _isPasca;
                              formatChecks.insert(1, ['NO METER']);
                            }
                          }),
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
                      title: Text("Apakah Anda yakin ?",
                          style: stateFontSize.title.copyWith(color: blackColor, fontWeight: FontWeight.w600)),
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
                    });
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 6,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: MediaQuery.of(context).size.width / 2 * inputDataState.progress,
                          height: 6,
                          color: inputDataState.progress < 0.5
                              ? redColor
                              : inputDataState.progress < 0.7
                                  ? yellowColor
                                  : greenColor,
                        ),
                      ),
                      SizedBox(width: 10),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text('${int.parse((inputDataState.progress * 100).toString().split(".")[0])}%',
                              style: stateFontSize.body2),
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
                  style: stateFontSize.body1.copyWith(color: redColor),
                  children: [
                    ...List.generate(
                      state.data.length ?? 0,
                      (index) => TextSpan(
                        text: "Kolom ",
                        style: stateFontSize.body1.copyWith(color: redColor),
                        children: [
                          TextSpan(
                            text: state.data[index].check,
                            style: stateFontSize.body1.copyWith(color: primaryColor),
                          ),
                          TextSpan(
                            text: " dengan ",
                            style: stateFontSize.body1.copyWith(color: redColor),
                          ),
                          TextSpan(
                            text: state.data[index].target + (index < state.data.length - 1 ? "\n" : ""),
                            style: stateFontSize.body1.copyWith(color: primaryColor),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : (state is ErrorCheckSucessfulState)
                ? Text("Kolom dan Data Valid!", style: stateFontSize.body1.copyWith(color: greenColor))
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
                    content: Text("Tindakan ini tidak dapat di undo", style: stateFontSize.body1),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          NavigationHelper.back();
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
          showMySnackBar(context, text: "Silahkan Pilih File terlebih dahulu !!!");
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Proses", style: stateFontSize.body1.copyWith(color: whiteColor)),
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
        print("pdil Row : $row");
        Pdil pdilExcel;
        if (counter > 0 && counter < 2) {
          context.read<ImportBloc>().add(ImportConfirm(_isPasca ? Import.pascabayarImported : Import.prabayarImported,
              prefixIdPel: row[1].toString().substring(0, 5)));
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
