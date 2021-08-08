part of 'pages.dart';

class SettingsPage extends StatefulWidget {
  final bool isImport;
  final Changing? data;
  SettingsPage({this.isImport = false, this.data});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
                  FutureBuilder<List<Directory>?>(
                    future: getExternalStorageDirectories(type: StorageDirectory.downloads),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            _divider(_),
                            _listPathInformation(_, stateFontSize, snapshot.data![0].path),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                  // FutureBuilder<List<Directory>?>(
                  //   future: getExternalStorageDirectories(type: StorageDirectory.downloads),
                  //   builder: (_, snapshot) {
                  //     if (snapshot.hasData) {
                  //       return Column(
                  //         children: [
                  //           _divider(_),
                  //           _listShareFile(context, stateFontSize, snapshot.data![0].path),
                  //         ],
                  //       );
                  //     }
                  //     return Container();
                  //   },
                  // ),
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
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) {
              return ExportPage(isExport: isExport);
            },
          );
        },
      );

  _listPathInformation(BuildContext context, FontSizeResult stateFontSize, String path) => ListTile(
        leading: Stack(
          children: [
            Icon(
              Icons.folder,
              size: 30,
            ),
          ],
        ),
        title: Text(
          'Lokasi Simpan File',
          style: stateFontSize.subtitle?.copyWith(fontWeight: FontWeight.w600),
        ),
        onTap: () {
          showDialog(
            useRootNavigator: true,
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(
                  'Lokasi Penyimpanan',
                  style: stateFontSize.title?.copyWith(fontWeight: FontWeight.w600),
                ),
                content: Text(
                  path,
                  style: stateFontSize.subtitle,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      NavigationHelper.back();
                    },
                    child: Text(
                      'Ok',
                      style: stateFontSize.subtitle,
                    ),
                  )
                ],
              );
            },
          );
        },
      );

  _listShareFile(BuildContext context, FontSizeResult stateFontSize, String path) => ListTile(
        leading: Stack(
          children: [
            Icon(
              Icons.folder,
              size: 30,
            ),
          ],
        ),
        title: Text(
          'Share File',
          style: stateFontSize.subtitle?.copyWith(fontWeight: FontWeight.w600),
        ),
        onTap: () async {
          MethodChannel platform = const MethodChannel("BlastTea.example.pdil");
          try {
            await platform.invokeMethod("openFolder",{"initPath" : path});
          } on PlatformException catch (ex) {
            print("${ex.code} : ${ex.message}");
          }
        },
      );
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
          if (!widget.isExportBoth!)
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
