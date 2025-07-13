import 'package:flutter/material.dart';
import 'package:hcs_driver/features/Home/Customer/data/models/add_cutomer_mdoel.dart';
import 'package:hcs_driver/features/Home/Customer/data/models/customers_model.dart';
import 'package:hcs_driver/features/Home/Customer/data/repositories/customer_repository.dart';
import 'package:hcs_driver/features/Home/Customer/presentation/controllers/customer_state.dart';
import 'package:hcs_driver/src/enums/request_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_controller.g.dart';

@riverpod
class CustomerController extends _$CustomerController {
  @override
  CustomerState build() => const CustomerState();

  Future<void> addCustomer(AddCustomerParams params) async {
    state = state.copyWith(customersStates: RequestStates.loading);

    try {
      final homeRepo = ref.read(customerRepositoryProvider);
      await homeRepo.addCustomer(params: params);

      fetchCostumers();
      // state = state.copyWith(customersStates: RequestStates.loaded);
    } catch (e) {
      state = state.copyWith(
        customersStates: RequestStates.error,
        customersMessage: e.toString(),
      );
    }
  }

  Future<void> toggleCustomer(Customers? selectedCustomer) async {
    if (state.selectedCustomer?.customerId == selectedCustomer?.customerId) {
      state = state.copyWith(selectedCustomer: null);
    } else {
      state = state.copyWith(selectedCustomer: selectedCustomer);
    }
  }

  searchCustomer(String customerName) {
    state = state.copyWith(customerSearchedFor: customerName);
    fetchCostumers();
  }

  Future<void> fetchCostumers() async {
    state = state.copyWith(customersStates: RequestStates.loading);

    try {
      final homeRepo = ref.read(customerRepositoryProvider);
      final customersData = await homeRepo.getCustomers(
        page: 1,
        customerName: state.customerSearchedFor,
      );

      int? nextPage;
      //if there is a second page ?
      if (customersData.pagination.totalPages > 1) {
        nextPage = 2;
      } else {
        nextPage = null;
      }
      debugPrint("ooo before $nextPage");
      state = state.copyWith(
        currentCustomersPage: nextPage,
        customers: customersData.data,
        // selectedCustomer: customersData.data[0],
        customersStates: RequestStates.loaded,
        customersMessage: '',
      );
      debugPrint("ooo after ${state.currentCustomersPage}");
    } catch (e) {
      state = state.copyWith(
        customersStates: RequestStates.error,
        customersMessage: e.toString(),
      );
    }
  }

  Future<void> onLoadMoreCostumers() async {
    try {
      final homeRepo = ref.read(customerRepositoryProvider);
      final customersData = await homeRepo.getCustomers(
        page: state.currentCustomersPage!,
        customerName: state.customerSearchedFor,
      );

      int? nextPage;
      //if we reach the limit or not ?
      if (customersData.pagination.totalPages > customersData.pagination.page) {
        nextPage = customersData.pagination.page + 1;
      } else {
        nextPage = null;
      }

      state = state.copyWith(
        currentCustomersPage: nextPage,
        customers: [...state.customers, ...customersData.data],
        customersStates: RequestStates.loaded,
        customersMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        customersStates: RequestStates.error,
        customersMessage: e.toString(),
      );
    }
  }
}
