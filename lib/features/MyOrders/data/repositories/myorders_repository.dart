// home_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/MyOrders/data/models/appointments_model.dart';
import 'package:hcs_driver/features/MyOrders/data/models/order_details_share.dart';
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
    String? dateType,
    String? status,
    String? search,
    String? date,
  }) async {
    final response = await _networkService.get(
      ApiConstance.myServicesOrders(),
      queryParameters: {
        "page": page,
        "action": "driver",
        if (status != null) "status": status,
        if (search != null) "search": search,
        if (date != null) "for_date": date,
        if (dateType != null) "date_type": dateType,
      },
    );

    if (response.statusCode == 200) {
      return ServicesOrders.fromJson(response.data);
    } else {
      throw Exception(response.message ?? 'Failed to get Services Orders');
    }
  }

  Future<OrdersDetails> getServicesOrderDetails({
    // required String serviceOrderId,
    required String staffAppointmentLog,
  }) async {
    final response = await _networkService.get(
      ApiConstance.getServiceOrderDetails(
        // serviceOrderId: serviceOrderId,
        staffAppointmentLog: staffAppointmentLog,
      ),
    );

    if (response.statusCode == 200) {
      return OrdersDetails.fromJson(response.data);
    } else {
      throw Exception(
        response.message ?? 'Failed to get Services Order Details',
      );
    }
  }

  Future<OrderDetailsShare> getOrderDetails({
    required String serviceOrderId,
  }) async {
    final response = await _networkService.get(
      ApiConstance.getOrderDetails(serviceOrderId: serviceOrderId),
    );
    if (response.statusCode == 200) {
      return OrderDetailsShare.fromJson(response.data);
    } else {
      throw Exception(
        response.message ?? 'Failed to get Services Order Details',
      );
    }
  }

  Future<bool> orderCancelltion({
    required String serviceOrderId,
    required String? cancelMsg,
  }) async {
    var data = FormData.fromMap({'service_order_id': serviceOrderId});
    final response = await _networkService
        .post(ApiConstance.orderCancelltion(), {
          'service_order_id': serviceOrderId,

          if (cancelMsg != null || cancelMsg!.isNotEmpty)
            "cancellation_reason": cancelMsg,
        });

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.message ?? 'Failed to cancel the orders');
    }
  }

  Future<bool> orderAppointmentLogCancelltion({
    required String appoinmentLog,
    required String? cancelMsg,
  }) async {
    // var data = FormData.fromMap({'staff_appointment_log': appoinmentLog});
    final response = await _networkService
        .post(ApiConstance.cancelAppointmentLog, {
          'staff_appointment_log': appoinmentLog,
          if (cancelMsg != null || cancelMsg!.isNotEmpty)
            "cancellation_reason": cancelMsg,
        });

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
        response.message ?? 'Failed to cancel the order appoinmentLog',
      );
    }
  }

  Future<UpdatedStatus> updateStatusOrder({
    required String appointmentID,
    String? amount,
  }) async {
    var data = FormData.fromMap({'staff_appointment_log': appointmentID});
    final response = await _networkService.post(
      ApiConstance.updateStatusOrder,
      {
        'staff_appointment_log': appointmentID,

        if (amount != null) "amount": amount,
      },
    );

    if (response.statusCode == 200) {
      return UpdatedStatus.fromJson(response.data);
    } else {
      throw Exception(response.message ?? 'Failed to update Status Order');
    }
  }

  Future<AppointmentModel> getAppontments({
    required int page,
    required String orderId,
     String? dateType,
  }) async {
    final response = await _networkService.get(
      ApiConstance.appontmentsLogs(page: page, orderId: orderId),
      queryParameters: {if (dateType != null) "date_type": dateType},
      // queryParameters: {"date_type": 'today'},
    );

    if (response.statusCode == 200) {
      return AppointmentModel.fromJson(response.data);
    } else {
      throw Exception(response.message ?? 'Failed to get Appontments');
    }
  }

  Future<AppointmentModel> getAppontmentsDetails({
    required int page,
    required String staffAppointmentLog,
  }) async {
    final response = await _networkService.get(
      ApiConstance.appontmentsLogsDetails(
        page: page,
        staffAppointmentLog: staffAppointmentLog,
      ),
    );

    if (response.statusCode == 200) {
      return AppointmentModel.fromJson(response.data);
    } else {
      throw Exception(response.message ?? 'Failed to get Appontments');
    }
  }
}
