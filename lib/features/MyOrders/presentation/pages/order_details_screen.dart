import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_controller.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/info_row.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/map_button.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/share_to_whatsapp.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/enums/request_state.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';
import 'package:hcs_driver/src/shared_widgets/app_error_widget.dart';
import 'package:hcs_driver/src/shared_widgets/custom_appbar.dart';
import 'package:hcs_driver/src/shared_widgets/fade_circle_loading_indicator.dart';
import 'package:hcs_driver/src/shared_widgets/row_error_widget.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

@RoutePage()
class OrderDetailsScreen extends ConsumerStatefulWidget {
  final String serviceOrderID;
  const OrderDetailsScreen({super.key, required this.serviceOrderID});

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future(
      () => ref
          .read(myOrdersControllerProvider.notifier)
          .fetchOrdersDetails(serviceOrderID: widget.serviceOrderID),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> days = [
      "saturday",
      "sunday",
      "monday",
      "TuesDay",
      "wensday",
      "tursday",
    ];
    var details = ref.watch(
      myOrdersControllerProvider.select((value) => value.ordersDetails),
    );
    var orderStatus = ref.watch(
      myOrdersControllerProvider.select((value) => value.ordersDetailsStates),
    );
    return Scaffold(
      body: orderStatus == RequestStates.loaded
          ? _buildContent(details, days)
          : orderStatus == RequestStates.loading
          ? Center(child: const FadeCircleLoadingIndicator())
          : orderStatus == RequestStates.error
          ? AppErrorWidget(
              onTap: () => Future(
                () => ref
                    .read(myOrdersControllerProvider.notifier)
                    .fetchOrdersDetails(serviceOrderID: widget.serviceOrderID),
              ),
            )
          : SizedBox.shrink(),
      appBar: CustomAppbar(
        hasBackArrow: true,
        title: context.tr(AppStrings.orderDetails),
        withTabs: false,
        actions: orderStatus == RequestStates.loaded
            ? [
                ShareToWhatsApp(
                  serviceOrderId: widget.serviceOrderID,
                  orderDetails: details,
                ),
              ]
            : null,
      ),
    );
  }

  Widget _wrapWithCard(Widget child) {
    return Column(
      children: [
        Card(
          color: Colors.white,
          // elevation: 2,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 17.w),
            child: child,
          ),
        ),
        18.verticalSpace,
      ],
    );
  }

  Widget _buildContent(Details? details, List<String> days) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 9.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 18.h),
            child: Center(
              child: Text(
                widget.serviceOrderID,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blueTitle,
                ),
              ),
            ),
          ),
          18.verticalSpace,
          _wrapWithCard(
            Column(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    var currentDriverStatus = ref.watch(
                      myOrdersControllerProvider.select(
                        (value) => value.currentDriverStatus,
                      ),
                    );
                    var statusOrderStates = ref.watch(
                      myOrdersControllerProvider.select(
                        (value) => value.statusOrderStates,
                      ),
                    );
                    switch (statusOrderStates) {
                      case RequestStates.init:
                      case RequestStates.loaded:
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Status",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      color: AppColors.blueText,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,

                                    vertical: 6.h,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: AppColors.grayBorder,
                                    ),
                                  ),
                                  child: Text(
                                    currentDriverStatus,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.displayMedium!.copyWith(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Consumer(
                                builder: (context, ref, child) {
                                  var statusOrderStates = ref.watch(
                                    myOrdersControllerProvider.select(
                                      (value) => value.statusOrderStates,
                                    ),
                                  );

                                  var statusOrders = ref.watch(
                                    myOrdersControllerProvider.select(
                                      (value) => value.statusOrders,
                                    ),
                                  );
                                  var currentDriverStatus = ref.watch(
                                    myOrdersControllerProvider.select(
                                      (value) => value.currentDriverStatus,
                                    ),
                                  );
                                  return InkWell(
                                    onTap:
                                        statusOrderStates !=
                                                RequestStates.loading &&
                                            statusOrders.last.status !=
                                                currentDriverStatus
                                        ? () => ref
                                              .watch(
                                                myOrdersControllerProvider
                                                    .notifier,
                                              )
                                              .updateStatusOrder(
                                                serviceOrderID:
                                                    widget.serviceOrderID,
                                              )
                                        : null,
                                    child: Text(
                                      "Change",
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                            color: AppColors.blueText,
                                          ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 5.w),
                              InkWell(
                                child: Container(
                                  height: 27.sp,
                                  width: 27.sp,

                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                  ),

                                  child: Assets.images.rightArrow.svg(
                                    height: 10.sp,
                                    width: 10.sp,
                                  ),
                                ),
                                onTap: () => context.pushRoute(
                                  OrderStatusRoute(
                                    statusOrderType: details!.status,
                                    serviceOrderID: widget.serviceOrderID,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                      case RequestStates.loading:
                        return Center(child: FadeCircleLoadingIndicator());
                      case RequestStates.error:
                        return SimpleErrorWidget(
                          onTap: () => ref
                              .watch(myOrdersControllerProvider.notifier)
                              .updateStatusOrder(
                                serviceOrderID: widget.serviceOrderID,
                              ),
                        );
                    }
                  },
                ),
              ],
            ),
          ),
          18.verticalSpace,
          _wrapWithCard(
            Column(
              children: [
                InfoRow("Customer", value: details?.customer?.customerName),
                InfoRow("Area", value: details?.customer?.location),
                InfoRow("Zone", value: details?.customer?.zone),
                InfoRow(
                  "Location",
                  widget: details?.customer?.locationUrl != null
                      ? MapPreviewCard(
                          lcoationUrl: details!.customer!.locationUrl!,
                          locationName: details.customer!.location!,
                        )
                      : null,
                ),
              ],
            ),
          ),

          _wrapWithCard(
            Column(
              children: [
                InfoRow("Service type", value: details?.serviceType),
                InfoRow("Shift type", value: details?.shiftType),
                InfoRow("Date", value: details!.date),
                days.isNotEmpty
                    ? InfoRow("Work Days", value: days.join(', '))
                    : SizedBox.shrink(),
              ],
            ),
          ),

          _wrapWithCard(
            Column(
              children: [
                InfoRow(
                  "Employees name",
                  value: (details.staffAppointment as List?)?.join(',\n') ?? '',
                ),
                InfoRow("Driver name", value: details.driver?.driverName),
              ],
            ),
          ),

          _wrapWithCard(
            Column(
              children: [
                InfoRow("Discount Type", value: details.discountType),
                InfoRow(
                  "Discount Percentage",
                  value: details.discountPercentage.toString(),
                ),
                InfoRow("Payment Method", value: details.methodOfPayment),
              ],
            ),
          ),

          _wrapWithCard(
            Column(
              children: [
                InfoRow(
                  "Cleaning supply",
                  value: details.withCleaningSupplies == 0 ? "No" : "Yes",
                ),
                InfoRow("Note", value: "details.note"),
              ],
            ),
          ),
          24.verticalSpace,
          Center(
            child: Text(
              "QR ${details.totalNetAmount}",
              style: TextStyle(
                fontSize: 20.sp,
                color: AppColors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
