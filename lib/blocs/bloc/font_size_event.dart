part of 'font_size_bloc.dart';

@immutable
class FontSizeEvent {}

class FetchFontSize extends FontSizeEvent {}

class SaveFontSize extends FontSizeEvent {
  final double fontSize;

  SaveFontSize(this.fontSize);
}
