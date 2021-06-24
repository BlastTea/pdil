part of 'toggle_button_bloc.dart';

@immutable
abstract class ToggleButtonEvent {}

class FetchCurrentToggleButtonState extends ToggleButtonEvent {
  final ToggleButtonSlot toggleButtonSlot;

  FetchCurrentToggleButtonState({required this.toggleButtonSlot});
}

class ChangeCurrentToggleButtonState extends ToggleButtonEvent {
  final ToggleButtonSlot toggleButtonSlot;
  final isPasca;

  ChangeCurrentToggleButtonState({
    required this.toggleButtonSlot,
    required this.isPasca,
  });
}