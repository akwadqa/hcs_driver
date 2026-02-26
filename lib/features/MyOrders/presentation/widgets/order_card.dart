import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/MyOrders/data/models/appointments_model.dart';
import 'package:hcs_driver/src/extenssions/status_extension.dart';
import 'package:hcs_driver/src/extenssions/string_extension.dart';
import 'package:hcs_driver/src/extenssions/widget_extensions.dart';
import 'package:hcs_driver/src/shared_widgets/custom_button.dart';
import 'package:hcs_driver/src/shared_widgets/custom_button_widget.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderCard extends StatelessWidget {
  final StaffAppointments order;
  final VoidCallback? onTap;
  final Future<bool?> Function()? onDismissedConfirm;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    required this.onDismissedConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Dismissible(
        key: ValueKey(order.serviceOrderId),
        background: _deleteBackground(),
        confirmDismiss: (_) async => onDismissedConfirm?.call(),
        child: Container(
          margin: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //----------------------------------------------------------
                // ORDER ID + STATUS
                //----------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: _LabeledRichText(
                        label: "Order Id: ",
                        value: order.serviceOrderId,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: _ChipStatus(text: order.driverStatus ?? ""),
                    ),
                  ],
                ),
                16.verticalSpace,

                //----------------------------------------------------------
                // SERVICE TYPE + VISIT + DATE
                //----------------------------------------------------------
                _InfoRow(
                  left: order.serviceType,
                  center:
                      "Visit ${order.visitNumber}/${order.totalVisitsNumber}",
                  right: order.date,
                ),

                12.verticalSpace,
                const _SectionDivider(),
                12.verticalSpace,

                //----------------------------------------------------------
                // CUSTOMER + PHONE
                //----------------------------------------------------------
                _LabeledRichText(
                  label: "Customer: ",
                  value: order.customerName ?? "",
                  withSpace: true,
                ),
                12.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _LabeledRichText(
                      label: "Phone :   ",
                      value: order.customerPhone ?? "",
                    ),
                    CustomButtonWidget(
                      height: 0,
                      width: 100,

                      isFiled: true,
                      backgroundColor: AppColors.lightGray,
                      radius: 18,
                      text: "Location",

                      child: Row(
                        children: [
                          2.horizontalSpace,

                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.red,
                            size: 20,
                          ),
                          2.horizontalSpace,
                          Text(
                            " Location",
                            style: Theme.of(context).textTheme.displaySmall!
                                .copyWith(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ).allPadding(8),

                      onTap: () {
                        openMapLink(order.customerLocation ?? "");
                      },
                    ),
                  ],
                ),
                // 12.verticalSpace,

                //----------------------------------------------------------
                // LOCATION
                //----------------------------------------------------------
                // CustomButtonWidget(
                //   height: 0,
                //   width: 100,

                //   isFiled: true,
                //   backgroundColor: AppColors.lightGray,
                //   radius: 18,
                //   text: "Location",

                //   child: Row(
                //     children: [
                //       2.horizontalSpace,

                //       Icon(Icons.location_on_rounded, color: Colors.red,size: 20,),
                //       2.horizontalSpace,
                //       Text(
                //         " Location",
                //         style: Theme.of(context).textTheme.displaySmall!
                //             .copyWith(
                //               fontSize: 15,
                //               color: Colors.black,
                //               fontWeight: FontWeight.w500,
                //             ),
                //       ),
                //     ],
                //   ).allPadding(8),

                //   onTap: () {
                //     openMapLink(order.customerLocation ?? "");
                //   },
                // ),

                // _IconLabelRichText(
                //   icon: Icons.location_on_rounded,
                //   label: "Location: ",
                //   value: order.customerLocation??"",
                // ),
                12.verticalSpace,
                const _SectionDivider(),
                12.verticalSpace,

                //----------------------------------------------------------
                // SUPERVISOR
                //----------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: _LabeledRichText(
                        label: "Supervisor: ",
                        value: order.supervisorName ?? "",
                        withSpace: true,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: _TextValue(
                        text: order.serviceShift ?? "",
                        fontSize: 15,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),

                12.verticalSpace,

                //----------------------------------------------------------
                // CLEANERS COUNT
                //----------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _LabeledRichText(
                      label: "Number of cleaners: ",
                      value: order.numberOfCleaners.toString(),
                      valueColor: Colors.grey,
                      withSpace: true,
                    ),
                    // _TextValue(
                    //   text: "Employees",
                    //   fontSize: 15,
                    //   color: AppColors.gray,
                    //   withUnderLine: true,
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =================================================================
  // PRIVATE UI HELPERS
  // =================================================================

  Widget _deleteBackground() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 22.w),
      color: Colors.redAccent,
      alignment: Alignment.center,
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }
}

// =================================================================
// REUSABLE SMALL WIDGETS
// =================================================================

class _LabeledRichText extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool withSpace;

  const _LabeledRichText({
    required this.label,
    required this.value,
    this.valueColor,
    this.withSpace = false,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          if (withSpace) WidgetSpan(child: SizedBox(width: 10)),
          TextSpan(
            text: value,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: valueColor ?? Colors.black,
              fontSize: 16,
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
  } else {
    throw 'Could not open map link';
  }
}

class _IconLabelRichText extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _IconLabelRichText({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(child: Icon(icon, color: Colors.red).onlyPadding(end: 10)),
          TextSpan(
            text: label,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: CustomButtonWidget(
              height: 0,
              width: 100,
              isFiled: true,
              backgroundColor: AppColors.primary,
              radius: 6,

              text: "Open map",
              onTap: () {
                openMapLink(value);
              },
            ).onlyPadding(start: 40),
            // text: value,

            // style: Theme.of(context).textTheme.headlineSmall!.copyWith(

            //       color:value.contains("maps")? Colors.blue:Colors.black,
            //       fontSize: 16,
            //           decoration: TextDecoration.underline,
            //           decorationColor: Colors.blue,

            //     ),
            //       recognizer: TapGestureRecognizer()
            //   ..onTap = () {
            //     openMapLink(value);
            //   },
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String left;
  final String center;
  final String right;

  const _InfoRow({
    required this.left,
    required this.center,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _TextValue(text: left),
        _TextValue(text: center, color: AppColors.gray),
        _TextValue(text: right),
      ],
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 8, color: AppColors.primary);
  }
}

class _ChipStatus extends StatelessWidget {
  final String text;
  const _ChipStatus({required this.text});

  @override
  Widget build(BuildContext context) {
    final status = parseJobStatus(text);
    final bgColor = status.color.withOpacity(0.15);

    return Container(
      // width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ).centered(),
    );
  }
}

class _TextValue extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final bool withUnderLine;

  const _TextValue({
    required this.text,
    this.fontSize = 14,
    this.color,
    this.withUnderLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: color ?? AppColors.grayishCharcoal,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        decoration: withUnderLine ? TextDecoration.underline : null,
      ),
    );
  }
}
