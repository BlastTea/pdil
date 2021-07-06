part of 'customer_data_bloc.dart';

@immutable
abstract class CustomerDataState {}

class CustomerDataInitial extends CustomerDataState {}

class CustomerDataResult extends CustomerDataState {
  final List<Pdil>? pdilPasca;
  final List<Pdil>? pdilPra;
  final String? searchResult;
  final String? column;
  final bool isSetIxExpandNull;

  CustomerDataResult({
    required this.pdilPasca,
    required this.pdilPra,
    this.searchResult,
    this.column,
    this.isSetIxExpandNull = false,
  });
}
