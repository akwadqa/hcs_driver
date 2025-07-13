import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_controller.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_state.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/info_row.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/map_button.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/share_to_whatsapp.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/enums/request_state.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/shared_widgets/app_error_widget.dart';
import 'package:hcs_driver/src/shared_widgets/custom_appbar.dart';
import 'package:hcs_driver/src/shared_widgets/custom_button.dart';
import 'package:hcs_driver/src/shared_widgets/fade_circle_loading_indicator.dart';
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
    var details = ref.watch(
      myOrdersControllerProvider.select((value) => value.ordersDetails),
    );
    var orderStatus = ref.watch(
      myOrdersControllerProvider.select((value) => value.ordersDetailsStates),
    );
    return Scaffold(
      body: orderStatus == RequestStates.loaded
          ? _buildContent(details)
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

      bottomNavigationBar:
          orderStatus == RequestStates.loaded && details?.status == 'Approved'
          ? Consumer(
              builder: (context, ref, child) {
                var orderCancelltionStates = ref.watch(
                  myOrdersControllerProvider.select(
                    (value) => value.orderCancelltionStates,
                  ),
                );
                ref.listen<MyOrdersState>(myOrdersControllerProvider, (
                  previous,
                  next,
                ) {
                  if (next.orderCancelltionStates == RequestStates.loaded) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Assets.images.redSuccessful.svg(
                          width: 100,
                          height: 100,
                        ),

                        content: Text(
                          'Service has been\ncancelled successfully.',
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.displayMedium!.copyWith(fontSize: 20.sp),
                        ),
                      ),
                    );
                  }

                  if (next.orderCancelltionStates == RequestStates.error) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Assets.images.errorX.svg(),
                        content: Text(
                          next.orderCancelltionMessage ??
                              "An unexpected error occurred.\nPlease try again.",
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.displayMedium!.copyWith(fontSize: 20.sp),
                        ),
                      ),
                    );
                  }
                });

                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 17.h,
                    horizontal: 26.w,
                  ),
                  child: CustomButton(
                    title: AppStrings.cancelOrder.tr(context: context),
                    buttonColor: AppColors.blueText,
                    onPressed: orderCancelltionStates != RequestStates.loading
                        ? () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  AppStrings.cancelOrder.tr(context: context),
                                ),
                                content: Text(
                                  "Are you sure you want to cancel this order?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ref
                                          .read(
                                            myOrdersControllerProvider.notifier,
                                          )
                                          .orderCancelltion(
                                            serviceOrderID:
                                                widget.serviceOrderID,
                                          );
                                    },
                                    child: Text("Yes"),
                                  ),
                                ],
                              ),
                            );
                          }
                        : null,
                  ),
                );
              },
            )
          : null,
    );
  }

  Widget _buildContent(Details? details) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 26.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              widget.serviceOrderID,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blueTitle,
              ),
            ),
          ),
          16.verticalSpace,

          // --- Info Rows ---
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

          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Divider(height: 0.1, color: AppColors.dividerGrey),
          ),

          InfoRow("Service type", value: details?.serviceType),
          InfoRow("Shift type", value: details?.shiftType),
          InfoRow("Date", value: details?.date),

          // InfoRow("Service Category", value: "On Call"),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Divider(height: 0.1, color: AppColors.dividerGrey),
          ),

          InfoRow(
            "Employees name",
            value: (details?.staffAppointment as List?)?.join(',\n') ?? '',
          ),

          InfoRow("Driver name", value: details?.driver?.driverName),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Divider(height: 0.1, color: AppColors.dividerGrey),
          ),

          // InfoRow("Discount Type", value: details?.discountType),
          InfoRow(
            "Discount Percentage",
            value: details?.discountPercentage.toString(),
          ),
          InfoRow("Payment Method", value: details?.methodOfPayment),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Divider(height: 0.1, color: AppColors.dividerGrey),
          ),

          InfoRow(
            "Cleaning supply",
            value: details?.withCleaningSupplies == 0 ? "No" : "Yes",
          ),

          24.verticalSpace,
          Center(
            child: Text(
              "QR ${details?.totalNetAmount}",
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
