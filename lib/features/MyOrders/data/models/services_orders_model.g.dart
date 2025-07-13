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
      data: (json['data'] as List<dynamic>)
          .map((e) => Orders.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ServicesOrdersToJson(ServicesOrders instance) =>
    <String, dynamic>{
      'status_code': instance.statusCode,
      'error': instance.error,
      'message': instance.message,
      'pagination': instance.pagination,
      'data': instance.data,
    };

Orders _$OrdersFromJson(Map<String, dynamic> json) => Orders(
  serviceOrderId: json['service_order_id'] as String,
  status: json['status'] as String,
  postingDate: json['posting_date'] as String,
  serviceType: json['service_type'] as String,
  totalNetAmount: (json['total_net_amount'] as num).toInt(),
);

Map<String, dynamic> _$OrdersToJson(Orders instance) => <String, dynamic>{
  'service_order_id': instance.serviceOrderId,
  'status': instance.status,
  'posting_date': instance.postingDate,
  'service_type': instance.serviceType,
  'total_net_amount': instance.totalNetAmount,
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
