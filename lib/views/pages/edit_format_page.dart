part of 'pages.dart';

class EditFormatPage extends StatefulWidget {
  List<String> formatChecks;
  String title;

  EditFormatPage(this.title, this.formatChecks);

  @override
  _EditFormatPageState createState() => _EditFormatPageState();
}

class _EditFormatPageState extends State<EditFormatPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) => (stateFontSize is FontSizeResult)
          ? Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.title,
                  style: stateFontSize.title!.copyWith(color: whiteColor, fontWeight: FontWeight.w600),
                ),
              ),
            )
          : Container(),
    );
  }
}
