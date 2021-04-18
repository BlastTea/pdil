part of 'pdil_bloc.dart';

@immutable
abstract class PdilEvent {}

class FetchPdil extends PdilEvent {
  final String idPel;

  FetchPdil(this.idPel);
}

class UpdatePdil extends PdilEvent {
  final Pdil pdil;

  UpdatePdil(this.pdil);
}
