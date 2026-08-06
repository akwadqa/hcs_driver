// To parse this JSON Details, do
//
//     final ordersDetails = ordersDetailsFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
part 'orders_details_model.g.dart';

OrdersDetails ordersDetailsFromJson(String str) =>
    OrdersDetails.fromJson(json.decode(str));

String ordersDetailsToJson(OrdersDetails data) => json.encode(data.toJson());

@JsonSerializable()
class OrdersDetails {
  @JsonKey(name: "status_code")
  final int statusCode;
  @JsonKey(name: "error")
  final int error;
  @JsonKey(name: "message")
  final String message;
  @JsonKey(name: "data")
  final Details details;

  OrdersDetails({
    required this.statusCode,
    required this.error,
    required this.message,
    required this.details,
  });

  factory OrdersDetails.fromJson(Map<String, dynamic> json) =>
      _$OrdersDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersDetailsToJson(this);
}

@JsonSerializable()
class Details {
  @JsonKey(name: "status")
  final String status;
  
  // تم تحويلها إلى Nullable لأنها لا تظهر في استجابة الـ JSON الحالية
  @JsonKey(name: "log_id")
  final String? logId; 
  @JsonKey(name: "log_status")
  final String? logStatus;

  @JsonKey(name: "supervisor")
  final Supervisor supervisor;
  @JsonKey(name: "customer")
  final Customer customer;
  @JsonKey(name: "driver")
  final Driver driver;
  @JsonKey(name: "date")
  final String date;
  @JsonKey(name: "service_type")
  final String serviceType;
  @JsonKey(name: "shift_type")
  final String shiftType;
  @JsonKey(name: "with_cleaning_supplies")
  final int withCleaningSupplies;
  @JsonKey(name: "discount_type")
  final dynamic discountType;
  
  // تم التعديل إلى double بناءً على الـ JSON (0.0)
  @JsonKey(name: "discount_percentage")
  final double discountPercentage;
  // تم التعديل إلى double بناءً على الـ JSON (1400.0)
  @JsonKey(name: "total_net_amount")
  final double totalNetAmount;
  
  // حقل جديد مضاف من الـ JSON
  @JsonKey(name: "outstanding_amount")
  final double outstandingAmount;
  
  @JsonKey(name: "method_of_payment")
  final String methodOfPayment;
  @JsonKey(name: "skipcash_link")
  final String? skipCashLink;
  @JsonKey(name: "staff_appointment")
  final List<String> staffAppointment;
  
  // حقول جديدة مضافة من الـ JSON
  @JsonKey(name: "service_items")
  final List<dynamic>? serviceItems;
  @JsonKey(name: "note")
  final dynamic note;
  @JsonKey(name: "staff_appointment_log")
  final String? staffAppointmentLog;
  @JsonKey(name: "days")
  final List<dynamic>? days;

  

  Details({
    required this.status,
    this.logId,
    this.logStatus,
    required this.supervisor,
    required this.customer,
    required this.driver,
    required this.date,
    required this.serviceType,
    required this.shiftType,
    required this.withCleaningSupplies,
    this.discountType,
    required this.discountPercentage,
    required this.totalNetAmount,
    required this.outstandingAmount, // حقل جديد
    required this.methodOfPayment,
    this.skipCashLink,
    required this.staffAppointment,
    this.serviceItems, // حقل جديد
    this.note,
    this.staffAppointmentLog, // حقل جديد
    this.days, // حقل جديد
  });

  
  Details copyWith({
    String? status,
    String? logId,
    String? logStatus,
    Supervisor? supervisor,
    Customer? customer,
    Driver? driver,
    String? date,
    String? serviceType,
    String? shiftType,
    int? withCleaningSupplies,
    dynamic discountType,
    double? discountPercentage,
    double? totalNetAmount,
    double? outstandingAmount,
    String? methodOfPayment,
    String? skipCashLink,
    List<String>? staffAppointment,
    List<dynamic>? serviceItems,
    dynamic note,
    String? staffAppointmentLog,
    List<dynamic>? days,
  }) {
    return Details(
      status: status ?? this.status,
      logId: logId ?? this.logId,
      logStatus: logStatus ?? this.logStatus,
      supervisor: supervisor ?? this.supervisor,
      customer: customer ?? this.customer,
      driver: driver ?? this.driver,
      date: date ?? this.date,
      serviceType: serviceType ?? this.serviceType,
      shiftType: shiftType ?? this.shiftType,
      withCleaningSupplies:
          withCleaningSupplies ?? this.withCleaningSupplies,
      discountType: discountType ?? this.discountType,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      totalNetAmount: totalNetAmount ?? this.totalNetAmount,
      outstandingAmount: outstandingAmount ?? this.outstandingAmount,
      methodOfPayment: methodOfPayment ?? this.methodOfPayment,
      skipCashLink: skipCashLink ?? this.skipCashLink,
      staffAppointment: staffAppointment ?? this.staffAppointment,
      serviceItems: serviceItems ?? this.serviceItems,
      note: note ?? this.note,
      staffAppointmentLog: staffAppointmentLog ?? this.staffAppointmentLog,
      days: days ?? this.days,
    );
  }


  factory Details.fromJson(Map<String, dynamic> json) =>
      _$DetailsFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsToJson(this);
}

@JsonSerializable()
class Customer {
  @JsonKey(name: "customer_id")
  final String customerId;
  @JsonKey(name: "customer_name")
  final String customerName;
  @JsonKey(name: "location")
  final String? location;
  @JsonKey(name: "location_url")
  final String? locationUrl; // تم التعديل من dynamic إلى String?
  @JsonKey(name: "zone")
  final String? zone;
  @JsonKey(name: "phone_number")
  final String phoneNumber;

  Customer({
    required this.customerId,
    required this.customerName,
    this.location,
    this.locationUrl,
    this.zone,
    required this.phoneNumber,
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
  final String driverName;
  @JsonKey(name: "current_driver_status")
  final String currentDriverStatus;
  @JsonKey(name: "driver_status")
  final List<DriverStatus> driverStatus;

  Driver({
    required this.driverId,
    required this.driverName,
    required this.currentDriverStatus,
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
  final String supervisor;
  @JsonKey(name: "supervisor_name")
  final String? supervisorName;

  Supervisor({required this.supervisor, this.supervisorName});

  factory Supervisor.fromJson(Map<String, dynamic> json) =>
      _$SupervisorFromJson(json);

  Map<String, dynamic> toJson() => _$SupervisorToJson(this);
}

UpdatedStatus updatedStatusFromJson(String str) =>
    UpdatedStatus.fromJson(json.decode(str));

String updatedStatusToJson(UpdatedStatus data) => json.encode(data.toJson());

@JsonSerializable()
class UpdatedStatus {
  @JsonKey(name: "status_code")
  int statusCode;
  @JsonKey(name: "error")
  int error;
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "data")
  List<DriverStatus> data;

  UpdatedStatus({
    required this.statusCode,
    required this.error,
    required this.message,
    required this.data,
  });

  factory UpdatedStatus.fromJson(Map<String, dynamic> json) =>
      _$UpdatedStatusFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatedStatusToJson(this);
}