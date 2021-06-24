part of 'export_data_bloc.dart';

@immutable
class ExportDataEvent {}

class ExportDataExport extends ExportDataEvent {
  final int row;
  final int maxRow;
  final String message;

  ExportDataExport({
    required this.row,
    required this.maxRow,
    required this.message,
  });
}
