part of 'export_data_bloc.dart';

@immutable
class ExportDataState {}

class ExportDataInitial extends ExportDataState {}

class ExportDataProgress extends ExportDataState {
  final double progress;
  final String message;
  final bool isExport;
  final bool isExportBoth;
  final bool isPasca;

  ExportDataProgress({
    required this.progress,
    required this.message,
    required this.isExport,
    required this.isExportBoth,
    required this.isPasca,
  });
}
