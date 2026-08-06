import 'package:json_annotation/json_annotation.dart';

part 'services_orders_model.g.dart';

// {"status_code":200
//"error":0,
//"message":"Service Orders retrieved successfully."
//,"pagination":{"page":1,"limit":10,"total_items":2,"total_pages":1},
//"data":{
//"totals":{
//"total_net_amount":120.0,
//"outstanding_amount":0.0,
//"received_amount":0.0},
//"orders":[
//{"service_order_id":"OC-25-10-0557",
//"status":"Approved",
//"posting_date":"2025-10-16",
//"service_type":"Daily","method_of_payment":"Cash","total_net_amount":0.0,"outstanding_amount":0.0,"received_amount":0.0},{"service_order_id":"OC-25-10-0556","status":"Approved","posting_date":"2025-10-16","service_type":"Daily","method_of_payment":"Cash","total_net_amount":120.0,"outstanding_amount":0.0,"received_amount":0.0}]}}
@JsonSerializable(explicitToJson: true)
class ServicesOrders {
  @JsonKey(name: 'status_code')
  final int statusCode;
  final int error;
  final String message;
  final Pagination pagination;
  final Data data;

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

@JsonSerializable(explicitToJson: true)
class Data {
  final List<Orders> orders;
  final Totals totals;

  Data({required this.orders, required this.totals});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Orders {
  @JsonKey(name: 'service_order_id')
  final String serviceOrderId;
  final String status;
  @JsonKey(name: 'posting_date')
  final String postingDate;
  @JsonKey(name: 'service_type')
  final String serviceType;
  @JsonKey(name: 'total_net_amount')
  final double totalNetAmount;
  @JsonKey(name: 'outstanding_amount')
  final double outstandingAmount;
  @JsonKey(name: 'received_amount')
  final double receivedAmount;
  @JsonKey(name: 'supervisor_name')
  final String supervisorName;
  @JsonKey(name: 'customer_name')
  final String customerName;

  @JsonKey(name: 'total_number_of_visits')
  final String? totalVisitsNumber;

  @JsonKey(name: 'visit_number')
  final String? visitNumber;

  Orders({
    required this.serviceOrderId,
    required this.status,
    required this.postingDate,
    required this.serviceType,
    required this.totalNetAmount,
    required this.outstandingAmount,
    required this.receivedAmount,
    required this.supervisorName,
    required this.customerName,
    required this.totalVisitsNumber,
    required this.visitNumber,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => _$OrdersFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersToJson(this);
}

@JsonSerializable()
class Totals {
  @JsonKey(name: 'total_net_amount')
  final double totalNetAmount;
  @JsonKey(name: 'outstanding_amount')
  final double totalOutstandingAmount;
  @JsonKey(name: 'received_amount')
  final double totalReceivedAmount;

  Totals({
    required this.totalOutstandingAmount,
    required this.totalNetAmount,
    required this.totalReceivedAmount,
  });

  factory Totals.fromJson(Map<String, dynamic> json) => _$TotalsFromJson(json);

  Map<String, dynamic> toJson() => _$TotalsToJson(this);
}

@JsonSerializable()
class Pagination {
  final int page;
  final int limit;
  @JsonKey(name: 'total_items')
  final int totalItems;
  @JsonKey(name: 'total_pages')
  final int totalPages;

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
