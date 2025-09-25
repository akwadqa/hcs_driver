import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_controller.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/core/enums/request_state.dart';
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
    final hasMore = customerState.currentPendingOrdersPage != null;

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

    if (ordersState.pendingOrdersStates == RequestStates.init ||
        ordersState.pendingOrdersStates == RequestStates.loading) {
      return Center(child: FadeCircleLoadingIndicator());
    } else if (ordersState.pendingOrdersStates == RequestStates.loaded) {
      if (ordersState.pendingOrders.isEmpty) {
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
          itemCount: ordersState.pendingOrders.length + 1,
          itemBuilder: (context, index) {
            if (index >= ordersState.pendingOrders.length) {
              if (ordersState.currentPendingOrdersPage == null) {
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
            return GestureDetector(
              onTap: () {
                context.pushRoute(
                  AppoinmentRoute(
                    serviceOrderID:
                        ordersState.pendingOrders[index].serviceOrderId,
                  ),
                  // OrderDetailsRoute(
                  //   serviceOrderID:
                  //       ordersState.pendingOrders[index].serviceOrderId,
                  // ),
                );
              },
              child: Stack(
                children: [
                  Dismissible(
                    key: ValueKey(
                      ordersState.pendingOrders[index].serviceOrderId,
                    ), // stable key
                    background: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 24.w,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 13.h,
                        horizontal: 22.w,
                      ),
                      color: Colors.redAccent,
                      alignment: Alignment.center,
                      child: Center(
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      final ok = await showAcceptCancelOrder(
                        context: context,
                        orderID:
                            ordersState.pendingOrders[index].serviceOrderId,

                        // logId: logId,
                        cancelAppointmentLog: false,
                        ref: ref,
                      );
                      return ok; // true => card animates out, false => stays
                    },

                    // optional: update extra state or analytics after the animation
                    onDismissed: (direction) {
                      // No-op if your provider already refetches/removes the item.
                      // If needed, you can also manually remove it from local list here.
                    },

                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 24.w,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 13.h,
                        horizontal: 22.w,
                      ),
                      // height: 100.h,
                      width: 345.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ordersState.pendingOrders[index].serviceOrderId,
                                style: Theme.of(context).textTheme.displaySmall!
                                    .copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Row(
                                children: [
                                  Assets.images.pending.svg(),
                                  9.horizontalSpace,
                                  Text(
                                    ordersState.pendingOrders[index].status
                                        .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(fontSize: 14.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          Text(
                            ordersState.pendingOrders[index].serviceType,
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  fontSize: 12.sp,
                                  color: AppColors.greyText,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          8.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ordersState.pendingOrders[index].postingDate,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      fontSize: 12.sp,
                                      color: AppColors.greyText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              Text(
                                "QR ${ordersState.pendingOrders[index].totalNetAmount}",
                                style: Theme.of(context).textTheme.displaySmall!
                                    .copyWith(
                                      fontSize: 12.sp,
                                      color: AppColors.greenText,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // PositionedDirectional(
                  //   start: 12,
                  //   top: 12,
                  //   child: InkWell(
                  //     onTap: () async {
                  //       await showAcceptCancelOrder(
                  //         context,
                  //         ordersState.pendingOrders[index].serviceOrderId,
                  //         false,
                  //         ref,
                  //       );
                  //     },
                  //     child: Container(
                  //       height: 25,
                  //       width: 25,
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: Colors.red,
                  //       ),

                  //       child: Icon(Icons.close, color: Colors.white),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
      );
    } else if (ordersState.pendingOrdersStates == RequestStates.error) {
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
