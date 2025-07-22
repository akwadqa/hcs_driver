// // To parse this JSON data, do
// //
// //     final updatedStatus = updatedStatusFromJson(jsonString);

// import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'dart:convert';

// part 'updated_status_model.g.dart';

// UpdatedStatus updatedStatusFromJson(String str) =>
//     UpdatedStatus.fromJson(json.decode(str));

// String updatedStatusToJson(UpdatedStatus data) => json.encode(data.toJson());

// @JsonSerializable()
// class UpdatedStatus {
//   @JsonKey(name: "status_code")
//   int statusCode;
//   @JsonKey(name: "error")
//   int error;
//   @JsonKey(name: "message")
//   String message;
//   @JsonKey(name: "data")
//   List<DriverStatus> data;

//   UpdatedStatus({
//     required this.statusCode,
//     required this.error,
//     required this.message,
//     required this.data,
//   });

//   factory UpdatedStatus.fromJson(Map<String, dynamic> json) =>
//       _$UpdatedStatusFromJson(json);

//   Map<String, dynamic> toJson() => _$UpdatedStatusToJson(this);
// }
