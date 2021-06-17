part of 'pages.dart';

class InputPage extends StatefulWidget {
  InputPage({Key key}) : super(key: key);

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    10,
    (index) => TextEditingController(),
  );

  Pdil _currentPdil;
  Pdil _previousPdil;
  Pdil _comparePdil;

  bool _isSearch = false;
  bool _isSaved = true;
  bool _isChangingPage = false;
  bool _isPasca = true;

  Stopwatch _stopwatchProgress = Stopwatch();

  String _prefixIdPel;

  PdilBloc _pdilBloc;

  @override
  void dispose() {
    _pdilBloc.add(UpdatePdilController(
      previousPdil: _previousPdil,
      currentPdil: _currentPdil,
      comparePdil: _comparePdil,
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _secondVersion(context);

    // return BlocBuilder<FontSizeBloc, FontSizeState>(
    //   builder: (_, stateFontSize) => (stateFontSize is FontSizeResult)
    //       ? BlocListener<PdilBloc, PdilState>(
    //           listener: (_, pdilState) async {
    //             if (pdilState is PdilError && !pdilState.isContinuingSearch) {
    //               showMySnackBar(context, text: pdilState.message);
    //             } else if (pdilState is PdilLoaded) {
    //               _isSearch = true;
    //               if (!_isSaved) {
    //                 await showDialog(
    //                   useRootNavigator: true,
    //                   context: context,
    //                   builder: (_) => AlertDialog(
    //                     title: Text("Simpan Perubahan ?",
    //                         style: stateFontSize.title.copyWith(color: blackColor, fontWeight: FontWeight.w600)),
    //                     actions: [
    //                       TextButton(
    //                         onPressed: () {
    //                           _isSaved = true;
    //                           NavigationHelper.back();
    //                           _controllers[4].text = pdilState.data.noHp == null ? "" : pdilState.data.noHp;
    //                           _controllers[5].text = pdilState.data.nik == null ? "" : pdilState.data.nik;
    //                           _controllers[6].text = pdilState.data.npwp == null ? "" : pdilState.data.npwp;
    //                           _controllers[7].text = pdilState.data.catatan == null ? "" : pdilState.data.catatan;
    //                           context.read<PdilBloc>().add(UpdatePdil(
    //                                 _pdilBefore.copyWith(
    //                                   isKoreksi: true,
    //                                   tanggalBaca: currentTime(),
    //                                 ),
    //                                 true,
    //                               ));
    //                         },
    //                         child: Text(
    //                           "Simpan",
    //                           style: stateFontSize.body,
    //                         ),
    //                       ),
    //                       TextButton(
    //                         onPressed: () {
    //                           NavigationHelper.back();
    //                         },
    //                         child: Text(
    //                           "Buang",
    //                           style: stateFontSize.body,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 );
    //               }
    //               _pdilBefore = pdilState.data;
    //             } else if (pdilState is PdilOnUpdate) {
    //               if (pdilState.count > 0) {
    //                 showMySnackBar(context, text: "Data Telah Tersimpan");
    //                 if (!pdilState.isUsingSaveDialog) {
    //                   _idPelController.text = "";
    //                   for (var controller in _controllers) {
    //                     controller.text = "";
    //                   }
    //                 }
    //               }
    //             }
    //           },
    //           child: Scaffold(
    //             appBar: AppBar(
    //               title: Text("Input Data",
    //                   style: stateFontSize.title.copyWith(color: whiteColor, fontWeight: FontWeight.w600)),
    //               actions: [
    //                 IconButton(
    //                   icon: Icon(Icons.settings, color: whiteColor),
    //                   onPressed: () {
    //                     _isChangingPage = true;
    //                     PageStorage.of(context).writeState(
    //                         context, Changing(_currentPdil, _pdilBefore, _isSaved, _isChangingPage),
    //                         identifier: 'changing');
    //                     NavigationHelper.to(MaterialPageRoute(builder: (_) => SettingsPage()));
    //                   },
    //                 ),
    //                 SizedBox(width: 10),
    //               ],
    //             ),
    //             body: Stack(
    //               children: [
    //                 ListView(
    //                   physics: BouncingScrollPhysics(),
    //                   children: [
    //                     BlocBuilder<InputDataBloc, InputDataState>(builder: (_, state) {
    //                       if (state is InputDataProgress) {
    //                         double rasio = (state.progress / 100);
    //                         if (state.progress < 100) {
    //                           if (!_stopwatchProgress.isRunning) _stopwatchProgress.start();
    //                           return Column(
    //                             children: [
    //                               SizedBox(height: 10),
    //                               Row(
    //                                 mainAxisAlignment: MainAxisAlignment.center,
    //                                 children: [
    //                                   Stack(
    //                                     children: [
    //                                       Container(
    //                                         width: MediaQuery.of(context).size.width * 0.45,
    //                                         height: 10,
    //                                         decoration: BoxDecoration(
    //                                           color: greyColor,
    //                                           borderRadius: BorderRadius.circular(5),
    //                                         ),
    //                                       ),
    //                                       AnimatedContainer(
    //                                         duration: Duration(milliseconds: 500),
    //                                         width: MediaQuery.of(context).size.width * 0.45 * rasio,
    //                                         height: 10,
    //                                         decoration: BoxDecoration(
    //                                           color: state.progress < 30
    //                                               ? redColor
    //                                               : state.progress < 60
    //                                                   ? yellowColor
    //                                                   : greenColor,
    //                                           borderRadius: BorderRadius.circular(5),
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                   SizedBox(width: 5),
    //                                   Text("${state.progress}/100%"),
    //                                 ],
    //                               ),
    //                             ],
    //                           );
    //                         } else if (state.progress == 100) {
    //                           _stopwatchProgress.stop();
    //                           print("import time : ${_stopwatchProgress.elapsedMilliseconds} ms");
    //                           return Container();
    //                         }
    //                       }
    //                       return Container();
    //                     }),
    //                     SizedBox(height: 10),
    //                     BlocBuilder<PdilBloc, PdilState>(builder: (_, state) {
    //                       if (state is PdilLoaded && state.data.isKoreksi) {
    //                         return Column(
    //                           children: [
    //                             Center(
    //                               child: Text(
    //                                 "Data Pernah Di Input !!!",
    //                                 style: stateFontSize.body.copyWith(color: greenColor),
    //                               ),
    //                             ),
    //                             SizedBox(height: 10),
    //                           ],
    //                         );
    //                       }
    //                       return Container();
    //                     }),
    //                     Padding(
    //                       padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
    //                       child: Row(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           FutureBuilder(
    //                             future: Future(() async => _prefixIdPel = await ImportServices.getPrefixIdpel()),
    //                             builder: (_, snap) => CurrentTextField(
    //                               controller: _idPelController,
    //                               label: "IdPel",
    //                               width: MediaQuery.of(context).size.width - 110,
    //                               borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
    //                               onSubmitted: (text) {
    //                                 if (_idPelController.text.length != 0) {
    //                                   context.read<PdilBloc>().add(FetchPdil(_prefixIdPel + _idPelController.text));
    //                                 } else {
    //                                   showMySnackBar(context, text: "IdPel Masih Kosong");
    //                                 }
    //                               },
    //                               onChanged: (text) {
    //                                 context
    //                                     .read<PdilBloc>()
    //                                     .add(FetchPdil(_prefixIdPel + _idPelController.text, isContinuingSearch: true));
    //                               },
    //                               textInputAction: TextInputAction.search,
    //                               keyboardType: TextInputType.number,
    //                               prefixText: snap.data ?? "",
    //                               padding: const EdgeInsets.fromLTRB(10, 24, 10, 0),
    //                               prefixIcon: Icon(Icons.people_alt),
    //                             ),
    //                           ),
    //                           Container(
    //                             width: 60,
    //                             height: 40 + (stateFontSize.title.fontSize - 20),
    //                             decoration: BoxDecoration(
    //                               borderRadius: BorderRadius.horizontal(right: Radius.circular(5)),
    //                               color: primaryColor,
    //                             ),
    //                             child: Material(
    //                               borderRadius: BorderRadius.horizontal(right: Radius.circular(5)),
    //                               color: Colors.transparent,
    //                               child: InkWell(
    //                                 hoverColor: Colors.lightBlue,
    //                                 borderRadius: BorderRadius.horizontal(right: Radius.circular(5)),
    //                                 onTap: () {
    //                                   if (_idPelController.text.length != 0) {
    //                                     context.read<PdilBloc>().add(FetchPdil(_prefixIdPel + _idPelController.text));
    //                                   } else {
    //                                     showMySnackBar(context, text: "IdPel Masih Kosong");
    //                                   }
    //                                 },
    //                                 child: Icon(
    //                                   Icons.search,
    //                                   color: Colors.white,
    //                                   size: stateFontSize.title.fontSize + 4,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     ...List.generate(
    //                       8,
    //                       (index) => Padding(
    //                         padding: EdgeInsets.fromLTRB(25, 10, 25, index == 7 ? 60 : 0),
    //                         child: BlocBuilder<PdilBloc, PdilState>(builder: (_, state) {
    //                           if (state is PdilLoaded) {
    //                             WidgetsBinding.instance.addPostFrameCallback((_) {
    //                               _currentPdil = state.data;
    //                               _controllers[0].text = state.data.nama == null ? "" : state.data.nama;
    //                               _controllers[1].text = state.data.alamat == null ? "" : state.data.alamat;
    //                               _controllers[2].text = state.data.tarip == null ? "" : state.data.tarip;
    //                               _controllers[3].text = state.data.daya == null ? "" : state.data.daya;
    //                               _controllers[4].text = state.data.noHp == null ? "" : state.data.noHp;
    //                               _controllers[5].text = state.data.nik == null ? "" : state.data.nik;
    //                               _controllers[6].text = state.data.npwp == null ? "" : state.data.npwp;
    //                               _controllers[7].text = state.data.catatan == null ? "" : state.data.catatan;

    //                               Changing value = PageStorage.of(context).readState(context, identifier: 'changing');
    //                               if (value != null && value.isChanging) {
    //                                 print('changing No Hp : ${value.pdilBefore.noHp}');
    //                                 _isChangingPage = value.isChanging;
    //                                 _currentPdil = value.currentPdil;
    //                                 _pdilBefore = value.pdilBefore;
    //                                 _isSaved = value.isSaved;
    //                                 _idPelController.text = value.pdilBefore.idPel.substring(5);
    //                                 _controllers[0].text = value.pdilBefore.nama == null ? "" : value.pdilBefore.nama;
    //                                 _controllers[1].text =
    //                                     value.pdilBefore.alamat == null ? "" : value.pdilBefore.alamat;
    //                                 _controllers[2].text = value.pdilBefore.tarip == null ? "" : value.pdilBefore.tarip;
    //                                 _controllers[3].text = value.pdilBefore.daya == null ? "" : value.pdilBefore.daya;
    //                                 _controllers[4].text = value.pdilBefore.noHp == null ? "" : value.pdilBefore.noHp;
    //                                 _controllers[5].text = value.pdilBefore.nik == null ? "" : value.pdilBefore.nik;
    //                                 _controllers[6].text = value.pdilBefore.npwp == null ? "" : value.pdilBefore.npwp;
    //                                 _controllers[7].text =
    //                                     value.pdilBefore.catatan == null ? "" : value.pdilBefore.catatan;
    //                                 _isChangingPage = false;
    //                               }
    //                             });
    //                           }
    //                           return CurrentTextField(
    //                             label: [
    //                               'Nama',
    //                               'Alamat',
    //                               'Tarif',
    //                               'Daya',
    //                               'No Hp',
    //                               'NIK',
    //                               'NPWP',
    //                               'CATATAN',
    //                             ][index],
    //                             readOnly: [
    //                               true,
    //                               true,
    //                               true,
    //                               true,
    //                               false,
    //                               false,
    //                               false,
    //                               false,
    //                             ][index],
    //                             controller: _controllers[index],
    //                             keyboardType: [
    //                               TextInputType.text,
    //                               TextInputType.text,
    //                               TextInputType.text,
    //                               TextInputType.text,
    //                               TextInputType.number,
    //                               TextInputType.number,
    //                               TextInputType.number,
    //                               TextInputType.text,
    //                             ][index],
    //                             padding: index == 7 ? const EdgeInsets.all(8.0) : null,
    //                             onSubmitted: (text) {},
    //                             onChanged: (text) {
    //                               if (_isSearch) {
    //                                 _isSaved = false;
    //                               }
    //                               if (index >= 4 && index <= 7) {
    //                                 print('onChanged : $index');
    //                                 _pdilBefore = _pdilBefore.copyWith(
    //                                   noHp: _controllers[4].text,
    //                                   nik: _controllers[5].text,
    //                                   npwp: _controllers[6].text,
    //                                   catatan: _controllers[7].text,
    //                                 );
    //                               }
    //                             },
    //                             expands: index == 7,
    //                             height: index == 7 ? 160 : null,
    //                             maxLines: index == 7 ? null : 1,
    //                           );
    //                         }),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Align(
    //                   alignment: Alignment.bottomCenter,
    //                   child: Container(
    //                     width: MediaQuery.of(context).size.width,
    //                     height: 40 + (stateFontSize.title.fontSize - 20),
    //                     margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadiusDirectional.circular(5),
    //                       color: primaryColor,
    //                     ),
    //                     child: Material(
    //                       borderRadius: BorderRadius.circular(5),
    //                       color: Colors.transparent,
    //                       child: InkWell(
    //                         onTap: () {
    //                           if (_isSearch) {
    //                             _isSaved = true;
    //                             _isSearch = false;
    //                             context.read<PdilBloc>().add(UpdatePdil(
    //                                   _currentPdil.copyWith(
    //                                     noHp: _controllers[4].text,
    //                                     nik: _controllers[5].text,
    //                                     npwp: _controllers[6].text,
    //                                     catatan: _controllers[7].text,
    //                                     isKoreksi: true,
    //                                     tanggalBaca: currentTime(),
    //                                   ),
    //                                   false,
    //                                 ));
    //                           } else if (!_isSearch) {
    //                             showMySnackBar(context, text: "IdPel Masih Kosong !!!");
    //                           }
    //                         },
    //                         borderRadius: BorderRadius.circular(5),
    //                         child: Center(
    //                           child: Row(
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: [
    //                               Icon(
    //                                 Icons.save,
    //                                 color: Colors.white,
    //                                 size: stateFontSize.title.fontSize + 4,
    //                               ),
    //                               SizedBox(width: 5),
    //                               Text(
    //                                 "Simpan Data",
    //                                 style: stateFontSize.subtitle.copyWith(
    //                                   color: Colors.white,
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         )
    //       : Container(),
    // );
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
                  if(_isPasca) {
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
                  _isSaved = true;
                  context.read<PdilBloc>().add(UpdatePdil(_previousPdil, false));
                }
              },
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(height: 10),
                    MyToggleButton(
                      toggleButtonSlot: ToggleButtonSlot.inputData,
                      onTap: (isPasca) {
                        _isPasca = isPasca;
                        InputService.saveInputPageState(_isPasca);
                      },
                    ),
                    ...List.generate(
                      10,
                      (index) => Padding(
                        padding: EdgeInsets.fromLTRB(defaultPadding, 10, defaultPadding, index == 9 ? 80 : 0),
                        child: FutureBuilder<String>(
                          future: ImportServices.getPrefixIdpel(),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              _prefixIdPel = snapshot.data;
                              return BlocBuilder<PdilBloc, PdilState>(
                                builder: (_, pdilState) {
                                  if (pdilState is PdilLoaded) {
                                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                      // set data ke currentTextField
                                      _currentPdil = pdilState.data;
                                      if (pdilState.isFromCustomerData) {
                                        _controllers[0].text = pdilState.data.idPel.substring(5);
                                        _comparePdil = pdilState.data.copyWith();
                                        _previousPdil = pdilState.data.copyWith();
                                      } else if (pdilState.isContinousSearch) {
                                        _comparePdil = pdilState.data.copyWith();
                                        _previousPdil = pdilState.data.copyWith();
                                      }
                                      _controllers[1].text = pdilState.data.nama;
                                      _controllers[2].text = pdilState.data.alamat;
                                      _controllers[3].text = pdilState.data.tarip;
                                      _controllers[4].text = pdilState.data.daya;
                                      _controllers[5].text = pdilState.data.noHp;
                                      _controllers[6].text = pdilState.data.nik;
                                      _controllers[7].text = pdilState.data.npwp;
                                      _controllers[8].text = pdilState.data.email;
                                      _controllers[9].text = pdilState.data.catatan;
                                    });
                                    _isSearch = true;
                                  } else if (pdilState is PdilClearedState) {
                                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                      _currentPdil = null;
                                      _comparePdil = null;
                                      _previousPdil = null;

                                      _controllers.forEach((controller) {
                                        controller.text = '';
                                      });
                                    });
                                  } else if (pdilState is UpdatedPdilController) {
                                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                      _comparePdil = pdilState.comparePdil;
                                      _currentPdil = pdilState.currentPdil;
                                      _previousPdil = pdilState.previousPdil;
                                      _controllers[0].text = pdilState.previousPdil?.idPel?.substring(5);
                                      _controllers[1].text = pdilState.previousPdil?.nama;
                                      _controllers[2].text = pdilState.previousPdil?.alamat;
                                      _controllers[3].text = pdilState.previousPdil?.tarip;
                                      _controllers[4].text = pdilState.previousPdil?.daya;
                                      _controllers[5].text = pdilState.previousPdil?.noHp;
                                      _controllers[6].text = pdilState.previousPdil?.nik;
                                      _controllers[7].text = pdilState.previousPdil?.npwp;
                                      _controllers[8].text = pdilState.previousPdil?.email;
                                      _controllers[9].text = pdilState.previousPdil?.catatan;
                                    });
                                  }
                                  return CurrentTextField(
                                    isInputPage: true,
                                    controller: _controllers[index],
                                    // width: MediaQuery.of(context).size.width - 110,
                                    padding: index == 0
                                        ? const EdgeInsets.fromLTRB(10, 24, 10, 0)
                                        : index == 9
                                            ? const EdgeInsets.all(15)
                                            : const EdgeInsets.symmetric(horizontal: 15),
                                    keyboardType: [
                                      TextInputType.number,
                                      TextInputType.text,
                                      TextInputType.text,
                                      TextInputType.text,
                                      TextInputType.text,
                                      TextInputType.number,
                                      TextInputType.number,
                                      TextInputType.number,
                                      TextInputType.emailAddress,
                                      TextInputType.text,
                                    ][index],
                                    label: [
                                      'IdPel',
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
                                      true,
                                      true,
                                      true,
                                      true,
                                      false,
                                      false,
                                      false,
                                      false,
                                      false,
                                      false,
                                    ][index],
                                    prefixText: index == 0 ? snapshot.data : null,
                                    prefixIcon: index == 0 ? Icon(Icons.people_alt) : null,
                                    height: index == 9 ? 160 : null,
                                    expands: index == 9,
                                    maxLines: index == 9
                                        ? index == 0
                                            ? 12
                                            : null
                                        : 1,
                                    onCancelTap: index == 0
                                        ? () {
                                            if (_comparePdil != null) {
                                              if (_comparePdil.compareTo(_previousPdil, isIgnoreIdpel: true)) {
                                                _pdilBloc.add(ClearPdilState());
                                              } else {
                                                _dialogSaveChanges(context, stateFontSize);
                                              }
                                            }
                                          }
                                        : null,
                                    onChanged: (value) {
                                      switch (index) {
                                        case 0:
                                          // _previousPdil?.idPel = value;
                                          _pdilBloc.add(FetchPdil(_prefixIdPel + value, isContinuingSearch: true));
                                          break;
                                        case 1:
                                          _previousPdil?.nama = value;
                                          break;
                                        case 2:
                                          _previousPdil?.alamat = value;
                                          break;
                                        case 3:
                                          _previousPdil?.tarip = value;
                                          break;
                                        case 4:
                                          _previousPdil?.daya = value;
                                          break;
                                        case 5:
                                          _previousPdil?.noHp = value;
                                          break;
                                        case 6:
                                          _previousPdil?.nik = value;
                                          break;
                                        case 7:
                                          _previousPdil?.npwp = value;
                                          break;
                                        case 8:
                                          _previousPdil?.email = value;
                                          break;
                                        case 9:
                                          _previousPdil?.catatan = value;
                                          break;
                                      }
                                      if (_comparePdil != null && index != 0) {
                                        if (!_comparePdil.compareTo(_previousPdil, isIgnoreIdpel: true)) {
                                          context.read<FabBloc>().add(ShowFab());
                                        } else {
                                          context.read<FabBloc>().add(HideFab());
                                        }
                                      }
                                    },
                                  );
                                },
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                  ]),
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
          style: stateFontSize.title.copyWith(fontWeight: FontWeight.w600),
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
              _isSaved = true;
              context.read<PdilBloc>().add(UpdatePdil(_previousPdil, true));
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
