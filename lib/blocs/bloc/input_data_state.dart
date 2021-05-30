part of 'input_data_bloc.dart';

@immutable
class InputDataState {}

class InputDataProgress extends InputDataState {
  final double progress;

  InputDataProgress(this.progress);
}

class InputDataInitial extends InputDataState {}