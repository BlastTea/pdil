part of 'widgets.dart';

class MyToggleButton extends StatefulWidget {
  final Function(bool isPasca) onTap;

  MyToggleButton(this.onTap);

  @override
  _MyToggleButtonState createState() => _MyToggleButtonState();
}

class _MyToggleButtonState extends State<MyToggleButton> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _animationControllerPasca;
  AnimationController _animationControllerPra;

  Animation<Color> _animationPascaColor;
  Animation<Color> _animationPraColor;

  bool _isPasca = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationControllerPasca = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationControllerPra = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationPascaColor = ColorTween(begin: whiteColor, end: primaryColor).animate(_animationControllerPasca);
    _animationPraColor = ColorTween(begin: primaryColor, end: whiteColor).animate(_animationControllerPra);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) {
        if (stateFontSize is FontSizeResult) {
          final double kWidth = (MediaQuery.of(context).size.width / 2) + (stateFontSize.title.fontSize - 20);
          return SizedBox(
            width: kWidth,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: kWidth,
                  height: 32,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: primaryColor),
                  ),
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (_, child) {
                    return Positioned(
                      left: (kWidth / 2 - 8.0) * _animationController.value,
                      child: child,
                    );
                  },
                  child: Container(
                    width: kWidth / 2,
                    height: 24,
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _isPasca = true;
                        widget.onTap(_isPasca);
                        _animationController.reverse();
                        _animationControllerPasca.reverse();
                        _animationControllerPra.reverse();
                      },
                      child: SizedBox(
                        width: kWidth / 2,
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (_, child) {
                            return DefaultTextStyle(
                              style: stateFontSize.body1.copyWith(color: _animationPascaColor.value),
                              child: child,
                            );
                          },
                          child: Text(
                            'PascaBayar',
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _isPasca = false;
                        widget.onTap(_isPasca);
                        _animationController.forward();
                        _animationControllerPasca.forward();
                        _animationControllerPra.forward();
                      },
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (_, child) {
                          return DefaultTextStyle(
                            style: stateFontSize.body1.copyWith(color: _animationPraColor.value),
                            child: child,
                          );
                        },
                        child: SizedBox(
                          width: kWidth / 2,
                          child: Text(
                            'PraBayar',
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}