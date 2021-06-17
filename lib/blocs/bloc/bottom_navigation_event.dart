part of 'bottom_navigation_bloc.dart';

@immutable
class BottomNavigationEvent {}

class ChangeCurrentNav extends BottomNavigationEvent {
  final int currentNav;

  ChangeCurrentNav(this.currentNav);
}

class FetchCurrentNav extends BottomNavigationEvent {}