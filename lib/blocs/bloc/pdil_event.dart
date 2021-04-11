part of 'pdil_bloc.dart';

@immutable
abstract class PdilEvent {}

class UpdatePdil extends PdilEvent {
  final String idPel;

  UpdatePdil(this.idPel);
}
