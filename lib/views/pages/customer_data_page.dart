part of 'pages.dart';

class CustomerDataPage extends StatefulWidget {
  @override
  _CustomerDataPageState createState() => _CustomerDataPageState();
}

class _CustomerDataPageState extends State<CustomerDataPage> {
  List<bool>? isExpandPascas;
  List<bool>? isExpandPras;
  int loop = 1;
  bool _isPasca = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) {
        if (stateFontSize is FontSizeResult) {
          return BlocBuilder<CustomerDataBloc, CustomerDataState>(
            builder: (_, stateCustomerData) {
              if (stateCustomerData is CustomerDataInitial) {
                context.read<CustomerDataBloc>().add(FetchCustomerData());
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (stateCustomerData is CustomerDataResult) {
                if (stateCustomerData.isSetIxExpandNull) {
                  isExpandPascas = null;
                  isExpandPras = null;
                }
                if (isExpandPascas == null) {
                  isExpandPascas = List.generate(stateCustomerData.pdilPasca?.length ?? 0, (index) => false);
                }
                if (isExpandPras == null) {
                  isExpandPras = List.generate(stateCustomerData.pdilPra?.length ?? 0, (index) => false);
                }
                return CusScrollFold(
                  isCustomerDataPage: true,
                  myToggleButton: MyToggleButton(
                      toggleButtonSlot: ToggleButtonSlot.showData,
                      onTap: (isPasca) {
                        setState(() {
                          _isPasca = isPasca;
                        });
                      }),
                  title: 'Data Pelanggan',
                  action: [
                    IconButton(
                      onPressed: () {
                        showSearch(context: context, delegate: PdilSearch(stateFontSize));
                      },
                      icon: Icon(Icons.search),
                      color: primaryColor,
                    ),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(Icons.filter_alt),
                    //   color: primaryColor,
                    // ),
                    SizedBox(width: defaultPadding),
                  ],
                  children: List.generate(
                    _isPasca ? stateCustomerData.pdilPasca!.length : stateCustomerData.pdilPra!.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.fastOutSlowIn,
                      width: double.infinity,
                      height: _getHeightIsExpand(context, index, stateFontSize),
                      margin: EdgeInsets.fromLTRB(defaultPadding, 15, defaultPadding, _getBottomMargin(context, index, stateCustomerData)),
                      decoration: cardDecoration.copyWith(
                        border: Border.all(color: primaryColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5.0),
                                      ...List.generate(!_isPasca ? 3 : 2, (indexText) {
                                        if (_getIsExpand(context, index)) {
                                          return Row(
                                            children: [
                                              SizedBox(
                                                width: 70 + (stateFontSize.width * (_isPasca ? 3.0 : 5.0)),
                                                child: Text(
                                                  [
                                                    'Idpel',
                                                    _isPasca ? 'Nama' : 'No Meter',
                                                    if (!_isPasca) 'Nama',
                                                  ][indexText],
                                                  style: stateFontSize.body1!.copyWith(color: greyColor),
                                                ),
                                              ),
                                              Text(
                                                ' : ',
                                                style: stateFontSize.body1!.copyWith(color: greyColor),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width * (_isPasca ? 0.3 : 0.299),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(
                                                    [
                                                      _isPasca ? stateCustomerData.pdilPasca![index].idPel : stateCustomerData.pdilPra![index].idPel,
                                                      _isPasca ? stateCustomerData.pdilPasca![index].nama : stateCustomerData.pdilPra![index].noMeter,
                                                      if (!_isPasca) stateCustomerData.pdilPra![index].nama,
                                                    ][indexText]!,
                                                    style: stateFontSize.body1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          if (_isPasca) {
                                            return SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.5,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Text(
                                                  [
                                                    stateCustomerData.pdilPasca![index].idPel,
                                                    stateCustomerData.pdilPasca![index].nama,
                                                  ][indexText]!,
                                                  style: stateFontSize.body1,
                                                ),
                                              ),
                                            );
                                          } else if (!_isPasca) {
                                            return SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.615,
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  [
                                                    stateCustomerData.pdilPra![index].idPel,
                                                    stateCustomerData.pdilPra![index].noMeter,
                                                    stateCustomerData.pdilPra![index].nama,
                                                  ][indexText]!,
                                                  style: stateFontSize.body1,
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                        return Container();
                                      })
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        child: IconButton(
                                          onPressed: () {
                                            ToggleButtonServices.saveInputData(_isPasca);
                                            context.read<PdilBloc>().add(
                                                  FetchPdil(
                                                    idPel: _isPasca ? stateCustomerData.pdilPasca![index].idPel : stateCustomerData.pdilPra![index].idPel,
                                                    isFromCustomerData: true,
                                                    isPasca: _isPasca,
                                                  ),
                                                );
                                            context.read<BottomNavigationBloc>()..add(ChangeCurrentNav(1));
                                          },
                                          icon: Icon(Icons.edit),
                                        ),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: ExpandIcon(
                                          color: primaryColor,
                                          isExpanded: _getIsExpand(context, index),
                                          onPressed: (newValue) {
                                            setState(() {
                                              if (_isPasca) {
                                                print('expand Pasca');
                                                isExpandPascas![index] = !isExpandPascas![index];
                                              } else {
                                                print('expand Pra');
                                                isExpandPras![index] = !isExpandPras![index];
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (_getIsExpand(context, index))
                                ...List.generate(
                                  8,
                                  (indexFuture) => Row(
                                    children: [
                                      SizedBox(
                                        width: 70 + (stateFontSize.width * (_isPasca ? 3.0 : 5.0)),
                                        child: Text(
                                          [
                                            'Alamat',
                                            'Tarif',
                                            'Daya',
                                            'No Hp',
                                            'Nik',
                                            'Npwp',
                                            'Email',
                                            'Catatan',
                                          ][indexFuture],
                                          style: stateFontSize.body1!.copyWith(color: greyColor),
                                        ),
                                      ),
                                      Text(
                                        ' : ',
                                        style: stateFontSize.body1!.copyWith(
                                          color: greyColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            [
                                              _isPasca ? stateCustomerData.pdilPasca![index].alamat ?? '' : stateCustomerData.pdilPra![index].alamat ?? '',
                                              _isPasca ? stateCustomerData.pdilPasca![index].tarip ?? '' : stateCustomerData.pdilPra![index].tarip ?? '',
                                              _isPasca ? stateCustomerData.pdilPasca![index].daya ?? '' : stateCustomerData.pdilPra![index].daya ?? '',
                                              _isPasca ? stateCustomerData.pdilPasca![index].noHp ?? '' : stateCustomerData.pdilPra![index].noHp ?? '',
                                              _isPasca ? stateCustomerData.pdilPasca![index].nik ?? '' : stateCustomerData.pdilPra![index].nik ?? '',
                                              _isPasca ? stateCustomerData.pdilPasca![index].npwp ?? '' : stateCustomerData.pdilPra![index].npwp ?? '',
                                              _isPasca ? stateCustomerData.pdilPasca![index].email ?? '' : stateCustomerData.pdilPra![index].email ?? '',
                                              _isPasca ? stateCustomerData.pdilPasca![index].catatan ?? '' : stateCustomerData.pdilPra![index].catatan ?? '',
                                            ][indexFuture],
                                            style: stateFontSize.body1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
          );
        }
        return Container();
      },
    );
  }

  double _getHeightIsExpand(BuildContext context, int index, FontSizeResult stateFontSize, {bool isIgnoreExpanded = false}) {
    if (_getIsExpand(context, index) && !isIgnoreExpanded) {
      if (_isPasca) {
        return 225 + (stateFontSize.width * 14);
      }

      return 250 + (stateFontSize.width * 15);
    } else {
      if (_isPasca) {
        return 50 + (stateFontSize.width * 3) - (isIgnoreExpanded ? 3.0 : 0);
      }

      return 72 + (stateFontSize.width * 5) - (isIgnoreExpanded ? 3.0 : 0);
    }
  }

  bool _getIsExpand(BuildContext context, int index) {
    if (_isPasca) {
      return isExpandPascas![index];
    } else {
      return isExpandPras![index];
    }
  }

  double _getBottomMargin(BuildContext context, int index, CustomerDataResult stateCustomerData) {
    if (_isPasca) {
      if (index == (stateCustomerData.pdilPasca!.length - 1)) {
        return 30.0;
      }
    } else {
      if (index == (stateCustomerData.pdilPra!.length - 1)) {
        return 30.0;
      }
    }
    return 0.0;
  }
}
