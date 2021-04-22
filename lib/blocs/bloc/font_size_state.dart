part of 'font_size_bloc.dart';

@immutable
class FontSizeState {}

class FontSizeResult extends FontSizeState {
  final TextStyle title;
  final TextStyle subtitle;
  final TextStyle body;

  FontSizeResult({this.title, this.subtitle, this.body});
}
