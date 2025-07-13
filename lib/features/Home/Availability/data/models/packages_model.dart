import 'package:json_annotation/json_annotation.dart';
part 'packages_model.g.dart';

@JsonSerializable()
class PackagesType {
  @JsonKey(name: "status_code")
  int statusCode;
  @JsonKey(name: "error")
  int error;
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "data")
  List<PackagesData> data;

  PackagesType({
    required this.statusCode,
    required this.error,
    required this.message,
    required this.data,
  });

  factory PackagesType.fromJson(Map<String, dynamic> json) =>
      _$PackagesTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PackagesTypeToJson(this);
}

@JsonSerializable()
class PackagesData {
  @JsonKey(name: "id")
  String id;
  @JsonKey(name: "service_item")
  String serviceItem;
  @JsonKey(name: "service_cost")
  int serviceCost;
  @JsonKey(name: "number_of_visits")
  String? numberOfVisits;

  PackagesData({
    required this.id,
    required this.serviceItem,
    required this.serviceCost,
    required this.numberOfVisits,
  });

  factory PackagesData.fromJson(Map<String, dynamic> json) =>
      _$PackagesDataFromJson(json);

  Map<String, dynamic> toJson() => _$PackagesDataToJson(this);
}
