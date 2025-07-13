import 'package:dio/dio.dart';
import 'package:hcs_driver/features/Home/Employees/data/models/employees_model.dart';

class SubmitServiceParams {
  final String customerId;
  final String customerName;
  final String driver;
  final String date;
  final String serviceType;
  final String shiftType;
  final List<String>? days;
  final List<Employee> employees;
  final String paymentMethod;
  final String discountPercentage;
  final String withCleaningSupplies;

  SubmitServiceParams({
    required this.customerId,
    required this.customerName,
    required this.driver,
    required this.date,
    required this.serviceType,
    required this.shiftType,
    required this.days,
    required this.employees,
    required this.paymentMethod,
    required this.discountPercentage,
    required this.withCleaningSupplies,
  });

  Map<String, dynamic> toMap() {
    return {
      'customer_name': customerName,
      'customer': customerId,
      'driver': driver,
      'date': date,
      'service_type': serviceType,
      'shift_type': shiftType,
      'days': days, // Keep as-is; if backend expects string, only then encode
      'employees': employees
          .map(
            (e) => {
              'employee_name': e.name,
              'occupation': e.designation,
              'monthly_contract_amount': e.serviceCost,
              'shift': e.shift,
            },
          )
          .toList(),
      'payment_method': paymentMethod,
      'discount_percentage': discountPercentage,
      'with_cleaning_supplies': withCleaningSupplies == 'yes' ? 1 : 0,
    };
  }

  FormData toFormData() {
    return FormData.fromMap(toMap());
  }
}
