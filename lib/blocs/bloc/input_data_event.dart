part of 'input_data_bloc.dart';

@immutable
class InputDataEvent {}

class InputDataAdd extends InputDataEvent {
  final BuildContext context;
  final Pdil? data;
  final int? row;
  final int? maxRow;
  final String? table;
  final bool isPasca;
  final bool isImportBoth;

  InputDataAdd({this.data, this.row, this.maxRow, this.table, required this.isPasca, required this.context, this.isImportBoth = false});
}

class InputDataInit extends InputDataEvent {}