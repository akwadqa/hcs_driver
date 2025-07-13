// home_repository.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/Home/Customer/data/models/add_cutomer_mdoel.dart';
import 'package:hcs_driver/features/Home/Customer/data/models/customers_model.dart';
import 'package:hcs_driver/src/constants/api_constance.dart';
import 'package:hcs_driver/src/network/network_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_repository.g.dart';

@Riverpod(keepAlive: true)
CustomerRepository customerRepository(Ref ref) =>
    CustomerRepository(ref.watch(networkServiceProvider()));

class CustomerRepository {
  final NetworkService _networkService;

  CustomerRepository(this._networkService);

  Future<bool> addCustomer({required AddCustomerParams params}) async {
    var formData = FormData.fromMap({
      'customer_type': params.customerType,
      'customer_name': params.customerName,
      'customer_qid': params.customerQid,
      'customer_phone': params.customerPhone,
      'zone': params.customerZone,
      'location': params.customerArea,
      'location_url': params.customerLocation,
    });
    final response = await _networkService.post(
      ApiConstance.addCustomers,
      formData,
    );

    // final data = json.encode(response.data);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.message ?? 'Failed to Add Customers');
    }
  }

  Future<CustomersModel> getCustomers({required int page,required String customerName}) async {
    final response = await _networkService.get(
      ApiConstance.getCustomers(page: page.toString(),customerName: customerName),
    );
    // final data = json.encode(response.data);

    if (response.statusCode == 200) {
      final jsonString = json.encode(response.data);
      return customersModelFromJson(jsonString);
    } else {
      throw Exception(response.message ?? 'Failed to Get Customers');
    }
  }
}
