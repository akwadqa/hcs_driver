import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/timeline_tile.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/shared_widgets/custom_appbar.dart';

@RoutePage()
class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        hasBackArrow: true,
        title: context.tr(AppStrings.orderStatus),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            CustomTimelineTile(
              isFirst: true,
              isLast: false,
              isPassed: true,
              index: 0,
              isParentPassed: false,
            ),
            CustomTimelineTile(
              isFirst: false,
              isLast: false,
              isPassed: false,
              index: 1,
              isParentPassed: true,
            ),
            CustomTimelineTile(
              isFirst: false,
              isLast: false,
              isPassed: false,
              index: 2,
              isParentPassed: false,
            ),
            CustomTimelineTile(
              isFirst: false,
              isLast: false,
              isPassed: false,
              index: 3,
              isParentPassed: false,

              // lastStepStatus: "done",
            ),
            CustomTimelineTile(
              isFirst: false,
              isLast: false,
              isPassed: false,
              index: 4,
              isParentPassed: false,

              // lastStepStatus: "done",
            ),
            CustomTimelineTile(
              isFirst: false,
              isLast: false,
              isPassed: false,
              index: 5,
              isParentPassed: false,

              // lastStepStatus: "done",
            ),
            CustomTimelineTile(
              isFirst: false,
              isLast: false,
              isPassed: false,
              index: 6,
              isParentPassed: false,

              // lastStepStatus: "done",
            ),
            CustomTimelineTile(
              isFirst: false,
              isLast: true,
              isPassed: false,
              index: 7,
              isParentPassed: false,

              lastStepStatus: "done",
            ),
          ],
        ),
      ),
    );
  }
}
