part of 'pages.dart';

class PdilSearch extends SearchDelegate {
  List<String> _historySuggestions = [];

  DbPasca _dbPasca = DbPasca();
  DbPra _dbPra = DbPra();

  bool isJustRemoveHistory = false;

  PdilSearch(FontSizeResult stateFontSize)
      : super(
          searchFieldLabel: 'Idpel, Nama, Alamat',
          searchFieldStyle: stateFontSize.body1.copyWith(color: greyColor),
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (!isJustRemoveHistory) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _saveCurrentHistory(context, query);
        close(context, null);
      });
      isJustRemoveHistory = false;
    }
    return _buildResultAndSuggestion(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResultAndSuggestion(context);
  }

  _buildResultAndSuggestion(BuildContext context) {
    List<String> viewPascas = [];
    List<String> viewPras = [];
    List<String> viewHistorys = [];

    return FutureBuilder<bool>(
      future: _futureFetchSelectWhereAll(context: context, viewPascas: viewPascas, viewPras: viewPras),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          viewHistorys = _historySuggestions.where((history) {
            return history.toLowerCase().contains(query.toLowerCase());
          }).toList();

          return _widgetResultSuggestion(
            context: context,
            pascas: viewPascas,
            pras: viewPras,
            history: viewHistorys,
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _widgetResultSuggestion({
    @required BuildContext context,
    @required List<String> pascas,
    @required List<String> pras,
    @required List<String> history,
  }) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) {
        if (stateFontSize is FontSizeResult) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (history != null && history.length > 0)
                  ..._listView(
                    context: context,
                    stateFontSize: stateFontSize,
                    title: 'Terakhir dicari',
                    data: history.reversed.toList(),
                    isHistory: true,
                  ),
                if (pascas != null && pascas.length > 0)
                  ..._listView(
                    context: context,
                    stateFontSize: stateFontSize,
                    title: 'Pascabayar',
                    data: pras,
                  ),
                if (pras != null && pras.length > 0)
                  ..._listView(
                    context: context,
                    stateFontSize: stateFontSize,
                    title: 'Prabayar',
                    data: pras,
                  ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  List<Widget> _listView({
    @required BuildContext context,
    @required FontSizeResult stateFontSize,
    @required String title,
    @required List<String> data,
    bool isHistory = false,
  }) =>
      [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: stateFontSize.subtitle.copyWith(color: primaryColor),
              ),
              if (isHistory)
                TextButton(
                  onPressed: () async {
                    await SearchServices.removeCurrentHistorys();
                    isJustRemoveHistory = true;
                    showResults(context);
                  },
                  child: Text(
                    'Hapus Semua',
                    style: stateFontSize.body2.copyWith(color: redColor),
                  ),
                )
            ],
          ),
        ),
        ...List.generate(
          data.length > 5 ? 5 : data.length,
          (indexData) => ListTile(
            onTap: () {
              if (!isHistory) {
                _saveCurrentHistory(context, data[indexData]);
              }
              close(context, null);
            },
            leading: isHistory ? Icon(Icons.history) : null,
            title: Text(
              data[indexData],
              style: stateFontSize.body1,
            ),
            trailing: IconButton(
              onPressed: () {
                query = data[indexData];
              },
              icon: Transform.rotate(
                angle: pi / 8,
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
        ),
      ];

  Future<bool> _futureFetchSelectWhereAll({@required BuildContext context, @required List<String> viewPascas, @required List<String> viewPras}) async {
    for (int i = 0; i < 10; i++) {
      await _dbPasca
          .selectWhereAll(
              query: query,
              column: [
                columnIdPel,
                columnNama,
                columnAlamat,
                columnTarip,
                columnDaya,
                columnNoHp,
                columnNik,
                columnNpwp,
                columnEmail,
                columnCatatan,
              ][i])
          .then((value) {
        viewPascas.addAll(value);
      });
    }

    for (int i = 0; i < 11; i++) {
      await _dbPra
          .selectWhereAll(
              query: query,
              column: [
                columnIdPel,
                columnNoMeter,
                columnNama,
                columnAlamat,
                columnTarip,
                columnDaya,
                columnNoHp,
                columnNik,
                columnNpwp,
                columnEmail,
                columnCatatan,
              ][i])
          .then((value) {
        viewPras.addAll(value);
      });
    }

    _historySuggestions = await SearchServices.getCurrentHistorys();
    return true;
  }

  _saveCurrentHistory(BuildContext context, String value) {
    if (_historySuggestions == null) {
      SearchServices.saveCurrentHistorys([value]);
    } else {
      SearchServices.saveCurrentHistorys(_historySuggestions..add(value));
    }
    context.read<CustomerDataBloc>().add(FetchCustomerData(searchQuery: value));
  }
}
