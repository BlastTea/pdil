part of 'import_bloc.dart';

@immutable
class ImportEvent {} 

class ImportCurrentImport extends ImportEvent {}

class ImportConfirm extends ImportEvent {
  final bool isConfirmed;
  final String prefixIdPel;

  ImportConfirm(this.isConfirmed, {this.prefixIdPel});
}