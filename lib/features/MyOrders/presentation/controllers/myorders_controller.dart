import 'package:hcs_driver/features/MyOrders/data/repositories/myorders_repository.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_state.dart';
import 'package:hcs_driver/src/enums/request_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'myorders_controller.g.dart';

@riverpod
class MyOrdersController extends _$MyOrdersController {
  @override
  MyOrdersState build() => const MyOrdersState();

  Future<void> fetchApprovedOrders() async {
    state = state.copyWith(approvedOrdersStates: RequestStates.loading);

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getServicesOrders(
        page: 1,
        status: 'Approved',
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

  Future<void> onLoadMoreApprovedOrders() async {
    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getServicesOrders(
        page: state.currentApprovedOrdersPage!,
        status: 'Approved',
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

  Future<void> fetchPendingOrders() async {
    state = state.copyWith(pendingOrdersStates: RequestStates.loading);

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getServicesOrders(
        page: 1,
        status: 'Pending',
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

  Future<void> onLoadMorePendingOrders() async {
    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getServicesOrders(
        page: state.currentPendingOrdersPage!,
        status: 'Pending',
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

  Future<void> fetchCancelledOrders() async {
    state = state.copyWith(cancelledOrdersStates: RequestStates.loading);

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getServicesOrders(
        page: 1,
        status: 'Cancelled',
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

  Future<void> onLoadMoreCancelledOrders() async {
    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersData = await myOrdersRepo.getServicesOrders(
        page: state.currentCancelledOrdersPage!,
        status: 'Cancelled',
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

  Future<void> fetchOrdersDetails({required String serviceOrderID}) async {
    state = state.copyWith(
      ordersDetailsStates: RequestStates.loading,
      orderCancelltionStates: RequestStates.init,
    );

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      final ordersDetails = await myOrdersRepo.getServicesOrderDetails(
        serviceOrderId: serviceOrderID,
      );

      state = state.copyWith(
        ordersDetails: ordersDetails.details,
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

  Future<void> orderCancelltion({required String serviceOrderID}) async {
    state = state.copyWith(orderCancelltionStates: RequestStates.loading);

    try {
      final myOrdersRepo = ref.read(myOrdersRepositoryProvider);
      await myOrdersRepo.orderCancelltion(serviceOrderId: serviceOrderID);

      state = state.copyWith(
        orderCancelltionStates: RequestStates.loaded,
        orderCancelltionMessage: '',
      );

      fetchOrdersDetails(serviceOrderID: serviceOrderID);
    } catch (e) {
      state = state.copyWith(
        orderCancelltionStates: RequestStates.error,
        orderCancelltionMessage: e.toString(),
      );
    }
  }
}
