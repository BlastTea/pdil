part of 'export_data_bloc.dart';

@immutable
class ExportDataState {}

class ExportDataInitial extends ExportDataState {}

class ExportDataProgress extends ExportDataState {
  final double progress;
  final String message;

  ExportDataProgress(this.progress, this.message);
}