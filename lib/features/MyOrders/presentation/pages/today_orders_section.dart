import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_controller.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/order_card.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/core/enums/request_state.dart';
import 'package:hcs_driver/src/extenssions/widget_extensions.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';
import 'package:hcs_driver/src/shared_widgets/app_dialogs.dart';
import 'package:hcs_driver/src/shared_widgets/app_error_widget.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';
import 'package:hcs_driver/src/shared_widgets/fade_circle_loading_indicator.dart';

class TodayOrdersScreen extends ConsumerStatefulWidget {
  const TodayOrdersScreen({super.key});
  @override
  ConsumerState<TodayOrdersScreen> createState() => _TodayOrdersScreenState();
}

class _TodayOrdersScreenState extends ConsumerState<TodayOrdersScreen> {
  late ScrollController _scrollController;
  Timer? _loadMoreTimer;

  @override
  void initState() {
    super.initState();
    Future(
      () => ref.read(myOrdersControllerProvider.notifier).fetchTodayOrders(),
    );

    _scrollController = ScrollController()..addListener(_onScroll);
  }

  _onScroll() {
    final customerState = ref.read(myOrdersControllerProvider);
    final hasMore = customerState.currentTodayOrdersPage != null;

    if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent - 100 &&
        hasMore) {
      _loadMoreTimer?.cancel();
      _loadMoreTimer = Timer(const Duration(milliseconds: 500), () {
        ref.read(myOrdersControllerProvider.notifier).onLoadMoreTodayOrders();
      });
    }
  }

  @override
  void dispose() {
    _loadMoreTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ordersState = ref.watch(myOrdersControllerProvider);

    if (ordersState.todayOrdersStates == RequestStates.init ||
        ordersState.todayOrdersStates == RequestStates.loading) {
      return Center(child: FadeCircleLoadingIndicator());
    } else if (ordersState.todayOrdersStates == RequestStates.loaded) {
      if (ordersState.todayOrders.isEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(myOrdersControllerProvider.notifier)
                .fetchTodayOrders();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 50.h),
              Center(child: Assets.images.noDataMin.image()),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(myOrdersControllerProvider.notifier)
              .fetchTodayOrders();
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: ordersState.todayOrders.length + 1,
    itemBuilder: (context, index) {
  if (index >= ordersState.todayOrders.length) {
    return ordersState.currentTodayOrdersPage == null
        ? Center(child: Text('No More Orders'))
        : const Padding(
            padding: EdgeInsets.all(8),
            child: Center(child: FadeCircleLoadingIndicator()),
          );
  }

  final order = ordersState.todayOrders[index];

  return OrderCard(
    order: order,
    // parentContext: context,
    onTap: () {
      context.pushRoute(
        OrderDetailsRoute(
          serviceOrderID: order.serviceOrderId,
          appointmentID: order.logId,
        ),
      );
    },
    onDismissedConfirm: () => showAcceptCancelOrder(
      context: context,
      orderID: order.serviceOrderId,
      cancelAppointmentLog: false,
      ref: ref,
    ),
  );
}
    ),
      );
    } else if (ordersState.todayOrdersStates == RequestStates.error) {
      return AppErrorWidget(
        onTap: () => Future(
          () =>
              ref.read(myOrdersControllerProvider.notifier).fetchTodayOrders(),
        ),
      );
    }
    return SizedBox.shrink();
  }
}
