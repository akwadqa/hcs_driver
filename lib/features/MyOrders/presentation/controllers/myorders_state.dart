// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:hcs_driver/features/MyOrders/data/models/appointments_model.dart';
import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
import 'package:hcs_driver/features/MyOrders/data/models/services_orders_model.dart';
import 'package:hcs_driver/src/enums/request_state.dart';

// List<Appointment> dummyData = [
//   Appointment(name: '1111111'),
//   Appointment(name: '2222222'),
//   Appointment(name: '3333333'),
//   Appointment(name: '4444444'),
//   Appointment(name: '5555555'),
// ];

class MyOrdersState extends Equatable {
  //approvedOrders
  final int? currentApprovedOrdersPage;
  final List<Orders> approvedOrders;
  final RequestStates approvedOrdersStates;

  //pendingOrders
  final int? currentPendingOrdersPage;
  final List<Orders> pendingOrders;
  final RequestStates pendingOrdersStates;

  //cancelledOrders
  final int? currentCancelledOrdersPage;
  final List<Orders> cancelledOrders;
  final RequestStates cancelledOrdersStates;

  //
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
  final String? nextDriverStatus;
  final RequestStates statusOrderStates;
  final String? statusOrderMessage;

  //Appointments
  final int? currentAppointmentsPage;
  final List<Appointment> ordersAppointments;
  final RequestStates appointmentsStates;

  final RequestStates customOrdersState;
  final List<Orders> customOrders;
  final String? lastCustomDate; // yyyy-MM-dd
  final int? currentCustomOrdersPage;

  final List<Orders> completedOrders;
  final RequestStates completedOrdersStates;
  final int? currentCompletedOrdersPage;
  final String? searchKey;

  const MyOrdersState({
    //orders
    this.currentApprovedOrdersPage,
    this.customOrdersState = RequestStates.init,
    this.customOrders = const [],
    this.lastCustomDate = '',
    this.approvedOrders = const [],
    this.currentPendingOrdersPage,
    this.pendingOrders = const [],
    this.currentCancelledOrdersPage,
    this.currentCustomOrdersPage,
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
    this.nextDriverStatus,
    this.statusOrderStates = RequestStates.init,
    this.statusOrderMessage = '',

    //Appointments
    this.currentAppointmentsPage,
    this.ordersAppointments = const [],
    this.appointmentsStates = RequestStates.init,
    this.completedOrders = const [],
    this.completedOrdersStates = RequestStates.init,
    this.currentCompletedOrdersPage,
    this.searchKey = '',
  });
  MyOrdersState copyWith({
    int? currentApprovedOrdersPage,
    List<Orders>? approvedOrders,
    RequestStates? approvedOrdersStates,
    int? currentPendingOrdersPage,
    List<Orders>? pendingOrders,
    RequestStates? pendingOrdersStates,
    int? currentCancelledOrdersPage,
    int? currentCustomOrdersPage,
    List<Orders>? cancelledOrders,
    RequestStates? cancelledOrdersStates,
    String? ordersMessage,
    Details? ordersDetails,
    RequestStates? ordersDetailsStates,
    String? ordersDetailsMessage,
    RequestStates? orderCancelltionStates,
    String? orderCancelltionMessage,
    List<DriverStatus>? statusOrders,
    String? currentDriverStatus,
    String? nextDriverStatus,
    RequestStates? statusOrderStates,
    String? statusOrderMessage,
    int? currentAppointmentsPage,
    List<Appointment>? ordersAppointments,
    RequestStates? appointmentsStates,
    RequestStates? customOrdersState,
    List<Orders>? customOrders,
    String? lastCustomDate,
    List<Orders>? completedOrders,
    RequestStates? completedOrdersStates,
    int? currentCompletedOrdersPage,
    String? searchKey,
  }) {
    return MyOrdersState(
      currentApprovedOrdersPage:
          currentApprovedOrdersPage ?? this.currentApprovedOrdersPage,
      approvedOrders: approvedOrders ?? this.approvedOrders,
      approvedOrdersStates: approvedOrdersStates ?? this.approvedOrdersStates,
      currentPendingOrdersPage:
          currentPendingOrdersPage ?? this.currentPendingOrdersPage,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      pendingOrdersStates: pendingOrdersStates ?? this.pendingOrdersStates,
      currentCancelledOrdersPage:
          currentCancelledOrdersPage ?? this.currentCancelledOrdersPage,
      currentCustomOrdersPage:
          currentCustomOrdersPage ?? this.currentCustomOrdersPage,
      cancelledOrders: cancelledOrders ?? this.cancelledOrders,
      cancelledOrdersStates:
          cancelledOrdersStates ?? this.cancelledOrdersStates,
      ordersMessage: ordersMessage ?? this.ordersMessage,
      ordersDetails: ordersDetails ?? this.ordersDetails,
      ordersDetailsStates: ordersDetailsStates ?? this.ordersDetailsStates,
      ordersDetailsMessage: ordersDetailsMessage ?? this.ordersDetailsMessage,
      orderCancelltionStates:
          orderCancelltionStates ?? this.orderCancelltionStates,
      orderCancelltionMessage:
          orderCancelltionMessage ?? this.orderCancelltionMessage,
      statusOrders: statusOrders ?? this.statusOrders,
      currentDriverStatus: currentDriverStatus ?? this.currentDriverStatus,
      nextDriverStatus: nextDriverStatus ?? this.nextDriverStatus,
      statusOrderStates: statusOrderStates ?? this.statusOrderStates,
      statusOrderMessage: statusOrderMessage ?? this.statusOrderMessage,
      currentAppointmentsPage:
          currentAppointmentsPage ?? this.currentAppointmentsPage,
      ordersAppointments: ordersAppointments ?? this.ordersAppointments,
      appointmentsStates: appointmentsStates ?? this.appointmentsStates,
      customOrdersState: customOrdersState ?? this.customOrdersState,
      customOrders: customOrders ?? this.customOrders,
      lastCustomDate: lastCustomDate ?? this.lastCustomDate,
      completedOrders: completedOrders ?? this.completedOrders,
      completedOrdersStates:
          completedOrdersStates ?? this.completedOrdersStates,
      currentCompletedOrdersPage:
          currentCompletedOrdersPage ?? this.currentCompletedOrdersPage,
      searchKey: searchKey ?? this.searchKey,
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
    currentDriverStatus,
    nextDriverStatus,
    statusOrderMessage,
    statusOrderStates,

    //Appointments
    currentAppointmentsPage,
    ordersAppointments,
    appointmentsStates,
    customOrdersState,
    customOrders,

    lastCustomDate,

    completedOrders,
    completedOrdersStates,
    currentCompletedOrdersPage,
    searchKey,
  ];
}
