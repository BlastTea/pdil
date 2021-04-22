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
  final bool isContinuingSearch;

  PdilError(this.message, {this.isContinuingSearch = false});
}

class PdilOnUpdate extends PdilState {
  final int count;

  PdilOnUpdate(this.count);
}
