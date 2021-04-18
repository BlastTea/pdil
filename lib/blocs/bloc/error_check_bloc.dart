import 'package:pdil/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'error_check_event.dart';
part 'error_check_state.dart';

class ErrorCheckBloc extends Bloc<ErrorCheckEvent, ErrorCheckState> {
  List<ErrorCheck> errors = [];

  ErrorCheckBloc() : super(ErrorCheckInitial());

  @override
  Stream<ErrorCheckState> mapEventToState(ErrorCheckEvent event) async* {
    if(event is ErrorCheckOnError) {
      errors.add(event.data);
      yield ErrorCheckResult(errors);
    } else if (event is ErrorCheckClear) {
      errors = [];
      yield ErrorCheckInitial();
    } else if (event is ErrorCheckSuccessfulEvent) {
      yield ErrorCheckSucessfulState();
    }
  }

}