// home_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
import 'package:hcs_driver/features/MyOrders/data/models/services_orders_model.dart';
import 'package:hcs_driver/src/constants/api_constance.dart';
import 'package:hcs_driver/src/network/network_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'myorders_repository.g.dart';

@Riverpod(keepAlive: true)
MyOrdersRepository myOrdersRepository(Ref ref) =>
    MyOrdersRepository(ref.watch(networkServiceProvider()));

class MyOrdersRepository {
  final NetworkService _networkService;

  MyOrdersRepository(this._networkService);

  Future<ServicesOrders> getServicesOrders({
    required int page,
    required String status,
  }) async {
    final response = await _networkService.get(
      ApiConstance.myServicesOrders(page: page.toString(), status: status),
    );

    if (response.statusCode == 200) {
      return ServicesOrders.fromJson(response.data);
    } else {
      throw Exception(response.message ?? 'Failed to get Services Orders');
    }
  }

  Future<OrdersDetails> getServicesOrderDetails({
    required String serviceOrderId,
  }) async {
    final response = await _networkService.get(
      ApiConstance.getServiceOrderDetails(serviceOrderId: serviceOrderId),
    );

    if (response.statusCode == 200) {
      return OrdersDetails.fromJson(response.data);
    } else {
      throw Exception(
        response.message ?? 'Failed to get Services Order Details',
      );
    }
  }

  Future<bool> orderCancelltion({required String serviceOrderId}) async {
    var data = FormData.fromMap({'service_order_id': serviceOrderId});
    final response = await _networkService.post(
      ApiConstance.orderCancelltion(),
      data,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.message ?? 'Failed to cancel the orders');
    }
  }
}
