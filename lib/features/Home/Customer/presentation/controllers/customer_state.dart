import 'package:equatable/equatable.dart';
import 'package:hcs_driver/features/Home/Customer/data/models/customers_model.dart';
import 'package:hcs_driver/src/enums/request_state.dart';

class CustomerState extends Equatable {
  //customers
  final int? currentCustomersPage;
  final List<Customers> customers;
  final RequestStates customersStates;
  final String? customersMessage;
  final Customers? selectedCustomer;
  final String customerSearchedFor;

  const CustomerState({
    //customers
    this.currentCustomersPage,
    this.customers = const [],
    this.customersStates = RequestStates.init,
    this.customersMessage = '',
    this.selectedCustomer,
    this.customerSearchedFor = '',
  });
  CustomerState copyWith({
    //customers
    int? currentCustomersPage,
    List<Customers>? customers,
    RequestStates? customersStates,
    String? customersMessage,
    Customers? selectedCustomer,
    String? customerSearchedFor,
  }) {
    return CustomerState(
      //customers
      currentCustomersPage: currentCustomersPage,
      customers: customers ?? this.customers,
      customersStates: customersStates ?? this.customersStates,
      customersMessage: customersMessage ?? this.customersMessage,
      selectedCustomer: selectedCustomer,
      customerSearchedFor: customerSearchedFor ?? this.customerSearchedFor,
    );
  }

  @override
  List<Object?> get props => [
    //customers
    currentCustomersPage,
    customers,
    customersStates,
    customersMessage, selectedCustomer, customerSearchedFor,
  ];
}
