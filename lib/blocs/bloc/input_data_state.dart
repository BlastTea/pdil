part of 'input_data_bloc.dart';

@immutable
class InputDataState {}

class InputDataProgress extends InputDataState {
  final double progress;

  InputDataProgress({
    @required this.progress,
  });
}

class InputDataInitial extends InputDataState {}
