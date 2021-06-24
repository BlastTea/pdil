part of 'pages.dart';

class PdilSearch extends SearchDelegate {
  List<String>? _historySuggestions = [];

  DbPasca _dbPasca = DbPasca();
  DbPra _dbPra = DbPra();

  bool isJustRemoveHistory = false;

  PdilSearch(FontSizeResult stateFontSize)
      : super(
          searchFieldLabel: 'Idpel, Nama, Alamat',
          searchFieldStyle: stateFontSize.body1!.copyWith(color: greyColor),
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
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        context.read<CustomerDataBloc>().add(FetchCustomerData(searchQuery: query));
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
    List<String?> viewPascas = [];
    List<String?> viewPras = [];
    List<String>? viewHistorys = [];

    return FutureBuilder<List<String>?>(
      future: _futureFetchSelectWhereAll(context: context, viewPascas: viewPascas, viewPras: viewPras),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          viewHistorys = snapshot.data?.where((history) {
            return history.toLowerCase().contains(query.toLowerCase());
          }).toList();
        }
        return _widgetResultSuggestion(
          context: context,
          pascas: viewPascas,
          pras: viewPras,
          history: viewHistorys,
        );
      },
    );
  }

  _widgetResultSuggestion({
    required BuildContext context,
    required List<String?> pascas,
    required List<String?> pras,
    required List<String>? history,
  }) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) {
        if (stateFontSize is FontSizeResult) {
          return BlocBuilder<ImportBloc, ImportState>(
            builder: (_, stateImport) => FutureBuilder<List<String>>(
              future: _fetchForSearchIn(context, stateImport),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (query != '' && query.length > 0)
                          _listView(
                            context: context,
                            stateFontSize: stateFontSize,
                            title: null,
                            data: snapshot.data,
                            isSearchDependsOnField: true,
                          ),
                        if (history != null && history.length > 0)
                          _listView(
                            context: context,
                            stateFontSize: stateFontSize,
                            title: 'Terakhir dicari',
                            data: history.reversed.toList(),
                            isHistory: true,
                          ),
                        if (pascas != null && pascas.length > 0)
                          _listView(
                            context: context,
                            stateFontSize: stateFontSize,
                            title: 'Pascabayar',
                            data: pascas,
                          ),
                        if (pras != null && pras.length > 0)
                          _listView(
                            context: context,
                            stateFontSize: stateFontSize,
                            title: 'Prabayar',
                            data: pras,
                          ),
                      ],
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _listView({
    required BuildContext context,
    required FontSizeResult stateFontSize,
    required String? title,
    required List<String?>? data,
    bool isHistory = false,
    bool isSearchDependsOnField = false,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: stateFontSize.subtitle!.copyWith(color: primaryColor),
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
                        style: stateFontSize.body2!.copyWith(color: redColor),
                      ),
                    )
                ],
              ),
            ),
          ...List.generate(
            _getListViewDataLength(
              context: context,
              data: data,
              isSearchDependsOnField: isSearchDependsOnField,
            ),
            (indexData) => ListTile(
              onTap: () {
                if (!isHistory) {
                  _saveCurrentHistory(context, isSearchDependsOnField ? query : data![indexData]);
                }
                context.read<CustomerDataBloc>().add(
                      FetchCustomerData(
                        searchQuery: isSearchDependsOnField ? query : data![indexData],
                        column: isSearchDependsOnField ? data![indexData] : null,
                      ),
                    );
                close(context, null);
              },
              leading: isHistory ? Icon(Icons.history) : null,
              title: Text(
                !isSearchDependsOnField ? data![indexData]! : query,
                style: stateFontSize.body1,
              ),
              trailing: !isSearchDependsOnField
                  ? IconButton(
                      onPressed: () {
                        query = data![indexData]!;
                      },
                      icon: Transform.rotate(
                        angle: pi / 8,
                        child: Icon(Icons.arrow_back),
                      ),
                    )
                  : Text(
                      'Cari di "${data![indexData]}"',
                      style: stateFontSize.body1!.copyWith(color: greyColor),
                    ),
            ),
          ),
        ],
      );

  int _getListViewDataLength({
    required BuildContext context,
    required List<String?>? data,
    required bool isSearchDependsOnField,
  }) {
    if (isSearchDependsOnField) {
      return data!.length;
    } else if (data!.length > 5) {
      return 5;
    }
    return data.length;
  }

  Future<List<String>> _fetchForSearchIn(BuildContext context, ImportState stateImport) async {
    List<String> searchInSuggestion = [];
    List<bool> searchChecks = List.generate(11, (index) => false);
    List<String> praFields = [
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
    ];
    if (stateImport is ImportBothImported || stateImport is ImportPascabayarImported) {
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
          ][i],
        )
            .then((value) {
          if (value!.length > 0 && value.length != 0) {
            searchChecks[i > 0 ? i + 1 : i] = true;
          }
        });
      }
    }
    if (stateImport is ImportBothImported || stateImport is ImportPrabayarImported) {
      for (int i = 0; i < 11; i++) {
        await _dbPra
            .selectWhereAll(
          query: query,
          column: praFields[i],
        )
            .then((value) {
          if (value!.length > 0 && value.length != 0) {
            searchChecks[i] = true;
          }
        });
      }
    }

    for (int i = 0; i < praFields.length; i++) {
      if (searchChecks[i]) {
        searchInSuggestion.add(praFields[i]);
      }
    }

    return searchInSuggestion;
  }

  Future<List<String>?> _futureFetchSelectWhereAll({
    required BuildContext context,
    required List<String?> viewPascas,
    required List<String?> viewPras,
  }) async {
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
        viewPascas.addAll(value!);
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
        viewPras.addAll(value!);
      });
    }

    return await SearchServices.getCurrentHistorys();
  }

  _saveCurrentHistory(BuildContext context, String? value) {
    if (_historySuggestions == null) {
      SearchServices.saveCurrentHistorys([value!]);
    } else {

      SearchServices.saveCurrentHistorys(_historySuggestions!..add(value!));
    }
  }
}
