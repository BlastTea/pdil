import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pdil/blocs/blocs.dart';

part 'fab_save_event.dart';
part 'fab_save_state.dart';

class FabSaveBloc extends Bloc<FabSaveEvent, FabSaveState> {

  FabSaveBloc() : super(FabSaveInitial());

  @override
  Stream<FabSaveState> mapEventToState(FabSaveEvent event) async* {
    if(event is FabSaveOnPressed) {
      yield FabSaveOnStatePressed();
    }
  }
  
}