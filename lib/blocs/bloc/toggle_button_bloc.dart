import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pdil/services/services.dart';
import 'package:pdil/views/widgets/widgets.dart';

part 'toggle_button_event.dart';
part 'toggle_button_state.dart';

class ToggleButtonBloc extends Bloc<ToggleButtonEvent, ToggleButtonState> {
  ToggleButtonBloc() : super(ToggleButtonInitial());

  @override
  Stream<ToggleButtonState> mapEventToState(ToggleButtonEvent event) async* {
    if (event is FetchCurrentToggleButtonState) {
      switch (event.toggleButtonSlot) {
        case ToggleButtonSlot.import:
          break;
        case ToggleButtonSlot.export:
          break;
        case ToggleButtonSlot.showData:
          yield ToggleButtonResult(
            toggleButtonSlot: event.toggleButtonSlot,
            isPasca: await ToggleButtonServices.getShowData(),
          );
          break;
        case ToggleButtonSlot.inputData:
          yield ToggleButtonResult(
            toggleButtonSlot: event.toggleButtonSlot,
            isPasca: await ToggleButtonServices.getInputData(),
          );
          break;
      }
    } else if (event is ChangeCurrentToggleButtonState) {
      yield ChangedCurrentToggleButtonState(
        toggleButtonSlot: event.toggleButtonSlot,
        isPasca: event.isPasca,
      );
    }
  }
}
