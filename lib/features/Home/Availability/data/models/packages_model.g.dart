// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packages_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackagesType _$PackagesTypeFromJson(Map<String, dynamic> json) => PackagesType(
  statusCode: (json['status_code'] as num).toInt(),
  error: (json['error'] as num).toInt(),
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => PackagesData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PackagesTypeToJson(PackagesType instance) =>
    <String, dynamic>{
      'status_code': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

PackagesData _$PackagesDataFromJson(Map<String, dynamic> json) => PackagesData(
  id: json['id'] as String,
  serviceItem: json['service_item'] as String,
  serviceCost: (json['service_cost'] as num).toInt(),
  numberOfVisits: json['number_of_visits'] as String?,
);

Map<String, dynamic> _$PackagesDataToJson(PackagesData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_item': instance.serviceItem,
      'service_cost': instance.serviceCost,
      'number_of_visits': instance.numberOfVisits,
    };
