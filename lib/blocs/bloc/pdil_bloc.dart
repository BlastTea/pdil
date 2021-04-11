import 'package:pdil/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'pdil_event.dart';
part 'pdil_state.dart';

class PdilBloc extends Bloc<PdilEvent, PdilState> {
  PdilBloc() : super(PdilInitial());

  @override
  Stream<PdilState> mapEventToState(event) async* {
    if (event is UpdatePdil) {}
  }
}
