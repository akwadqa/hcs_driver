import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
import 'package:hcs_driver/features/MyOrders/data/repositories/myorders_repository.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_state.dart';
import 'package:hcs_driver/src/enums/request_state.dart';
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
      completedOrders: ordersData.data,
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
      completedOrders: [...state.completedOrders, ...resp.data],
      completedOrdersStates: RequestStates.loaded,
    );
  } catch (e) {
    state = state.copyWith(
      completedOrdersStates: RequestStates.error,
      ordersMessage: e.toString(),
    );
  }
}

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
        approvedOrders: ordersData.data,
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
 Future<void> fetchOrdersForDate(String yyyymmdd) async {
    state = state.copyWith(
      customOrdersState: RequestStates.loading,
      lastCustomDate: yyyymmdd,
    );
    try {
      final repo = ref.read(myOrdersRepositoryProvider);
      final resp = await repo.getServicesOrders(
        page: 1,
        dateType: '',
        date: yyyymmdd,           // <— pass the specific date
      );

      // final next = resp.pagination.totalPages > 1 ? 2 : null;
      state = state.copyWith(
        // currentCustomOrdersPage: next,
        customOrders: resp.data,
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
      final resp = await repo.getServicesOrders(
        page: nextPage,
        dateType: '',
        date: state.lastCustomDate,
      );
      final next = resp.pagination.totalPages > resp.pagination.page
          ? resp.pagination.page + 1
          : null;
      state = state.copyWith(
        currentCustomOrdersPage: next,
        customOrders: [...state.customOrders, ...resp.data],
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
        approvedOrders: [...state.approvedOrders, ...ordersData.data],
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
    state = state.copyWith(pendingOrdersStates: RequestStates.loading);

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getServicesOrders(
        page: 1,
        dateType: 'today',
      );

      int? nextPage;
      //if there is a second page ?
      if (ordersData.pagination.totalPages > 1) {
        nextPage = 2;
      } else {
        nextPage = null;
      }
      state = state.copyWith(
        currentPendingOrdersPage: nextPage,
        pendingOrders: ordersData.data,
        pendingOrdersStates: RequestStates.loaded,
        ordersMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        pendingOrdersStates: RequestStates.error,
        ordersMessage: e.toString(),
      );
    }
  }

  Future<void> onLoadMoreTodayOrders() async {
    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getServicesOrders(
        page: state.currentPendingOrdersPage!,
        dateType: 'today',
      );

      int? nextPage;
      //if we reach the limit or not ?
      if (ordersData.pagination.totalPages > ordersData.pagination.page) {
        nextPage = ordersData.pagination.page + 1;
      } else {
        nextPage = null;
      }
      state = state.copyWith(
        currentPendingOrdersPage: nextPage,
        pendingOrders: [...state.pendingOrders, ...ordersData.data],
        pendingOrdersStates: RequestStates.loaded,
        ordersMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        pendingOrdersStates: RequestStates.error,
        ordersMessage: e.toString(),
      );
    }
  }

  Future<void> fetchTomorrowOrders() async {
    state = state.copyWith(cancelledOrdersStates: RequestStates.loading);

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getServicesOrders(
        page: 1,
        dateType: 'tomorrow',
      );

      int? nextPage;
      //if there is a second page ?
      if (ordersData.pagination.totalPages > 1) {
        nextPage = 2;
      } else {
        nextPage = null;
      }
      state = state.copyWith(
        currentCancelledOrdersPage: nextPage,
        cancelledOrders: ordersData.data,
        cancelledOrdersStates: RequestStates.loaded,
        ordersMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        cancelledOrdersStates: RequestStates.error,
        ordersMessage: e.toString(),
      );
    }
  }

  Future<void> onLoadMoreTomorrowOrders() async {
    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getServicesOrders(
        page: state.currentCancelledOrdersPage!,
        dateType: 'tomorrow',
      );

      int? nextPage;
      //if we reach the limit or not ?
      if (ordersData.pagination.totalPages > ordersData.pagination.page) {
        nextPage = ordersData.pagination.page + 1;
      } else {
        nextPage = null;
      }
      state = state.copyWith(
        currentCancelledOrdersPage: nextPage,
        cancelledOrders: [...state.cancelledOrders, ...ordersData.data],
        cancelledOrdersStates: RequestStates.loaded,
        ordersMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        cancelledOrdersStates: RequestStates.error,
        ordersMessage: e.toString(),
      );
    }
  }

  Future<void> fetchOrdersDetails({required String staffAppointmentLog}) async {
    state = state.copyWith(
      ordersDetailsStates: RequestStates.loading,
      orderCancelltionStates: RequestStates.init,
    );

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersDetails = await myOrdersRepo.getServicesOrderDetails(
        // serviceOrderId: serviceOrderID,
        staffAppointmentLog: staffAppointmentLog,
      );

      DriverStatus? nextStatusElement = ordersDetails
          .details
          .driver
          .driverStatus
          .where((element) => element.active == false)
          .cast<DriverStatus?>()
          .firstOrNull;

      state = state.copyWith(
        ordersDetails: ordersDetails.details,
        currentDriverStatus: ordersDetails.details?.driver?.currentDriverStatus,
        nextDriverStatus: nextStatusElement?.status,
        statusOrders: ordersDetails.details?.driver?.driverStatus,
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

  Future<void> updateStatusOrder({required String appointmentID,String? amount}) async {
    state = state.copyWith(statusOrderStates: RequestStates.loading);
    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final statusOrders = await myOrdersRepo.updateStatusOrder(
        appointmentID: appointmentID,
        amount:amount,
      );

      String currentDriverStatus = statusOrders.data
          .lastWhere((element) => element.active == true)
          .status;

      DriverStatus? nextStatusElement = statusOrders.data
          .where((element) => element.active == false)
          .cast<DriverStatus?>()
          .firstOrNull;

      state = state.copyWith(
        statusOrders: statusOrders.data,
        currentDriverStatus: currentDriverStatus,
        nextDriverStatus: nextStatusElement?.status,
        statusOrderStates: RequestStates.loaded,
        statusOrderMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        statusOrderStates: RequestStates.error,
        statusOrderMessage: e.toString(),
      );
    }
  }

  Future<void> fetchAppontments({required String serviceOrderID}) async {
    state = state.copyWith(appointmentsStates: RequestStates.loading);

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final appointmentsData = await myOrdersRepo.getAppontments(
        page: 1,
        orderId: serviceOrderID,
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
        ordersAppointments: appointmentsData.data,

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

  Future<void> onLoadMoreAppontments({required String serviceOrderID}) async {
    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final appointmentsData = await myOrdersRepo.getAppontments(
        page: state.currentAppointmentsPage!,
        orderId: serviceOrderID,
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
          ...appointmentsData.data,
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
      await myOrdersRepo.orderCancelltion(serviceOrderId: serviceOrderID,cancelMsg:cancelMsg);

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
        cancelMsg:cancelMsg
      );
      debugPrint('staffAppointmentLogCancelltion: $staffAppointmentLog');
      // context.pop();
      // fetchAppontments(serviceOrderID: staffAppointmentLog);
      // fetchOrdersDetails(staffAppointmentLog: staffAppointmentLog);
      state = state.copyWith(
        orderCancelltionStates: RequestStates.loaded,
        orderCancelltionMessage: '',
      );
         await fetchAppontments(serviceOrderID: orderId);
      // ref.invalidate(myOrdersControllerProvider);
      // fetchOrdersDetails(staffAppointmentLog: serviceOrderID);
    } catch (e) {
      state = state.copyWith(
        orderCancelltionStates: RequestStates.error,
        orderCancelltionMessage: e.toString(),
      );
    }
  }
}
