part of 'bottom_navigation_bloc.dart';

@immutable
class BottomNavigationState {}

class BottomNavigationResult extends BottomNavigationState {
  final int currentNav;

  BottomNavigationResult(this.currentNav);
}

class BottomNavigationError extends BottomNavigationState {
  final String message;

  BottomNavigationError(this.message);
}