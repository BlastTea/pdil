part of 'customer_data_bloc.dart';

@immutable
abstract class CustomerDataEvent {}

class FetchCustomerData extends CustomerDataEvent {
  final String? searchQuery;
  final String? column;

  FetchCustomerData({
    this.searchQuery,
    this.column,
  });
}

class UpdateCustomerDataPasca extends CustomerDataEvent {}

class UpdateCustomerDataPra extends CustomerDataEvent {}
