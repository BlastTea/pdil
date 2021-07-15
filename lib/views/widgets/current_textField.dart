part of 'widgets.dart';

class CurrentTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? prefixText;
  final String? hintText;
  final bool? readOnly;
  final bool expands;
  final bool isInputPage;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final ScrollController? scrollController;
  final TextInputType? keyboardType;
  final Function(String text)? onSubmitted;
  final Function(String text)? onChanged;
  final Function? onCancelTap;
  final Function()? onTap;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final EdgeInsetsGeometry? padding;
  final Widget? prefixIcon;
  final bool autofocus;

  CurrentTextField({
    this.controller,
    this.label,
    this.prefixText,
    this.hintText,
    this.readOnly,
    this.expands = false,
    this.isInputPage = false,
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
    this.onTap,
    this.autofocus = false,
  });

  @override
  _CurrentTextFieldState createState() => _CurrentTextFieldState();
}

class _CurrentTextFieldState extends State<CurrentTextField> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    widget.controller!.addListener(() {
      if (widget.controller!.text != '' && widget.onCancelTap != null) {
        _showCancelButton(context);
      } else if (widget.controller!.text == '' && widget.onCancelTap != null) {
        _hideCanelButton(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.controller!.text != '' && widget.onCancelTap != null) {
        _showCancelButton(context);
      } else if (widget.controller!.text == '' && widget.onCancelTap != null) {
        _hideCanelButton(context);
      }
    });
    return BlocBuilder<FontSizeBloc, FontSizeState>(
      builder: (_, stateFontSize) {
        if (stateFontSize is FontSizeResult) {
          return Stack(
            // fit: StackFit.passthrough,
            alignment: Alignment.centerRight,
            children: [
              Container(
                width: widget.width ?? double.infinity,
                height: (widget.height ?? 40) + (stateFontSize.width),
                decoration: cardDecoration,
                child: TextField(
                  textInputAction: widget.textInputAction,
                  onSubmitted: widget.onSubmitted,
                  onChanged: (value) {
                    if (widget.controller!.text != '' && widget.onCancelTap != null) {
                      _showCancelButton(context);
                    } else if (widget.controller!.text == '' && widget.onCancelTap != null) {
                      _hideCanelButton(context);
                    }
                    widget.onChanged!(value);
                  },
                  autofocus: widget.autofocus,
                  onTap: widget.onTap ?? () {},
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
                    contentPadding: widget.padding ?? EdgeInsets.only(left: 10, right: widget.onCancelTap != null ? 35 : 10),
                    prefixText: widget.prefixText,
                    prefixStyle: stateFontSize.body1,
                    prefixIcon: widget.prefixIcon,
                    labelText: widget.label,
                    labelStyle: stateFontSize.subtitle,
                    hintText: widget.hintText,
                    hintStyle: stateFontSize.body1!.copyWith(color: greyColor),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: widget.borderRadius as BorderRadius? ?? BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: primaryColor,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: widget.borderRadius as BorderRadius? ?? BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.onCancelTap != null)
                BlocListener<PdilBloc, PdilState>(
                  listener: (_, statePdil) {
                    if (widget.isInputPage && statePdil is PdilClearedState) {
                      Future.delayed(const Duration(milliseconds: 100)).then((value) {
                        if (widget.controller!.text == '' && widget.onCancelTap != null) {
                          _hideCanelButton(context);
                        }
                      });
                    }
                  },
                  child: Positioned(
                    right: 10,
                    child: AnimatedOpacity(
                      opacity: _opacity,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.fastOutSlowIn,
                      child: AbsorbPointer(
                        absorbing: widget.controller!.text == '' && widget.onCancelTap != null,
                        child: GestureDetector(
                          onTap: () {
                            widget.onCancelTap!();
                            if (widget.controller!.text == '' && widget.onCancelTap != null) {
                              _hideCanelButton(context);
                            }
                          },
                          child: Icon(Icons.cancel),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }
        return Container();
      },
    );
  }

  _showCancelButton(BuildContext context) {
    setState(() {
      _opacity = 1.0;
    });
  }

  _hideCanelButton(BuildContext context) {
    setState(() {
      _opacity = 0.0;
    });
  }
}
