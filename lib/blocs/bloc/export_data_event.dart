part of 'export_data_bloc.dart';

@immutable
class ExportDataEvent {}

class ExportDataExport extends ExportDataEvent {
  final double persentase;
  final String message;
  final BuildContext context;
  final bool isExport;
  final bool isExportBoth;
  final bool isPasca;
  final Excel excel;
  final String namaFile;

  ExportDataExport({
    required this.persentase,
    required this.message,
    required this.context,
    required this.isExport,
    required this.isExportBoth,
    required this.isPasca,
    required this.excel,
    required this.namaFile,
  });
}

class ExportDataInit extends ExportDataEvent {}
