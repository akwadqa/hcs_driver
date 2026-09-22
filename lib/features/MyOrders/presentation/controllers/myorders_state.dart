// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:hcs_driver/features/MyOrders/data/models/appointments_model.dart';
import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
import 'package:hcs_driver/features/MyOrders/data/models/services_orders_model.dart';
import 'package:hcs_driver/src/core/enums/shift_type_enum.dart';

class MyOrdersState extends Equatable {
  // --- UI Inputs & Pagination Variables (بقيت كما هي) ---
  final int? currentApprovedOrdersPage;
  final int? currentTodayOrdersPage;
  final int? currentTomorrowOrdersPage;
  final int? currentAppointmentsPage;
  final int? currentCustomOrdersPage;
  final int? currentCompletedOrdersPage;
  final String? lastCustomDate; // yyyy-MM-dd
  final String? searchKey;
  final List<ShiftTypeEnum> selectedShiftTypes;

  // --- Server Data Variables (تحولت إلى AsyncValue) ---
  final AsyncValue<List<Orders>> approvedOrders;
  final AsyncValue<List<StaffAppointments>> todayOrders;
  final AsyncValue<List<StaffAppointments>> tomorrowOrders;
  
  final AsyncValue<Details?> ordersDetails;
  
  // Status Order
  final AsyncValue<List<DriverStatus>> statusOrders;
  final String currentDriverStatus;
  final AsyncValue<String?> nextDriverStatus;

  final AsyncValue<List<StaffAppointments>> ordersAppointments;
  final AsyncValue<List<StaffAppointments>> customOrders;
  final AsyncValue<List<Orders>> completedOrders;

  // Action States (بديل للـ RequestStates الخاص بالعمليات التي لا تعيد بيانات)
  final AsyncValue<void>? orderCancellationState;

  const MyOrdersState({
    // UI & Pagination
    this.currentApprovedOrdersPage,
    this.currentTodayOrdersPage,
    this.currentTomorrowOrdersPage,
    this.currentAppointmentsPage,
    this.currentCustomOrdersPage,
    this.currentCompletedOrdersPage,
    this.lastCustomDate = '',
    this.searchKey = '',
    this.selectedShiftTypes = const [],

    // Server Data (AsyncValues)
    this.approvedOrders = const AsyncData([]),
    this.todayOrders = const AsyncData([]),
    this.tomorrowOrders = const AsyncData([]),
    this.ordersDetails = const AsyncData(null),
    this.statusOrders = const AsyncData([]),
    this.currentDriverStatus = '',
    this.nextDriverStatus = const AsyncData(null),
    this.ordersAppointments = const AsyncData([]),
    this.customOrders = const AsyncData([]),
    this.completedOrders = const AsyncData([]),
    this.orderCancellationState = const AsyncData(null),
  });

  MyOrdersState copyWith({
    int? currentApprovedOrdersPage,
    int? currentTodayOrdersPage,
    int? currentTomorrowOrdersPage,
    int? currentAppointmentsPage,
    int? currentCustomOrdersPage,
    int? currentCompletedOrdersPage,
    String? lastCustomDate,
    String? searchKey,
    List<ShiftTypeEnum>? selectedShiftTypes,
    bool clearShiftType = false,

    AsyncValue<List<Orders>>? approvedOrders,
    AsyncValue<List<StaffAppointments>>? todayOrders,
    AsyncValue<List<StaffAppointments>>? tomorrowOrders,
    AsyncValue<Details?>? ordersDetails,
    AsyncValue<List<DriverStatus>>? statusOrders,
    String? currentDriverStatus,
    AsyncValue<String?>? nextDriverStatus,
    AsyncValue<List<StaffAppointments>>? ordersAppointments,
    AsyncValue<List<StaffAppointments>>? customOrders,
    AsyncValue<List<Orders>>? completedOrders,
    AsyncValue<void>? orderCancellationState,
  }) {
    return MyOrdersState(
      currentApprovedOrdersPage: currentApprovedOrdersPage ?? this.currentApprovedOrdersPage,
      currentTodayOrdersPage: currentTodayOrdersPage ?? this.currentTodayOrdersPage,
      currentTomorrowOrdersPage: currentTomorrowOrdersPage ?? this.currentTomorrowOrdersPage,
      currentAppointmentsPage: currentAppointmentsPage ?? this.currentAppointmentsPage,
      currentCustomOrdersPage: currentCustomOrdersPage ?? this.currentCustomOrdersPage,
      currentCompletedOrdersPage: currentCompletedOrdersPage ?? this.currentCompletedOrdersPage,
      lastCustomDate: lastCustomDate ?? this.lastCustomDate,
      searchKey: searchKey ?? this.searchKey,
      selectedShiftTypes: clearShiftType ? [] : selectedShiftTypes ?? this.selectedShiftTypes,

      approvedOrders: approvedOrders ?? this.approvedOrders,
      todayOrders: todayOrders ?? this.todayOrders,
      tomorrowOrders: tomorrowOrders ?? this.tomorrowOrders,
      ordersDetails: ordersDetails ?? this.ordersDetails,
      statusOrders: statusOrders ?? this.statusOrders,
      currentDriverStatus: currentDriverStatus ?? this.currentDriverStatus,
      nextDriverStatus: nextDriverStatus ?? this.nextDriverStatus,
      ordersAppointments: ordersAppointments ?? this.ordersAppointments,
      customOrders: customOrders ?? this.customOrders,
      completedOrders: completedOrders ?? this.completedOrders,
      orderCancellationState: orderCancellationState ?? this.orderCancellationState,
    );
  }

  @override
  List<Object?> get props => [
        currentApprovedOrdersPage,
        currentTodayOrdersPage,
        currentTomorrowOrdersPage,
        currentAppointmentsPage,
        currentCustomOrdersPage,
        currentCompletedOrdersPage,
        lastCustomDate,
        searchKey,
        selectedShiftTypes,
        
        approvedOrders,
        todayOrders,
        tomorrowOrders,
        ordersDetails,
        statusOrders,
        currentDriverStatus,
        nextDriverStatus,
        ordersAppointments,
        customOrders,
        completedOrders,
        orderCancellationState,
      ];
}