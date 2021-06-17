part of 'widgets.dart';

class MyToggleButton extends StatefulWidget {
  final ToggleButtonSlot toggleButtonSlot;
  final Function(bool isPasca) onTap;

  MyToggleButton({@required this.toggleButtonSlot, @required this.onTap});

  @override
  _MyToggleButtonState createState() => _MyToggleButtonState();
}

class _MyToggleButtonState extends State<MyToggleButton> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _animationControllerPasca;
  AnimationController _animationControllerPra;

  Animation<Color> _animationPascaColor;
  Animation<Color> _animationPraColor;

  bool _isPasca = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationControllerPasca = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationControllerPra = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationPascaColor = ColorTween(begin: whiteColor, end: primaryColor).animate(_animationControllerPasca);
    _animationPraColor = ColorTween(begin: primaryColor, end: whiteColor).animate(_animationControllerPra);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) {
        if (stateFontSize is FontSizeResult) {
          final double kWidth = (MediaQuery.of(context).size.width / 2) + (stateFontSize.title.fontSize - 20);
          return FutureBuilder<Import>(
            future: ImportServices.getCurrentImport(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                _isPasca = _getIspasca(context, snapshot.data, widget.toggleButtonSlot);
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  if (!_isPasca) {
                    _animatePrabayar(context);
                    widget.onTap(_isPasca);
                  }
                });
                return SizedBox(
                  width: kWidth,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: kWidth,
                        height: 32,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: primaryColor),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (_, child) {
                          return Positioned(
                            left: (kWidth / 2 - 8.0) * _animationController.value,
                            child: child,
                          );
                        },
                        child: Container(
                          width: kWidth / 2,
                          height: 24,
                          margin: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              _onPascaPraPressed(context, snapshot.data, true);
                            },
                            child: SizedBox(
                              width: kWidth / 2,
                              child: AnimatedBuilder(
                                animation: _animationController,
                                builder: (_, child) {
                                  return DefaultTextStyle(
                                    style: stateFontSize.body1.copyWith(color: _animationPascaColor.value),
                                    child: child,
                                  );
                                },
                                child: Text(
                                  'PascaBayar',
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              _onPascaPraPressed(context, snapshot.data, false);
                            },
                            child: AnimatedBuilder(
                              animation: _animationController,
                              builder: (_, child) {
                                return DefaultTextStyle(
                                  style: stateFontSize.body1.copyWith(color: _animationPraColor.value),
                                  child: child,
                                );
                              },
                              child: SizedBox(
                                width: kWidth / 2,
                                child: Text(
                                  'PraBayar',
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          );
        }
        return Container();
      },
    );
  }

  bool _getIspasca(BuildContext context, Import currentImport, ToggleButtonSlot toggleButtonSlot) {
    switch (currentImport) {
      case Import.bothImported:
        break;
      case Import.bothNotImported:
        return true;
        break;
      case Import.pascabayarImported:
        switch (toggleButtonSlot) {
          case ToggleButtonSlot.import:
            return false;
            break;
          case ToggleButtonSlot.export:
            return true;
            break;
          case ToggleButtonSlot.showData:
            return true;
            break;
          case ToggleButtonSlot.inputData:
            return true;
            break;
        }
        break;
      case Import.prabayarImported:
        switch (toggleButtonSlot) {
          case ToggleButtonSlot.import:
            return true;
            break;
          case ToggleButtonSlot.export:
            return false;
            break;
          case ToggleButtonSlot.showData:
            return false;
            break;
          case ToggleButtonSlot.inputData:
            return false;
            break;
        }
        break;
    }
    return true;
  }

  _onPascaPraPressed(BuildContext context, Import currentImport, bool isPaca) {
    if (isPaca) {
      // Pascabayar pressed

      switch (widget.toggleButtonSlot) {
        case ToggleButtonSlot.import:
          if (currentImport == Import.pascabayarImported) {
            Fluttertoast.showToast(msg: 'Data sudah di import');
          } else {
            _animatePascabayar(context);
          }
          break;
        case ToggleButtonSlot.export:
          if (currentImport == Import.pascabayarImported || currentImport == Import.bothImported) {
            _animatePascabayar(context);
          } else {
            Fluttertoast.showToast(msg: 'Data tidak ada silahkan Import terlebih dahulu');
          }
          break;
        case ToggleButtonSlot.showData:
          if (currentImport == Import.pascabayarImported || currentImport == Import.bothImported) {
            _animatePascabayar(context);
          } else {
            Fluttertoast.showToast(msg: 'Data tidak ada silahkan Import terlebih dahulu');
          }
          break;
        case ToggleButtonSlot.inputData:
          if (currentImport == Import.pascabayarImported || currentImport == Import.bothImported) {
            _animatePascabayar(context);
          } else {
            Fluttertoast.showToast(msg: 'Data tidak ada silahkan Import terlebih dahulu');
          }
          break;
      }
    } else {
      // Prabayar pressed

      switch (widget.toggleButtonSlot) {
        case ToggleButtonSlot.import:
          if (currentImport == Import.prabayarImported) {
            Fluttertoast.showToast(msg: 'Data sudah di import');
          } else {
            _animatePrabayar(context);
          }
          break;
        case ToggleButtonSlot.export:
          if (currentImport == Import.prabayarImported || currentImport == Import.bothImported) {
            _animatePrabayar(context);
          } else {
            Fluttertoast.showToast(msg: 'Data tidak ada silahkan Import terlebih dahulu');
          }
          break;
        case ToggleButtonSlot.showData:
          if (currentImport == Import.prabayarImported || currentImport == Import.bothImported) {
            _animatePrabayar(context);
          } else {
            Fluttertoast.showToast(msg: 'Data tidak ada silahkan Import terlebih dahulu');
          }
          break;
        case ToggleButtonSlot.inputData:
          if (currentImport == Import.prabayarImported || currentImport == Import.bothImported) {
            _animatePrabayar(context);
          } else {
            Fluttertoast.showToast(msg: 'Data tidak ada silahkan Import terlebih dahulu');
          }
          break;
      }
    }
  }

  _animatePascabayar(BuildContext context) {
    _isPasca = true;
    widget.onTap(_isPasca);
    _animationController.reverse();
    _animationControllerPasca.reverse();
    _animationControllerPra.reverse();
  }

  _animatePrabayar(BuildContext context) {
    _isPasca = false;
    widget.onTap(_isPasca);
    _animationController.forward();
    _animationControllerPasca.forward();
    _animationControllerPra.forward();
  }
}

enum ToggleButtonSlot { import, export, showData, inputData }
