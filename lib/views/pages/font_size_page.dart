part of 'pages.dart';

class FontSizePage extends StatefulWidget {
  double sliderValue;

  FontSizePage({this.sliderValue = 0});

  @override
  _FontSizePageState createState() => _FontSizePageState();
}

class _FontSizePageState extends State<FontSizePage> {
  double defaultValue = 24;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) => (stateFontSize is FontSizeResult)
          ? Scaffold(
              appBar: AppBar(
                title: Text("Ukuran Font",
                    style: stateFontSize.title!.copyWith(color: whiteColor, fontWeight: FontWeight.w600)),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        Text("Setting Font", style: stateFontSize.title),
                        SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            text: "Memperbesar",
                            style: stateFontSize.subtitle!.copyWith(color: blackColor),
                            children: [
                              TextSpan(
                                text: " Geser Slider ke kanan",
                                style: stateFontSize.body1!.copyWith(color: blackColor),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            text: "Memperkecil",
                            style: stateFontSize.subtitle!.copyWith(color: blackColor),
                            children: [
                              TextSpan(
                                text: " Geser Slider ke kiri",
                                style: stateFontSize.body1!.copyWith(color: blackColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(width: 10),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: greenColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text('A', style: body1.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Expanded(
                        child: Slider(
                          value: widget.sliderValue,
                          min: 0,
                          max: 4,
                          divisions: 4,
                          label: '${(defaultValue + widget.sliderValue * 2).toString().split(".")[0]}',
                          onChanged: (value) {
                            setState(() {
                              widget.sliderValue = value;

                              context.read<FontSizeBloc>().add(SaveFontSize(defaultValue + value * 2));
                            });
                          },
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: greenColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            'A',
                            style: title.copyWith(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            )
          : Container(),
    );
  }
}
