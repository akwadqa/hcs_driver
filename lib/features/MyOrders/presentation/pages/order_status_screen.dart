import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_controller.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/timeline_tile.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/shared_widgets/app_error_widget.dart';
import 'package:hcs_driver/src/shared_widgets/custom_appbar.dart';
import 'package:hcs_driver/src/shared_widgets/fade_circle_loading_indicator.dart';

@RoutePage()
class OrderStatusScreen extends ConsumerWidget {
  final String? statusOrderType;
  // final String serviceOrderID;
  final String appointmentID;

  const OrderStatusScreen({
    super.key,
    required this.statusOrderType,
    // required this.serviceOrderID,
    required this.appointmentID,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // أصبحنا نراقب statusOrders فقط لأنه يحمل بداخله حالات (loading, data, error)
    final statusOrdersAsync = ref.watch(
      myOrdersControllerProvider.select((value) => value.statusOrders),
    );

    // استخدام .when بدلاً من switch (statusOrderStates)
    return statusOrdersAsync.when(
      loading: () => const FadeCircleLoadingIndicator(),
      error: (error, stack) => AppErrorWidget(
        onTap: () => ref
            .read(myOrdersControllerProvider.notifier)
            .updateStatusOrder(appointmentID: appointmentID),
      ),
      data: (statusOrders) {
        return Scaffold(
          appBar: CustomAppbar(
            hasBackArrow: true,
            title: context.tr(AppStrings.orderStatus),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(statusOrders.length, (index) {
                final status = statusOrders[index];

                final isFirst = index == 0;
                final isLast = index == statusOrders.length - 1;

                final isActive = status.active;
                final isChildActive = !isLast && statusOrders[index + 1].active;
                final isParentActive =
                    !isFirst && statusOrders[index - 1].active;

                final lastStepStatus = isLast && isActive
                    ? (statusOrderType == "Cancellation Request"
                        ? "cancelled"
                        : "done")
                    : null;

                return CustomTimelineTile(
                  index: index,
                  title: status.status,
                  isParentActive: isParentActive,
                  isActive: isActive,
                  isChildActive: isChildActive,
                  isFirst: isFirst,
                  isLast: isLast,
                  lastStepStatus: lastStepStatus,
                  hasButton: isActive && !isChildActive && !isLast,
                  onPressed: () => ref
                      .read(myOrdersControllerProvider.notifier)
                      .updateStatusOrder(appointmentID: appointmentID),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
