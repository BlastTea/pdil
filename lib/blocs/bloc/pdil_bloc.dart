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

  Pdil? previousCurrentPdilPasca;
  Pdil? previousCurrentPdilPra;
  Pdil? currentPdilPasca;
  Pdil? originalPdilPasca;
  Pdil? currentPdilPra;
  Pdil? originalPdilPra;

  bool isPascaDiff = true;
  bool isPraDiff = true;

  PdilBloc() : super(PdilInitial());

  @override
  Stream<PdilState> mapEventToState(event) async* {
    if (event is FetchPdil) {
      if (event.isPasca) {
        originalPdilPasca = await dbPasca.selectWhere(event.idPel);
        if (originalPdilPasca == null && event.isContinuingSearch) {
          yield PdilLoaded(
            previousCurrentPdilPasca: previousCurrentPdilPasca,
            previousCurrentPdilPra: previousCurrentPdilPra,
            originalPdilPasca: originalPdilPasca,
            currentPdilPasca: currentPdilPasca,
            originalPdilPra: originalPdilPra,
            currentPdilPra: currentPdilPra,
            isPascaDiff: isPascaDiff,
            isPraDiff: isPraDiff,
            isFromCustomerData: event.isFromCustomerData,
            isContinuingSearch: event.isContinuingSearch,
            isPasca: event.isPasca,
            isClearState: true,
          );
        } else if (originalPdilPasca == null) {
          yield PdilError('Data Tidak Ditemukan', isContinuingSearch: event.isContinuingSearch);
        } else if (originalPdilPasca != null) {
          currentPdilPasca = originalPdilPasca!.copyWith();
          yield PdilLoaded(
            previousCurrentPdilPasca: previousCurrentPdilPasca,
            previousCurrentPdilPra: previousCurrentPdilPra,
            originalPdilPasca: originalPdilPasca,
            currentPdilPasca: currentPdilPasca,
            originalPdilPra: originalPdilPra,
            currentPdilPra: currentPdilPra,
            isPascaDiff: isPascaDiff,
            isPraDiff: isPraDiff,
            isFromCustomerData: event.isFromCustomerData,
            isContinuingSearch: event.isContinuingSearch,
            isPasca: event.isPasca,
          );
        }
      } else if (!event.isPasca) {
        originalPdilPra = await dbPra.selectWhere(idPel: event.idPel, noMeter: event.noMeter);
        if (originalPdilPra == null && event.isContinuingSearch) {
          yield PdilLoaded(
            previousCurrentPdilPasca: previousCurrentPdilPasca,
            previousCurrentPdilPra: previousCurrentPdilPra,
            originalPdilPasca: originalPdilPasca,
            currentPdilPasca: currentPdilPasca,
            originalPdilPra: originalPdilPra,
            currentPdilPra: currentPdilPra,
            isPascaDiff: isPascaDiff,
            isPraDiff: isPraDiff,
            isFromCustomerData: event.isFromCustomerData,
            isContinuingSearch: event.isContinuingSearch,
            isPasca: event.isPasca,
            isClearState: true,
          );
        } else if (originalPdilPra == null) {
          yield PdilError('Data Tidak Ditemukan', isContinuingSearch: event.isContinuingSearch);
        } else if (originalPdilPra != null) {
          currentPdilPra = originalPdilPra!.copyWith();
          yield PdilLoaded(
            previousCurrentPdilPasca: previousCurrentPdilPasca,
            previousCurrentPdilPra: previousCurrentPdilPra,
            originalPdilPasca: originalPdilPasca,
            currentPdilPasca: currentPdilPasca,
            originalPdilPra: originalPdilPra,
            currentPdilPra: currentPdilPra,
            isPascaDiff: isPascaDiff,
            isPraDiff: isPraDiff,
            isFromCustomerData: event.isFromCustomerData,
            isContinuingSearch: event.isContinuingSearch,
            isPasca: event.isPasca,
            isIdpel: event.idPel == null,
          );
        }
      }
    } else if (event is UpdatePdil) {
      String? startDate = await DatePickerService.getStartDate();
      if (startDate == null) {
        DatePickerService.saveStartDate(event.pdil?.tanggalBaca as String);
      }
      DatePickerService.saveEndDate(event.pdil?.tanggalBaca as String);
      if (event.isPasca) {
        int count = await dbPasca.update(event.pdil!);
        yield PdilOnUpdate(count: count, isUsingSaveDialog: event.isUsingSaveDialog);
      } else if (!event.isPasca) {
        int count = await dbPra.update(event.pdil!);
        yield PdilOnUpdate(count: count, isUsingSaveDialog: event.isUsingSaveDialog);
      }
    } else if (event is ClearPdilState) {
      yield PdilClearedState(
        isPasca: event.isPasca,
      );
    } else if (event is UpdatePdilController) {
      previousCurrentPdilPasca = event.currentPdilPasca;
      previousCurrentPdilPra = event.currentPdilPra;
      currentPdilPasca = event.currentPdilPasca;
      originalPdilPasca = event.originalPdilPasca;
      currentPdilPra = event.currentPdilPra;
      originalPdilPra = event.originalPdilPra;
      isPascaDiff = originalPdilPasca?.isSame(currentPdilPasca) ?? true;
      isPraDiff = originalPdilPra?.isSame(currentPdilPra) ?? true;

      yield UpdatedPdilController(
        currentPdilPasca: event.currentPdilPasca,
        originalPdilPasca: event.originalPdilPasca,
        currentPdilPra: event.currentPdilPra,
        originalPdilPra: event.originalPdilPra,
        isPasca: event.isPasca,
      );
    }
  }
}
