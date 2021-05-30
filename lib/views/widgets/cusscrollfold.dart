part of 'widgets.dart';

class CusScrollFold extends StatefulWidget {
  final List<Widget> children;
  final String title;
  final List<Widget> action;

  CusScrollFold({
    @required this.children,
    this.title = '',
    this.action,
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
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Color(0xFFF1F5FF),
                flexibleSpace: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: defaultPadding),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.title,
                        style: stateFontSize.title.copyWith(color: primaryColor),
                      ),
                    ),
                  ),
                ),
                actions: widget.action,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  widget.children,
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
