import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'fab_event.dart';
part 'fab_state.dart';

class FabBloc extends Bloc<FabEvent, FabState> {

  FabBloc() : super(FabInitial());

  @override
  Stream<FabState> mapEventToState(FabEvent event) async* {
    if (event is ShowFab) {
      yield FabShowed();
    } else if (event is HideFab) {
      yield FabHided();
    }
  }
  
}