import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class TextCard extends StatelessWidget {
  final String text;
  final bool isActive;
  const TextCard({super.key, required this.text, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: isActive
          ? Theme.of(context).textTheme.displaySmall!.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            )
          : Theme.of(context).textTheme.displaySmall!.copyWith(
              fontSize: 15.sp,
              color: AppColors.blackText,
              fontWeight: FontWeight.w500,
            ),
    );
  }
}
