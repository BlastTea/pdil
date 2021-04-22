part of 'pages.dart';

class FontSizePage extends StatefulWidget {
  double sliderValue;

  FontSizePage({this.sliderValue = 0});

  @override
  _FontSizePageState createState() => _FontSizePageState();
}

class _FontSizePageState extends State<FontSizePage> {
  double defaultValue = 20;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) => (stateFontSize is FontSizeResult)
          ? Scaffold(
              appBar: AppBar(
                title: Text("Ukuran Font",
                    style: stateFontSize.title.copyWith(color: whiteColor, fontWeight: FontWeight.w600)),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        Text("Judul", style: stateFontSize.title),
                        Text("SubJudul", style: stateFontSize.subtitle),
                        Text(loremIpsum, style: stateFontSize.body),
                      ],
                    ),
                  ),
                  Slider(
                    value: widget.sliderValue,
                    min: 0,
                    max: 4,
                    divisions: 4,
                    onChanged: (value) {
                      setState(() {
                        widget.sliderValue = value;

                        context.read<FontSizeBloc>().add(SaveFontSize(defaultValue + value * 2));
                      });
                    },
                  ),
                ],
              ),
            )
          : Container(),
    );
  }
}
