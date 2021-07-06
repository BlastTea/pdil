part of 'export_data_bloc.dart';

@immutable
class ExportDataEvent {}

class ExportDataExport extends ExportDataEvent {
  final int row;
  final int maxRow;
  final String message;
  final BuildContext context;
  final bool isExport;
  final bool isExportBoth;
  final bool isPasca;

  ExportDataExport({
    required this.row,
    required this.maxRow,
    required this.message,
    required this.context,
    required this.isExport,
    required this.isExportBoth,
    required this.isPasca,
  });
}

class ExportDataInit extends ExportDataEvent {}
