import 'package:pdil/blocs/blocs.dart';
import 'package:pdil/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pdil/services/services.dart';

part 'pdil_event.dart';
part 'pdil_state.dart';

class PdilBloc extends Bloc<PdilEvent, PdilState> {
  DbPasca dbPasca = DbPasca();
  DbPra dbPra = DbPra();

  PdilBloc() : super(PdilInitial());

  @override
  Stream<PdilState> mapEventToState(event) async* {
    if (event is FetchPdil) {
      Pdil data = await dbPasca.selectWhere(event.idPel);

      if (data == null) {
        yield PdilError('Data Tidak Ditemukan', isContinuingSearch: event.isContinuingSearch);
      } else if (data != null) {
        yield PdilLoaded(data, isFromCustomerData: event.isFromCustomerData, isContinousSearch: event.isContinuingSearch);
      }
    } else if (event is UpdatePdil) {
      int count = await dbPasca.update(event.pdil);

      yield PdilOnUpdate(count, event.isUsingSaveDialog);
    } else if (event is ClearPdilState) {
      yield PdilClearedState();
    } else if (event is UpdatePdilController) {
      yield UpdatedPdilController(
        previousPdil: event.previousPdil,
        currentPdil: event.currentPdil,
        comparePdil: event.comparePdil,
      );
    }
  }
}
