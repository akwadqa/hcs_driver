import 'package:json_annotation/json_annotation.dart';

part 'employees_model.g.dart';

@JsonSerializable()
class Employees {
  @JsonKey(name: "status_code")
  int statusCode;
  @JsonKey(name: "error")
  int error;
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "pagination")
  Pagination pagination;
  @JsonKey(name: "data")
  List<Employee> data;

  Employees({
    required this.statusCode,
    required this.error,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory Employees.fromJson(Map<String, dynamic> json) =>
      _$EmployeesFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeesToJson(this);
}

@JsonSerializable()
class Employee {
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "employee_name")
  final String employeeName;
  @JsonKey(name: "designation")
  final String designation;
  @JsonKey(name: "service_cost")
  final int serviceCost;
  @JsonKey(name: "shift")
  final String shift;

  const Employee({
    required this.name,
    required this.employeeName,
    required this.designation,
    required this.serviceCost,
    required this.shift,
  });

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Employee &&
          runtimeType == other.runtimeType &&
          employeeName == other.employeeName &&
          shift == other.shift;

  @override
  int get hashCode => employeeName.hashCode ^ shift.hashCode;
}

@JsonSerializable()
class Pagination {
  @JsonKey(name: "page")
  int page;
  @JsonKey(name: "limit")
  int limit;
  @JsonKey(name: "total_items")
  int totalItems;
  @JsonKey(name: "total_pages")
  int totalPages;

  Pagination({
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
