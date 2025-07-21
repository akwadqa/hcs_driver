// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updated_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatedStatus _$UpdatedStatusFromJson(Map<String, dynamic> json) =>
    UpdatedStatus(
      statusCode: (json['status_code'] as num).toInt(),
      error: (json['error'] as num).toInt(),
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => DriverStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UpdatedStatusToJson(UpdatedStatus instance) =>
    <String, dynamic>{
      'status_code': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };
