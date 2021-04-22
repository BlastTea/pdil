part of 'pdil_bloc.dart';

@immutable
abstract class PdilEvent {}

class FetchPdil extends PdilEvent {
  final String idPel;
  final bool isContinuingSearch;

  FetchPdil(this.idPel, {this.isContinuingSearch = false});
}

class UpdatePdil extends PdilEvent {
  final Pdil pdil;

  UpdatePdil(this.pdil);
}
