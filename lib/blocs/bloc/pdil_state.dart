part of 'pdil_bloc.dart';

@immutable
abstract class PdilState {}

class PdilInitial extends PdilState {}

class PdilLoaded extends PdilState {
  final Pdil? originalPdilPasca;
  final Pdil? currentPdilPasca;
  final Pdil? originalPdilPra;
  final Pdil? currentPdilPra;
  final bool isFromCustomerData;
  final bool isContinousSearch;
  final bool isPasca;

  PdilLoaded({
    required this.originalPdilPasca,
    required this.currentPdilPasca,
    required this.originalPdilPra,
    required this.currentPdilPra,
    this.isFromCustomerData = false,
    this.isContinousSearch = false,
    required this.isPasca,
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

  PdilOnUpdate(this.count, this.isUsingSaveDialog);
}

class PdilClearedState extends PdilState {
  final bool isPasca;

  PdilClearedState({required this.isPasca});
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
