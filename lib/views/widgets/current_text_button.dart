part of 'widgets.dart';

class CurrentTextButton extends StatelessWidget {
  CurrentTextButton({required this.text, required this.onTap, this.width, this.decoration, this.textStyle});

  final Function onTap;
  final String text;
  final double? width;
  final BoxDecoration? decoration;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) {
        if (stateFontSize is FontSizeResult) {
          return Container(
            width: width ?? double.infinity,
            height: 41 + stateFontSize.width,
            decoration: decoration ?? cardDecoration.copyWith(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6AD7FF),
                  Color(0xFF5AC4FF),
                ],
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              child: InkWell(
                borderRadius: BorderRadius.circular(5),
                splashColor: inkWellSplashColor,
                hoverColor: inkWellSplashColor.withOpacity(0.5),
                onTap: onTap as void Function()?,
                child: Center(child: Text(text, style: textStyle ?? stateFontSize.subtitle!.copyWith(color: whiteColor))),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
