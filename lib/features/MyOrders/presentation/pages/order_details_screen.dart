import 'dart:ui' as ui;

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/MyOrders/data/models/appointments_model.dart';
import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_controller.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/customer_card_widget.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/info_row.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/map_button.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/order_details_card.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/share_to_whatsapp.dart';
import 'package:hcs_driver/src/core/enums/request_state.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/manager/extensions.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';
import 'package:hcs_driver/src/shared_widgets/app_dialogs.dart';
import 'package:hcs_driver/src/shared_widgets/app_error_widget.dart';
import 'package:hcs_driver/src/shared_widgets/custom_appbar.dart';
import 'package:hcs_driver/src/shared_widgets/custom_bottom_sheets.dart';
import 'package:hcs_driver/src/shared_widgets/custom_button.dart';
import 'package:hcs_driver/src/shared_widgets/fade_circle_loading_indicator.dart';
import 'package:hcs_driver/src/shared_widgets/row_error_widget.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

@RoutePage()
class OrderDetailsScreen extends ConsumerStatefulWidget {
  // final String serviceOrderID;
  final StaffAppointments staffAppointments;
  // final String status;
  const OrderDetailsScreen({
    super.key,
    // required this.serviceOrderID,
    required this.staffAppointments,
    // required this.appointmentID,
    // required this.status,
  });

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
          //todo here we should use appointment Id not serviceOrderID
          .fetchOrdersDetails(
              staffAppointmentLog:
                  widget.staffAppointments.serviceOrderId ?? '',
              date: widget.staffAppointments.date ?? '',
              shift: widget.staffAppointments.shiftType ?? ''),
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
    var currentDriverStatus = ref.watch(
      myOrdersControllerProvider.select(
        (value) => value.currentDriverStatus,
      ),
    );
    return Scaffold(
      body: switch (orderStatus) {
        RequestStates.loaded =>
          _buildContent(details, days, currentDriverStatus),
        RequestStates.loading ||
        RequestStates.init =>
          const Center(child: FadeCircleLoadingIndicator()),
        RequestStates.error => AppErrorWidget(
            onTap: () => Future(
              () => ref
                  .read(myOrdersControllerProvider.notifier)
                  //todo here we should use appointment Id not serviceOrderID
                  .fetchOrdersDetails(
                      staffAppointmentLog:
                          widget.staffAppointments.serviceOrderId ?? '',
                      date: widget.staffAppointments.date ?? '',
                      shift: widget.staffAppointments.shiftType ?? ''),
            ),
          ),
      },
      appBar: CustomAppbar(
        hasBackArrow: true,
        title: context.tr(AppStrings.orderDetails),
        withTabs: false,
        actions: orderStatus == RequestStates.loaded
            ? [
                ShareToWhatsApp(
                  serviceOrderId: widget.staffAppointments.serviceOrderId,
                  orderDetails: details,
                  staffAppointments: widget.staffAppointments,
                  isOrderShare: false,
                ),
              ]
            : null,
      ),
    );
  }

  Widget _buildContent(
      Details? details, List<String> days, String currentDriverStatus) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 9.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          OrderCard(
            staffAppointments: widget.staffAppointments,
            details: details,
            currentDriverStatus: currentDriverStatus,
          ),
          18.verticalSpace,
          // 18.verticalSpace,
          CustomerDetailsCard(
            details: details!,
            parentContext: context,
          ),

          12.verticalSpace,
          OrderDetailsCards(
            details: details,
          )
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard(
      {Key? key,
      required this.staffAppointments,
      this.details,
      this.currentDriverStatus})
      : super(key: key);
  final StaffAppointments staffAppointments;
  final Details? details;
  final String? currentDriverStatus;

  // دالة لاختيار الأيقونة المناسبة بناءً على النص
  IconData _getShiftIcon(String shiftText) {
    final lowerText = shiftText.toLowerCase();

    if (lowerText.contains('morning')) {
      return Icons.wb_sunny_outlined; // أيقونة شمس الصباح
    } else if (lowerText.contains('evening')) {
      return Icons
          .dark_mode_outlined; // أيقونة هلال للمساء (يمكنك استخدام nights_stay_outlined أيضاً)
    } else if (lowerText.contains('over time') ||
        lowerText.contains('overtime')) {
      return Icons.more_time; // أيقونة وقت إضافي
    } else if (lowerText.contains('full day')) {
      return Icons
          .light_mode_outlined; // أيقونة شمس ساطعة لليوم الكامل (أو يمكن استخدام access_time)
    }

    return Icons.schedule; // أيقونة افتراضية في حال أتى نص غير معروف
  }

  @override
  Widget build(BuildContext context) {
    // جلب الـ TextTheme العام للتطبيق
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 353.w,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.white, // أو Colors.white إذا لم يتوفر في AppColors
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Row (العنوان + حالة الطلب)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Order ID
              Flexible(
                child: FittedBox(
                  child: Text(
                    staffAppointments.serviceOrderId,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8), // مسافة صغيرة بين المعرف والحالة

              // 2. Order status tag
              Flexible(
                // أضفنا Flexible هنا لكي لا يتجاوز الصندوق حدود الشاشة إذا كان النص طويلاً جداً
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.getDriverStatusBgColor(
                        currentDriverStatus ?? 'status'),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min, // يأخذ المساحة التي يحتاجها فقط
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.getDriverStatusTextColor(
                              currentDriverStatus ?? 'status'),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        // أضفنا Flexible هنا لإجبار النص على الالتزام بالمساحة وتصغيره
                        child: FittedBox(
                          fit: BoxFit
                              .scaleDown, // هذه الخاصية تقوم بتصغير النص بدلاً من قطعه
                          alignment: Alignment.center,
                          child: Text(
                            currentDriverStatus ?? 'status',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppColors.getDriverStatusTextColor(
                                  currentDriverStatus ?? 'status'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.getServiceTypeColor(
                  staffAppointments.serviceType ?? 'serviceType'), // #E4DAFF
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              staffAppointments.serviceType ?? 'serviceType',
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.getServiceTypeTextColor(
                    staffAppointments.serviceType ?? 'serviceType'), // #6F46DB
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 2. Middle Row (العلامة البنفسجية + الوقت + التاريخ)
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Shift/Sun info (مع حدود جانبية)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: const BoxDecoration(
                      border: Border(
                          // left: BorderSide(
                          //     color: AppColors.borderGrey, width: 1), // #A1A1A1
                          // right: BorderSide(color: AppColors.borderGrey, width: 1),
                          ),
                    ),
                    child: FittedBox(
                      child: Row(
                        children: [
                          Icon(
                            _getShiftIcon(
                                staffAppointments.shiftType ?? 'serviceShift'),
                            size: 16,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            staffAppointments.shiftType ?? 'serviceShift',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                VerticalDivider(
                  color: AppColors.borderGrey, // #A1A1A1
                  thickness: 1,
                  // width: 20, // المسافة بين العمودين
                ),
                // const SizedBox(width: 13),

                // Date info
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: AppColors.grey600, // #767676
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: FittedBox(
                          child: Text(
                            staffAppointments.date.toFormattedEventDate(),
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Divider Line
          const Divider(
            color: AppColors.dividerGrey, // #D8D8D8
            thickness: 1,
            height: 1,
          ),

          const SizedBox(height: 10),
          if (details?.logStatus != "Cancelled")
            InkWell(
              onTap: () => context.pushRoute(
                OrderStatusRoute(
                  statusOrderType: details?.status ?? "",
                  appointmentID: staffAppointments.serviceOrderId ?? '',
                ),
              ),
              child: Consumer(
                builder: (context, ref, child) {
                  var currentDriverStatus = ref.watch(
                    myOrdersControllerProvider.select(
                      (value) => value.currentDriverStatus,
                    ),
                  );
                  var nextDriverStatus = ref.watch(
                    myOrdersControllerProvider.select(
                      (value) => value.nextDriverStatus,
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
                      return Column(
                        children: [
                          // InfoRow("status".tr(), value: currentDriverStatus),
                          nextDriverStatus == null
                              ? 10.verticalSpace
                              : 0.verticalSpace,
                          currentDriverStatus != "Completed"
                              ? nextDriverStatus != null
                                  ? InfoRow(
                                      "nextStatus".tr(),
                                      value: nextDriverStatus,
                                      widget: (details?.logStatus == "Canceled")
                                          ? Chip(
                                              label: Text(
                                                "canceled".tr(),
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              backgroundColor:
                                                  Colors.red.shade50,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6.w,
                                              ),
                                            )
                                          : CustomButton(
                                              title: nextDriverStatus,
                                              fixedSize: nextDriverStatus ==
                                                      'Awaiting Cash Payment'
                                                  ? WidgetStateProperty.all(
                                                      Size(
                                                        150.w,
                                                        80.h,
                                                      ),
                                                    )
                                                  : null,
                                              onPressed: statusOrderStates !=
                                                      RequestStates.loading
                                                  //     &&
                                                  // statusOrders.last.status !=
                                                  //     currentDriverStatus
                                                  ? () async {
                                                      // ref.invalidate(myOrdersControllerProvider);

                                                      if (nextDriverStatus ==
                                                          "Payment Received") {
                                                        // 1) Ask how to handle payment (no status change yet)
                                                        final res =
                                                            await showPaymentMethodDialog(
                                                          context,
                                                        );
                                                        if (res == null) {
                                                          return; // user canceled
                                                        }

                                                        // 2) Call the correct API(s) based on the choice
                                                        await withBlockingLoader(
                                                            context, () async {
                                                          final notifier =
                                                              ref.read(
                                                            myOrdersControllerProvider
                                                                .notifier,
                                                          );

                                                          // if (res.choice ==
                                                          //     PaymentChoice
                                                          //         .cash) {
                                                          await ref
                                                              .read(
                                                                myOrdersControllerProvider
                                                                    .notifier,
                                                              )
                                                              .updateStatusOrder(
                                                                appointmentID:
                                                                    details?.staffAppointmentLog ??
                                                                        '',
                                                                paymentMethod:
                                                                    res.choice
                                                                        .name,
                                                                amount: res
                                                                    .amount
                                                                    .toString(),
                                                              );
                                                        });

                                                        // optional toast
                                                        // if (!mounted) return;
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              res.choice ==
                                                                      PaymentChoice
                                                                          .Cash
                                                                  ? "Order completed (cash)."
                                                                  : "Order completed.",
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        // normal path for other next statuses
                                                        await ref
                                                            .read(
                                                              myOrdersControllerProvider
                                                                  .notifier,
                                                            )
                                                            .updateStatusOrder(
                                                              appointmentID:
                                                                  details?.staffAppointmentLog ??
                                                                      '',
                                                            );
                                                      }
                                                    }
                                                  : null,
                                            ),
                                    )
                                  : Text(
                                      "Order Completed ✓",
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                            color: AppColors.greenText,
                                          ),
                                    )
                              : Text(
                                  "Order Completed ✓",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(color: AppColors.greenText),
                                ),
                        ],
                      );

                    case RequestStates.loading:
                      return Center(child: FadeCircleLoadingIndicator());
                    case RequestStates.error:
                      return SimpleErrorWidget(
                        onTap: () => ref
                            .watch(myOrdersControllerProvider.notifier)
                            .updateStatusOrder(
                              appointmentID: details?.staffAppointmentLog ?? '',
                            ),
                      );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
