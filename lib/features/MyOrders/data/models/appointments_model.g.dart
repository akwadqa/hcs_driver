// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointments_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    AppointmentModel(
      statusCode: (json['status_code'] as num).toInt(),
      error: (json['error'] as num).toInt(),
      message: json['message'] as String,
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
      data: (json['data'] as List<dynamic>)
          .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'status_code': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'pagination': instance.pagination,
      'data': instance.data,
    };

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
  logId: json['log_id'] as String,
  employee: json['employee'] as String,
  date: json['date'] as String,
  serviceType: json['service_type'] as String,
  serviceShift: json['service_shift'] as String,
  driverStatus: json['driver_status'] as String?,
  logStatus: json['log_status'] as String,
  creation: json['creation'] as String?,
  employeeName: json['employee_name'] as String,
);

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'log_id': instance.logId,
      'employee': instance.employee,
      'date': instance.date,
      'service_type': instance.serviceType,
      'service_shift': instance.serviceShift,
      'driver_status': instance.driverStatus,
      'log_status': instance.logStatus,
      'creation': instance.creation,
      'employee_name': instance.employeeName,
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
