part of 'pages.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final List<TextEditingController> controllers = List.generate(
    7,
    (index) => TextEditingController(),
  );

  final TextEditingController idPelController = TextEditingController();

  Pdil currentPdil;
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PdilBloc, PdilState>(
      listener: (_, pdilState) {
        if (pdilState is PdilError) {
          showMySnackBar(context, text: pdilState.message);
        } else if (pdilState is PdilLoaded) {
          isSearch = true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Input Data", style: title24),
          actions: [
            IconButton(
              icon: Icon(Icons.settings, color: whiteColor),
              onPressed: () {
                NavigationHelper.to(MaterialPageRoute(builder: (_) => SettingsPage()));
              },
            ),
            SizedBox(width: 10),
          ],
        ),
        body: Stack(
          children: [
            ListView(
              physics: BouncingScrollPhysics(),
              children: [
                BlocBuilder<InputDataBloc, InputDataState>(builder: (_, state) {
                  if (state is InputDataProgress) {
                    double rasio = (state.progress / 100);
                    if (state.progress < 100) {
                      return AnimatedContainer(
                        duration: Duration(seconds: 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: greyColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  width: MediaQuery.of(context).size.width * 0.45 * rasio,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 5),
                            Text("${state.progress}/100%"),
                          ],
                        ),
                      );
                    } else if (state.progress == 100) return Container();
                  }
                  return Container();
                }),
                SizedBox(height: 10),
                BlocBuilder<PdilBloc, PdilState>(builder: (_, state) {
                  if (state is PdilLoaded && state.data.isKoreksi) {
                    return Column(
                      children: [
                        Center(
                          child: Text(
                            "Data Pernah Di Input !!!",
                            style: title12.copyWith(color: greenColor),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  }
                  return Container();
                }),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                  child: Row(
                    children: [
                      FutureBuilder(
                        future: Future(() async => await ImportServices.getPrefixIdpel()),
                        builder: (_, snap) => CurrentTextField(
                          controller: idPelController,
                          label: "IdPel",
                          width: MediaQuery.of(context).size.width - 110,
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
                          onSubmitted: (text) async {
                            if (idPelController.text.length != 0) {
                              context
                                  .read<PdilBloc>()
                                  .add(FetchPdil(await ImportServices.getPrefixIdpel() + idPelController.text));
                            } else {
                              showMySnackBar(context, text: "IdPel Masih Kosong");
                            }
                          },
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.number,
                          prefixText: snap.data ?? "",
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 45,
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
                              if (idPelController.text.length != 0) {
                                context
                                    .read<PdilBloc>()
                                    .add(FetchPdil(await ImportServices.getPrefixIdpel() + idPelController.text));
                              } else {
                                showMySnackBar(context, text: "IdPel Masih Kosong");
                              }
                            },
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ...List.generate(
                  7,
                  (index) => Padding(
                    padding: EdgeInsets.fromLTRB(25, 10, 25, (index == 6) ? 60 : 0),
                    child: BlocBuilder<PdilBloc, PdilState>(builder: (_, state) {
                      if (state is PdilLoaded) {
                        currentPdil = state.data;
                        controllers[0].text = state.data.nama == "null" ? "" : state.data.nama;
                        controllers[1].text = state.data.alamat == "null" ? "" : state.data.alamat;
                        controllers[2].text = state.data.tarip == "null" ? "" : state.data.tarip;
                        controllers[3].text = state.data.daya == "null" ? "" : state.data.daya;
                        controllers[4].text = state.data.noHp == "null" ? "" : state.data.noHp;
                        controllers[5].text = state.data.nik == "null" ? "" : state.data.nik;
                        controllers[6].text = state.data.npwp == "null" ? "" : state.data.npwp;
                      }
                      return CurrentTextField(
                        label: [
                          'Nama',
                          'Alamat',
                          'Tarif',
                          'Daya',
                          'No Hp',
                          'NIK',
                          'NPWP',
                        ][index],
                        readOnly: [
                          true,
                          true,
                          true,
                          true,
                          false,
                          false,
                          false,
                        ][index],
                        controller: controllers[index],
                        keyboardType: [
                          TextInputType.text,
                          TextInputType.text,
                          TextInputType.text,
                          TextInputType.text,
                          TextInputType.number,
                          TextInputType.number,
                          TextInputType.number,
                        ][index],
                        onSubmitted: (text) {},
                      );
                    }),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(5),
                  color: primaryColor,
                ),
                child: BlocListener<PdilBloc, PdilState>(
                  listener: (_, state) {
                    if (state is PdilOnUpdate) {
                      print("update Count : ${state.count}");
                      if (state.count > 0) {
                        showMySnackBar(context, text: "Data Telah Tersimpan");
                        idPelController.text = "";
                        for (var controller in controllers) {
                          controller.text = "";
                        }
                      }
                    }
                  },
                  child: Material(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (isSearch) {
                          context.read<PdilBloc>().add(UpdatePdil(currentPdil.copyWith(
                                noHp: controllers[4].text,
                                nik: controllers[5].text,
                                npwp: controllers[6].text,
                                isKoreksi: true,
                              )));
                        } else if (!isSearch) {
                          showMySnackBar(context, text: "IdPel Masih Kosong !!!");
                        }
                      },
                      borderRadius: BorderRadius.circular(5),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Simpan Data",
                              style: subtitle16.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
