part of 'pdil_bloc.dart';

@immutable
abstract class PdilState {}

class PdilInitial extends PdilState {}

class PdilLoaded extends PdilState {
  final Pdil? previousCurrentPdilPasca;
  final Pdil? previousCurrentPdilPra;
  final Pdil? originalPdilPasca;
  final Pdil? currentPdilPasca;
  final Pdil? originalPdilPra;
  final Pdil? currentPdilPra;
  final bool isFromCustomerData;
  final bool isContinuingSearch;
  final bool isPasca;
  final bool isClearState;
  final bool? isIdpel;
  final bool isPascaDiff;
  final bool isPraDiff;

  PdilLoaded({
    required this.previousCurrentPdilPasca,
    required this.previousCurrentPdilPra,
    required this.originalPdilPasca,
    required this.currentPdilPasca,
    required this.originalPdilPra,
    required this.currentPdilPra,
    required this.isPascaDiff,
    required this.isPraDiff,
    this.isFromCustomerData = false,
    this.isContinuingSearch = false,
    required this.isPasca,
    this.isClearState = false,
    this.isIdpel,
  });
}

class PdilError extends PdilState {
  final String message;
  final bool isContinuingSearch;

  PdilError(this.message, {this.isContinuingSearch = false});
}

class PdilOnUpdate extends PdilState {
  final int count;
  final bool isUsingSaveDialog;

  PdilOnUpdate({required this.count, required this.isUsingSaveDialog});
}

class PdilClearedState extends PdilState {
  final bool isPasca;
  final bool isContinuingSearch;

  PdilClearedState({required this.isPasca, this.isContinuingSearch = false});
}

class UpdatedPdilController extends PdilState {
  final Pdil? currentPdilPasca;
  final Pdil? originalPdilPasca;

  final Pdil? currentPdilPra;
  final Pdil? originalPdilPra;

  final bool isPasca;

  UpdatedPdilController({
    required this.currentPdilPasca,
    required this.originalPdilPasca,
    required this.currentPdilPra,
    required this.originalPdilPra,
    required this.isPasca,
  });
}
