part of 'import_bloc.dart';

@immutable
class ImportEvent {} 

class ImportCurrentImport extends ImportEvent {}

class ImportConfirm extends ImportEvent {
  final Import import;
  final String? prefixIdPel;

  ImportConfirm(this.import, {this.prefixIdPel});
}