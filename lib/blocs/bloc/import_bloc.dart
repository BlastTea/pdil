import 'package:pdil/blocs/blocs.dart';
import 'package:pdil/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pdil/services/navigation_helper.dart';
import 'package:pdil/services/services.dart';

part 'import_event.dart';
part 'import_state.dart';

class ImportBloc extends Bloc<ImportEvent, ImportState> {
  ImportBloc() : super(ImportBothNotImported());

  @override
  Stream<ImportState> mapEventToState(ImportEvent event) async* {
    if (event is ImportCurrentImport) {
      Import import = await ImportServices.getCurrentImport() ?? Import.bothNotImported;
      switch (import) {
        case Import.bothImported:
          yield ImportBothImported();
          break;
        case Import.bothNotImported:
          yield ImportBothNotImported();
          break;
        case Import.pascabayarImported:
          yield ImportPascabayarImported();
          break;
        case Import.prabayarImported:
          yield ImportPrabayarImported();
          break;
      }
    } else if (event is ImportConfirm) {
      await ImportServices.savePrefixIdpel(event.prefixIdPel ?? "");

      Import currentImport = await ImportServices.getCurrentImport();

      switch (event.import) {
        case Import.bothImported:
          break;
        case Import.bothNotImported:
          break;
        case Import.pascabayarImported:
          if (currentImport == Import.prabayarImported) {
            await ImportServices.saveImport(Import.bothImported);
          } else {
            await ImportServices.saveImport(event.import);
          }
          break;
        case Import.prabayarImported:
          if(currentImport == Import.pascabayarImported) {
            await ImportServices.saveImport(Import.bothImported);
          } else {
            await ImportServices.saveImport(event.import);
          }
          break;
      }

      // if (event.isConfirmed) {
      //   yield ImportImported();
      // } else if (!event.isConfirmed) {
      //   await dbHelper.deleteAll();
      //   NavigationHelper.back();
      //   NavigationHelper.back();
      //   yield ImportNotImported();
      // }
    }
  }
}

enum Import {
  bothImported,
  bothNotImported,
  pascabayarImported,
  prabayarImported,
}
