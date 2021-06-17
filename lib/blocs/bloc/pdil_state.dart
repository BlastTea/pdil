part of 'pdil_bloc.dart';

@immutable
abstract class PdilState {}

class PdilInitial extends PdilState {}

class PdilLoaded extends PdilState {
  final Pdil data;
  final bool isFromCustomerData;
  final bool isContinousSearch;

  PdilLoaded(this.data, {this.isFromCustomerData = false, this.isContinousSearch = false});
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

class PdilClearedState extends PdilState {}

class UpdatedPdilController extends PdilState {
  final Pdil previousPdil;
  final Pdil currentPdil;
  final Pdil comparePdil;

  UpdatedPdilController({
    @required this.previousPdil,
    @required this.currentPdil,
    @required this.comparePdil,
  });
}
