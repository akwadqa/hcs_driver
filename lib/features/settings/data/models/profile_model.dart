// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'profile_model.g.dart';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

@JsonSerializable()
class ProfileModel {
  @JsonKey(name: "status_code")
  int statusCode;
  @JsonKey(name: "error")
  int error;
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "data")
  Data data;

  ProfileModel({
    required this.statusCode,
    required this.error,
    required this.message,
    required this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "full_name")
  String fullName;
  @JsonKey(name: "mobile_no")
  String mobileNo;
  @JsonKey(name: "email")
  String email;
  @JsonKey(name: "user_image")
  dynamic userImage;

  Data({
    required this.fullName,
    required this.mobileNo,
    required this.email,
    required this.userImage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
