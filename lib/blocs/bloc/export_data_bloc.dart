import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdil/services/navigation_helper.dart';
import 'package:pdil/services/services.dart';
import 'package:path/path.dart';

import 'import_bloc.dart';

part 'export_data_event.dart';
part 'export_data_state.dart';

class ExportDataBloc extends Bloc<ExportDataEvent, ExportDataState> {
  ExportDataBloc() : super(ExportDataInitial());

  @override
  Stream<ExportDataState> mapEventToState(ExportDataEvent event) async* {
    if (event is ExportDataExport) {
      double persentase = event.persentase;
      if (persentase == 1.0) {
        List<Directory>? listDirectory = await getExternalStorageDirectories(type: StorageDirectory.downloads);
        var data = event.excel.save();
        File(join(listDirectory![0].path + '/${event.namaFile}.xlsx'))
          ..createSync(recursive: true)
          ..writeAsBytesSync(data!);
        NavigationHelper.back();
        NavigationHelper.back();
        if (event.isExport) {
          BlocProvider.of<ImportBloc>(event.context).add(ImportConfirm(await _getImportBloc(isExportBoth: event.isExportBoth, isPasca: event.isPasca), isFromExportPage: true));
          if (event.isExportBoth) {
            Future.delayed(const Duration(milliseconds: 1000)).then((value) {
              NavigationHelper.back();
            });
          }
        }
      }
      yield ExportDataProgress(progress: persentase, message: event.message, isExport: event.isExport, isExportBoth: event.isExportBoth, isPasca: event.isPasca);
    } else if (event is ExportDataInit) {
      yield ExportDataInitial();
    }
  }

  Future<Import> _getImportBloc({required bool isExportBoth, required bool isPasca}) async {
    Import currentImport = await ImportServices.getCurrentImport();
    switch (currentImport) {
      case Import.bothImported:
        if (isExportBoth) {
          return Import.bothNotImported;
        } else if (isPasca) {
          return Import.prabayarImported;
        } else if (!isPasca) {
          return Import.pascabayarImported;
        }
        break;
      case Import.bothNotImported:
        return Import.bothNotImported;
      case Import.pascabayarImported:
        if (isPasca) {
          return Import.bothNotImported;
        }
        break;
      case Import.prabayarImported:
        if (!isPasca) {
          return Import.bothNotImported;
        }
        break;
    }
    return Import.bothNotImported;
  }
}
