part of 'export_data_bloc.dart';

@immutable
class ExportDataState {}

class ExportDataInitial extends ExportDataState {}

class ExportDataProgress extends ExportDataState {
  final int progress;

  ExportDataProgress(this.progress) : assert(progress <= 100);
}