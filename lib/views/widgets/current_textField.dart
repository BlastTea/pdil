part of 'widgets.dart';

class CurrentTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String prefixText;
  final String hintText;
  final bool readOnly;
  final bool expands;
  final double width;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final ScrollController scrollController;
  final TextInputType keyboardType;
  final Function(String text) onSubmitted;
  final Function(String text) onChanged;
  final Function onCancelTap;
  final TextInputAction textInputAction;
  final int maxLines;
  final int minLines;
  final EdgeInsetsGeometry padding;
  final Widget prefixIcon;

  CurrentTextField({
    this.controller,
    this.label,
    this.prefixText,
    this.hintText,
    this.readOnly,
    this.expands = false,
    this.width,
    this.height,
    this.borderRadius,
    this.scrollController,
    this.keyboardType,
    this.onSubmitted,
    this.textInputAction,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.padding,
    this.prefixIcon,
    this.onCancelTap,
  });

  @override
  _CurrentTextFieldState createState() => _CurrentTextFieldState();
}

class _CurrentTextFieldState extends State<CurrentTextField> with SingleTickerProviderStateMixin {
  bool _showCancelButton = false;

  AnimationController _animationController;

  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: -2.5, end: 1.0).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) {
        if (stateFontSize is FontSizeResult) {
          return Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.center,
            children: [
              Container(
                width: widget.width ?? double.infinity,
                height: (widget.height ?? 40) + (stateFontSize.title.fontSize - 20),
                decoration: cardDecoration,
                child: TextField(
                  textInputAction: widget.textInputAction,
                  onSubmitted: widget.onSubmitted,
                  onChanged: (value) {
                    if (value != '' && widget.onCancelTap != null) {
                      _animationController.forward();
                    } else if (widget.controller.text == '' && widget.onCancelTap != null) {
                      _animationController.reverse();
                    }
                    widget.onChanged(value);
                  },
                  keyboardType: widget.keyboardType,
                  scrollController: widget.scrollController,
                  controller: widget.controller,
                  readOnly: widget.readOnly ?? false,
                  style: stateFontSize.body1,
                  expands: widget.expands,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    contentPadding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 10),
                    prefixText: widget.prefixText,
                    prefixStyle: stateFontSize.body1,
                    prefixIcon: widget.prefixIcon,
                    labelText: widget.label,
                    labelStyle: stateFontSize.subtitle,
                    hintText: widget.hintText,
                    hintStyle: stateFontSize.body1.copyWith(color: greyColor),
                    // disabledBorder: OutlineInputBorder(
                    //   borderRadius: widget.borderRadius ?? BorderRadius.circular(5),
                    //   borderSide: BorderSide(
                    //     color: primaryColor,
                    //   ),
                    // ),
                    // enabledBorder: OutlineInputBorder(
                    //   borderRadius: widget.borderRadius ?? BorderRadius.circular(5),
                    //   borderSide: BorderSide(
                    //     color: primaryColor,
                    //   ),
                    // ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: widget.borderRadius ?? BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: primaryColor,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: widget.borderRadius ?? BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.onCancelTap != null)
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (_, child) => Positioned(right: 10 * _animation.value, child: child),
                  child: GestureDetector(
                    onTap: () {
                      widget.onCancelTap();
                      if (widget.controller.text == '' && widget.onCancelTap != null) {
                        _animationController.reverse();
                      }
                    },
                    child: Icon(Icons.cancel),
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
