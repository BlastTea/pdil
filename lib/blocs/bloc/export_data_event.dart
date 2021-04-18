part of 'export_data_bloc.dart';

@immutable
class ExportDataEvent {}

class ExportDataExport extends ExportDataEvent {
  final row;
  final maxRow;

  ExportDataExport(this.row, this.maxRow);
}