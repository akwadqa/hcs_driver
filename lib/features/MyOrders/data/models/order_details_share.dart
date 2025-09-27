
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'order_details_share.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderDetailsShare extends Equatable {
  @JsonKey(name: 'status_code')
  final int? statusCode;

  final int? error;

  final String? message;

  final Data? data;

  const OrderDetailsShare({
    this.statusCode,
    this.error,
    this.message,
    this.data,
  });

  factory OrderDetailsShare.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsShareFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsShareToJson(this);

  @override
  List<Object?> get props => [statusCode, error, message, data];
}

@JsonSerializable(explicitToJson: true)
class Data extends Equatable {
  final String? status;

  final Supervisor? supervisor;

  final Customer? customer;

  final Driver? driver;

  final String? date;

  @JsonKey(name: 'service_type')
  final String? serviceType;

  @JsonKey(name: 'shift_type')
  final String? shiftType;

  @JsonKey(name: 'with_cleaning_supplies')
  final int? withCleaningSupplies;

  @JsonKey(name: 'discount_type')
  final dynamic discountType;

  @JsonKey(name: 'discount_percentage')
  final double? discountPercentage;

  @JsonKey(name: 'total_net_amount')
  final double? totalNetAmount;

  @JsonKey(name: 'outstanding_amount')
  final double? outstandingAmount;

  @JsonKey(name: 'method_of_payment')
  final String? methodOfPayment;

  @JsonKey(name: 'staff_appointment')
  final List<String>? staffAppointment;

  final String? note;

  final List<String>? days;

  const Data({
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
    this.outstandingAmount,
    this.methodOfPayment,
    this.staffAppointment,
    this.note,
    this.days,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);

  @override
  List<Object?> get props => [
        status,
        supervisor,
        customer,
        driver,
        date,
        serviceType,
        shiftType,
        withCleaningSupplies,
        discountType,
        discountPercentage,
        totalNetAmount,
        outstandingAmount,
        methodOfPayment,
        staffAppointment,
        note,
        days,
      ];
}

@JsonSerializable()
class Supervisor extends Equatable {
  final String? supervisor;

  @JsonKey(name: 'supervisor_name')
  final String? supervisorName;

  const Supervisor({this.supervisor, this.supervisorName});

  factory Supervisor.fromJson(Map<String, dynamic> json) =>
      _$SupervisorFromJson(json);

  Map<String, dynamic> toJson() => _$SupervisorToJson(this);

  @override
  List<Object?> get props => [supervisor, supervisorName];
}

@JsonSerializable()
class Customer extends Equatable {
  @JsonKey(name: 'customer_id')
  final String? customerId;

  @JsonKey(name: 'customer_name')
  final String? customerName;

  final String? location;

  @JsonKey(name: 'location_url')
  final String? locationUrl;

  final String? zone;

  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  const Customer({
    this.customerId,
    this.customerName,
    this.location,
    this.locationUrl,
    this.zone,
    this.phoneNumber,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  @override
  List<Object?> get props =>
      [customerId, customerName, location, locationUrl, zone, phoneNumber];
}

@JsonSerializable(explicitToJson: true)
class Driver extends Equatable {
  @JsonKey(name: 'driver_id')
  final String? driverId;

  @JsonKey(name: 'driver_name')
  final String? driverName;

  @JsonKey(name: 'current_driver_status')
  final String? currentDriverStatus;

  @JsonKey(name: 'driver_status')
  final List<DriverStatus>? driverStatus;

  const Driver({
    this.driverId,
    this.driverName,
    this.currentDriverStatus,
    this.driverStatus,
  });

  factory Driver.fromJson(Map<String, dynamic> json) =>
      _$DriverFromJson(json);

  Map<String, dynamic> toJson() => _$DriverToJson(this);

  @override
  List<Object?> get props =>
      [driverId, driverName, currentDriverStatus, driverStatus];
}

@JsonSerializable()
class DriverStatus extends Equatable {
  final String? status;

  final bool? active;

  const DriverStatus({this.status, this.active});

  factory DriverStatus.fromJson(Map<String, dynamic> json) =>
      _$DriverStatusFromJson(json);

  Map<String, dynamic> toJson() => _$DriverStatusToJson(this);

  @override
  List<Object?> get props => [status, active];
}
