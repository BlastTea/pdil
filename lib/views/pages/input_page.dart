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
  bool _isChangeTextController = false;

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
    if (_isChangeTextController) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
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
        }
      });
      _isChangeTextController = false;
    }
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
                  _controllers.forEach((controller) {
                    controller.text = '';
                  });
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
                  context.read<PdilBloc>().add(UpdatePdil(pdil: _currentPdilPasca, isUsingSaveDialog: false, isPasca: _isPasca));
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
                            _isChangeTextController = true;
                          });
                        },
                      ),
                      ...List.generate(
                        !_isPasca ? 11 : 10,
                        (index) => Padding(
                          padding: EdgeInsets.fromLTRB(defaultPadding, 10, defaultPadding, index == (_isPasca ? 9 : 10) ? 80 : 0),
                          child: BlocBuilder<PdilBloc, PdilState>(
                            builder: (_, pdilState) {
                              if (pdilState is PdilLoaded) {
                                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                                  // set data ke currentTextField
                                  if (pdilState.isPasca) {
                                    if (pdilState.isFromCustomerData) {
                                      if (_isPasca) {
                                        _controllers[0].text = pdilState.originalPdilPasca!.idPel!.substring(5);
                                      }
                                      _originalPdilPasca = pdilState.originalPdilPasca?.copyWith();
                                      _currentPdilPasca = pdilState.currentPdilPasca?.copyWith();

                                      _originalPdilPra = pdilState.originalPdilPra?.copyWith();
                                      _currentPdilPra = pdilState.currentPdilPra?.copyWith();
                                    } else if (pdilState.isContinousSearch) {
                                      _originalPdilPasca = pdilState.originalPdilPasca?.copyWith();
                                      _currentPdilPasca = pdilState.currentPdilPasca?.copyWith();
                                    }
                                    if (_isPasca) {
                                      _controllers[1].text = pdilState.originalPdilPasca!.nama ?? '';
                                      _controllers[2].text = pdilState.originalPdilPasca!.alamat ?? '';
                                      _controllers[3].text = pdilState.originalPdilPasca!.tarip ?? '';
                                      _controllers[4].text = pdilState.originalPdilPasca!.daya ?? '';
                                      _controllers[5].text = pdilState.originalPdilPasca!.noHp ?? '';
                                      _controllers[6].text = pdilState.originalPdilPasca!.nik ?? '';
                                      _controllers[7].text = pdilState.originalPdilPasca!.npwp ?? '';
                                      _controllers[8].text = pdilState.originalPdilPasca!.email ?? '';
                                      _controllers[9].text = pdilState.originalPdilPasca!.catatan ?? '';
                                    }
                                  } else {
                                    if (pdilState.isFromCustomerData) {
                                      if (!_isPasca) {
                                        _controllers[0].text = pdilState.originalPdilPra!.idPel!.substring(5);
                                        _controllers[1].text = pdilState.originalPdilPra!.noMeter!;
                                      }
                                      _originalPdilPra = pdilState.originalPdilPra?.copyWith();
                                      _currentPdilPra = pdilState.currentPdilPra?.copyWith();

                                      _originalPdilPasca = pdilState.originalPdilPasca?.copyWith();
                                      _currentPdilPasca = pdilState.currentPdilPasca?.copyWith();
                                    } else if (pdilState.isContinousSearch) {
                                      _originalPdilPra = pdilState.originalPdilPra?.copyWith();
                                      _currentPdilPra = pdilState.currentPdilPra?.copyWith();
                                    }
                                    if (!_isPasca) {
                                      _controllers[1].text = pdilState.originalPdilPra!.noMeter ?? '';
                                      _controllers[2].text = pdilState.originalPdilPra!.nama ?? '';
                                      _controllers[3].text = pdilState.originalPdilPra!.alamat ?? '';
                                      _controllers[4].text = pdilState.originalPdilPra!.tarip ?? '';
                                      _controllers[5].text = pdilState.originalPdilPra!.daya ?? '';
                                      _controllers[6].text = pdilState.originalPdilPra!.noHp ?? '';
                                      _controllers[7].text = pdilState.originalPdilPra!.nik ?? '';
                                      _controllers[8].text = pdilState.originalPdilPra!.npwp ?? '';
                                      _controllers[9].text = pdilState.originalPdilPra!.email ?? '';
                                      _controllers[10].text = pdilState.originalPdilPra!.catatan ?? '';
                                    }
                                  }
                                });
                              } else if (pdilState is PdilClearedState) {
                              } else if (pdilState is UpdatedPdilController) {
                                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                                  if (pdilState.isPasca && _isPasca) {
                                    _originalPdilPasca = pdilState.originalPdilPasca;
                                    _currentPdilPasca = pdilState.currentPdilPasca;
                                    if (pdilState.currentPdilPasca != null) {
                                      _controllers[0].text = pdilState.currentPdilPasca!.idPel!.substring(5);
                                      _controllers[1].text = pdilState.currentPdilPasca!.nama ?? '';
                                      _controllers[2].text = pdilState.currentPdilPasca!.alamat ?? '';
                                      _controllers[3].text = pdilState.currentPdilPasca!.tarip ?? '';
                                      _controllers[4].text = pdilState.currentPdilPasca!.daya ?? '';
                                      _controllers[5].text = pdilState.currentPdilPasca!.noHp ?? '';
                                      _controllers[6].text = pdilState.currentPdilPasca!.nik ?? '';
                                      _controllers[7].text = pdilState.currentPdilPasca!.npwp ?? '';
                                      _controllers[8].text = pdilState.currentPdilPasca!.email ?? '';
                                      _controllers[9].text = pdilState.currentPdilPasca!.catatan ?? '';
                                    }
                                  } else if (!pdilState.isPasca && !_isPasca) {
                                    _originalPdilPra = pdilState.originalPdilPra;
                                    _currentPdilPra = pdilState.currentPdilPra;
                                    if (pdilState.currentPdilPra != null) {
                                      _controllers[0].text = pdilState.currentPdilPra!.idPel!.substring(5);
                                      _controllers[1].text = pdilState.currentPdilPra!.noMeter ?? '';
                                      _controllers[2].text = pdilState.currentPdilPra!.nama ?? '';
                                      _controllers[3].text = pdilState.currentPdilPra!.alamat ?? '';
                                      _controllers[4].text = pdilState.currentPdilPra!.tarip ?? '';
                                      _controllers[5].text = pdilState.currentPdilPra!.daya ?? '';
                                      _controllers[6].text = pdilState.currentPdilPra!.noHp ?? '';
                                      _controllers[7].text = pdilState.currentPdilPra!.nik ?? '';
                                      _controllers[8].text = pdilState.currentPdilPra!.npwp ?? '';
                                      _controllers[9].text = pdilState.currentPdilPra!.email ?? '';
                                      _controllers[10].text = pdilState.currentPdilPra!.catatan ?? '';
                                    }
                                  } else {
                                    _controllers.forEach((controller) {
                                      controller.text = '';
                                    });
                                  }
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
                                            ? const EdgeInsets.fromLTRB(10, 24, 10, 0)
                                            : index == (_isPasca ? 9 : 10)
                                                ? const EdgeInsets.all(15)
                                                : const EdgeInsets.symmetric(horizontal: 15),
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
                                        onCancelTap: index == 0
                                            ? () {
                                              if (_isPasca) {
                                                if (_originalPdilPasca != null) {
                                                  if (_originalPdilPasca!.compareTo(_currentPdilPasca, isIgnoreIdpel: true)) {
                                                    setState(() {
                                                      _originalPdilPasca = null;
                                                      _currentPdilPasca = null;
                                                      _isChangeTextController = true;
                                                    });
                                                    context.read<PdilBloc>().add(ClearPdilState(isPasca: _isPasca));
                                                  } else {
                                                    _dialogSaveChanges(context, stateFontSize);
                                                  }
                                                }
                                              } else {
                                                if (_originalPdilPra != null) {
                                                  if (_originalPdilPra!.compareTo(_currentPdilPra, isIgnoreIdpel: true)) {
                                                    setState(() {
                                                      _originalPdilPra = null;
                                                      _currentPdilPra = null;
                                                      _isChangeTextController = true;
                                                    });
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
                                                // _previousPdil?.idPel = value;
                                                _pdilBloc.add(FetchPdil(idPel: _prefixIdPelPasca ?? '' + value, isContinuingSearch: true, isPasca: _isPasca));
                                                break;
                                              case 1:
                                                _currentPdilPasca?.nama = value;
                                                break;
                                              case 2:
                                                _currentPdilPasca?.alamat = value;
                                                break;
                                              case 3:
                                                _currentPdilPasca?.tarip = value;
                                                break;
                                              case 4:
                                                _currentPdilPasca?.daya = value;
                                                break;
                                              case 5:
                                                _currentPdilPasca?.noHp = value;
                                                break;
                                              case 6:
                                                _currentPdilPasca?.nik = value;
                                                break;
                                              case 7:
                                                _currentPdilPasca?.npwp = value;
                                                break;
                                              case 8:
                                                _currentPdilPasca?.email = value;
                                                break;
                                              case 9:
                                                _currentPdilPasca?.catatan = value;
                                                break;
                                            }
                                            if (_originalPdilPasca != null && index != 0) {
                                              if (!_originalPdilPasca!.compareTo(_currentPdilPasca, isIgnoreIdpel: true)) {
                                                context.read<FabBloc>().add(ShowFab());
                                              } else {
                                                context.read<FabBloc>().add(HideFab());
                                              }
                                            }
                                          } else if (!_isPasca) {
                                            switch (index) {
                                              case 0:
                                                // _previousPdil?.idPel = value;
                                                _pdilBloc.add(FetchPdil(idPel: _prefixIdPelPra ?? '' + value, isContinuingSearch: true, isPasca: _isPasca));
                                                break;
                                              case 1:
                                                _currentPdilPra?.noMeter = value;
                                                break;
                                              case 2:
                                                _currentPdilPra?.nama = value;
                                                break;
                                              case 3:
                                                _currentPdilPra?.alamat = value;
                                                break;
                                              case 4:
                                                _currentPdilPra?.tarip = value;
                                                break;
                                              case 5:
                                                _currentPdilPra?.daya = value;
                                                break;
                                              case 6:
                                                _currentPdilPra?.noHp = value;
                                                break;
                                              case 7:
                                                _currentPdilPra?.nik = value;
                                                break;
                                              case 8:
                                                _currentPdilPra?.npwp = value;
                                                break;
                                              case 9:
                                                _currentPdilPra?.email = value;
                                                break;
                                              case 10:
                                                _currentPdilPra?.catatan = value;
                                                break;
                                            }
                                            if (_originalPdilPra != null && index != 0) {
                                              if (!_originalPdilPra!.compareTo(_currentPdilPra, isIgnoreIdpel: true)) {
                                                context.read<FabBloc>().add(ShowFab());
                                              } else {
                                                context.read<FabBloc>().add(HideFab());
                                              }
                                            }
                                          }
                                        },
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

  _dialogSaveChanges(BuildContext context, FontSizeResult stateFontSize) async {
    await showDialog(
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
              NavigationHelper.back();
            },
            child: Text('Buang', style: stateFontSize.body1),
          ),
          TextButton(
            onPressed: () {
              context.read<PdilBloc>().add(UpdatePdil(pdil: _isPasca ? _currentPdilPasca : _currentPdilPra, isUsingSaveDialog: true, isPasca: _isPasca));
              NavigationHelper.back();
            },
            child: Text('Simpan', style: stateFontSize.body1),
          ),
        ],
      ),
    );
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
