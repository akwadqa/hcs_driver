// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:hcs_driver/features/MyOrders/data/models/appointments_model.dart';
import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
import 'package:hcs_driver/features/MyOrders/data/models/services_orders_model.dart';
import 'package:hcs_driver/src/core/enums/request_state.dart';
import 'package:hcs_driver/src/core/enums/shift_type_enum.dart';

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
  final int? currentTodayOrdersPage;
  final List<StaffAppointments> todayOrders;
  final RequestStates todayOrdersStates;

  //tommorowOrders
  final int? currentTomorrowOrdersPage;
  final List<StaffAppointments> tomorrowOrders;
  final RequestStates tomorrowOrdersStates;

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
  final List<StaffAppointments> ordersAppointments;
  final RequestStates appointmentsStates;

  final RequestStates customOrdersState;
  final List<StaffAppointments> customOrders;
  final String? lastCustomDate; // yyyy-MM-dd
  final int? currentCustomOrdersPage;

  final List<Orders> completedOrders;
  final RequestStates completedOrdersStates;
  final int? currentCompletedOrdersPage;
  final String? searchKey;

  final ShiftTypeEnum? selectedShiftType;

  const MyOrdersState({
    //orders
    this.currentApprovedOrdersPage,
    this.customOrdersState = RequestStates.init,
    this.customOrders = const [],
    this.lastCustomDate = '',
    this.approvedOrders = const [],
    this.currentTodayOrdersPage,
    this.todayOrders = const [],
    this.currentTomorrowOrdersPage,
    this.currentCustomOrdersPage,
    this.tomorrowOrders = const [],
    this.approvedOrdersStates = RequestStates.init,
    this.todayOrdersStates = RequestStates.init,
    this.tomorrowOrdersStates = RequestStates.init,
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
    this.selectedShiftType,
  });
  MyOrdersState copyWith({
    int? currentApprovedOrdersPage,
    List<Orders>? approvedOrders,
    RequestStates? approvedOrdersStates,
    int? currentTodayOrdersPage,
    List<StaffAppointments>? todayOrders,
    RequestStates? todayOrdersStates,
    int? currentTomorrowOrdersPage,
    int? currentCustomOrdersPage,
    List<StaffAppointments>? tomorrowOrders,
    RequestStates? tomorrowOrdersStates,
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
    List<StaffAppointments>? ordersAppointments,
    RequestStates? appointmentsStates,
    RequestStates? customOrdersState,
    List<StaffAppointments>? customOrders,
    String? lastCustomDate,
    List<Orders>? completedOrders,
    RequestStates? completedOrdersStates,
    int? currentCompletedOrdersPage,
    String? searchKey,
    ShiftTypeEnum? selectedShiftType,
      bool clearShiftType = false,

  }) {
    return MyOrdersState(
      currentApprovedOrdersPage:
          currentApprovedOrdersPage ?? this.currentApprovedOrdersPage,
      approvedOrders: approvedOrders ?? this.approvedOrders,
      approvedOrdersStates: approvedOrdersStates ?? this.approvedOrdersStates,
      currentTodayOrdersPage:
          currentTodayOrdersPage ?? this.currentTodayOrdersPage,
      todayOrders: todayOrders ?? this.todayOrders,
      todayOrdersStates: todayOrdersStates ?? this.todayOrdersStates,
      currentTomorrowOrdersPage:
          currentTomorrowOrdersPage ?? this.currentTomorrowOrdersPage,
      currentCustomOrdersPage:
          currentCustomOrdersPage ?? this.currentCustomOrdersPage,
      tomorrowOrders: tomorrowOrders ?? this.tomorrowOrders,
      tomorrowOrdersStates: tomorrowOrdersStates ?? this.tomorrowOrdersStates,
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
      currentAppointmentsPage: currentAppointmentsPage,
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
     selectedShiftType: clearShiftType
        ? null
        : selectedShiftType ?? this.selectedShiftType,
    );
  }

  @override
  List<Object?> get props => [
    //orders
    currentApprovedOrdersPage,
    approvedOrders,
    currentTodayOrdersPage,
    todayOrders,
    currentTomorrowOrdersPage,
    tomorrowOrders,
    approvedOrdersStates,
    todayOrdersStates,
    tomorrowOrdersStates,
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
    selectedShiftType,
  ];
}
