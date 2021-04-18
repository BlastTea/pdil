part of 'error_check_bloc.dart';

@immutable
abstract class ErrorCheckState {}

class ErrorCheckInitial extends ErrorCheckState {}

class ErrorCheckResult extends ErrorCheckState {
  final List<ErrorCheck> data;
  
  ErrorCheckResult(this.data);
}

class ErrorCheckSucessfulState extends ErrorCheckState {}