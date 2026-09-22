import 'package:flutter/cupertino.dart';
import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
import 'package:hcs_driver/features/MyOrders/data/repositories/myorders_repository.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_state.dart';
import 'package:hcs_driver/src/core/enums/shift_type_enum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'myorders_controller.g.dart';

@riverpod
class MyOrdersController extends _$MyOrdersController {
  @override
  MyOrdersState build() => const MyOrdersState();

  Future<void> fetchCompletedOrders({String? searchKey}) async {
    state = state.copyWith(
      completedOrders: const AsyncLoading(),
      searchKey: searchKey ?? '',
    );

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getServicesOrders(
        page: 1,
        status: 'completed',
        search: searchKey,
      );

      int? nextPage = ordersData.pagination.totalPages > 1 ? 2 : null;

      state = state.copyWith(
        currentCompletedOrdersPage: nextPage,
        completedOrders: AsyncData(ordersData.data.orders),
      );
    } catch (e, st) {
      state = state.copyWith(completedOrders: AsyncError(e, st));
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
        search: state.searchKey,
      );

      final next = resp.pagination.totalPages > resp.pagination.page
          ? resp.pagination.page + 1
          : null;

      // نحافظ على البيانات السابقة ونضيف عليها
      final currentList = state.completedOrders.value ?? [];

