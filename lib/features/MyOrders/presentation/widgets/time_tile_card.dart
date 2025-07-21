import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/text_card.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class TimeTileCard extends StatelessWidget {
  final String text;
  final bool isActive;
  final bool isLast;
  final bool isChildActive;
  final void Function()? onPressed;
  const TimeTileCard({
    super.key,
    required this.isActive,
    required this.isChildActive,
    required this.text,
    required this.isLast,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextCard(text: text, isActive: isActive),
        if (isActive && !isChildActive && !isLast)
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppColors.greenText.withValues(alpha: 0.1),
              foregroundColor: AppColors.greenText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
                side: BorderSide(width: 0.6, color: AppColors.greenText),
              ),
              tapTargetSize: MaterialTapTargetSize.padded,
              minimumSize: Size(100.w, 28.h),
              fixedSize: Size(140.w, 40.h),

              visualDensity: VisualDensity.comfortable,
            ),
            onPressed: onPressed,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'Mark as completed ✓',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          )
        else
          SizedBox.shrink(),
      ],
    );
  }
}
