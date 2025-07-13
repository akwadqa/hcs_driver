// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drivers_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Drivers _$DriversFromJson(Map<String, dynamic> json) => Drivers(
  statusCode: (json['status_code'] as num).toInt(),
  error: (json['error'] as num).toInt(),
  message: json['message'] as String,
  pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
  data: (json['data'] as List<dynamic>)
      .map((e) => Driver.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DriversToJson(Drivers instance) => <String, dynamic>{
  'status_code': instance.statusCode,
  'error': instance.error,
  'message': instance.message,
  'pagination': instance.pagination,
  'data': instance.data,
};

Driver _$DriverFromJson(Map<String, dynamic> json) => Driver(
  driverId: json['driver_id'] as String,
  fullName: json['full_name'] as String,
);

Map<String, dynamic> _$DriverToJson(Driver instance) => <String, dynamic>{
  'driver_id': instance.driverId,
  'full_name': instance.fullName,
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
