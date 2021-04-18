part of 'input_data_bloc.dart';

@immutable
class InputDataState {}

class InputDataProgress extends InputDataState {
  final int progress;

  InputDataProgress(this.progress) : assert(progress <= 100);
}

class InputDataInitial extends InputDataState {}