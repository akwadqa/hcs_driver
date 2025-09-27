import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_controller.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/core/enums/request_state.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';
import 'package:hcs_driver/src/shared_widgets/app_error_widget.dart';
import 'package:hcs_driver/src/shared_widgets/fade_circle_loading_indicator.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class YesterdayOrdersScreen extends ConsumerStatefulWidget {
  const YesterdayOrdersScreen({super.key});
  @override
  ConsumerState<YesterdayOrdersScreen> createState() =>
      _YesterdayOrdersScreenState();
}

class _YesterdayOrdersScreenState extends ConsumerState<YesterdayOrdersScreen> {
  late ScrollController _scrollController;
  Timer? _loadMoreTimer;

  @override
  void initState() {
    super.initState();
    Future(
      () =>
          ref.read(myOrdersControllerProvider.notifier).fetchYesterdayOrders(),
    );

    _scrollController = ScrollController()..addListener(_onScroll);
  }

  _onScroll() {
    final customerState = ref.read(myOrdersControllerProvider);
    final hasMore = customerState.currentApprovedOrdersPage != null;

    if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent - 100 &&
        hasMore) {
      _loadMoreTimer?.cancel();
      _loadMoreTimer = Timer(const Duration(milliseconds: 500), () {
        ref
            .read(myOrdersControllerProvider.notifier)
            .onLoadMoreYesterdayOrders();
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

    if (ordersState.approvedOrdersStates == RequestStates.init ||
        ordersState.approvedOrdersStates == RequestStates.loading) {
      // return Center(child: FadeCircleLoadingIndicator());
      return Center(child: FadeCircleLoadingIndicator());
    } else if (ordersState.approvedOrdersStates == RequestStates.loaded) {
      if (ordersState.approvedOrders.isEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(myOrdersControllerProvider.notifier)
                .fetchYesterdayOrders();
          },
          child: Center(child: Assets.images.noDataMin.image()),
        );
      }
      return RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(myOrdersControllerProvider.notifier)
              .fetchYesterdayOrders();
        },
        child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: ordersState.approvedOrders.length + 1,
          itemBuilder: (context, index) {
            if (index >= ordersState.approvedOrders.length) {
              if (ordersState.currentApprovedOrdersPage == null) {
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
                    dateType: 'yesterday',
                    serviceOrderID:
                        ordersState.pendingOrders[index].serviceOrderId,
                  ),
                  // OrderDetailsRoute(
                  //   serviceOrderID:
                  //       ordersState.approvedOrders[index].serviceOrderId,
                  // ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
                padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 22.w),
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
                          ordersState.approvedOrders[index].serviceOrderId,
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
                              ordersState.approvedOrders[index].status
                                  .toString(),
                              style: Theme.of(context).textTheme.displayMedium!
                                  .copyWith(fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    Text(
                      ordersState.approvedOrders[index].serviceType,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                          ordersState.approvedOrders[index].postingDate,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 12.sp,
                                color: AppColors.greyText,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Text(
                          "QR ${ordersState.approvedOrders[index].totalNetAmount}",
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
            );
          },
        ),
      );
    } else if (ordersState.approvedOrdersStates == RequestStates.error) {
      return AppErrorWidget(
        onTap: () => Future(
          () => ref
              .read(myOrdersControllerProvider.notifier)
              .fetchYesterdayOrders(),
        ),
      );
    }
    return SizedBox.shrink();
  }
}
