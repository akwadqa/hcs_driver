// home_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/Home/Employees/data/models/employees_model.dart';
import 'package:hcs_driver/features/Home/Employees/data/models/get_employees_params.dart';
import 'package:hcs_driver/src/constants/api_constance.dart';
import 'package:hcs_driver/src/network/network_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employees_repository.g.dart';

@Riverpod(keepAlive: true)
EmployeesRepository employeesRepository(Ref ref) =>
    EmployeesRepository(ref.watch(networkServiceProvider()));

class EmployeesRepository {
  final NetworkService _networkService;

  EmployeesRepository(this._networkService);

  Future<Employees> getEmployees({
    required GetEmployeesParams getEmployeesParams,
  }) async {

    final response = await _networkService.get(
      ApiConstance.getEmployees(
        serviceType: getEmployeesParams.serviceType,
        date: getEmployeesParams.date,
        shift: getEmployeesParams.shift,
        serviceCategory: getEmployeesParams.serviceCategory,
        days: getEmployeesParams.days,
        employeeName: getEmployeesParams.employeeName,
        page: getEmployeesParams.page.toString(),
      ),
    );
    // final data = json.encode(response.data);

    if (response.statusCode == 200) {
      // final jsonString = json.encode(response.data);
      return Employees.fromJson(response.data);
    } else {
      throw Exception(response.message ?? 'Failed to Get Employees');
    }
  }
}
