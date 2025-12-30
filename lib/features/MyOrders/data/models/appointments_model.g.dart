// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointments_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentModel _$AppointmentModelFromJson(
  Map<String, dynamic> json,
) => AppointmentModel(
  statusCode: (json['status_code'] as num).toInt(),
  error: (json['error'] as num).toInt(),
  message: json['message'] as String,
  pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
  data: StaffAppointmentsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'status_code': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'pagination': instance.pagination,
      'data': instance.data,
    };

StaffAppointmentsData _$StaffAppointmentsDataFromJson(
  Map<String, dynamic> json,
) => StaffAppointmentsData(
  staffAppointments: (json['logs'] as List<dynamic>)
      .map((e) => StaffAppointments.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StaffAppointmentsDataToJson(
  StaffAppointmentsData instance,
) => <String, dynamic>{'logs': instance.staffAppointments};

StaffAppointments _$StaffAppointmentsFromJson(Map<String, dynamic> json) =>
    StaffAppointments(
      logId: json['log_id'] as String,
      date: json['date'] as String,
      serviceType: json['service_type'] as String,
      serviceShift: json['service_shift'] as String,
      supervisorName: json['supervisor_name'] as String?,
      serviceOrderId: json['service_order_id'] as String,
      status: json['status'] as String,
      paymentMethod: json['method_of_payment'] as String,
      totalNetAmount: (json['total_net_amount'] as num).toDouble(),
      outstandingAmount: (json['outstanding_amount'] as num).toDouble(),
      postingDate: json['posting_date'] as String,
      shiftType: json['shift_type'] as String,
      driverStatus: json['driver_status'] as String?,
      customerName: json['customer_name'] as String?,
      customerPhone: json['customer_phone_number'] as String?,
      customerLocation: json['customer_location'] as String?,
      numberOfCleaners: (json['number_of_cleaners'] as num?)?.toInt(),
      totalVisitsNumber: (json['total_number_of_visits'] as num?)?.toInt(),
      visitNumber: json['visit_number'] as String?,
    );

Map<String, dynamic> _$StaffAppointmentsToJson(StaffAppointments instance) =>
    <String, dynamic>{
      'log_id': instance.logId,
      'service_order_id': instance.serviceOrderId,
      'status': instance.status,
      'driver_status': instance.driverStatus,
      'method_of_payment': instance.paymentMethod,
      'total_net_amount': instance.totalNetAmount,
      'outstanding_amount': instance.outstandingAmount,
      'posting_date': instance.postingDate,
      'date': instance.date,
      'service_type': instance.serviceType,
      'service_shift': instance.serviceShift,
      'shift_type': instance.shiftType,
      'supervisor_name': instance.supervisorName,
      'customer_name': instance.customerName,
      'customer_phone_number': instance.customerPhone,
      'customer_location': instance.customerLocation,
      'number_of_cleaners': instance.numberOfCleaners,
      'total_number_of_visits': instance.totalVisitsNumber,
      'visit_number': instance.visitNumber,
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
