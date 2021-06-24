part of 'font_size_bloc.dart';

@immutable
class FontSizeState {}

class FontSizeResult extends FontSizeState {
  final TextStyle? title;
  final TextStyle? subtitle;
  final TextStyle? body1;
  final TextStyle? body2;

  final double? width;

  FontSizeResult({
    this.title,
    this.subtitle,
    this.body1,
    this.body2,
    this.width,
  });
}
