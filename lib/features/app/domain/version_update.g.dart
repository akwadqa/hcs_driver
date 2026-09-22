// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VersionUpdate _$VersionUpdateFromJson(Map<String, dynamic> json) =>
    _VersionUpdate(
      appAndroidVersion: json['android_version'] as String,
      appIosVersion: json['ios_version'] as String,
      appUpdateRequired: json['app_update_required'] as bool?,
      appUpdateMessage: json['app_update_message'] as String?,
      appIosUrl: json['ios_url'] as String?,
      appAndroidUrl: json['android_url'] as String?,
    );

Map<String, dynamic> _$VersionUpdateToJson(_VersionUpdate instance) =>
    <String, dynamic>{
      'android_version': instance.appAndroidVersion,
      'ios_version': instance.appIosVersion,
      'app_update_required': instance.appUpdateRequired,
      'app_update_message': instance.appUpdateMessage,
      'ios_url': instance.appIosUrl,
      'android_url': instance.appAndroidUrl,
    };
