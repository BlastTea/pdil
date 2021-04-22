import 'package:pdil/blocs/blocs.dart';
import 'package:pdil/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pdil/services/navigation_helper.dart';
import 'package:pdil/services/services.dart';

part 'import_event.dart';
part 'import_state.dart';

class ImportBloc extends Bloc<ImportEvent, ImportState> {
  ImportBloc() : super(ImportNotImported());

  DbHelper dbHelper = DbHelper();

  @override
  Stream<ImportState> mapEventToState(ImportEvent event) async* {
    if (event is ImportCurrentImport) {
      bool isImported = await ImportServices.getCurrentImport() ?? false;
      if (isImported) {
        yield ImportImported();
      } else {
        yield ImportNotImported();
      }
    } else if (event is ImportConfirm) {
      await ImportServices.saveImport(event.isConfirmed);
      await ImportServices.savePrefixIdpel(event.prefixIdPel ?? "");

      if (event.isConfirmed) {
        yield ImportImported();
      } else if (!event.isConfirmed) {
        await dbHelper.deleteAll();
        NavigationHelper.back();
        NavigationHelper.back();
        yield ImportNotImported();
      }
    }
  }
}
