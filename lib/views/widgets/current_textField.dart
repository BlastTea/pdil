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
  });

  @override
  _CurrentTextFieldState createState() => _CurrentTextFieldState();
}

class _CurrentTextFieldState extends State<CurrentTextField> {
  TextStyle theStyle = body;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) => (stateFontSize is FontSizeResult)
          ? Container(
              width: widget.width,
              height: (widget.height ?? 40) + (stateFontSize.title.fontSize - 20),
              child: TextField(
                textInputAction: widget.textInputAction,
                onSubmitted: widget.onSubmitted,
                onChanged: widget.onChanged,
                keyboardType: widget.keyboardType,
                scrollController: widget.scrollController,
                controller: widget.controller,
                readOnly: widget.readOnly ?? false,
                style: stateFontSize.body,
                expands: widget.expands,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  contentPadding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 10),
                  prefixText: widget.prefixText,
                  prefixStyle: stateFontSize.body,
                  prefixIcon: widget.prefixIcon,
                  labelText: widget.label,
                  labelStyle: stateFontSize.subtitle,
                  hintText: widget.hintText,
                  hintStyle: stateFontSize.body.copyWith(color: greyColor),
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
            )
          : Container(),
    );
  }
}
