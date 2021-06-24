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
    
  Pdil? currentPdilPasca;
  Pdil? originalPdilPasca;
  Pdil? currentPdilPra;
  Pdil? originalPdilPra;

  PdilBloc() : super(PdilInitial());

  @override
  Stream<PdilState> mapEventToState(event) async* {
    if (event is FetchPdil) {
      if (event.isPasca) {
        originalPdilPasca = await dbPasca.selectWhere(event.idPel);
        if (originalPdilPasca == null) {
          yield PdilError('Data Tidak Ditemukan', isContinuingSearch: event.isContinuingSearch);
        } else if (originalPdilPasca != null) {
          currentPdilPasca = originalPdilPasca!.copyWith();
          yield PdilLoaded(
            originalPdilPasca: originalPdilPasca,
            currentPdilPasca: currentPdilPasca,
            originalPdilPra: originalPdilPra,
            currentPdilPra: currentPdilPra,
            isFromCustomerData: event.isFromCustomerData,
            isContinousSearch: event.isContinuingSearch,
            isPasca: event.isPasca,
          );
        }
      } else if (!event.isPasca) {
        originalPdilPra = await dbPra.selectWhere(idPel: event.idPel, noMeter: event.noMeter);
        if (originalPdilPra == null) {
          yield PdilError('Data Tidak Ditemukan', isContinuingSearch: event.isContinuingSearch);
        } else if (originalPdilPra != null) {
          currentPdilPra = originalPdilPra!.copyWith();
          yield PdilLoaded(
            originalPdilPasca: originalPdilPasca,
            currentPdilPasca: currentPdilPasca,
            originalPdilPra: originalPdilPra,
            currentPdilPra: currentPdilPra,
            isFromCustomerData: event.isFromCustomerData,
            isContinousSearch: event.isContinuingSearch,
            isPasca: event.isPasca,
          );
        }
      }
    } else if (event is UpdatePdil) {
      if (event.isPasca) {
        int count = await dbPasca.update(event.pdil!);
        yield PdilOnUpdate(count, event.isUsingSaveDialog);
      } else if (!event.isPasca) {
        int count = await dbPra.update(event.pdil!);
        yield PdilOnUpdate(count, event.isUsingSaveDialog);
      }
    } else if (event is ClearPdilState) {
      yield PdilClearedState(
        isPasca: event.isPasca,
      );
    } else if (event is UpdatePdilController) {
      currentPdilPasca = event.currentPdilPasca;
      originalPdilPasca = event.originalPdilPasca;
      currentPdilPra = event.currentPdilPra;
      originalPdilPra = event.originalPdilPra;

      yield UpdatedPdilController(
        currentPdilPasca: event.currentPdilPasca,
        originalPdilPasca: event.originalPdilPra,
        currentPdilPra: event.currentPdilPra,
        originalPdilPra: event.originalPdilPra,
        isPasca: event.isPasca,
      );
    }
  }
}
