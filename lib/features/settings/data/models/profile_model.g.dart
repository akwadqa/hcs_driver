// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  statusCode: (json['status_code'] as num).toInt(),
  error: (json['error'] as num).toInt(),
  message: json['message'] as String,
  data: Data.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'status_code': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  fullName: json['full_name'] as String,
  mobileNo: json['mobile_no'] as String,
  email: json['email'] as String,
  userImage: json['user_image'],
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'full_name': instance.fullName,
  'mobile_no': instance.mobileNo,
  'email': instance.email,
  'user_image': instance.userImage,
};
