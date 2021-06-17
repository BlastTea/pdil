part of 'pages.dart';

class CustomerDataPage extends StatefulWidget {
  @override
  _CustomerDataPageState createState() => _CustomerDataPageState();
}

class _CustomerDataPageState extends State<CustomerDataPage> {
  List<bool> isExpandPascas;
  List<bool> isExpandPras;
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
                if (isExpandPascas == null) {
                  isExpandPascas = List.generate(stateCustomerData.pdilPasca?.length ?? 0, (index) => false);
                }
                if (isExpandPras == null) {
                  List.generate(stateCustomerData.pdilPra?.length ?? 0, (index) => false);
                }
                return CusScrollFold(
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
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.filter_alt),
                      color: primaryColor,
                    ),
                    SizedBox(width: defaultPadding),
                  ],
                  children: List.generate(
                    _isPasca ? stateCustomerData.pdilPasca.length : stateCustomerData.pdilPra.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.fastOutSlowIn,
                      width: double.infinity,
                      height: _getHeightIsExpand(context, index),
                      margin: EdgeInsets.fromLTRB(defaultPadding, 15, defaultPadding, _getBottomMargin(context, index, stateCustomerData)),
                      decoration: cardDecoration.copyWith(
                        border: Border.all(color: primaryColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                                      if (isExpandPascas[index]) {
                                        return SingleChildScrollView(
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 70,
                                                child: Text(
                                                  [
                                                    'Idpel',
                                                    _isPasca ? 'Nama' : 'No Meter',
                                                    if (!_isPasca) 'Nama',
                                                  ][indexText],
                                                  style: stateFontSize.body1.copyWith(color: greyColor),
                                                ),
                                              ),
                                              Text(
                                                ' : ',
                                                style: stateFontSize.body1.copyWith(color: greyColor),
                                              ),
                                              Text(
                                                [
                                                  _isPasca ? stateCustomerData.pdilPasca[index].idPel : stateCustomerData.pdilPra[index].idPel,
                                                  _isPasca ? stateCustomerData.pdilPasca[index].nama : stateCustomerData.pdilPra[index].noMeter,
                                                  if (!_isPasca) stateCustomerData.pdilPra[index].nama,
                                                ][indexText],
                                                style: stateFontSize.body1,
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        if (_isPasca) {
                                          return Text(
                                            [
                                              stateCustomerData.pdilPasca[index].idPel,
                                              stateCustomerData.pdilPasca[index].nama,
                                            ][indexText],
                                            style: stateFontSize.body1,
                                          );
                                        } else if (!_isPasca) {
                                          return FutureBuilder<bool>(
                                            future: Future.delayed(const Duration(milliseconds: 200), () {
                                              return true;
                                            }),
                                            builder: (_, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  [
                                                    stateCustomerData.pdilPra[index].idPel,
                                                    stateCustomerData.pdilPra[index].noMeter,
                                                    stateCustomerData.pdilPra[index].nama,
                                                  ][indexText],
                                                  style: stateFontSize.body1,
                                                );
                                              }
                                              return Container();
                                            },
                                          );
                                        }
                                        // return Text(
                                        //   [
                                        //     _isPasca ? stateCustomerData.pdilPasca[index].idPel : stateCustomerData.pdilPra[index].idPel,
                                        //     _isPasca ? stateCustomerData.pdilPasca[index].nama : stateCustomerData.pdilPra[index].noMeter,
                                        //     if (!_isPasca) stateCustomerData.pdilPra[index].nama,
                                        //   ][indexText],
                                        //   style: stateFontSize.body1,
                                        // );
                                      }
                                    })
                                  ],
                                ),
                                Row(
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: IconButton(
                                        onPressed: () {
                                          context.read<PdilBloc>().add(FetchPdil(stateCustomerData.pdilPasca[index].idPel, isContinuingSearch: true, isFromCustomerData: true));
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
                                            isExpandPascas[index] = !isExpandPascas[index];
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (isExpandPascas[index])
                              ...List.generate(
                                8,
                                (indexFuture) => FutureBuilder<bool>(
                                  future: Future.delayed(const Duration(milliseconds: 200), () {
                                    return true;
                                  }),
                                  builder: (_, snapshot) {
                                    if (snapshot.hasData) {
                                      return Row(
                                        children: [
                                          SizedBox(
                                            width: 70,
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
                                              style: stateFontSize.body1.copyWith(color: greyColor),
                                            ),
                                          ),
                                          Text(
                                            ' : ',
                                            style: stateFontSize.body1.copyWith(
                                              color: greyColor,
                                            ),
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                [
                                                  stateCustomerData.pdilPasca[index].alamat ?? '',
                                                  stateCustomerData.pdilPasca[index].tarip ?? '',
                                                  stateCustomerData.pdilPasca[index].daya ?? '',
                                                  stateCustomerData.pdilPasca[index].noHp ?? '',
                                                  stateCustomerData.pdilPasca[index].nik ?? '',
                                                  stateCustomerData.pdilPasca[index].npwp ?? '',
                                                  stateCustomerData.pdilPasca[index].email ?? '',
                                                  stateCustomerData.pdilPasca[index].catatan ?? '',
                                                ][indexFuture],
                                                style: stateFontSize.body1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return Container();
                                  },
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
        return Container();
      },
    );
  }

  double _getHeightIsExpand(BuildContext context, int index) {
    if (isExpandPascas[index]) {
      if (_isPasca) {
        return 225;
      }

      return 250;
    } else {
      if (_isPasca) {
        return 50;
      }

      return 72;
    }
  }

  bool _getIsExpand(BuildContext context, int index) {
    return isExpandPascas[index];
  }

  double _getBottomMargin(BuildContext context, int index, CustomerDataResult stateCustomerData) {
    if (_isPasca) {
      if (index == (stateCustomerData.pdilPasca.length - 1)) {
        return 30.0;
      }
    } else {
      if (index == (stateCustomerData.pdilPra.length - 1)) {
        return 30.0;
      }
    }
    return 0.0;
  }
}
