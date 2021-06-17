import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_navigation_event.dart';
part 'bottom_navigation_state.dart';

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc() : super(BottomNavigationResult(1));

  int _currentNav = 1;

  @override
  Stream<BottomNavigationState> mapEventToState(BottomNavigationEvent event) async* {
    if (event is ChangeCurrentNav) {
      assert(event.currentNav >= 0 && event.currentNav <= 2);
      _currentNav = event.currentNav;
      yield BottomNavigationResult(_currentNav);
    } else if (event is FetchCurrentNav) {
      yield BottomNavigationResult(_currentNav);
    }
  }
}
