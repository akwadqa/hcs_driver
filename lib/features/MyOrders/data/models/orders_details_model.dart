// To parse this JSON Details, do
//
//     final ordersDetails = ordersDetailsFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'orders_details_model.g.dart';

OrdersDetails ordersDetailsFromJson(String str) =>
    OrdersDetails.fromJson(json.decode(str));

String ordersDetailsToJson(OrdersDetails details) =>
    json.encode(details.toJson());

@JsonSerializable()
class OrdersDetails {
  @JsonKey(name: "status_code")
  final int? statusCode;

  @JsonKey(name: "error")
  final int? error;

  @JsonKey(name: "message")
  final String? message;

  @JsonKey(name: "data")
  final Details? details;

  OrdersDetails({this.statusCode, this.error, this.message, this.details});

  factory OrdersDetails.fromJson(Map<String, dynamic> json) =>
      _$OrdersDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersDetailsToJson(this);
}

@JsonSerializable()
class Details {
  @JsonKey(name: "status")
  final String? status;

  @JsonKey(name: "supervisor")
  final Supervisor? supervisor;

  @JsonKey(name: "customer")
  final Customer? customer;

  @JsonKey(name: "driver")
  final Driver? driver;

  @JsonKey(name: "date")
  final String? date;

  @JsonKey(name: "service_type")
  final String? serviceType;

  @JsonKey(name: "shift_type")
  final String? shiftType;

  @JsonKey(name: "with_cleaning_supplies")
  final int? withCleaningSupplies;

  @JsonKey(name: "discount_type")
  final dynamic discountType;

  @JsonKey(name: "discount_percentage")
  final int? discountPercentage;

  @JsonKey(name: "total_net_amount")
  final int? totalNetAmount;

  @JsonKey(name: "method_of_payment")
  final String? methodOfPayment;

  @JsonKey(name: "staff_appointment")
  final List<String>? staffAppointment;

  @JsonKey(name: "note")
  final String? note;

  @JsonKey(name: "days")
  final List<String>? days;

  Details({
    this.status,
    this.supervisor,
    this.customer,
    this.driver,
    this.date,
    this.serviceType,
    this.shiftType,
    this.withCleaningSupplies,
    this.discountType,
    this.discountPercentage,
    this.totalNetAmount,
    this.methodOfPayment,
    this.staffAppointment,
    this.note,
    this.days,
  });

  factory Details.fromJson(Map<String, dynamic> json) =>
      _$DetailsFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsToJson(this);
}

@JsonSerializable()
class Customer {
  @JsonKey(name: "customer_id")
  final String customerId;

  @JsonKey(name: "customer_name")
  final String? customerName;

  @JsonKey(name: "location")
  final String? location;

  @JsonKey(name: "location_url")
  final String? locationUrl;

  @JsonKey(name: "zone")
  final String? zone;

  @JsonKey(name: "phone_number")
  String? phoneNumber;
  Customer({
    required this.customerId,
    this.customerName,
    this.location,
    this.locationUrl,
    this.zone,
    this.phoneNumber,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
class Driver {
  @JsonKey(name: "driver_id")
  final String driverId;

  @JsonKey(name: "driver_name")
  final String? driverName;

  @JsonKey(name: "current_driver_status")
  final String? currentDriverStatus;

  @JsonKey(name: "driver_status")
  final List<DriverStatus> driverStatus;

  Driver({
    required this.driverId,
    this.driverName,
    this.currentDriverStatus,
    required this.driverStatus,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);

  Map<String, dynamic> toJson() => _$DriverToJson(this);
}

@JsonSerializable()
class DriverStatus {
  @JsonKey(name: "status")
  final String status;
  @JsonKey(name: "active")
  final bool active;

  DriverStatus({required this.status, required this.active});

  factory DriverStatus.fromJson(Map<String, dynamic> json) =>
      _$DriverStatusFromJson(json);

  Map<String, dynamic> toJson() => _$DriverStatusToJson(this);
}

@JsonSerializable()
class Supervisor {
  @JsonKey(name: "supervisor")
  String supervisor;
  @JsonKey(name: "supervisor_name")
  String supervisorName;

  Supervisor({required this.supervisor, required this.supervisorName});

  factory Supervisor.fromJson(Map<String, dynamic> json) =>
      _$SupervisorFromJson(json);

  Map<String, dynamic> toJson() => _$SupervisorToJson(this);
}
