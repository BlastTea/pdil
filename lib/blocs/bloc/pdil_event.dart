part of 'pdil_bloc.dart';

@immutable
abstract class PdilEvent {}

class FetchPdil extends PdilEvent {
  final String? idPel;
  final String? noMeter;
  final bool isPasca;
  final bool isContinuingSearch;
  final bool isFromCustomerData;

  FetchPdil({
    required this.isPasca,
    this.idPel,
    this.noMeter,
    this.isContinuingSearch = false,
    this.isFromCustomerData = false,
  });
}

class UpdatePdil extends PdilEvent {
  final Pdil? pdil;
  final bool isUsingSaveDialog;
  final bool isPasca;

  UpdatePdil({
    required this.pdil,
    required this.isUsingSaveDialog,
    required this.isPasca,
  });
}

class ClearPdilState extends PdilEvent {
  final bool isPasca;

  ClearPdilState({required this.isPasca});
}

class UpdatePdilController extends PdilEvent {
  final Pdil? currentPdilPasca;
  final Pdil? originalPdilPasca;

  final Pdil? currentPdilPra;
  final Pdil? originalPdilPra;

  final bool isPasca;

  UpdatePdilController({
    required this.currentPdilPasca,
    required this.originalPdilPasca,
    required this.currentPdilPra,
    required this.originalPdilPra,
    required this.isPasca,
  });
}
