part of 'import_bloc.dart';

@immutable
class ImportEvent {}

class ImportCurrentImport extends ImportEvent {}

class ImportConfirm extends ImportEvent {
  final Import import;
  final String? prefixIdPelPasca;
  final String? prefixIdpelPra;
  final bool isFromExportPage;

  ImportConfirm(
    this.import, {
    this.prefixIdPelPasca,
    this.prefixIdpelPra,
    this.isFromExportPage = false,
  });
}
