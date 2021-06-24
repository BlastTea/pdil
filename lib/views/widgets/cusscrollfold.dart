part of 'widgets.dart';

class CusScrollFold extends StatefulWidget {
  final List<Widget> children;
  final String title;
  final List<Widget>? action;
  final MyToggleButton? myToggleButton;
  final bool isCustomerDataPage;

  CusScrollFold({
    required this.children,
    this.title = '',
    this.action,
    this.myToggleButton,
    required this.isCustomerDataPage,
  });

  @override
  _CusScrollFoldState createState() => _CusScrollFoldState();
}

class _CusScrollFoldState extends State<CusScrollFold> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) {
        if (stateFontSize is FontSizeResult) {
          return BlocBuilder<CustomerDataBloc, CustomerDataState>(
            builder: (_, stateCustomerData) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    backgroundColor: Color(0xFFF1F5FF),
                    flexibleSpace: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(left: defaultPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.title,
                                style: stateFontSize.title!.copyWith(color: primaryColor),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            if (widget.myToggleButton != null) widget.myToggleButton!,
                            if (stateCustomerData is CustomerDataResult && stateCustomerData.searchResult != null && widget.isCustomerDataPage) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Hasil Pencarian untuk "${stateCustomerData.searchResult}" ' + _getColumnCustomerData(context, stateCustomerData)),
                                  TextButton(
                                    onPressed: () {
                                      context.read<CustomerDataBloc>().add(FetchCustomerData());
                                    },
                                    child: Text(
                                      'Batal',
                                      style: stateFontSize.body2!.copyWith(color: primaryColor),
                                    ),
                                  )
                                ],
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      Row(
                        crossAxisAlignment: widget.myToggleButton != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                        children: widget.action ?? [Container()],
                      ),
                    ],
                    toolbarHeight: _getToolbarHeight(context, stateCustomerData),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      widget.children,
                    ),
                  ),
                ],
              );
            },
          );
        }
        return Container();
      },
    );
  }

  double _getToolbarHeight(BuildContext context, CustomerDataState stateCustomerData) {
    if (stateCustomerData is CustomerDataResult) {
      if (widget.myToggleButton != null && stateCustomerData.searchResult != null) {
        return 128.0;
      } else if (widget.myToggleButton != null) {
        return 90.0;
      }
    }

    return 56.0;
  }

  String _getColumnCustomerData(BuildContext context, CustomerDataResult stateCustomerData) {
    if (stateCustomerData.column != null) {
      return '(${stateCustomerData.column == columnTarip ? 'Tarif' : stateCustomerData.column})';
    }
    return '';
  }
}
