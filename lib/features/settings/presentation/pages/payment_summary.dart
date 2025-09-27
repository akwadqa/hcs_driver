import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_controller.dart';
import 'package:hcs_driver/features/MyOrders/presentation/pages/appointment_screen.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/core/enums/request_state.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';
import 'package:hcs_driver/src/shared_widgets/app_dialogs.dart';
import 'package:hcs_driver/src/shared_widgets/app_error_widget.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';
import 'package:hcs_driver/src/shared_widgets/fade_circle_loading_indicator.dart';

@RoutePage()
class PaymentSummaryScreen extends ConsumerStatefulWidget {
  const PaymentSummaryScreen({super.key});

  @override
  ConsumerState<PaymentSummaryScreen> createState() =>
      _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends ConsumerState<PaymentSummaryScreen> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  Timer? _loadMoreTimer;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    Future(
      () =>
          ref.read(myOrdersControllerProvider.notifier).fetchCompletedOrders(),
    );

    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    final ordersState = ref.read(myOrdersControllerProvider);
    final hasMore = ordersState.currentCompletedOrdersPage != null;

    if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent - 100 &&
        hasMore) {
      _loadMoreTimer?.cancel();
      _loadMoreTimer = Timer(const Duration(milliseconds: 500), () {
        ref
            .read(myOrdersControllerProvider.notifier)
            .onLoadMoreCompletedOrders();
      });
    }
  }

  void _onSearchChanged(String value) {
    // debounce للبحث
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref
          .read(myOrdersControllerProvider.notifier)
          .fetchCompletedOrders(searchKey: value.trim());
    });
  }

  @override
  void dispose() {
    _loadMoreTimer?.cancel();
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ordersState = ref.watch(myOrdersControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Payment Summary")),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search by name or phone...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (ordersState.completedOrdersStates ==
                    RequestStates.loading) {
                  return const Center(child: FadeCircleLoadingIndicator());
                }
                if (ordersState.completedOrdersStates == RequestStates.error) {
                  return Center(
                    child: Text(
                      "Error: ${ordersState.ordersMessage ?? "Unknown"}",
                    ),
                  );
                }
                if (ordersState.completedOrders.isEmpty) {
                  return const Center(child: Text("No completed orders"));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(myOrdersControllerProvider.notifier)
                        .fetchCompletedOrders(
                          searchKey: _searchController.text,
                        );
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount:
                        ordersState.completedOrders.length + 1, // +1 for footer
                    itemBuilder: (context, index) {
                      // Footer (load-more / no more)
                      if (index >= ordersState.completedOrders.length) {
                        if (ordersState.currentCompletedOrdersPage == null) {
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
                          return const Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(child: FadeCircleLoadingIndicator()),
                          );
                        }
                      }

                      final order = ordersState.completedOrders[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            //TODO: 
                            MaterialPageRoute(
                              builder: (m) => AppoinmentScreen(
                                serviceOrderID: order.serviceOrderId,
                                dateType: '',
                              ),
                            ),
                          );
                          //  context.pushRoute(
                          //       AppoinmentRoute(
                          //         serviceOrderID:
                          //             order.serviceOrderId,
                          //       ),
                          //  );
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
                          width: 345.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // top row: id + status
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    order.serviceOrderId,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
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
                                        order.status.toString(),
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
                                order.serviceType,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      fontSize: 12.sp,
                                      color: AppColors.greyText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              8.verticalSpace,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    order.postingDate,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 12.sp,
                                          color: AppColors.greyText,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  Text(
                                    "QR ${order.totalNetAmount}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
