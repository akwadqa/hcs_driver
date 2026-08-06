import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hcs_driver/features/MyOrders/data/models/appointments_model.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/extenssions/status_extension.dart';
import 'package:hcs_driver/src/extenssions/widget_extensions.dart';
import 'package:hcs_driver/src/manager/extensions.dart';
import 'package:hcs_driver/src/shared_widgets/custom_button_widget.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderCard extends StatelessWidget {
  final StaffAppointments order;
  final VoidCallback? onTap;
  final Future<bool?> Function()? onDismissedConfirm;
  final VoidCallback? onViewAllEmployeesTap; // هاندلر اختياري لـ View All

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    required this.onDismissedConfirm,
    this.onViewAllEmployeesTap,
  });

  @override
  Widget build(BuildContext context) {
    final dummyNote = order.note;
    // "يرجى العلم أن العميل طلب التركيز على نظافة المطبخ والزجاج الخارجي بشكل خاص، والتأكد من عدم استخدام أي مواد كيميائية حادة على الخشب.";

    return GestureDetector(
      onTap: onTap,
      child: Dismissible(
        key: ValueKey(order.serviceOrderId),
        direction: DismissDirection.none,
        background: _deleteBackground(),
        confirmDismiss: (_) async => onDismissedConfirm?.call(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8.r,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //----------------------------------------------------------
                // HEADER: Order ID + Status
                //----------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'order_id'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                        ),
                        5.verticalSpace,
                        Text(
                          order.serviceOrderId,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                        ),
                      ],
                    ),
                    _ChipStatus(text: order.driverStatus ?? ""),
                  ],
                ),
                10.verticalSpace,

                //----------------------------------------------------------
                // SERVICE INFO: Type, Visit, Date
                //----------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ServiceTypeChip(text: order.serviceType ?? 'Service Type'),
                    Text(
                      "${'visit'.tr()} ${order.visitNumber ?? ''}/${order.totalVisitsNumber}",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.labelGrey,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 14.sp, color: AppColors.labelGrey),
                        3.horizontalSpace,
                        Text(
                          order.date.toFormattedEventDate(),
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppColors.labelGrey,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
                10.verticalSpace,
                const Divider(
                    height: 1, thickness: 1, color: AppColors.dividerColor),
                10.verticalSpace,

                //----------------------------------------------------------
                // CUSTOMER & PHONE & LOCATION
                //----------------------------------------------------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _IconInfoTile(
                            icon: Assets.images.customerIc,
                            label: 'customer'.tr(),
                            value: order.customerName ?? "",
                          ),
                          12.verticalSpace,
                          _IconInfoTile(
                            icon: Assets.images.phoneIc,
                            label: 'phone'.tr(),
                            value: order.customerPhone ?? "",
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: GestureDetector(
                          onTap: () =>
                              openMapLink(order.customerLocationUrl ?? ""),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: AppColors.locationBg,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Assets.images.orderCardLoactionIc.svg(),
                                4.horizontalSpace,
                                Flexible(
                                  child: Text(
                                    order.customerLocation ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                10.verticalSpace,
                const Divider(
                    height: 1, thickness: 1, color: AppColors.dividerColor),
                10.verticalSpace,

                //----------------------------------------------------------
                // SUPERVISOR & SHIFT
                //----------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _IconInfoTile(
                        icon: Assets.images.supervisorIc,
                        label: 'supervisor'.tr(),
                        value: order.supervisorName ?? "",
                      ),
                    ),
                    _ShiftChip(text: order.shiftType ?? ""),
                  ],
                ),
                12.verticalSpace,

                //----------------------------------------------------------
                // CLEANERS COUNT & EMPLOYEE NAME
                //----------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _IconInfoTile(
                        icon: Assets.images.numberOfCleanerIc,
                        label: 'number_of_cleaners'.tr(),
                        value: order.numberOfCleaners.toString(),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.iconBg,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 5.h),
                          child: Text(
                            order.staffAppointmentNames?.first ?? '',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: AppColors.primary,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                //----------------------------------------------------------
                // NOTE SECTION (القسم الجديد المضاف)
                //----------------------------------------------------------
                if (dummyNote?.isNotEmpty == true) ...[
                  10.verticalSpace,
                  const Divider(
                      height: 1, thickness: 1, color: AppColors.dividerColor),
                  10.verticalSpace,
                  _ExpandableNoteTile(noteText: dummyNote),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _deleteBackground() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(10.r),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }
}

