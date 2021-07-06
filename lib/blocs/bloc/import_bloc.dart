import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
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
      Import import = await ImportServices.getCurrentImport();
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
      if (!event.isFromExportPage) {
        Import currentImport = await ImportServices.getCurrentImport();

        switch (event.import) {
          case Import.bothImported:
            await ImportServices.saveImport(event.import);
            if (event.prefixIdPelPasca != null) await ImportServices.savePrefixIdpelPasca(event.prefixIdPelPasca ?? '');
            if (event.prefixIdpelPra != null) await ImportServices.savePrefixIdpelPra(event.prefixIdpelPra ?? '');
            yield ImportBothImported();
            break;
          case Import.bothNotImported:
            break;
          case Import.pascabayarImported:
            await ImportServices.savePrefixIdpelPasca(event.prefixIdPelPasca ?? "");
            if (currentImport == Import.prabayarImported) {
              await ImportServices.saveImport(Import.bothImported);
              yield ImportBothImported();
            } else {
              await ImportServices.saveImport(event.import);
              yield ImportPascabayarImported();
            }
            break;
          case Import.prabayarImported:
            await ImportServices.savePrefixIdpelPra(event.prefixIdPelPasca ?? '');
            if (currentImport == Import.pascabayarImported) {
              await ImportServices.saveImport(Import.bothImported);
              yield ImportBothImported();
            } else {
              await ImportServices.saveImport(event.import);
              yield ImportPrabayarImported();
            }
            break;
        }
      } else {
        ImportServices.saveImport(event.import);
        switch (event.import) {
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
      }
    }
  }
}

enum Import {
  bothImported,
  bothNotImported,
  pascabayarImported,
  prabayarImported,
}
