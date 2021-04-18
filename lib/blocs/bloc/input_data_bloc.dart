import 'dart:io';
import 'dart:async';

import 'package:pdil/blocs/blocs.dart';
import 'package:pdil/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pdil/services/services.dart';
import 'package:sqflite/sqflite.dart';

part 'input_data_event.dart';
part 'input_data_state.dart';

class InputDataBloc extends Bloc<InputDataEvent, InputDataState> {
  DbHelper dbHelper = DbHelper();

  InputDataBloc() : super(InputDataInitial());

  @override
  Stream<InputDataState> mapEventToState(InputDataEvent event) async* {
    if (event is InputDataAdd) {
      // print("pdil Excel idPel : ${event.data.idPel}");
      // print("pdil Excel nama : ${event.data.nama}");
      // print("pdil Excel alamat : ${event.data.alamat}");
      // print("pdil Excel tarip : ${event.data.tarip}");
      // print("pdil Excel daya : ${event.data.daya}");
      // print("pdil Excel noHp : ${event.data.noHp}");
      // print("pdil Excel nik : ${event.data.nik}");
      // print("pdil Excel npwp : ${event.data.npwp}");

      double persentase = (event.row / event.maxRow) * 100;
      await dbHelper.insert(event.data);
      yield InputDataProgress(int.parse(persentase.toString().split(".")[0]));
    }
  }
}
