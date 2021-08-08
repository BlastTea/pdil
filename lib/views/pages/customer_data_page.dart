part of 'pages.dart';

const double kMinRadius = 50.0;
const double kMaxRadius = 128.0;
const opacityCurve = const Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);

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
                if (stateCustomerData.isSetIsExpandNull) {
                  isExpandPascas = null;
                  isExpandPras = null;
                  context.read<CustomerDataBloc>().add(UpdateIsExpandNull(isSetIsExpandNull: false));
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
                      width: MediaQuery.of(context).size.width,
                      // height: _getHeightIsExpand(context, index, stateFontSize),
                      // height: null,
                      margin: EdgeInsets.fromLTRB(defaultPadding, 15, defaultPadding, _getBottomMargin(context, index, stateCustomerData)),
                      decoration: cardDecoration.copyWith(
                        border: Border.all(color: primaryColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _imageData(context, _isPasca ? stateCustomerData.pdilPasca![index] : stateCustomerData.pdilPra![index], stateFontSize, index),
                                  SizedBox(width: 10.0),
                                  _header(context, stateFontSize, stateCustomerData, index),
                                  _button(context, stateCustomerData, index),
                                ],
                              ),
                              if (_getIsExpand(context, index)) ..._body(context, stateFontSize, stateCustomerData, index)
                            ],
                          ),

                          // Row(
                          //   children: [
                          //     _imageData(context),
                          //     SizedBox(width: 10.0),
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Row(
                          //           crossAxisAlignment: CrossAxisAlignment.start,
                          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             _header(context, stateFontSize, stateCustomerData, index),
                          //             _button(context, stateCustomerData, index),
                          //           ],
                          //         ),
                          //         if (_getIsExpand(context, index)) ..._body(context, stateFontSize, stateCustomerData, index)
                          //       ],
                          //     ),
                          //   ],
                          // ),
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

  _imageData(BuildContext context, Pdil data, FontSizeResult stateFontSize, int index) {
    File? photoFile;
    if (data.image != "kosong") {
      photoFile = File(data.image!);
    }
    return Container(
      width: kMinRadius,
      height: kMinRadius,
      child: FutureBuilder<bool>(
        future: photoFile?.exists(),
        builder: (_, snapshot) {
          bool? isFileExists = false;

          if (snapshot.hasData || data.image == "kosong") {
            isFileExists = snapshot.data;

            return Hero(
              createRectTween: (begin, end) => RectTween(begin: begin, end: end),
              tag: "detail $index",
              child: RadialExpansion(
                maxRadius: MediaQuery.of(context).size.width * 0.5,
                child: Photo(
                  photo: data.image,
                  isFileExists: isFileExists ?? false,
                  onTap: () => NavigationHelper.to(
                    PageRouteBuilder(
                      barrierColor: Colors.black54,
                      opaque: false,
                      barrierDismissible: true,
                      pageBuilder: (context, animation, secondaryAnimation) => AnimatedBuilder(
                        animation: animation,
                        builder: (_, child) => Opacity(
                          opacity: opacityCurve.transform(animation.value),
                          child: _buildPage(context, data, stateFontSize, index, isFileExists ?? false),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  _buildPage(BuildContext context, Pdil data, FontSizeResult stateFontSize, int index, bool isFileExists) => Center(
        child: Hero(
          createRectTween: (begin, end) => RectTween(begin: begin, end: end),
          tag: "detail $index",
          child: RadialExpansion(
            maxRadius: MediaQuery.of(context).size.width * 0.5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Photo(
                  photo: data.image,
                  isFileExists: isFileExists,
                  // photo: "assets/images/Logo_Pdil.png",
                  onTap: () {},
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 40.0,
                    color: whiteColor,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        child: Icon(Icons.edit),
                        onTap: () {
                          /// Handle Edit the Image
                          _changeImageSheet(context: context, stateFontSize: stateFontSize, data: data, isFileExists: isFileExists);
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );

  _changeImageSheet({required BuildContext context, required FontSizeResult stateFontSize, required Pdil data, required bool isFileExists}) => showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(5.0),
        )),
        builder: (_) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ganti Foto Untuk ${data.nama}", style: stateFontSize.subtitle?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 10.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isFileExists)
                    _changeImageIcon(
                      context: context,
                      name: "Hapus Foto",
                      stateFontSize: stateFontSize,
                      data: data,
                      icon: Icons.delete,
                      color: Colors.red,
                      onPressed: () {
                        context.read<CustomerDataBloc>().add(UpdateImageToDatabase(isPasca: _isPasca, data: data.copyWith(image: "kosong")));
                      },
                    ),
                  _changeImageIcon(
                    context: context,
                    name: "Galeri",
                    stateFontSize: stateFontSize,
                    data: data,
                    icon: Icons.image,
                    onPressed: () async {
                      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        List<Directory>? dir = await getExternalStorageDirectories(type: StorageDirectory.pictures);
                        String path = dir![0].path + "/${data.idPel}(${data.nama?.trim()}).png";
                        image.saveTo(path);
                        context.read<CustomerDataBloc>().add(UpdateImageToDatabase(isPasca: _isPasca, data: data.copyWith(image: path)));
                      }
                    },
                  ),
                  _changeImageIcon(
                    context: context,
                    name: "Kamera",
                    stateFontSize: stateFontSize,
                    data: data,
                    icon: Icons.camera_alt,
                    onPressed: () async {
                      final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                      if (image != null) {
                        List<Directory>? dir = await getExternalStorageDirectories(type: StorageDirectory.pictures);
                        String path = dir![0].path + "/${data.idPel}(${data.nama?.trim()}).png";
                        image.saveTo(path);
                        context.read<CustomerDataBloc>().add(UpdateImageToDatabase(isPasca: _isPasca, data: data.copyWith(image: path)));
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  _changeImageIcon({
    required BuildContext context,
    required String name,
    required FontSizeResult stateFontSize,
    required Pdil data,
    required IconData icon,
    Color? color,
    required VoidCallback onPressed,
  }) =>
      SizedBox(
        width: 100.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: onPressed, icon: Icon(icon, color: color)),
            SizedBox(height: 5.0),
            Text(
              name,
              style: stateFontSize.body1,
            ),
          ],
        ),
      );

  _header(BuildContext context, FontSizeResult stateFontSize, CustomerDataResult stateCustomerData, int index) => SizedBox(
        width: MediaQuery.of(context).size.width - 218,
        child: Column(
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
                      width: MediaQuery.of(context).size.width - ((298 + (_isPasca ? 0 : 14)) + (stateFontSize.width * 4)),
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
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      [
                        stateCustomerData.pdilPasca![index].idPel,
                        stateCustomerData.pdilPasca![index].nama,
                      ][indexText]!,
                      style: stateFontSize.body1,
                    ),
                  );
                } else if (!_isPasca) {
                  return SingleChildScrollView(
                    child: Text(
                      [
                        stateCustomerData.pdilPra![index].idPel,
                        stateCustomerData.pdilPra![index].noMeter,
                        stateCustomerData.pdilPra![index].nama,
                      ][indexText]!,
                      style: stateFontSize.body1,
                    ),
                  );
                }
              }
              return Container();
            })
          ],
        ),
      );

  _button(BuildContext context, CustomerDataResult stateCustomerData, int index) => Row(
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
                    isExpandPascas![index] = !isExpandPascas![index];
                  } else {
                    isExpandPras![index] = !isExpandPras![index];
                  }
                });
              },
            ),
          ),
        ],
      );

  _body(BuildContext context, FontSizeResult stateFontSize, CustomerDataResult stateCustomerData, int index) => List.generate(
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
      );

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

