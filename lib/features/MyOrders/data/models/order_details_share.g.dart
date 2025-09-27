// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_share.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailsShare _$OrderDetailsShareFromJson(Map<String, dynamic> json) =>
    OrderDetailsShare(
      statusCode: (json['status_code'] as num?)?.toInt(),
      error: (json['error'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderDetailsShareToJson(OrderDetailsShare instance) =>
    <String, dynamic>{
      'status_code': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  status: json['status'] as String?,
  supervisor: json['supervisor'] == null
      ? null
      : Supervisor.fromJson(json['supervisor'] as Map<String, dynamic>),
  customer: json['customer'] == null
      ? null
      : Customer.fromJson(json['customer'] as Map<String, dynamic>),
  driver: json['driver'] == null
      ? null
      : Driver.fromJson(json['driver'] as Map<String, dynamic>),
  date: json['date'] as String?,
  serviceType: json['service_type'] as String?,
  shiftType: json['shift_type'] as String?,
  withCleaningSupplies: (json['with_cleaning_supplies'] as num?)?.toInt(),
  discountType: json['discount_type'],
  discountPercentage: (json['discount_percentage'] as num?)?.toDouble(),
  totalNetAmount: (json['total_net_amount'] as num?)?.toDouble(),
  outstandingAmount: (json['outstanding_amount'] as num?)?.toDouble(),
  methodOfPayment: json['method_of_payment'] as String?,
  staffAppointment: (json['staff_appointment'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  note: json['note'] as String?,
  days: (json['days'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'status': instance.status,
  'supervisor': instance.supervisor?.toJson(),
  'customer': instance.customer?.toJson(),
  'driver': instance.driver?.toJson(),
  'date': instance.date,
  'service_type': instance.serviceType,
  'shift_type': instance.shiftType,
  'with_cleaning_supplies': instance.withCleaningSupplies,
  'discount_type': instance.discountType,
  'discount_percentage': instance.discountPercentage,
  'total_net_amount': instance.totalNetAmount,
  'outstanding_amount': instance.outstandingAmount,
  'method_of_payment': instance.methodOfPayment,
  'staff_appointment': instance.staffAppointment,
  'note': instance.note,
  'days': instance.days,
};

Supervisor _$SupervisorFromJson(Map<String, dynamic> json) => Supervisor(
  supervisor: json['supervisor'] as String?,
  supervisorName: json['supervisor_name'] as String?,
);

Map<String, dynamic> _$SupervisorToJson(Supervisor instance) =>
    <String, dynamic>{
      'supervisor': instance.supervisor,
      'supervisor_name': instance.supervisorName,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
  customerId: json['customer_id'] as String?,
  customerName: json['customer_name'] as String?,
  location: json['location'] as String?,
  locationUrl: json['location_url'] as String?,
  zone: json['zone'] as String?,
  phoneNumber: json['phone_number'] as String?,
);

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
  'customer_id': instance.customerId,
  'customer_name': instance.customerName,
  'location': instance.location,
  'location_url': instance.locationUrl,
  'zone': instance.zone,
  'phone_number': instance.phoneNumber,
};

Driver _$DriverFromJson(Map<String, dynamic> json) => Driver(
  driverId: json['driver_id'] as String?,
  driverName: json['driver_name'] as String?,
  currentDriverStatus: json['current_driver_status'] as String?,
  driverStatus: (json['driver_status'] as List<dynamic>?)
      ?.map((e) => DriverStatus.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DriverToJson(Driver instance) => <String, dynamic>{
  'driver_id': instance.driverId,
  'driver_name': instance.driverName,
  'current_driver_status': instance.currentDriverStatus,
  'driver_status': instance.driverStatus?.map((e) => e.toJson()).toList(),
};

DriverStatus _$DriverStatusFromJson(Map<String, dynamic> json) => DriverStatus(
  status: json['status'] as String?,
  active: json['active'] as bool?,
);

Map<String, dynamic> _$DriverStatusToJson(DriverStatus instance) =>
    <String, dynamic>{'status': instance.status, 'active': instance.active};
