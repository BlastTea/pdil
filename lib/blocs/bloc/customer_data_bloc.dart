import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:pdil/blocs/blocs.dart';
import 'package:pdil/models/models.dart';
import 'package:pdil/services/navigation_helper.dart';
import 'package:pdil/services/services.dart';
import 'package:sqflite/sqflite.dart';

part 'customer_data_event.dart';
part 'customer_data_state.dart';

class CustomerDataBloc extends Bloc<CustomerDataEvent, CustomerDataState> {
  CustomerDataBloc() : super(CustomerDataInitial());

  List<Pdil>? pdilPasca;
  List<Pdil>? pdilPra;

  DbPasca dbPasca = DbPasca();
  DbPra dbPra = DbPra();

  @override
  Stream<CustomerDataState> mapEventToState(CustomerDataEvent event) async* {
    if (event is FetchCustomerData) {
      if (event.searchQuery != null) {
        if (event.column != null) {
          pdilPasca = await dbPasca.getPdilList(query: event.searchQuery, column: event.column);
          pdilPra = await dbPra.getPdilList(query: event.searchQuery, column: event.column);
          yield CustomerDataResult(
            pdilPasca: pdilPasca,
            pdilPra: pdilPra,
            searchResult: event.searchQuery,
            column: event.column,
            isSetIsExpandNull: event.isSetIsExpandNull,
          );
        } else {
          pdilPasca = await dbPasca.getPdilList(query: event.searchQuery);
          pdilPra = await dbPra.getPdilList(query: event.searchQuery);
          yield CustomerDataResult(
            pdilPasca: pdilPasca,
            pdilPra: pdilPra,
            searchResult: event.searchQuery,
            isSetIsExpandNull: event.isSetIsExpandNull,
          );
        }
      } else {
        pdilPasca = await dbPasca.getPdilList();
        pdilPra = await dbPra.getPdilList();
        yield CustomerDataResult(
          pdilPasca: pdilPasca,
          pdilPra: pdilPra,
          isSetIsExpandNull: event.isSetIsExpandNull,
        );
      }
    } else if (event is UpdateCustomerDataPasca) {
      pdilPasca = await dbPasca.getPdilList();
      yield CustomerDataResult(pdilPasca: pdilPasca, pdilPra: pdilPra);
    } else if (event is UpdateCustomerDataPra) {
      pdilPra = await dbPra.getPdilList();
      yield CustomerDataResult(pdilPasca: pdilPasca, pdilPra: pdilPra);
    } else if (event is UpdateIsExpandNull) {
      yield CustomerDataResult(
        pdilPasca: pdilPasca,
        pdilPra: pdilPra,
        isSetIsExpandNull: event.isSetIsExpandNull,
      );
    } else if (event is UpdateImageToDatabase) {
      int count = 0;
      if (event.isPasca) {
        count = await dbPasca.update(event.data);
        pdilPasca = await dbPasca.getPdilList();
      } else {
        count = await dbPra.update(event.data);
        pdilPra = await dbPra.getPdilList();
      }
      if (count > 0) {
        File imageFile = File(event.data.image!);
        var entity = await imageFile.delete();
        Fluttertoast.showToast(msg: 'Berhasil Diganti');
        NavigationHelper.back();
        NavigationHelper.back();
        yield CustomerDataResult(pdilPasca: pdilPasca, pdilPra: pdilPra);
      } else {
        Fluttertoast.showToast(msg: 'Gagal Diganti');
      }
    }
  }
}
