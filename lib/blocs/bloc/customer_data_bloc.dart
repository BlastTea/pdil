import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pdil/models/models.dart';
import 'package:pdil/services/services.dart';
import 'package:sqflite/sqflite.dart';

part 'customer_data_event.dart';
part 'customer_data_state.dart';

class CustomerDataBloc extends Bloc<CustomerDataEvent, CustomerDataState> {
  CustomerDataBloc() : super(CustomerDataInitial());

  List<Pdil> pdilPasca;
  List<Pdil> pdilPra;

  DbPasca dbPasca = DbPasca();
  DbPra dbPra = DbPra();

  @override
  Stream<CustomerDataState> mapEventToState(CustomerDataEvent event) async* {
    if (event is FetchCustomerData) {
      if (event.searchQuery != null) {
        pdilPasca = await dbPasca.getPdilList(query: event.searchQuery);
        pdilPra = await dbPra.getPdilList(query: event.searchQuery);
        yield CustomerDataResult(pdilPasca: pdilPasca, pdilPra: pdilPra);
      }

      pdilPasca = await dbPasca.getPdilList();
      pdilPra = await dbPra.getPdilList();
      yield CustomerDataResult(pdilPasca: pdilPasca, pdilPra: pdilPra);
    } else if (event is UpdateCustomerDataPasca) {
      pdilPasca = await dbPasca.getPdilList();
      yield CustomerDataResult(pdilPasca: pdilPasca, pdilPra: pdilPra);
    } else if (event is UpdateCustomerDataPra) {
      pdilPra = await dbPra.getPdilList();
      yield CustomerDataResult(pdilPasca: pdilPasca, pdilPra: pdilPra);
    }
  }
  
}