part of 'pdil_bloc.dart';

@immutable
abstract class PdilEvent {}

class FetchPdil extends PdilEvent {
  final String idPel;
  final bool isContinuingSearch;
  final bool isFromCustomerData;

  FetchPdil(this.idPel, {this.isContinuingSearch = false, this.isFromCustomerData = false});
}

class UpdatePdil extends PdilEvent {
  final Pdil pdil;
  final bool isUsingSaveDialog;

  UpdatePdil(this.pdil, this.isUsingSaveDialog);
}

class ClearPdilState extends PdilEvent {}

class UpdatePdilController extends PdilEvent {
  final Pdil previousPdil;
  final Pdil currentPdil;
  final Pdil comparePdil;

  UpdatePdilController({
    @required this.previousPdil,
    @required this.currentPdil,
    @required this.comparePdil,
  });
}
