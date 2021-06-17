part of 'customer_data_bloc.dart';

@immutable
abstract class CustomerDataEvent {}

class FetchCustomerData extends CustomerDataEvent {
  final String searchQuery;

  FetchCustomerData({
    this.searchQuery,
  });
}

class UpdateCustomerDataPasca extends CustomerDataEvent {}

class UpdateCustomerDataPra extends CustomerDataEvent {}
