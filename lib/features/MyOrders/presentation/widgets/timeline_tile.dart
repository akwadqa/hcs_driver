import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/text_card.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/time_tile_card.dart';
import 'package:hcs_driver/src/shared_widgets/custom_button.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CustomTimelineTile extends StatelessWidget {
  final int index;
  final String title;
  final bool isParentActive;
  final bool isActive;
  final bool isChildActive;
  final bool isFirst;
  final bool isLast;
  final String? lastStepStatus; // 'done', 'issue', 'cancelled'
  final void Function()? onPressed;

  const CustomTimelineTile({
    super.key,
    required this.index,
    required this.title,
    required this.isParentActive,
    required this.isActive,
    required this.isChildActive,
    required this.isFirst,
    required this.isLast,
    this.lastStepStatus, this.onPressed,
  });

  Color _getLastStepColor() {
    switch (lastStepStatus) {
      case 'done':
        return Colors.green;
      case 'issue':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Icon _getLastStepIcon() {
    switch (lastStepStatus) {
      case 'done':
        return const Icon(Icons.check, color: Colors.white);
      case 'issue':
        return const Icon(Icons.error_outline, color: Colors.white);
      case 'cancelled':
        return const Icon(Icons.close, color: Colors.white);
      default:
        return const Icon(Icons.circle, color: Colors.white);
    }
  }

  Widget _buildIndicator() {
    if (isLast && lastStepStatus != null) {
      return Container(
        height: 38.h,
        width: 38.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getLastStepColor(),
        ),
        child: Center(child: _getLastStepIcon()),
      );
    } else if (isActive && isChildActive) {
      return Container(
        height: 38.h,
        width: 38.w,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.blueTitle,
        ),
        child: const Center(child: Icon(Icons.check, color: Colors.white)),
      );
    } else {
      return Container(
        height: 38.h,
        width: 38.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
          border: Border.all(color: AppColors.blueTitle, width: 2.w),
        ),
        child: Center(
          child: Text(
            (index + 1).toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.blueTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  Color _getLineColor(bool beforeLine) {
    if (beforeLine) {
      return isActive ? AppColors.blueTitle : Colors.white;
    } else {
      return isChildActive ? AppColors.blueTitle : Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        alignment: TimelineAlign.center,
        axis: TimelineAxis.vertical,
        hasIndicator: true,
        indicatorStyle: IndicatorStyle(
          height: 38.h,
          width: 38.w,
          indicator: _buildIndicator(),
        ),
        beforeLineStyle: LineStyle(color: _getLineColor(true), thickness: 6),
        afterLineStyle: LineStyle(color: _getLineColor(false), thickness: 6),

        startChild: (index % 2 != 0)
            ? TimeTileCard( 
              onPressed: onPressed,
                isActive: isActive,
                isLast: isLast,
                isChildActive: isChildActive,
                text: title,
              )
            : SizedBox.shrink(),
        endChild: !isLast && (index % 2 == 0)
            ? TimeTileCard(
              onPressed:onPressed ,
                isActive: isActive,
                isLast: isLast,
                isChildActive: isChildActive,
                text: title,
              )
            : SizedBox.shrink(),
      ),
    );
  }
}
