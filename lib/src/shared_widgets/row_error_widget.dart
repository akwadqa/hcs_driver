import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class SimpleErrorWidget extends StatelessWidget {
  final void Function()? onTap;
  const SimpleErrorWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 15.h,
          width: 30.w,
          child: Icon(Icons.refresh, color: AppColors.primary, size: 20.sp),
        ),
      ),
    );
  }
}
