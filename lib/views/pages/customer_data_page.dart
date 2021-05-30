part of 'pages.dart';

class CustomerDataPage extends StatefulWidget {
  @override
  _CustomerDataPageState createState() => _CustomerDataPageState();
}

class _CustomerDataPageState extends State<CustomerDataPage> {
  DbPasca _dbPasca = DbPasca();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) {
        if (stateFontSize is FontSizeResult) {
          return FutureBuilder(
            future: _dbPasca.getPdilList(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                final List<Pdil> _pdils = snapshot.data;
                return CusScrollFold(
                  title: 'Data Pelanggan',
                  action: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search),
                      color: primaryColor,
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt), color: primaryColor),
                    SizedBox(width: defaultPadding),
                  ],
                  children: List.generate(
                    _pdils.length,
                    (index) => Container(
                      width: double.infinity,
                      height: 50,
                      margin:
                          EdgeInsets.fromLTRB(defaultPadding, 15, defaultPadding, index == _pdils.length - 1 ? 30 : 0),
                      decoration: cardDecoration.copyWith(
                        border: Border.all(color: primaryColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${_pdils[index].idPel}', style: stateFontSize.body1),
                            Text('${_pdils[index].nama}', style: stateFontSize.body1),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
