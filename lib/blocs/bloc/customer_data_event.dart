part of 'customer_data_bloc.dart';

@immutable
abstract class CustomerDataEvent {}

class FetchCustomerData extends CustomerDataEvent {
  final String? searchQuery;
  final String? column;
  final bool isSetIsExpandNull;

  FetchCustomerData({
    this.searchQuery,
    this.column,
    this.isSetIsExpandNull = false,
  });
}

class UpdateCustomerDataPasca extends CustomerDataEvent {}

class UpdateCustomerDataPra extends CustomerDataEvent {}

class UpdateIsExpandNull extends CustomerDataEvent {
  final bool isSetIsExpandNull;

  UpdateIsExpandNull({required this.isSetIsExpandNull});
}

class UpdateImageToDatabase extends CustomerDataEvent {
  final bool isPasca;
  final Pdil data;

  UpdateImageToDatabase({required this.isPasca, required this.data});
}
