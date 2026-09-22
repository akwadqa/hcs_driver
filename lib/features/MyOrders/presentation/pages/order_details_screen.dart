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
  final StaffAppointments staffAppointments;

  const OrderDetailsScreen({
    super.key,
    required this.staffAppointments,
  });

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  void _fetchDetails() {
    Future(
      () => ref.read(myOrdersControllerProvider.notifier).fetchOrdersDetails(
            staffAppointmentLog: widget.staffAppointments.serviceOrderId ?? '',
            date: widget.staffAppointments.date ?? '',
            shift: widget.staffAppointments.shiftType ?? '',
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // جلب حالة البيانات باستخدام AsyncValue
    final ordersDetailsAsync = ref.watch(
      myOrdersControllerProvider.select((value) => value.ordersDetails),
    );

    return Scaffold(
      appBar: CustomAppbar(
        hasBackArrow: true,
        title: context.tr(AppStrings.orderDetails),
        withTabs: false,
        actions: ordersDetailsAsync.hasValue && ordersDetailsAsync.value != null
            ? [
                ShareToWhatsApp(
                  serviceOrderId: widget.staffAppointments.serviceOrderId,
                  orderDetails: ordersDetailsAsync.value,
                  staffAppointments: widget.staffAppointments,
                  isOrderShare: false,
                ),
              ]
            : null,
      ),
      body: ordersDetailsAsync.when(
        data: (details) {
          if (details == null) return const SizedBox.shrink();
          return _OrderDetailsContent(
            details: details,
            staffAppointments: widget.staffAppointments,
          );
        },
        loading: () => const Center(child: FadeCircleLoadingIndicator()),
        error: (error, stack) => AppErrorWidget(
          onTap: _fetchDetails,
        ),
      ),
    );
  }
}

/// تم فصل المحتوى الأساسي للصفحة في ويدجت منفصل لترتيب الكود
class _OrderDetailsContent extends StatelessWidget {
  final Details details;
  final StaffAppointments staffAppointments;

  const _OrderDetailsContent({
    required this.details,
    required this.staffAppointments,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 9.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          OrderCard(
            staffAppointments: staffAppointments,
            details: details,
          ),
          18.verticalSpace,
          CustomerDetailsCard(
            details: details,
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

/// تم تقسيم OrderCard إلى ويدجتات صغيرة لسهولة الصيانة والقراءة
class OrderCard extends StatelessWidget {
  final StaffAppointments staffAppointments;
  final Details? details;

  const OrderCard({
    Key? key,
    required this.staffAppointments,
    this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 353.w,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OrderHeaderRow(staffAppointments: staffAppointments),
          const SizedBox(height: 10),
          _OrderServiceBadge(serviceType: staffAppointments.serviceType),
          const SizedBox(height: 10),
          _OrderDateTimeRow(staffAppointments: staffAppointments),
          const SizedBox(height: 10),
          const Divider(
            color: AppColors.dividerGrey,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 10),
          if (details?.logStatus != "Cancelled")
            _OrderActionSection(
              details: details,
              staffAppointments: staffAppointments,
            ),
        ],
      ),
    );
  }
}

// ---------------- الويدجتات الداخلية لـ OrderCard ----------------

class _OrderHeaderRow extends ConsumerWidget {
  final StaffAppointments staffAppointments;

  const _OrderHeaderRow({required this.staffAppointments});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    // جلب حالة السائق الحالية لعرض لون وحالة الـ Tag
    final currentStatusAsync = ref.watch(
      myOrdersControllerProvider.select((val) => val.currentDriverStatus),
    );
    final currentStatus = currentStatusAsync ?? 'status';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: FittedBox(
            child: Text(
              staffAppointments.serviceOrderId ?? '',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.getDriverStatusBgColor(currentStatus),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.getDriverStatusTextColor(currentStatus),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 3),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                      currentStatus,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color:
                            AppColors.getDriverStatusTextColor(currentStatus),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderServiceBadge extends StatelessWidget {
  final String? serviceType;

  const _OrderServiceBadge({required this.serviceType});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final type = serviceType ?? 'serviceType';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.getServiceTypeColor(type),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        type,
        style: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: AppColors.getServiceTypeTextColor(type),
        ),
      ),
    );
  }
}

class _OrderDateTimeRow extends StatelessWidget {
  final StaffAppointments staffAppointments;

  const _OrderDateTimeRow({required this.staffAppointments});

  IconData _getShiftIcon(String shiftText) {
    final lowerText = shiftText.toLowerCase();
    if (lowerText.contains('morning')) return Icons.wb_sunny_outlined;
    if (lowerText.contains('evening')) return Icons.dark_mode_outlined;
    if (lowerText.contains('over time') || lowerText.contains('overtime'))
      return Icons.more_time;
    if (lowerText.contains('full day')) return Icons.light_mode_outlined;
    return Icons.schedule;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final shift = staffAppointments.shiftType ?? 'serviceShift';

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: FittedBox(
                child: Row(
                  children: [
                    Icon(
                      _getShiftIcon(shift),
                      size: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      shift,
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
          const VerticalDivider(
            color: AppColors.borderGrey,
            thickness: 1,
          ),
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: AppColors.grey600,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: FittedBox(
                    child: Text(
                      staffAppointments.date?.toFormattedEventDate() ?? '',
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
    );
  }
}

/// هذا الويدجت يعالج منطق الـ AsyncValue الجديد للأزرار السفلية الخاصة بالحالة
class _OrderActionSection extends ConsumerWidget {
  final Details? details;
  final StaffAppointments staffAppointments;

  const _OrderActionSection({
    required this.details,
    required this.staffAppointments,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStatusAsync = ref.watch(
      myOrdersControllerProvider.select((val) => val.currentDriverStatus),
    );
    final nextStatusAsync = ref.watch(
      myOrdersControllerProvider.select((val) => val.nextDriverStatus),
    );

    // حالة التحميل
    if (nextStatusAsync.isLoading) {
      return const Center(child: FadeCircleLoadingIndicator());
    }

    // حالة الخطأ
    if (nextStatusAsync.hasError) {
      return SimpleErrorWidget(
        onTap: () =>
            ref.read(myOrdersControllerProvider.notifier).updateStatusOrder(
                  appointmentID: details?.staffAppointmentLog ?? '',
                ),
      );
    }

    final currentDriverStatus = currentStatusAsync;
    final nextDriverStatus = nextStatusAsync.value;

    return InkWell(
      onTap: () => context.pushRoute(
        OrderStatusRoute(
          statusOrderType: details?.status ?? "",
          appointmentID: staffAppointments.serviceOrderId ?? '',
        ),
      ),
      child: Column(
        children: [
          if (nextDriverStatus == null) 10.verticalSpace else 0.verticalSpace,
          _buildActionContent(
              context, ref, currentDriverStatus, nextDriverStatus),
        ],
      ),
    );
  }

  Widget _buildActionContent(
    BuildContext context,
    WidgetRef ref,
    String currentDriverStatus,
    String? nextDriverStatus,
  ) {
    // التحقق الأساسي من حالة الطلب
    final isFlexiblePayment = details?.serviceType == "Flexible" &&
        currentDriverStatus == "Payment Received";

    if (currentDriverStatus != "Completed" && !isFlexiblePayment) {
      if (nextDriverStatus != null) {
        return InfoRow(
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
                  backgroundColor: Colors.red.shade50,
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                )
              : CustomButton(
                  title: nextDriverStatus,
                  fixedSize: nextDriverStatus == 'Awaiting Cash Payment'
                      ? WidgetStateProperty.all(Size(150.w, 80.h))
                      : null,
                  onPressed: () => _handleStatusUpdate(
                    context,
                    ref,
                    nextDriverStatus,
                  ),
                ),
        );
      }
    }

    // عرض النص إذا كان الطلب مكتملاً أو لا يوجد حالة قادمة
    return Text(
      "Order Completed ✓",
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.displayMedium!.copyWith(
            color: AppColors.greenText,
          ),
    );
  }

  Future<void> _handleStatusUpdate(
    BuildContext context,
    WidgetRef ref,
    String nextDriverStatus,
  ) async {
    final notifier = ref.read(myOrdersControllerProvider.notifier);
    final appointmentID = details?.staffAppointmentLog ?? '';

    if (nextDriverStatus == "Payment Received") {
      final res = await showPaymentMethodDialog(context);
      if (res == null) return; // تم الإلغاء

      await withBlockingLoader(context, () async {
        await notifier.updateStatusOrder(
          appointmentID: appointmentID,
          paymentMethod: res.choice.name,
          amount: res.amount.toString(),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            res.choice.name.toLowerCase() ==
                    'cash' // تم التعديل لتناسب الـ Enum الخاص بك
                ? "Order completed (cash)."
                : "Order completed.",
          ),
        ),
      );
    } else {
      await notifier.updateStatusOrder(
        appointmentID: appointmentID,
      );
    }
  }
}
