// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscountTypes _$DiscountTypesFromJson(Map<String, dynamic> json) =>
    DiscountTypes(
      statusCode: (json['status_code'] as num).toInt(),
      error: (json['error'] as num).toInt(),
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => Discount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DiscountTypesToJson(DiscountTypes instance) =>
    <String, dynamic>{
      'status_code': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

Discount _$DiscountFromJson(Map<String, dynamic> json) => Discount(
  id: json['id'] as String,
  title: json['title'] as String,
  discountPercentage: (json['discount_percentage'] as num).toInt(),
);

Map<String, dynamic> _$DiscountToJson(Discount instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'discount_percentage': instance.discountPercentage,
};
