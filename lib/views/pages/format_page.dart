part of 'pages.dart';

class FormatPage extends StatefulWidget {
  List<String> formatChecks;

  FormatPage(this.formatChecks);

  @override
  _FormatPageState createState() => _FormatPageState();
}

class _FormatPageState extends State<FormatPage> {
  final List<String> formats = [
    'IDPEL',
    'NAMA',
    'ALAMAT',
    'TARIF',
    'DAYA',
    'NO HP',
    'NIK',
    'NPWP',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) => (stateFontSize is FontSizeResult)
          ? Scaffold(
              appBar: AppBar(
                title: Text("Format Kolom",
                    style: stateFontSize.title.copyWith(color: whiteColor, fontWeight: FontWeight.w600)),
              ),
              body: _body(context, stateFontSize),
            )
          : Container(),
    );
  }

  _body(BuildContext context, FontSizeResult stateFontSize) => AnimatedList(
        initialItemCount: widget.formatChecks.length,
        itemBuilder: (_, index, animation) => Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(
              color: blackColor,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 70 + ((stateFontSize.title.fontSize - 20) / 2 * 6.5),
                      child: Text(
                        '${formats[index]}',
                        style: stateFontSize.subtitle.copyWith(color: primaryColor),
                      ),
                    ),
                    Text(
                      '=  ',
                      style: stateFontSize.subtitle.copyWith(color: blackColor),
                    ),
                    Expanded(
                      child: Text(
                        '${widget.formatChecks[index]}',
                        style: stateFontSize.subtitle.copyWith(color: greenColor),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
