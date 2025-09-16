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

class CustomDateOrdersScreen extends ConsumerStatefulWidget {
  const CustomDateOrdersScreen({super.key});

  @override
  ConsumerState<CustomDateOrdersScreen> createState() =>
      _CustomDateOrdersScreenState();
}

class _CustomDateOrdersScreenState
    extends ConsumerState<CustomDateOrdersScreen> {
  late final ScrollController _scrollController;
  Timer? _loadMoreTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    // If you want to (re)fetch on first open when there is a lastCustomDate:
    // final s = ref.read(myOrdersControllerProvider);
    // final d = s.lastCustomDate;
    // if (d != null && s.customOrdersState == RequestStates.init) {
    //   Future(() => ref.read(myOrdersControllerProvider.notifier).fetchOrdersForDate(d));
    // }
  }

  void _onScroll() {
    final state = ref.read(myOrdersControllerProvider);

    // Only try to load more if you’ve implemented paging for custom date.
    final hasMore = state.currentCustomOrdersPage != null; // <- optional

    if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent - 100 &&
        hasMore) {
      _loadMoreTimer?.cancel();
      _loadMoreTimer = Timer(const Duration(milliseconds: 500), () async {
        // Implement this in your controller if you want paging for custom:
        // await ref.read(myOrdersControllerProvider.notifier).onLoadMoreCustomDate();
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
    final ordersState = ref.watch(myOrdersControllerProvider);

    if (ordersState.customOrdersState == RequestStates.init ||
        ordersState.customOrdersState == RequestStates.loading) {
      return const Center(child: FadeCircleLoadingIndicator());
    }

    if (ordersState.customOrdersState == RequestStates.error) {
      return AppErrorWidget(
        onTap: () => ref
            .read(myOrdersControllerProvider.notifier)
            .refetchCustomDate(),
      );
    }

    if (ordersState.customOrders.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(myOrdersControllerProvider.notifier)
              .refetchCustomDate();
        },
        child: Center(child: Assets.images.noDataMin.image()),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(myOrdersControllerProvider.notifier).refetchCustomDate();
      },
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: ordersState.customOrders.length + 1, // +1 for footer
        itemBuilder: (context, index) {
          // footer
          if (index >= ordersState.customOrders.length) {
            // If you don't implement pagination for custom dates, show "No more"
            if (ordersState.currentCustomOrdersPage == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'No More Orders',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            } else {
              // Loading next page (if you implement it)
              return const Padding(
                padding: EdgeInsets.all(8),
                child: Center(child: FadeCircleLoadingIndicator()),
              );
            }
          }

          final o = ordersState.customOrders[index];

          return GestureDetector(
            onTap: () {
              context.pushRoute(
                AppoinmentRoute(serviceOrderID: o.serviceOrderId),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
              padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 22.w),
              width: 345.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // top row: id + status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        o.serviceOrderId,
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Row(
                        children: [
                          // use an icon if you have a specific status icon
                          // Assets.images.pending.svg(),
                          // 9.horizontalSpace,
                          Text(
                            o.status.toString(),
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
                  // service type
                  Text(
                    o.serviceType,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12.sp,
                          color: AppColors.greyText,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  8.verticalSpace,
                  // date + price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        o.postingDate,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 12.sp,
                              color: AppColors.greyText,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Text(
                        "QR ${o.totalNetAmount}",
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
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
  }
}
