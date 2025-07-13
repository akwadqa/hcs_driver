// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employees_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employees _$EmployeesFromJson(Map<String, dynamic> json) => Employees(
  statusCode: (json['status_code'] as num).toInt(),
  error: (json['error'] as num).toInt(),
  message: json['message'] as String,
  pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
  data: (json['data'] as List<dynamic>)
      .map((e) => Employee.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$EmployeesToJson(Employees instance) => <String, dynamic>{
  'status_code': instance.statusCode,
  'error': instance.error,
  'message': instance.message,
  'pagination': instance.pagination,
  'data': instance.data,
};

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
  name: json['name'] as String,
  employeeName: json['employee_name'] as String,
  designation: json['designation'] as String,
  serviceCost: (json['service_cost'] as num).toInt(),
  shift: json['shift'] as String,
);

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
  'name': instance.name,
  'employee_name': instance.employeeName,
  'designation': instance.designation,
  'service_cost': instance.serviceCost,
  'shift': instance.shift,
};

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  totalItems: (json['total_items'] as num).toInt(),
  totalPages: (json['total_pages'] as num).toInt(),
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total_items': instance.totalItems,
      'total_pages': instance.totalPages,
    };
