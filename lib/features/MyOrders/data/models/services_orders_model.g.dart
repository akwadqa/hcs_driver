// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'services_orders_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServicesOrders _$ServicesOrdersFromJson(Map<String, dynamic> json) =>
    ServicesOrders(
      statusCode: (json['status_code'] as num).toInt(),
      error: (json['error'] as num).toInt(),
      message: json['message'] as String,
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ServicesOrdersToJson(ServicesOrders instance) =>
    <String, dynamic>{
      'status_code': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'pagination': instance.pagination.toJson(),
      'data': instance.data.toJson(),
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  orders: (json['orders'] as List<dynamic>)
      .map((e) => Orders.fromJson(e as Map<String, dynamic>))
      .toList(),
  totals: Totals.fromJson(json['totals'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'orders': instance.orders.map((e) => e.toJson()).toList(),
  'totals': instance.totals.toJson(),
};

Orders _$OrdersFromJson(Map<String, dynamic> json) => Orders(
  serviceOrderId: json['service_order_id'] as String,
  status: json['status'] as String,
  postingDate: json['posting_date'] as String,
  serviceType: json['service_type'] as String,
  totalNetAmount: (json['total_net_amount'] as num).toInt(),
  outstandingAmount: (json['outstanding_amount'] as num).toInt(),
  receivedAmount: (json['received_amount'] as num).toInt(),
);

Map<String, dynamic> _$OrdersToJson(Orders instance) => <String, dynamic>{
  'service_order_id': instance.serviceOrderId,
  'status': instance.status,
  'posting_date': instance.postingDate,
  'service_type': instance.serviceType,
  'total_net_amount': instance.totalNetAmount,
  'outstanding_amount': instance.outstandingAmount,
  'received_amount': instance.receivedAmount,
};

Totals _$TotalsFromJson(Map<String, dynamic> json) => Totals(
  totalOutstandingAmount: (json['total_outstanding_amount'] as num).toInt(),
  totalNetAmount: (json['total_net_amount'] as num).toInt(),
  totalReceivedAmount: (json['total_received_amount'] as num).toInt(),
);

Map<String, dynamic> _$TotalsToJson(Totals instance) => <String, dynamic>{
  'total_outstanding_amount': instance.totalOutstandingAmount,
  'total_net_amount': instance.totalNetAmount,
  'total_received_amount': instance.totalReceivedAmount,
};

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  totalItems: (json['total_items'] as num).toInt(),
  totalPages: (json['total_pages'] as num).toInt(),
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total_items': instance.totalItems,
      'total_pages': instance.totalPages,
    };
