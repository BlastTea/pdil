part of 'error_check_bloc.dart';

@immutable
abstract class ErrorCheckEvent {}

class ErrorCheckOnError extends ErrorCheckEvent {
  final ErrorCheck data;

  ErrorCheckOnError(this.data);
}

class ErrorCheckClear extends ErrorCheckEvent {}

class ErrorCheckSuccessfulEvent extends ErrorCheckEvent {}