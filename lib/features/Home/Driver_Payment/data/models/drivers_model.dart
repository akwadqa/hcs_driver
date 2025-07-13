import 'package:json_annotation/json_annotation.dart';

part 'drivers_model.g.dart';

@JsonSerializable()
class Drivers {
  @JsonKey(name: "status_code")
  int statusCode;
  @JsonKey(name: "error")
  int error;
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "pagination")
  Pagination pagination;
  @JsonKey(name: "data")
  List<Driver> data;

  Drivers({
    required this.statusCode,
    required this.error,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory Drivers.fromJson(Map<String, dynamic> json) =>
      _$DriversFromJson(json);

  Map<String, dynamic> toJson() => _$DriversToJson(this);
}

@JsonSerializable()
class Driver {
  @JsonKey(name: "driver_id")
  String driverId;
  @JsonKey(name: "full_name")
  String fullName;

  Driver({required this.driverId, required this.fullName});

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);

  Map<String, dynamic> toJson() => _$DriverToJson(this);
}

@JsonSerializable()
class Pagination {
  @JsonKey(name: "page")
  int page;
  @JsonKey(name: "limit")
  int limit;
  @JsonKey(name: "total_items")
  int totalItems;
  @JsonKey(name: "total_pages")
  int totalPages;

  Pagination({
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
