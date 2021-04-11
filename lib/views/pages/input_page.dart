part of 'pages.dart';

class InputPage extends StatelessWidget {
  final List<TextEditingController> controllers = List.generate(
    8,
    (index) => TextEditingController(),
  );

  final TextEditingController idPelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Data", style: title24),
      ),
      body: Stack(
        children: [
          ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                child: Row(
                  children: [
                    CurrentTextField(
                      controller: idPelController,
                      label: "IdPel",
                      width: MediaQuery.of(context).size.width - 110,
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(5)),
                    ),
                    Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.circular(5)),
                        color: primaryColor,
                      ),
                      child: Material(
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.circular(5)),
                        color: Colors.transparent,
                        child: InkWell(
                          hoverColor: Colors.lightBlue,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(5)),
                          onTap: () {},
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
                8,
                (index) => Padding(
                  padding:
                      EdgeInsets.fromLTRB(25, 10, 25, (index == 7) ? 60 : 0),
                  child: CurrentTextField(
                    label: [
                      'Kode RBM',
                      'Nama',
                      'Alamat',
                      'Tarip',
                      'Daya',
                      'No Hp',
                      'NIK',
                      'NPWP',
                    ][index],
                    enable: [
                      false,
                      false,
                      false,
                      false,
                      false,
                      true,
                      true,
                      true,
                    ][index],
                    controller: controllers[index],
                  ),
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
              child: Material(
                borderRadius: BorderRadius.circular(5),
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
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
        ],
      ),
    );
  }
}
