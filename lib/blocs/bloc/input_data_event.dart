part of 'input_data_bloc.dart';

@immutable
class InputDataEvent {}

class InputDataAdd extends InputDataEvent {
  final Pdil data;
  final int row;
  final maxRow;

  InputDataAdd(this.data, this.row, this.maxRow);
}