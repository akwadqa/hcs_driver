import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_controller.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/order_card.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/core/enums/request_state.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';
import 'package:hcs_driver/src/shared_widgets/app_dialogs.dart';
import 'package:hcs_driver/src/shared_widgets/app_error_widget.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';
import 'package:hcs_driver/src/shared_widgets/fade_circle_loading_indicator.dart';

class TomorrowOrdersScreen extends ConsumerStatefulWidget {
  const TomorrowOrdersScreen({super.key});
  @override
  ConsumerState<TomorrowOrdersScreen> createState() =>
      _TomorrowOrdersScreenState();
}

class _TomorrowOrdersScreenState extends ConsumerState<TomorrowOrdersScreen> {
  late ScrollController _scrollController;
  Timer? _loadMoreTimer;

  @override
  void initState() {
    super.initState();
    Future(
      () => ref.read(myOrdersControllerProvider.notifier).fetchTomorrowOrders(),
    );

    _scrollController = ScrollController()..addListener(_onScroll);
  }

  _onScroll() {
    final customerState = ref.read(myOrdersControllerProvider);
    final hasMore = customerState.currentTomorrowOrdersPage != null;

    if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent - 100 &&
        hasMore) {
      _loadMoreTimer?.cancel();
      _loadMoreTimer = Timer(const Duration(milliseconds: 500), () {
        ref
            .read(myOrdersControllerProvider.notifier)
            .onLoadMoreTomorrowOrders();
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
    final notifier = ref.read(myOrdersControllerProvider.notifier);

    if (ordersState.tomorrowOrdersStates == RequestStates.init ||
        ordersState.tomorrowOrdersStates == RequestStates.loading) {
      return Center(child: FadeCircleLoadingIndicator());
    } else if (ordersState.tomorrowOrdersStates == RequestStates.loaded) {
      if (ordersState.tomorrowOrders.isEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(myOrdersControllerProvider.notifier)
                .fetchTomorrowOrders();
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
              .fetchTomorrowOrders();
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),

          controller: _scrollController,
          shrinkWrap: true,
          itemCount: ordersState.tomorrowOrders.length + 1,
          itemBuilder: (context, index) {
            if (index >= ordersState.tomorrowOrders.length) {
              if (ordersState.currentTomorrowOrdersPage == null) {
                return Center(
                  child: Text(
                    'No More Orders',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(child: FadeCircleLoadingIndicator()),
                );
              }
            }
      
  final order = ordersState.tomorrowOrders[index];

  return OrderCard(
    order: order,
    // parentContext: context,
    onTap: () {
      context.pushRoute(
        OrderDetailsRoute(
                  staffAppointments: order,

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
          },
        ),
      );
    } else if (ordersState.tomorrowOrdersStates == RequestStates.error) {
      return AppErrorWidget(
        onTap: () => Future(
          () => ref
              .read(myOrdersControllerProvider.notifier)
              .fetchTomorrowOrders(),
        ),
      );
    }
    return SizedBox.shrink();
  }
}
