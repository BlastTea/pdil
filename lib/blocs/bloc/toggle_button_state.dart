part of 'toggle_button_bloc.dart';

@immutable
abstract class ToggleButtonState {}

class ToggleButtonInitial extends ToggleButtonState {}

class ToggleButtonResult extends ToggleButtonState {
  final ToggleButtonSlot toggleButtonSlot;
  final bool isPasca;

  ToggleButtonResult({
    required this.toggleButtonSlot,
    required this.isPasca,
  });
}

class ChangedCurrentToggleButtonState extends ToggleButtonState {
  final ToggleButtonSlot toggleButtonSlot;
  final bool isPasca;

  ChangedCurrentToggleButtonState({
    required this.toggleButtonSlot,
    required this.isPasca,
  });
}