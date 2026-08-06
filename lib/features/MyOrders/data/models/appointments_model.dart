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
  final StaffAppointmentsData data;

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
class StaffAppointmentsData {
  @JsonKey(name: "logs")
  final List<StaffAppointments> staffAppointments;

  StaffAppointmentsData({required this.staffAppointments});

  factory StaffAppointmentsData.fromJson(Map<String, dynamic> json) =>
      _$StaffAppointmentsDataFromJson(json);

  Map<String, dynamic> toJson() => _$StaffAppointmentsDataToJson(this);
}

@JsonSerializable()
class StaffAppointments {
  @JsonKey(name: "service_order_id")
  final String serviceOrderId;
  
  @JsonKey(name: "status")
  final String status;
  
  @JsonKey(name: "posting_date")
  final String postingDate;
  
  @JsonKey(name: "shift_type")
  final String shiftType;
  
  @JsonKey(name: "date")
  final String date;
  
  @JsonKey(name: "driver_status")
  final String? driverStatus;
  
  @JsonKey(name: "service_type")
  final String? serviceType;
  
  @JsonKey(name: "method_of_payment")
  final String paymentMethod;
  
  @JsonKey(name: "total_net_amount")
  final double totalNetAmount;
  
  @JsonKey(name: "outstanding_amount")
  final double outstandingAmount;
  
  @JsonKey(name: "received_amount")
  final double receivedAmount;
  
  @JsonKey(name: "supervisor_name")
  final String? supervisorName;
  
  @JsonKey(name: "customer_name")
  final String? customerName;
  
  @JsonKey(name: "customer_phone_number")
  final String? customerPhone;
  
  @JsonKey(name: "customer_location")
  final String? customerLocation;
  
  @JsonKey(name: "customer_location_url")
  final String? customerLocationUrl;
  
  @JsonKey(name: "total_number_of_visits")
  final int? totalVisitsNumber;
  
  @JsonKey(name: "visit_number")
  final String? visitNumber;
  
  @JsonKey(name: "staff_appointment")
  final List<String>? staffAppointmentNames;
  
  @JsonKey(name: "number_of_cleaners")
  final int? numberOfCleaners;

  @JsonKey(name: "note")
  final String? note;

  StaffAppointments({
    required this.serviceOrderId,
    required this.status,
    required this.postingDate,
    required this.shiftType,
    required this.date,
    this.driverStatus,
    this.serviceType,
    required this.paymentMethod,
    required this.totalNetAmount,
    required this.outstandingAmount,
    required this.receivedAmount,
    this.supervisorName,
    this.customerName,
    this.customerPhone,
    this.customerLocation,
    this.customerLocationUrl,
    this.totalVisitsNumber,
    this.visitNumber,
    this.staffAppointmentNames,
    this.numberOfCleaners, 
  required this.note,
  });

  factory StaffAppointments.fromJson(Map<String, dynamic> json) =>
      _$StaffAppointmentsFromJson(json);

  Map<String, dynamic> toJson() => _$StaffAppointmentsToJson(this);
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