      state = state.copyWith(
        currentCompletedOrdersPage: next,
        completedOrders: AsyncData([...currentList, ...resp.data.orders]),
      );
    } catch (e, st) {
      state = state.copyWith(completedOrders: AsyncError(e, st));
    }
  }

  // ? Yesterday
  Future<void> fetchYesterdayOrders() async {
    state = state.copyWith(approvedOrders: const AsyncLoading());

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getServicesOrders(
        page: 1,
        dateType: 'yesterday',
      );

      int? nextPage = ordersData.pagination.totalPages > 1 ? 2 : null;

      state = state.copyWith(
        currentApprovedOrdersPage: nextPage,
        approvedOrders: AsyncData(ordersData.data.orders),
      );
    } catch (e, st) {
      state = state.copyWith(approvedOrders: AsyncError(e, st));
    }
  }

  Future<void> onLoadMoreYesterdayOrders() async {
    final nextPage = state.currentApprovedOrdersPage;
    if (nextPage == null) return;

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getServicesOrders(
        page: nextPage,
        dateType: 'yesterday',
      );

      final next = ordersData.pagination.totalPages > ordersData.pagination.page
          ? ordersData.pagination.page + 1
          : null;

      final currentList = state.approvedOrders.value ?? [];

      state = state.copyWith(
        currentApprovedOrdersPage: next,
        approvedOrders: AsyncData([...currentList, ...ordersData.data.orders]),
      );
    } catch (e, st) {
      state = state.copyWith(approvedOrders: AsyncError(e, st));
    }
  }

  // ? Custom Data
  Future<void> fetchOrdersForDate(String yyyymmdd) async {
    state = state.copyWith(
      customOrders: const AsyncLoading(),
      lastCustomDate: yyyymmdd,
    );
    try {
      final repo = ref.read(myOrdersRepositoryProvider);
      final resp = await repo.getAppontments(
        page: 1,
        date: yyyymmdd,
        shiftType: state.selectedShiftTypes.isNotEmpty
            ? state.selectedShiftTypes
            : null,
      );

      int next = resp.pagination.totalPages > 1 ? 2 : -1;
      
      state = state.copyWith(
        currentCustomOrdersPage: next,
        customOrders: AsyncData(resp.data.staffAppointments),
      );
    } catch (e, st) {
      state = state.copyWith(customOrders: AsyncError(e, st));
    }
  }

  Future<void> refetchCustomDate() async {
    final d = state.lastCustomDate;
    if (d != null && d.isNotEmpty) await fetchOrdersForDate(d);
  }

  Future<void> onLoadMoreCustomDate() async {
    final nextPage = state.currentCustomOrdersPage;
    if (nextPage == null || nextPage == -1) return;
    try {
      final repo = ref.read(myOrdersRepositoryProvider);
      final resp = await repo.getAppontments(
        page: nextPage,
        date: state.lastCustomDate,
        shiftType: state.selectedShiftTypes.isNotEmpty
            ? state.selectedShiftTypes
            : null,
      );
      final next = resp.pagination.totalPages > resp.pagination.page
          ? resp.pagination.page + 1
          : -1;

      final currentList = state.customOrders.value ?? [];

      state = state.copyWith(
        currentCustomOrdersPage: next,
        customOrders: AsyncData([...currentList, ...resp.data.staffAppointments]),
      );
    } catch (e, st) {
      state = state.copyWith(customOrders: AsyncError(e, st));
    }
  }

  // ? Today
  Future<void> fetchTodayOrders() async {
    state = state.copyWith(todayOrders: const AsyncLoading());

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getAppontments(
        page: 1,
        dateType: 'today',
        shiftType: state.selectedShiftTypes.isNotEmpty
            ? state.selectedShiftTypes
            : null,
      );

      int? nextPage = ordersData.pagination.totalPages > 1 ? 2 : -1;
      
      state = state.copyWith(
        currentTodayOrdersPage: nextPage,
        todayOrders: AsyncData(ordersData.data.staffAppointments),
      );
    } catch (e, st) {
      state = state.copyWith(todayOrders: AsyncError(e, st));
    }
  }

  Future<void> onLoadMoreTodayOrders() async {
    final nextPage = state.currentTodayOrdersPage;
    if (nextPage == null || nextPage == -1) return;

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getAppontments(
        page: nextPage,
        dateType: 'today',
        shiftType: state.selectedShiftTypes.isNotEmpty
            ? state.selectedShiftTypes
            : null,
      );

      final next = ordersData.pagination.totalPages > ordersData.pagination.page
          ? ordersData.pagination.page + 1
          : -1;

      final currentList = state.todayOrders.value ?? [];

      state = state.copyWith(
        currentTodayOrdersPage: next,
        todayOrders: AsyncData([...currentList, ...ordersData.data.staffAppointments]),
      );
    } catch (e, st) {
      state = state.copyWith(todayOrders: AsyncError(e, st));
    }
  }

  // ? Tomorrow
  Future<void> fetchTomorrowOrders() async {
    state = state.copyWith(tomorrowOrders: const AsyncLoading());

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getAppontments(
        page: 1,
        dateType: 'tomorrow',
        shiftType: state.selectedShiftTypes.isNotEmpty
            ? state.selectedShiftTypes
            : null,
      );

      int? nextPage = ordersData.pagination.totalPages > 1 ? 2 : -1;
      
      state = state.copyWith(
        currentTomorrowOrdersPage: nextPage,
        tomorrowOrders: AsyncData(ordersData.data.staffAppointments),
      );
    } catch (e, st) {
      state = state.copyWith(tomorrowOrders: AsyncError(e, st));
    }
  }

  Future<void> onLoadMoreTomorrowOrders() async {
    final nextPage = state.currentTomorrowOrdersPage;
    if (nextPage == null || nextPage == -1) return;

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getAppontments(
        page: nextPage,
        dateType: 'tomorrow',
        shiftType: state.selectedShiftTypes.isNotEmpty
            ? state.selectedShiftTypes
            : null,
      );

      final next = ordersData.pagination.totalPages > ordersData.pagination.page
          ? ordersData.pagination.page + 1
          : -1;

      final currentList = state.tomorrowOrders.value ?? [];

      state = state.copyWith(
        currentTomorrowOrdersPage: next,
        tomorrowOrders: AsyncData([...currentList, ...ordersData.data.staffAppointments]),
      );
    } catch (e, st) {
      state = state.copyWith(tomorrowOrders: AsyncError(e, st));
    }
  }

  // ? Details
  Future<void> fetchOrdersDetails({
    required String staffAppointmentLog,
    required String date,
    required String shift,
  }) async {
    state = state.copyWith(
      ordersDetails: const AsyncLoading(),
      orderCancellationState: const AsyncData(null), // إعادة تعيين حالة الإلغاء إن لزم الأمر
    );

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersDetails = await myOrdersRepo.getServicesOrderDetails(
        staffAppointmentLog: staffAppointmentLog,
        date: date,
        shift: shift,
      );

      DriverStatus? nextStatusElement = ordersDetails.details.driver.driverStatus
          .where((element) => element.active == false)
          .cast<DriverStatus?>()
          .firstOrNull;

      final isCompleted = ordersDetails.details.driver.currentDriverStatus == "Completed";

      state = state.copyWith(
        ordersDetails: AsyncData(ordersDetails.details),
        currentDriverStatus: ordersDetails.details.driver.currentDriverStatus,
        nextDriverStatus: AsyncData(!isCompleted ? nextStatusElement?.status : ''),
        statusOrders: AsyncData(ordersDetails.details.driver.driverStatus),
      );
    } catch (e, st) {
      state = state.copyWith(ordersDetails: AsyncError(e, st));
    }
  }

  // ? Update Status
  Future<void> updateStatusOrder({
    required String appointmentID,
    String? amount,
    String? paymentMethod,
  }) async {
    state = state.copyWith(
      statusOrders: const AsyncLoading(),
      // currentDriverStatus: const AsyncLoading(),
      nextDriverStatus: const AsyncLoading(),
    );
    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final statusOrdersData = await myOrdersRepo.updateStatusOrder(
        appointmentID: appointmentID,
        paymentMethod: paymentMethod,
        amount: amount,
      );

      String currentDriverStatus = statusOrdersData.data
          .lastWhere((element) => element.active == true)
          .status;

      DriverStatus? nextStatusElement = statusOrdersData.data
          .where((element) => element.active == false)
          .cast<DriverStatus?>()
          .firstOrNull;

      state = state.copyWith(
        statusOrders: AsyncData(statusOrdersData.data),
        currentDriverStatus: currentDriverStatus,
        nextDriverStatus: AsyncData(nextStatusElement?.status),
      );
      
      refreshAllOrdersList();
    } catch (e, st) {
      state = state.copyWith(
        statusOrders: AsyncError(e, st),
        // currentDriverStatus: AsyncError(e, st),
        nextDriverStatus: AsyncError(e, st),
      );
    }
  }

  Future<void> refreshAllOrdersList() async {
    fetchTomorrowOrders();
    fetchTodayOrders();
    refetchCustomDate();
  }

  // ? Appointments
  Future<void> fetchAppontments({
    required String serviceOrderID,
    String? dateType,
  }) async {
    state = state.copyWith(ordersAppointments: const AsyncLoading());

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final appointmentsData = await myOrdersRepo.getAppontments(
        dateType: dateType,
        page: 1,
      );

      int? nextPage = appointmentsData.pagination.totalPages > 1 ? 2 : null;
      
      state = state.copyWith(
        currentAppointmentsPage: nextPage,
        ordersAppointments: AsyncData(appointmentsData.data.staffAppointments ?? []), // حسب نوع المودل لديك
      );
    } catch (e, st) {
      state = state.copyWith(ordersAppointments: AsyncError(e, st));
    }
  }

  Future<void> onLoadMoreAppontments({
    required String serviceOrderID,
    String? dateType,
  }) async {
    final nextPage = state.currentAppointmentsPage;
    if (nextPage == null) return;

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final appointmentsData = await myOrdersRepo.getAppontments(
        page: nextPage,
        dateType: dateType,
        shiftType: state.selectedShiftTypes.isNotEmpty
            ? state.selectedShiftTypes
            : null,
      );

      final next = appointmentsData.pagination.totalPages > appointmentsData.pagination.page
          ? appointmentsData.pagination.page + 1
          : null;

      final currentList = state.ordersAppointments.value ?? [];

      state = state.copyWith(
        currentAppointmentsPage: next,
        ordersAppointments: AsyncData([...currentList, ...(appointmentsData.data.staffAppointments ?? [])]),
      );
    } catch (e, st) {
      state = state.copyWith(ordersAppointments: AsyncError(e, st));
    }
  }

  // ? Cancellations
  Future<void> orderCancelltion({
    required String serviceOrderID,
    required String cancelMsg,
    required int orderDate,
  }) async {
    state = state.copyWith(orderCancellationState: const AsyncLoading());

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      await myOrdersRepo.orderCancelltion(
        serviceOrderId: serviceOrderID,
        cancelMsg: cancelMsg,
      );

      state = state.copyWith(orderCancellationState: const AsyncData(null));
      
      orderDate == 0 ? fetchTodayOrders() : fetchTomorrowOrders();
    } catch (e, st) {
      state = state.copyWith(orderCancellationState: AsyncError(e, st));
    }
  }

  Future<void> orderAppointmentLogCancelltion({
    required String staffAppointmentLog,
    required String orderId,
    required String cancelMsg,
    required BuildContext context,
  }) async {
    state = state.copyWith(orderCancellationState: const AsyncLoading());

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      await myOrdersRepo.orderAppointmentLogCancelltion(
        appoinmentLog: staffAppointmentLog,
        cancelMsg: cancelMsg,
      );
      debugPrint('staffAppointmentLogCancelltion: $staffAppointmentLog');
      
      state = state.copyWith(orderCancellationState: const AsyncData(null));
      
      await fetchAppontments(serviceOrderID: orderId, dateType: '');
    } catch (e, st) {
      state = state.copyWith(orderCancellationState: AsyncError(e, st));
    }
  }

  // --- UI Modification Methods (بقيت كما هي لأنها لا تتلاعب ببيانات الـ Server) ---

  void toggleShiftType(ShiftTypeEnum shiftType) {
    final currentList = List<ShiftTypeEnum>.from(state.selectedShiftTypes);

    if (currentList.contains(shiftType)) {
      currentList.remove(shiftType);
    } else {
      currentList.add(shiftType);
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