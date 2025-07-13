// To parse this JSON data, do
//
//     final customersModel = customersModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'customers_model.g.dart';

CustomersModel customersModelFromJson(String str) =>
    CustomersModel.fromJson(json.decode(str));

String customersModelToJson(CustomersModel data) => json.encode(data.toJson());

@JsonSerializable()
class CustomersModel {
  @JsonKey(name: "status_code")
  int statusCode;
  @JsonKey(name: "error")
  int error;
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "pagination")
  Pagination pagination;
  @JsonKey(name: "data")
  List<Customers> data;

  CustomersModel({
    required this.statusCode,
    required this.error,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory CustomersModel.fromJson(Map<String, dynamic> json) =>
      _$CustomersModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomersModelToJson(this);
}

@JsonSerializable()
class Customers {
  @JsonKey(name: "customer_id")
  String customerId;
  @JsonKey(name: "customer_name")
  String customerName;

  Customers({required this.customerId, required this.customerName});

  factory Customers.fromJson(Map<String, dynamic> json) =>
      _$CustomersFromJson(json);

  Map<String, dynamic> toJson() => _$CustomersToJson(this);
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
