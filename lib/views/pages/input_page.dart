part of 'pages.dart';

class InputPage extends StatefulWidget {
  InputPage({Key? key}) : super(key: key);

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(11, (index) => TextEditingController());

  Pdil? _currentPdilPasca;
  Pdil? _originalPdilPasca;
  Pdil? _currentPdilPra;
  Pdil? _originalPdilPra;

  bool _isPasca = true;
  bool _isIgnorePdilLoaded = false;
  bool _isShowDialogInit = true;

  Stopwatch _stopwatchProgress = Stopwatch();

  String? _prefixIdPelPasca;
  String? _prefixIdPelPra;

  late PdilBloc _pdilBloc;

  @override
  void dispose() {
    _pdilBloc.add(UpdatePdilController(
      currentPdilPasca: _currentPdilPasca,
      originalPdilPasca: _originalPdilPasca,
      currentPdilPra: _currentPdilPra,
      originalPdilPra: _originalPdilPra,
      isPasca: _isPasca,
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _secondVersion(context);
  }

  _secondVersion(BuildContext context) {
    _pdilBloc = context.read<PdilBloc>();
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) {
        if (stateFontSize is FontSizeResult) {
          return BlocListener<PdilBloc, PdilState>(
            listener: (_, statePdil) async {
              if (statePdil is PdilError && !statePdil.isContinuingSearch) {
                Fluttertoast.showToast(msg: statePdil.message);
              } else if (statePdil is PdilLoaded) {
              } else if (statePdil is PdilOnUpdate) {
                if (statePdil.count > 0) {
                  Fluttertoast.showToast(msg: 'Data Berhasil Disimpan');
                  if (_isPasca) {
                    context.read<CustomerDataBloc>().add(UpdateCustomerDataPasca());
                  } else if (!_isPasca) {
                    context.read<CustomerDataBloc>().add(UpdateCustomerDataPra());
                  }
                } else if (statePdil.count == 0) {
                  Fluttertoast.showToast(msg: 'Data gagal Disimpan');
                }
              }
            },
            child: BlocListener<FabSaveBloc, FabSaveState>(
              listener: (_, stateFabSave) {
                if (stateFabSave is FabSaveOnStatePressed) {
                  if (_isPasca) {
                    _currentPdilPasca!.tanggalBaca = currentTime();
                  } else {
                    _currentPdilPra!.tanggalBaca = currentTime();
                  }
                  context.read<PdilBloc>().add(UpdatePdil(pdil: _isPasca ? _currentPdilPasca : _currentPdilPra, isUsingSaveDialog: false, isPasca: _isPasca));
                  if (_isPasca) {
                    _originalPdilPasca = null;
                    _currentPdilPasca = null;
                    _changeTextController(context);
                  } else if (!_isPasca) {
                    _originalPdilPra = null;
                    _currentPdilPra = null;
                    _changeTextController(context);
                  }
                  context.read<PdilBloc>().add(ClearPdilState(isPasca: _isPasca));
                }
              },
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      MyToggleButton(
                        toggleButtonSlot: ToggleButtonSlot.inputData,
                        onTap: (isPasca) {
                          setState(() {
                            _isPasca = isPasca;
                            _changeTextController(context);
                            _isIgnorePdilLoaded = true;
                          });
                        },
                      ),
                      ...List.generate(
                        !_isPasca ? 11 : 10,
                        (index) => Padding(
                          padding: EdgeInsets.fromLTRB(defaultPadding, 10, defaultPadding, index == (_isPasca ? 9 : 10) ? 80 : 0),
                          child: BlocBuilder<PdilBloc, PdilState>(
                            builder: (_, pdilState) {
                              if (pdilState is PdilLoaded && !_isIgnorePdilLoaded) {
                                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
                                  // set data ke currentTextField
                                  if (pdilState.isPasca) {
                                    if (pdilState.isFromCustomerData) {
                                      if (_isPasca && !pdilState.isPascaDiff && _isShowDialogInit) {
                                        _isShowDialogInit = false;
                                        _changeTextControllerWithValue(context: context, data: pdilState.previousCurrentPdilPasca, isPasca: pdilState.isPasca);
                                        await _dialogSaveChanges(context, stateFontSize, pdilState.previousCurrentPdilPasca).then((value) {
                                          _originalPdilPasca = pdilState.originalPdilPasca?.copyWith();
                                          _currentPdilPasca = pdilState.currentPdilPasca?.copyWith();

                                          _originalPdilPra = pdilState.originalPdilPra?.copyWith();
                                          _currentPdilPra = pdilState.currentPdilPra?.copyWith();
                                          _changeTextControllerWithValue(context: context, data: pdilState.originalPdilPasca, isPasca: pdilState.isPasca);
                                        });
                                      } else {
                                        if (_isShowDialogInit) {
                                          _isShowDialogInit = false;
                                          _originalPdilPasca = pdilState.originalPdilPasca?.copyWith();
                                          _currentPdilPasca = pdilState.currentPdilPasca?.copyWith();

                                          _originalPdilPra = pdilState.originalPdilPra?.copyWith();
                                          _currentPdilPra = pdilState.currentPdilPra?.copyWith();
                                          _changeTextControllerWithValue(context: context, data: pdilState.originalPdilPasca, isPasca: pdilState.isPasca);
                                        }
                                      }
                                    } else if (pdilState.isContinuingSearch) {
                                      if (pdilState.isClearState) {
                                        _controllers.forEach((controller) {
                                          int index = _controllers.indexOf(controller);

                                          if (index != 0) {
                                            controller.text = '';
                                          }
                                        });
                                      }
                                      _originalPdilPasca = pdilState.originalPdilPasca?.copyWith();
                                      _currentPdilPasca = pdilState.currentPdilPasca?.copyWith();

                                      _originalPdilPra = pdilState.originalPdilPra?.copyWith();
                                      _currentPdilPra = pdilState.currentPdilPra?.copyWith();
                                      _changeTextControllerWithValue(context: context, data: pdilState.originalPdilPasca, isPasca: pdilState.isPasca);
                                    }
                                  } else {
                                    if (pdilState.isFromCustomerData) {
                                      if (!_isPasca && !pdilState.isPraDiff && _isShowDialogInit) {
                                        _isShowDialogInit = false;
                                        _changeTextControllerWithValue(context: context, data: pdilState.previousCurrentPdilPra, isPasca: pdilState.isPasca);
                                        await _dialogSaveChanges(context, stateFontSize, pdilState.previousCurrentPdilPra).then((value) {
                                          _originalPdilPra = pdilState.originalPdilPra?.copyWith();
                                          _currentPdilPra = pdilState.currentPdilPra?.copyWith();

                                          _originalPdilPasca = pdilState.originalPdilPasca?.copyWith();
                                          _currentPdilPasca = pdilState.currentPdilPasca?.copyWith();
                                          _changeTextControllerWithValue(context: context, data: pdilState.originalPdilPra, isPasca: pdilState.isPasca);
                                        });
                                      } else {
                                        if (_isShowDialogInit) {
                                          _isShowDialogInit = false;
                                          _originalPdilPra = pdilState.originalPdilPra?.copyWith();
                                          _currentPdilPra = pdilState.currentPdilPra?.copyWith();

                                          _originalPdilPasca = pdilState.originalPdilPasca?.copyWith();
                                          _currentPdilPasca = pdilState.currentPdilPasca?.copyWith();
                                          _changeTextControllerWithValue(context: context, data: pdilState.originalPdilPra, isPasca: pdilState.isPasca);
                                        }
                                      }
                                    } else if (pdilState.isContinuingSearch) {
                                      if (pdilState.isClearState) {
                                        _controllers.forEach((controller) {
                                          int index = _controllers.indexOf(controller);

                                          if (index != 0 && index != 1) {
                                            controller.text = '';
                                          }
                                        });
                                      }
                                      _originalPdilPasca = pdilState.originalPdilPasca?.copyWith();
                                      _currentPdilPasca = pdilState.currentPdilPasca?.copyWith();

                                      _originalPdilPra = pdilState.originalPdilPra?.copyWith();
                                      _currentPdilPra = pdilState.currentPdilPra?.copyWith();
                                      _changeTextControllerWithValue(context: context, data: pdilState.originalPdilPra, isPasca: pdilState.isPasca);
                                    }
                                  }
                                  _isIgnorePdilLoaded = true;
                                });
                              } else if (pdilState is PdilClearedState) {
                              } else if (pdilState is UpdatedPdilController) {
                                WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                                  _originalPdilPasca = pdilState.originalPdilPasca;
                                  _currentPdilPasca = pdilState.currentPdilPasca;
                                  _originalPdilPra = pdilState.originalPdilPra;
                                  _currentPdilPra = pdilState.currentPdilPra;
                                  _changeTextController(context);
                                });
                              }
                              return FutureBuilder<String?>(
                                future: ImportServices.getPrefixIdpelPasca(),
                                builder: (_, snapshotPasca) {
                                  if (snapshotPasca.hasData) {
                                    _prefixIdPelPasca = snapshotPasca.data;
                                  }
                                  return FutureBuilder<String?>(
                                    future: ImportServices.getPrefixIdpelPra(),
                                    builder: (__, snapshotPra) {
                                      if (snapshotPra.hasData) {
                                        _prefixIdPelPra = snapshotPra.data;
                                      }
                                      return CurrentTextField(
                                        isInputPage: true,
                                        controller: _controllers[index],
                                        // width: MediaQuery.of(context).size.width - 110,
                                        padding: index == 0
                                            ? const EdgeInsets.fromLTRB(10, 24, 25, 0)
                                            : index == (_isPasca ? 9 : 10)
                                                ? const EdgeInsets.all(15)
                                                : const EdgeInsets.only(left: 15, right: 35),
                                        keyboardType: [
                                          TextInputType.number,
                                          if (!_isPasca) TextInputType.number,
                                          TextInputType.text,
                                          TextInputType.text,
                                          TextInputType.text,
                                          TextInputType.text,
                                          TextInputType.number,
                                          TextInputType.number,
                                          TextInputType.text,
                                          TextInputType.emailAddress,
                                          TextInputType.text,
                                        ][index],
                                        label: [
                                          'IdPel',
                                          if (!_isPasca) 'No Meter',
                                          'Nama',
                                          'Alamat',
                                          'Tarif',
                                          'Daya',
                                          'No Hp',
                                          'NIK',
                                          'NPWP',
                                          'Email',
                                          'CATATAN',
                                        ][index],
                                        readOnly: [
                                          false,
                                          if (!_isPasca) false,
                                          true,
                                          true,
                                          true,
                                          true,
                                          false,
                                          false,
                                          false,
                                          false,
                                          false,
                                        ][index],
                                        prefixText: index == 0
                                            ? _isPasca
                                                ? snapshotPasca.data
                                                : snapshotPra.data
                                            : null,
                                        prefixIcon: index == 0 ? Icon(Icons.people_alt) : null,
                                        height: index == (_isPasca ? 9 : 10) ? 160 : null,
                                        expands: index == (_isPasca ? 9 : 10),
                                        maxLines: index == (_isPasca ? 9 : 10)
                                            ? index == 0
                                                ? 12
                                                : null
                                            : 1,
                                        onCancelTap: _getFunction(context, index)
                                            ? () {
                                                if (_isPasca) {
                                                  if (_controllers[index].text != '' && _originalPdilPasca == null) {
                                                    _controllers[index].text = '';
                                                  } else if (_originalPdilPasca != null) {
                                                    if (_originalPdilPasca!.isSame(_currentPdilPasca, isIgnoreIdpel: true)) {
                                                      _originalPdilPasca = null;
                                                      _currentPdilPasca = null;
                                                      _changeTextController(context);
                                                      context.read<FabBloc>().add(HideFab());
                                                      context.read<PdilBloc>().add(ClearPdilState(isPasca: _isPasca));
                                                    } else {
                                                      _dialogSaveChanges(context, stateFontSize);
                                                    }
                                                  }
                                                } else {
                                                  if (_controllers[index].text != '' && _originalPdilPra == null) {
                                                    _controllers[index].text = '';
                                                  } else if (_originalPdilPra != null) {
                                                    if (_originalPdilPra!.isSame(_currentPdilPra, isIgnoreIdpel: true)) {
                                                      _originalPdilPra = null;
                                                      _currentPdilPra = null;
                                                      _changeTextController(context);
                                                      context.read<FabBloc>().add(HideFab());
                                                      context.read<PdilBloc>().add(ClearPdilState(isPasca: _isPasca));
                                                    } else {
                                                      _dialogSaveChanges(context, stateFontSize);
                                                    }
                                                  }
                                                }
                                              }
                                            : null,
                                        onChanged: (value) {
                                          if (_isPasca) {
                                            switch (index) {
                                              case 0:
                                                _pdilBloc.add(FetchPdil(idPel: '${_prefixIdPelPasca ?? ''}$value', isContinuingSearch: true, isPasca: _isPasca));
                                                _isIgnorePdilLoaded = false;
                                                break;
                                              case 5:
                                                _currentPdilPasca?.noHp = value == '' ? null : value;
                                                break;
                                              case 6:
                                                _currentPdilPasca?.nik = value == '' ? null : value;
                                                break;
                                              case 7:
                                                _currentPdilPasca?.npwp = value == '' ? null : value;
                                                break;
                                              case 8:
                                                _currentPdilPasca?.email = value == '' ? null : value;
                                                break;
                                              case 9:
                                                _currentPdilPasca?.catatan = value == '' ? null : value;
                                                break;
                                            }
                                            if (_originalPdilPasca != null && index != 0) {
                                              if (!_originalPdilPasca!.isSame(_currentPdilPasca, isIgnoreIdpel: true)) {
                                                context.read<FabBloc>().add(ShowFab());
                                              } else {
                                                context.read<FabBloc>().add(HideFab());
                                              }
                                            }
                                          } else if (!_isPasca) {
                                            switch (index) {
                                              case 0:
                                                _pdilBloc.add(FetchPdil(idPel: '${_prefixIdPelPra ?? ''}$value', isContinuingSearch: true, isPasca: _isPasca));
                                                _isIgnorePdilLoaded = false;
                                                break;
                                              case 1:
                                                _pdilBloc.add(FetchPdil(noMeter: value, isContinuingSearch: true, isPasca: _isPasca));
                                                _isIgnorePdilLoaded = false;
                                                break;
                                              case 6:
                                                _currentPdilPra?.noHp = value == '' ? null : value;
                                                break;
                                              case 7:
                                                _currentPdilPra?.nik = value == '' ? null : value;
                                                break;
                                              case 8:
                                                _currentPdilPra?.npwp = value == '' ? null : value;
                                                break;
                                              case 9:
                                                _currentPdilPra?.email = value == '' ? null : value;
                                                break;
                                              case 10:
                                                _currentPdilPra?.catatan = value == '' ? null : value;
                                                break;
                                            }
                                            if (_originalPdilPra != null && index != 0) {
                                              if (!_originalPdilPra!.isSame(_currentPdilPra, isIgnoreIdpel: true)) {
                                                context.read<FabBloc>().add(ShowFab());
                                              } else {
                                                context.read<FabBloc>().add(HideFab());
                                              }
                                            }
                                          }
                                        },
                                        onSubmitted: _getFunction(context, index)
                                            ? (value) {
                                                _pdilBloc.add(FetchPdil(idPel: '${_prefixIdPelPra ?? ''}$value', isPasca: _isPasca));
                                                _isIgnorePdilLoaded = false;
                                              }
                                            : null,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Future<void> _dialogSaveChanges(BuildContext context, FontSizeResult stateFontSize, [Pdil? previousCurrentPdil]) {
    return showDialog(
      context: context,
      useRootNavigator: true,
      builder: (_) => AlertDialog(
        title: Text(
          'Simpan Perubahan ?',
          style: stateFontSize.title!.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Pdil? currentPdil = previousCurrentPdil;
              if (currentPdil != null) {
                currentPdil.tanggalBaca = currentTime();
              } else {
                if (_isPasca) {
                  _currentPdilPasca!.tanggalBaca = currentTime();
                } else {
                  _currentPdilPra!.tanggalBaca = currentTime();
                }
              }
              context.read<PdilBloc>().add(UpdatePdil(
                    pdil: previousCurrentPdil != null
                        ? currentPdil
                        : _isPasca
                            ? _currentPdilPasca
                            : _currentPdilPra,
                    isUsingSaveDialog: true,
                    isPasca: _isPasca,
                  ));
              context.read<FabBloc>().add(HideFab());
              if (currentPdil == null) {
                context.read<PdilBloc>().add(ClearPdilState(isPasca: _isPasca));
                if (_isPasca) {
                  _originalPdilPasca = null;
                  _currentPdilPasca = null;
                  // _isChangeTextController = true;
                  _changeTextController(context);
                } else if (!_isPasca) {
                  _originalPdilPra = null;
                  _currentPdilPra = null;
                  _changeTextController(context);
                  // _isChangeTextController = true;
                }
              } else {
                _changeTextController(context);
              }
              NavigationHelper.back();
            },
            child: Text('Simpan', style: stateFontSize.body1),
          ),
          TextButton(
            onPressed: () {
              context.read<FabBloc>().add(HideFab());
              if (previousCurrentPdil == null) {
                context.read<PdilBloc>().add(ClearPdilState(isPasca: _isPasca));
                if (_isPasca) {
                  _originalPdilPasca = null;
                  _currentPdilPasca = null;
                  _changeTextController(context);
                } else if (!_isPasca) {
                  _originalPdilPra = null;
                  _currentPdilPra = null;
                  _changeTextController(context);
                }
              } else {
                _changeTextController(context);
              }
              NavigationHelper.back();
            },
            child: Text('Buang', style: stateFontSize.body1),
          ),
        ],
      ),
    );
  }

  _changeTextController(BuildContext context) {
    if (_isPasca) {
      if (_currentPdilPasca != null) {
        _controllers[0].text = _currentPdilPasca!.idPel!.substring(5);
        _controllers[1].text = _currentPdilPasca!.nama ?? '';
        _controllers[2].text = _currentPdilPasca!.alamat ?? '';
        _controllers[3].text = _currentPdilPasca!.tarip ?? '';
        _controllers[4].text = _currentPdilPasca!.daya ?? '';
        _controllers[5].text = _currentPdilPasca!.noHp ?? '';
        _controllers[6].text = _currentPdilPasca!.nik ?? '';
        _controllers[7].text = _currentPdilPasca!.npwp ?? '';
        _controllers[8].text = _currentPdilPasca!.email ?? '';
        _controllers[9].text = _currentPdilPasca!.catatan ?? '';
      } else if (_currentPdilPasca == null) {
        _controllers.forEach((controller) {
          controller.text = '';
        });
      }
      if (_originalPdilPasca != null) {
        if (!_originalPdilPasca!.isSame(_currentPdilPasca, isIgnoreIdpel: true)) {
          context.read<FabBloc>().add(ShowFab());
        } else {
          context.read<FabBloc>().add(HideFab());
        }
      } else if (_originalPdilPasca == null) {
        context.read<FabBloc>().add(HideFab());
      }
    } else {
      if (_currentPdilPra != null) {
        _controllers[0].text = _currentPdilPra!.idPel!.substring(5);
        _controllers[1].text = _currentPdilPra!.noMeter ?? '';
        _controllers[2].text = _currentPdilPra!.nama ?? '';
        _controllers[3].text = _currentPdilPra!.alamat ?? '';
        _controllers[4].text = _currentPdilPra!.tarip ?? '';
        _controllers[5].text = _currentPdilPra!.daya ?? '';
        _controllers[6].text = _currentPdilPra!.noHp ?? '';
        _controllers[7].text = _currentPdilPra!.nik ?? '';
        _controllers[8].text = _currentPdilPra!.npwp ?? '';
        _controllers[9].text = _currentPdilPra!.email ?? '';
        _controllers[10].text = _currentPdilPra!.catatan ?? '';
      } else if (_currentPdilPra == null) {
        _controllers.forEach((controller) {
          controller.text = '';
        });
      }
      if (_originalPdilPra != null) {
        if (!_originalPdilPra!.isSame(_currentPdilPra, isIgnoreIdpel: true)) {
          context.read<FabBloc>().add(ShowFab());
        } else {
          context.read<FabBloc>().add(HideFab());
        }
      } else if (_originalPdilPra == null) {
        context.read<FabBloc>().add(HideFab());
      }
    }
  }

  bool _getFunction(BuildContext context, int index) {
    if (_isPasca) {
      return index == 0;
    }
    return index == 0 || index == 1;
  }

  _changeTextControllerWithValue({
    required BuildContext context,
    required Pdil? data,
    required bool isPasca,
    bool? isIdPel,
  }) {
    if (_isPasca) {
      _controllers[0].text = data?.idPel?.substring(5) ?? '';
    } else if (!isPasca) {
      if (isIdPel ?? false) {
        _controllers[0].text = data?.idPel?.substring(5) ?? '';
      } else if (isIdPel == false) {
        _controllers[1].text = data?.noMeter ?? '';
      } else {
        _controllers[0].text = data?.idPel?.substring(5) ?? '';
        _controllers[1].text = data?.noMeter ?? '';
      }
    }
    _controllers[isPasca ? 1 : 2].text = data?.nama ?? '';
    _controllers[isPasca ? 2 : 3].text = data?.alamat ?? '';
    _controllers[isPasca ? 3 : 4].text = data?.tarip ?? '';
    _controllers[isPasca ? 4 : 5].text = data?.daya ?? '';
    _controllers[isPasca ? 5 : 6].text = data?.noHp ?? '';
    _controllers[isPasca ? 6 : 7].text = data?.nik ?? '';
    _controllers[isPasca ? 7 : 8].text = data?.npwp ?? '';
    _controllers[isPasca ? 8 : 9].text = data?.email ?? '';
    _controllers[isPasca ? 9 : 10].text = data?.catatan ?? '';
  }
}

class ImportClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 60);
    path.cubicTo(
      0,
      50,
      10,
      40,
      20,
      40,
    );
    path.arcTo(Rect.fromLTWH(size.width / 2 - 41, 0, 82, 82), pi, pi, false);
    path.lineTo(size.width - 20, 40);
    path.cubicTo(
      size.width - 10,
      40,
      size.width,
      50,
      size.width,
      60,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 60);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
