import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/MyOrders/data/repositories/myorders_repository.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/order_details_controller.dart';

class OrderDetailsNotifier extends StateNotifier<OrderDetailsState> {
  OrderDetailsNotifier(this.repo) : super(OrderDetailsState.initial());

  final MyOrdersRepository repo;

  Future<void> getOrderDetails(String id) async {
    state = OrderDetailsState.loading();

    try {
      final orderDetails = await repo.getOrderDetails(serviceOrderId: id);
      state = OrderDetailsState.loaded(orderDetails);
    } catch (e) {
      state = OrderDetailsState.error(e.toString());
    }
  }
}

final orderDetailsNotifierProvider =
    StateNotifierProvider<OrderDetailsNotifier, OrderDetailsState>((ref) {
      final repo = ref.watch(myOrdersRepositoryProvider);
      final notifier = OrderDetailsNotifier(repo);
      return notifier;
    });
