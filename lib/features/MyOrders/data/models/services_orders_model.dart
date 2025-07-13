// To parse this JSON data, do
//
//     final servicesOrders = servicesOrdersFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'services_orders_model.g.dart';

ServicesOrders servicesOrdersFromJson(String str) =>
    ServicesOrders.fromJson(json.decode(str));

String servicesOrdersToJson(ServicesOrders data) => json.encode(data.toJson());

@JsonSerializable()
class ServicesOrders {
  @JsonKey(name: "status_code")
  int statusCode;
  @JsonKey(name: "error")
  int error;
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "pagination")
  Pagination pagination;
  @JsonKey(name: "data")
  List<Orders> data;

  ServicesOrders({
    required this.statusCode,
    required this.error,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory ServicesOrders.fromJson(Map<String, dynamic> json) =>
      _$ServicesOrdersFromJson(json);

  Map<String, dynamic> toJson() => _$ServicesOrdersToJson(this);
}

@JsonSerializable()
class Orders {
  @JsonKey(name: "service_order_id")
  String serviceOrderId;
  @JsonKey(name: "status")
  String status;
  @JsonKey(name: "posting_date")
  String postingDate;
  @JsonKey(name: "service_type")
  String serviceType;
  @JsonKey(name: "total_net_amount")
  int totalNetAmount;

  Orders({
    required this.serviceOrderId,
    required this.status,
    required this.postingDate,
    required this.serviceType,
    required this.totalNetAmount,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => _$OrdersFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersToJson(this);
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
