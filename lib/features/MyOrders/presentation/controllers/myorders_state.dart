import 'package:equatable/equatable.dart';
import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
import 'package:hcs_driver/features/MyOrders/data/models/services_orders_model.dart';

import 'package:hcs_driver/src/enums/request_state.dart';

class MyOrdersState extends Equatable {
  //orders
  final int? currentApprovedOrdersPage;
  final List<Orders> approvedOrders;
  final int? currentPendingOrdersPage;
  final List<Orders> pendingOrders;
  final int? currentCancelledOrdersPage;
  final List<Orders> cancelledOrders;
  final RequestStates approvedOrdersStates;
  final RequestStates pendingOrdersStates;
  final RequestStates cancelledOrdersStates;
  final String? ordersMessage;

  //Orders Details
  final Details? ordersDetails;
  final RequestStates ordersDetailsStates;
  final String? ordersDetailsMessage;

  //cancelltion
  final RequestStates orderCancelltionStates;
  final String? orderCancelltionMessage;

  //status Order
  final List<DriverStatus> statusOrders;
  final String currentDriverStatus;
  final RequestStates statusOrderStates;
  final String? statusOrderMessage;
  const MyOrdersState({
    //orders
    this.currentApprovedOrdersPage,
    this.approvedOrders = const [],
    this.currentPendingOrdersPage,
    this.pendingOrders = const [],
    this.currentCancelledOrdersPage,
    this.cancelledOrders = const [],
    this.approvedOrdersStates = RequestStates.init,
    this.pendingOrdersStates = RequestStates.init,
    this.cancelledOrdersStates = RequestStates.init,
    this.ordersMessage = '',
    //Orders Details
    this.ordersDetails,
    this.ordersDetailsStates = RequestStates.init,
    this.ordersDetailsMessage = '',

    //cancelletion
    this.orderCancelltionStates = RequestStates.init,
    this.orderCancelltionMessage = '',

    //status order
    this.statusOrders = const [],
    this.currentDriverStatus = '',
    this.statusOrderStates = RequestStates.init,
    this.statusOrderMessage = '',
  });
  MyOrdersState copyWith({
    //orders
    int? currentApprovedOrdersPage,
    List<Orders>? approvedOrders,
    int? currentPendingOrdersPage,
    List<Orders>? pendingOrders,
    int? currentCancelledOrdersPage,
    List<Orders>? cancelledOrders,
    RequestStates? approvedOrdersStates,
    RequestStates? pendingOrdersStates,
    RequestStates? cancelledOrdersStates,
    String? ordersMessage,

    //Orders Details
    Details? ordersDetails,
    RequestStates? ordersDetailsStates,
    String? ordersDetailsMessage,

    //cancelletion
    RequestStates? orderCancelltionStates,
    String? orderCancelltionMessage,

    //status Order
    List<DriverStatus>? statusOrders,
    String? currentDriverStatus,
    RequestStates? statusOrderStates,
    String? statusOrderMessage,
  }) {
    return MyOrdersState(
      //orders
      currentApprovedOrdersPage: currentApprovedOrdersPage,
      approvedOrders: approvedOrders ?? this.approvedOrders,
      currentPendingOrdersPage: currentPendingOrdersPage,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      currentCancelledOrdersPage: currentCancelledOrdersPage,
      cancelledOrders: cancelledOrders ?? this.cancelledOrders,
      approvedOrdersStates: approvedOrdersStates ?? this.approvedOrdersStates,
      pendingOrdersStates: pendingOrdersStates ?? this.pendingOrdersStates,
      cancelledOrdersStates:
          cancelledOrdersStates ?? this.cancelledOrdersStates,
      ordersMessage: ordersMessage ?? this.ordersMessage,

      //Orders Details
      ordersDetails: ordersDetails ?? this.ordersDetails,
      ordersDetailsMessage: ordersDetailsMessage ?? this.ordersDetailsMessage,
      ordersDetailsStates: ordersDetailsStates ?? this.ordersDetailsStates,
      //cancelletion
      orderCancelltionStates:
          orderCancelltionStates ?? this.orderCancelltionStates,
      orderCancelltionMessage:
          orderCancelltionMessage ?? this.orderCancelltionMessage,

      // status orders
      statusOrders: statusOrders ?? this.statusOrders,
      currentDriverStatus: currentDriverStatus ?? this.currentDriverStatus,
      statusOrderMessage: statusOrderMessage ?? this.statusOrderMessage,
      statusOrderStates: statusOrderStates ?? this.statusOrderStates,
    );
  }

  @override
  List<Object?> get props => [
    //orders
    currentApprovedOrdersPage,
    approvedOrders,
    currentPendingOrdersPage,
    pendingOrders,
    currentCancelledOrdersPage,
    cancelledOrders,
    approvedOrdersStates,
    pendingOrdersStates,
    cancelledOrdersStates,
    ordersMessage,

    //Orders Details
    ordersDetails,
    ordersDetailsMessage,
    ordersDetailsStates,
    orderCancelltionStates,
    orderCancelltionMessage,

    //status order
    statusOrders,
    currentDriverStatus, statusOrderMessage, statusOrderStates,
  ];
}
