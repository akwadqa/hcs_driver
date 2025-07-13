import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/src/manager/font_family.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';
import 'package:hcs_driver/src/theme/app_sizes.dart';

class CustomButton extends ElevatedButton {
  CustomButton({
    super.key,
    required String title,
    required super.onPressed,
    double? textSize,
    WidgetStateProperty<Size?>? fixedSize,
    Color? buttonColor,
    Color? fontColor,
  }) : super(
         style: ElevatedButton.styleFrom(
           backgroundColor: buttonColor ?? AppColors.primary,
           fixedSize:
               fixedSize?.resolve({}) ??
               Size(AppSizes.authButtonWidth.w, AppSizes.authButtonHeight.h),
           shadowColor: Colors.transparent,
         ),
         child: Text(
           title,
           style: TextStyle(
             fontSize: textSize ?? 16.sp,
             fontWeight: FontWeight.w700,
             color: fontColor ?? AppColors.white,
             fontFamily: FontFamily.instrumentSan,
           ),
         ),
       );
}
