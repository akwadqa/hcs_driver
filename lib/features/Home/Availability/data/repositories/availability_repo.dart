// home_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/Home/Availability/data/models/packages_model.dart';
import 'package:hcs_driver/src/constants/api_constance.dart';
import 'package:hcs_driver/src/network/network_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'availability_repo.g.dart';

@Riverpod(keepAlive: true)
AvailabilityRepository availabilityRepository(Ref ref) =>
    AvailabilityRepository(ref.watch(networkServiceProvider()));

class AvailabilityRepository {
  final NetworkService _networkService;

  AvailabilityRepository(this._networkService);

  // Future<bool> addCustomer({required AddCustomerParams params}) async {
  //   var formData = FormData.fromMap({
  //     'customer_type': params.customerType,
  //     'customer_name': params.customerName,
  //     'customer_qid': params.customerQid,
  //     'customer_phone': params.customerPhone,
  //   });
  //   final response = await _networkService.post(
  //     ApiConstance.addCustomers,
  //     formData,
  //   );

  //   // final data = json.encode(response.data);

  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {
  //     throw Exception(response.message ?? 'Failed to Add Customers');
  //   }
  // }

  Future<PackagesType> getPackages() async {
    final response = await _networkService.get(ApiConstance.getPackages);
    // final data = json.encode(response.data);

    if (response.statusCode == 200) {
      // final jsonString = json.encode(response.data);
      return PackagesType.fromJson(response.data);
    } else {
      throw Exception(response.message ?? 'Failed to Get Packages');
    }
  }
}
