part of 'pdil_bloc.dart';

@immutable
abstract class PdilState {}

class PdilInitial extends PdilState {}

class PdilLoaded extends PdilState {
  final Pdil data;

  PdilLoaded(this.data);
}

class PdilError extends PdilState {
  final String message;

  PdilError(this.message);
}

class PdilOnUpdate extends PdilState {
  final int count;

  PdilOnUpdate(this.count);
}
