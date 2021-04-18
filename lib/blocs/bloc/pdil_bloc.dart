import 'package:pdil/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pdil/services/services.dart';

part 'pdil_event.dart';
part 'pdil_state.dart';

class PdilBloc extends Bloc<PdilEvent, PdilState> {
  DbHelper dbHelper = DbHelper();

  PdilBloc() : super(PdilInitial());

  @override
  Stream<PdilState> mapEventToState(event) async* {
    if (event is FetchPdil) {
      Pdil data = await dbHelper.selectWhere(event.idPel);

      if (data == null) {
        yield PdilError("Data Tidak Ditemukan!!!");
      } else {
        yield PdilLoaded(data);
      }
    } else if(event is UpdatePdil) {
      int count = await dbHelper.update(event.pdil);

      yield PdilOnUpdate(count);
    }
  }
}