// =================================================================
// REUSABLE SMALL WIDGETS
// =================================================================

/// ويدجت الملاحظة القابلة للتوسع بأناقة وأنيميشن
class _ExpandableNoteTile extends StatefulWidget {
  final String? noteText;

  const _ExpandableNoteTile({required this.noteText});

  @override
  State<_ExpandableNoteTile> createState() => _ExpandableNoteTileState();
}

class _ExpandableNoteTileState extends State<_ExpandableNoteTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Colors.black,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        );

    return (widget.noteText != null && widget.noteText!.isNotEmpty)
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 27.w,
                height: 27.w,
                padding: EdgeInsets.all(6.w),
                decoration: const BoxDecoration(
                  color: AppColors.iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.note_alt_outlined,
                  size: 15.sp,
                  color: AppColors.primary,
                ),
              ),
              5.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'note'.tr(),
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: AppColors.labelGrey,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    7.verticalSpace,
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final span =
                            TextSpan(text: widget.noteText, style: textStyle);
                        final tp = TextPainter(
                          text: span,
                          maxLines: 2,
                          textDirection: Directionality.of(context),
                        );
                        tp.layout(maxWidth: constraints.maxWidth);

                        final bool isOverflowing = tp.didExceedMaxLines;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: Text(
                                widget.noteText!,
                                style: textStyle,
                                maxLines: _isExpanded ? null : 2,
                                overflow: _isExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                              ),
                            ),
                            if (isOverflowing) ...[
                              4.verticalSpace,
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                child: Text(
                                  _isExpanded
                                      ? 'show_less'.tr()
                                      : 'show_more'.tr(),
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
        : SizedBox.shrink();
  }
}

class _IconInfoTile extends StatelessWidget {
  final SvgGenImage icon;
  final String label;
  final String value;

  const _IconInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 27.w,
          height: 27.w,
          padding: EdgeInsets.all(6.w),
          decoration: const BoxDecoration(
            color: AppColors.iconBg,
            shape: BoxShape.circle,
          ),
          child: icon.svg(),
        ),
        5.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: AppColors.labelGrey,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              7.verticalSpace,
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChipStatus extends StatelessWidget {
  final String text;
  const _ChipStatus({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.getDriverStatusBgColor(text),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: AppColors.getDriverStatusTextColor(text),
              shape: BoxShape.circle,
            ),
          ),
          3.horizontalSpace,
          Text(
            text,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: AppColors.getDriverStatusTextColor(text),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _ServiceTypeChip extends StatelessWidget {
  final String text;
  const _ServiceTypeChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.getServiceTypeColor(text),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppColors.getServiceTypeTextColor(text),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}

class _ShiftChip extends StatelessWidget {
  final String text;
  const _ShiftChip({required this.text});

  IconData _getShiftIcon(String shiftText) {
    final lowerText = shiftText.toLowerCase();

    if (lowerText.contains('morning')) {
      return Icons.wb_sunny_outlined;
    } else if (lowerText.contains('evening')) {
      return Icons.dark_mode_outlined;
    } else if (lowerText.contains('over time') ||
        lowerText.contains('overtime')) {
      return Icons.more_time;
    } else if (lowerText.contains('full day')) {
      return Icons.light_mode_outlined;
    }

    return Icons.schedule;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.shiftBg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getShiftIcon(text),
            size: 16.sp,
            color: Colors.black,
          ),
          3.horizontalSpace,
          Text(
            text,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }
}

Future<void> openMapLink(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
