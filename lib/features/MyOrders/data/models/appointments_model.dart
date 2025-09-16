import 'package:json_annotation/json_annotation.dart';

part 'appointments_model.g.dart';

@JsonSerializable()
class AppointmentModel {
  @JsonKey(name: "status_code")
  final int statusCode;
  @JsonKey(name: "error")
  final int error;
  @JsonKey(name: "message")
  final String message;
  @JsonKey(name: "pagination")
  final Pagination pagination;
  @JsonKey(name: "data")
  final List<Appointment> data;

  AppointmentModel({
    required this.statusCode,
    required this.error,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);
}

@JsonSerializable()
class Appointment {
  @JsonKey(name: "log_id")
  final String logId;
  @JsonKey(name: "employee")
  final String employee;
  @JsonKey(name: "date")
  final String date;
  @JsonKey(name: "service_type")
  final String serviceType;
  @JsonKey(name: "service_shift")
  final String serviceShift;
  @JsonKey(name: "driver_status")
  final String? driverStatus;
  @JsonKey(name: "log_status")
  final String logStatus;
  @JsonKey(name: "creation")
  final String? creation;
  @JsonKey(name: "employee_name")
  final String employeeName;
  @JsonKey(name: "supervisor_name")
  final String? supervisorName;

  Appointment({
    required this.logId,
    required this.employee,
    required this.date,
    required this.serviceType,
    required this.serviceShift,
    this.driverStatus,
    required this.logStatus,
    this.creation,
    required this.supervisorName,
    required this.employeeName,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}

@JsonSerializable()
class Pagination {
  @JsonKey(name: "page")
  final int page;
  @JsonKey(name: "limit")
  final int limit;
  @JsonKey(name: "total_items")
  final int totalItems;
  @JsonKey(name: "total_pages")
  final int totalPages;

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