class Photo extends StatelessWidget {
  Photo({
    Key? key,
    required this.photo,
    required this.onTap,
    required this.isFileExists,
  }) : super(key: key);

  final String? photo;
  final VoidCallback onTap;
  final bool isFileExists;

  Widget build(BuildContext context) {
    File? photoFile;
    if (photo != "kosong") {
      photoFile = File(photo!);
    }
    return Material(
      // Slightly opaque color appears where the image has transparency.
      // color: Theme.of(context).primaryColor.withOpacity(0.25),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (_, size) => isFileExists
              ? Image.file(
                  File(photo!),
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  "assets/images/No_Image_Found.png",
                  fit: BoxFit.contain,
                ),
        ),

        // FutureBuilder<int>(
        //   future: photoFile?.length(),
        //   builder: (_, snapshot) {
        //     int fileLength = snapshot.data ?? 0;
        //     if (snapshot.hasError || photo == "kosong") {
        //       return LayoutBuilder(
        //         builder: (BuildContext context, BoxConstraints size) => Image.asset(
        //           "assets/images/No_Image_Found.png",
        //           fit: BoxFit.contain,
        //         ),
        //       );
        //     } else if (snapshot.hasData && (fileLength > 0)) {
        //       return LayoutBuilder(
        //         builder: (BuildContext context, BoxConstraints size) => Image.file(
        //           File(photo!),
        //           // photo!,
        //           fit: BoxFit.contain,
        //         ),
        //       );
        //     }
        //   },
        // ),
      ),
    );
  }
}

class RadialExpansion extends StatelessWidget {
  RadialExpansion({
    Key? key,
    required this.maxRadius,
    required this.child,
  })  : clipRectSize = 2.0 * (maxRadius / sqrt2),
        super(key: key);

  final double maxRadius;
  final clipRectSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Center(
        child: SizedBox(
          width: clipRectSize,
          height: clipRectSize,
          child: ClipRect(
            child: child,
          ),
        ),
      ),
    );
  }
}
