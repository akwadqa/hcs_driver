import 'package:flutter/cupertino.dart';
import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
import 'package:hcs_driver/features/MyOrders/data/repositories/myorders_repository.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_state.dart';
import 'package:hcs_driver/src/core/enums/request_state.dart';
import 'package:hcs_driver/src/core/enums/shift_type_enum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'myorders_controller.g.dart';

@riverpod
class MyOrdersController extends _$MyOrdersController {
  @override
  MyOrdersState build() => const MyOrdersState();
  // inside MyOrdersController

  Future<void> fetchCompletedOrders({String? searchKey}) async {
    state = state.copyWith(
      completedOrdersStates: RequestStates.loading,
      searchKey: searchKey ?? '',
    );

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getServicesOrders(
        page: 1,
        status: 'completed', // 👈 أهم حاجة
        search: searchKey, // 👈 دعم البحث بالاسم أو الموبايل
      );

      int? nextPage;
      if (ordersData.pagination.totalPages > 1) {
        nextPage = 2;
      } else {
        nextPage = null;
      }

      state = state.copyWith(
        currentCompletedOrdersPage: nextPage,
        completedOrders: ordersData.data.orders,
        completedOrdersStates: RequestStates.loaded,
        ordersMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        completedOrdersStates: RequestStates.error,
        ordersMessage: e.toString(),
      );
    }
  }

  Future<void> onLoadMoreCompletedOrders() async {
    final nextPage = state.currentCompletedOrdersPage;
    if (nextPage == null) return;

    try {
      final repo = ref.read(myOrdersRepositoryProvider);
      final resp = await repo.getServicesOrders(
        page: nextPage,
        status: 'completed',
        search: state.searchKey, // 👈 يحافظ على الفلترة
      );

      final next = resp.pagination.totalPages > resp.pagination.page
          ? resp.pagination.page + 1
          : null;

      state = state.copyWith(
        currentCompletedOrdersPage: next,
        completedOrders: [...state.completedOrders, ...resp.data.orders],
        completedOrdersStates: RequestStates.loaded,
      );
    } catch (e) {
      state = state.copyWith(
        completedOrdersStates: RequestStates.error,
        ordersMessage: e.toString(),
      );
    }
  }

  // ? Yesterday
  Future<void> fetchYesterdayOrders() async {
    state = state.copyWith(approvedOrdersStates: RequestStates.loading);

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getServicesOrders(
        page: 1,
        dateType: 'yesterday',
      );

      int? nextPage;
      //if there is a second page ?
      if (ordersData.pagination.totalPages > 1) {
        nextPage = 2;
      } else {
        nextPage = null;
      }
      state = state.copyWith(
        currentApprovedOrdersPage: nextPage,
        approvedOrders: ordersData.data.orders,
        approvedOrdersStates: RequestStates.loaded,
        ordersMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        approvedOrdersStates: RequestStates.error,
        ordersMessage: e.toString(),
      );
    }
  }

  // ? Custom Data
  Future<void> fetchOrdersForDate(String yyyymmdd) async {
    state = state.copyWith(
      customOrdersState: RequestStates.loading,
      lastCustomDate: yyyymmdd,
    );
    try {
      final repo = ref.read(myOrdersRepositoryProvider);
      final resp = await repo.getAppontments(
        page: 1,
        // dateType: '',
        date: yyyymmdd, // <— pass the specific date
        //TODO : Add list here:
        shiftType: state.selectedShiftTypes.isNotEmpty
            ? state.selectedShiftTypes
            : null,
      );

      // final next = resp.pagination.totalPages > 1 ? 2 : null;
      state = state.copyWith(
        // currentCustomOrdersPage: next,
        customOrders: resp.data.staffAppointments,
        customOrdersState: RequestStates.loaded,
      );
    } catch (e) {
      state = state.copyWith(
        customOrdersState: RequestStates.error,
        ordersMessage: e.toString(),
      );
    }
  }

  Future<void> refetchCustomDate() async {
    final d = state.lastCustomDate;
    if (d != null) await fetchOrdersForDate(d);
  }

  // Optional if you need infinite scroll for custom date

  Future<void> onLoadMoreCustomDate() async {
    final nextPage = state.currentCustomOrdersPage;
    if (nextPage == null) return;
    try {
      final repo = ref.read(myOrdersRepositoryProvider);
      final resp = await repo.getAppontments(
        page: nextPage,
        // dateType: '',
        date: state.lastCustomDate,
        //TODO : Add list here:
        shiftType: state.selectedShiftTypes.isNotEmpty
            ? state.selectedShiftTypes
            : null,
      );
      final next = resp.pagination.totalPages > resp.pagination.page
          ? resp.pagination.page + 1
          : null;
      state = state.copyWith(
        currentCustomOrdersPage: next,
        customOrders: [...state.customOrders, ...resp.data.staffAppointments],
        customOrdersState: RequestStates.loaded,
      );
    } catch (e) {
      state = state.copyWith(
        customOrdersState: RequestStates.error,
        ordersMessage: e.toString(),
      );
    }
  }

  Future<void> onLoadMoreYesterdayOrders() async {
    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getServicesOrders(
        page: state.currentApprovedOrdersPage!,
        dateType: 'yesterday',
      );

      int? nextPage;
      //if we reach the limit or not ?
      if (ordersData.pagination.totalPages > ordersData.pagination.page) {
        nextPage = ordersData.pagination.page + 1;
      } else {
        nextPage = null;
      }
      state = state.copyWith(
        currentApprovedOrdersPage: nextPage,
        approvedOrders: [...state.approvedOrders, ...ordersData.data.orders],
        approvedOrdersStates: RequestStates.loaded,
        ordersMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        approvedOrdersStates: RequestStates.error,
        ordersMessage: e.toString(),
      );
    }
  }

  Future<void> fetchTodayOrders() async {
    state = state.copyWith(todayOrdersStates: RequestStates.loading);

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getAppontments(
        page: 1,
        dateType: 'today',
        //TODO : Add list here:
        shiftType: state.selectedShiftTypes.isNotEmpty
            ? state.selectedShiftTypes
            : null,
      );

      int? nextPage;
      //if there is a second page ?
      if (ordersData.pagination.totalPages > 1) {
        nextPage = 2;
      } else {
        nextPage = null;
      }
      state = state.copyWith(
        currentTodayOrdersPage: nextPage,
        todayOrders: ordersData.data.staffAppointments,
        todayOrdersStates: RequestStates.loaded,
        ordersMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        todayOrdersStates: RequestStates.error,
        ordersMessage: e.toString(),
      );
    }
  }

  Future<void> onLoadMoreTodayOrders() async {
    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getAppontments(
        page: state.currentTodayOrdersPage!,
        dateType: 'today',
        //TODO : Add list here:
        shiftType: state.selectedShiftTypes.isNotEmpty
            ? state.selectedShiftTypes
            : null,
      );

      int? nextPage;
      //if we reach the limit or not ?
      if (ordersData.pagination.totalPages > ordersData.pagination.page) {
        nextPage = ordersData.pagination.page + 1;
      } else {
        nextPage = null;
      }
      state = state.copyWith(
        currentTodayOrdersPage: nextPage,
        todayOrders: [
          ...state.todayOrders,
          ...ordersData.data.staffAppointments,
        ],
        todayOrdersStates: RequestStates.loaded,
        ordersMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        todayOrdersStates: RequestStates.error,
        ordersMessage: e.toString(),
      );
    }
  }

  Future<void> fetchTomorrowOrders() async {
    state = state.copyWith(tomorrowOrdersStates: RequestStates.loading);

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getAppontments(
        page: 1,
        dateType: 'tomorrow',
        //TODO : Add list here:
        shiftType: state.selectedShiftTypes.isNotEmpty
            ? state.selectedShiftTypes
            : null,
      );

      int? nextPage;
      //if there is a second page ?
      if (ordersData.pagination.totalPages > 1) {
        nextPage = 2;
      } else {
        nextPage = null;
      }
      state = state.copyWith(
        currentTomorrowOrdersPage: nextPage,
        tomorrowOrders: ordersData.data.staffAppointments,
        tomorrowOrdersStates: RequestStates.loaded,
        ordersMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        tomorrowOrdersStates: RequestStates.error,
        ordersMessage: e.toString(),
      );
    }
  }

  Future<void> onLoadMoreTomorrowOrders() async {
    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getAppontments(
        page: state.currentTodayOrdersPage!,
        dateType: 'tomorrow',
        //TODO : Add list here:
        shiftType: state.selectedShiftTypes.isNotEmpty
            ? state.selectedShiftTypes
            : null,
      );

      int? nextPage;
      //if we reach the limit or not ?
      if (ordersData.pagination.totalPages > ordersData.pagination.page) {
        nextPage = ordersData.pagination.page + 1;
      } else {
        nextPage = null;
      }
      state = state.copyWith(
        currentAppointmentsPage: nextPage,
        tomorrowOrders: [
          ...state.tomorrowOrders,
          ...ordersData.data.staffAppointments
        ],
        tomorrowOrdersStates: RequestStates.loaded,
        ordersMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        todayOrdersStates: RequestStates.error,
        ordersMessage: e.toString(),
      );
    }
  }

  // Future<void> getOrderDetails({required String serviceOrderId}) async {
  //   state = state.copyWith(ordersDetailsStates: RequestStates.loading);

  //   try {
  //     final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
  //     final orderDetails = await myOrdersRepo.getOrderDetails(
  //       serviceOrderId: serviceOrderId,
  //     );
  //     // DriverStatus? nextStatusElement = orderDetails.details.driver.driverStatus
  //     //     .where((element) => element.active == false)
  //     //     // .cast<DriverStatus?>()
  //     //     .firstOrNull;

  //     state = state.copyWith(
  //       orderShare:  orderDetails,
  //       // ordersDetails: orderDetails.,
  //       // currentDriverStatus: orderDetails.details.driver.currentDriverStatus,
  //       // nextDriverStatus: state.currentDriverStatus != "Completed"
  //       //     ? nextStatusElement?.status
  //       //     : null,
  //       // statusOrders: orderDetails.details.driver.driverStatus,
  //       ordersDetailsStates: RequestStates.loaded,
  //       ordersDetailsMessage: '',
  //       orderCancelltionStates: RequestStates.init,
  //     );
  //   } catch (e) {
  //     state = state.copyWith(
  //       ordersDetailsStates: RequestStates.error,
  //       ordersDetailsMessage: e.toString(),
  //     );
  //   }
  // }

  Future<void> fetchOrdersDetails(
      {required String staffAppointmentLog,
      required String date,
      required String shift}) async {
    state = state.copyWith(
      ordersDetailsStates: RequestStates.loading,
      orderCancelltionStates: RequestStates.init,
    );

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersDetails = await myOrdersRepo.getServicesOrderDetails(
        // serviceOrderId: serviceOrderID,
        staffAppointmentLog: staffAppointmentLog,
        date: date,
        shift: shift,
      );

      DriverStatus? nextStatusElement = ordersDetails
          .details.driver.driverStatus
          .where((element) => element.active == false)
          .cast<DriverStatus?>()
          .firstOrNull;

      state = state.copyWith(
        ordersDetails: ordersDetails.details,
        currentDriverStatus: ordersDetails.details.driver.currentDriverStatus,
        nextDriverStatus: state.currentDriverStatus != "Completed"
            ? nextStatusElement?.status
            : '',
        statusOrders: ordersDetails.details.driver.driverStatus,
        ordersDetailsStates: RequestStates.loaded,
        ordersDetailsMessage: '',
        orderCancelltionStates: RequestStates.init,
      );
    } catch (e) {
      state = state.copyWith(
        ordersDetailsStates: RequestStates.error,
        ordersDetailsMessage: e.toString(),
      );
    }
  }

  Future<void> updateStatusOrder({
    required String appointmentID,
    String? amount,
    String? paymentMethod,
  }) async {
    state = state.copyWith(statusOrderStates: RequestStates.loading);
    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final statusOrders = await myOrdersRepo.updateStatusOrder(
        appointmentID: appointmentID,
        paymentMethod: paymentMethod,
        amount: amount,
      );

      String currentDriverStatus = statusOrders.data
          .lastWhere((element) => element.active == true)
          .status;

      DriverStatus? nextStatusElement = statusOrders.data
          .where((element) => element.active == false)
          .cast<DriverStatus?>()
          .firstOrNull;

      print('currentDriverStatus: $currentDriverStatus');
      print('------------------------------------');
      print('nextStatusElement: ${nextStatusElement?.status}');

      state = state.copyWith(
        // ordersDetails: state.ordersDetails?.copyWith(
        //   driver: state.ordersDetails?.driver.copyWith(
        //     currentDriverStatus: currentDriverStatus,
        //     driverStatus: statusOrders.data,
        //   ),
        // ),
        statusOrders: statusOrders.data,
        currentDriverStatus: currentDriverStatus,
        nextDriverStatus: nextStatusElement?.status,
        statusOrderStates: RequestStates.loaded,
        statusOrderMessage: '',
      );
      refreshAllOrdersList();
    } catch (e) {
      state = state.copyWith(
        statusOrderStates: RequestStates.error,
        statusOrderMessage: e.toString(),
      );
    }
  }

  Future<void> refreshAllOrdersList() async {
    fetchTomorrowOrders();
    fetchTodayOrders();
    refetchCustomDate();
  }

  Future<void> fetchAppontments({
    required String serviceOrderID,
    String? dateType,
  }) async {
    state = state.copyWith(appointmentsStates: RequestStates.loading);

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final appointmentsData = await myOrdersRepo.getAppontments(
        dateType: dateType,
        page: 1,
        // orderId: serviceOrderID,
      );

      int? nextPage;
      //if there is a second page ?
      if (appointmentsData.pagination.totalPages > 1) {
        nextPage = 2;
      } else {
        nextPage = null;
      }
      state = state.copyWith(
        currentAppointmentsPage: nextPage,
        // ordersAppointments: appointmentsData.data,

        // ordersAppointments: appointmentsData.data,
        appointmentsStates: RequestStates.loaded,
      );
    } catch (e) {
      state = state.copyWith(
        appointmentsStates: RequestStates.error,
        ordersMessage: e.toString(),
      );
    }
  }

  Future<void> onLoadMoreAppontments({
    required String serviceOrderID,
    String? dateType,
  }) async {
    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final appointmentsData = await myOrdersRepo.getAppontments(
        page: state.currentAppointmentsPage!,
        // orderId: serviceOrderID,
        dateType: dateType,
        //TODO : Add list here:
        shiftType: state.selectedShiftTypes.isNotEmpty
            ? state.selectedShiftTypes
            : null,
      );

      int? nextPage;
      //if we reach the limit or not ?
      if (appointmentsData.pagination.totalPages >
          appointmentsData.pagination.page) {
        nextPage = appointmentsData.pagination.page + 1;
      } else {
        nextPage = null;
      }
      state = state.copyWith(
        currentAppointmentsPage: nextPage,
        ordersAppointments: [
          ...state.ordersAppointments,
          // ...appointmentsData.data,
        ],
        appointmentsStates: RequestStates.loaded,
        ordersMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        appointmentsStates: RequestStates.error,
        ordersMessage: e.toString(),
      );
    }
  }

  Future<void> orderCancelltion({
    required String serviceOrderID,
    required String cancelMsg,
    required int orderDate,
  }) async {
    state = state.copyWith(orderCancelltionStates: RequestStates.loading);

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      await myOrdersRepo.orderCancelltion(
        serviceOrderId: serviceOrderID,
        cancelMsg: cancelMsg,
      );

      state = state.copyWith(
        orderCancelltionStates: RequestStates.loaded,
        orderCancelltionMessage: '',
      );
      orderDate == 0 ? fetchTodayOrders() : fetchTomorrowOrders();
      // ref.invalidate(myOrdersControllerProvider);
      // fetchOrdersDetails(staffAppointmentLog: serviceOrderID);
    } catch (e) {
      state = state.copyWith(
        orderCancelltionStates: RequestStates.error,
        orderCancelltionMessage: e.toString(),
      );
    }
  }

  Future<void> orderAppointmentLogCancelltion({
    required String staffAppointmentLog,
    required String orderId,
    required String cancelMsg,
    required BuildContext context,
  }) async {
    state = state.copyWith(orderCancelltionStates: RequestStates.loading);

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      await myOrdersRepo.orderAppointmentLogCancelltion(
        appoinmentLog: staffAppointmentLog,
        cancelMsg: cancelMsg,
      );
      debugPrint('staffAppointmentLogCancelltion: $staffAppointmentLog');
      // context.pop();
      // fetchAppontments(serviceOrderID: staffAppointmentLog);
      // fetchOrdersDetails(staffAppointmentLog: staffAppointmentLog);
      state = state.copyWith(
        orderCancelltionStates: RequestStates.loaded,
        orderCancelltionMessage: '',
      );
      //TODO
      await fetchAppontments(serviceOrderID: orderId, dateType: '');
      // ref.invalidate(myOrdersControllerProvider);
      // fetchOrdersDetails(staffAppointmentLog: serviceOrderID);
    } catch (e) {
      state = state.copyWith(
        orderCancelltionStates: RequestStates.error,
        orderCancelltionMessage: e.toString(),
      );
    }
  }

  void toggleShiftType(ShiftTypeEnum shiftType) {
    final currentList = List<ShiftTypeEnum>.from(state.selectedShiftTypes);

    if (currentList.contains(shiftType)) {
      currentList.remove(shiftType); // إذا كان موجوداً يتم حذفه
    } else {
      currentList.add(shiftType); // إذا لم يكن موجوداً يتم إضافته
    }

    state = state.copyWith(selectedShiftTypes: currentList);
  }

  void clearShiftType() {
    state = state.copyWith(clearShiftType: true);
  }

  Future<void> applyShiftFilter({required int tabIndex}) async {
    switch (tabIndex) {
      case 0:
        await refetchCustomDate();
        break;
      case 1:
        await fetchTodayOrders();
        break;
      case 2:
        await fetchTomorrowOrders();
        break;
    }
  }
}
