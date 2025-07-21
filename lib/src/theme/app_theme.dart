import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/src/manager/font_family.dart';
import 'package:hcs_driver/src/theme/app_sizes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_colors.dart';

part 'app_theme.g.dart';

abstract class AppTheme {
  // Define shared styles to avoid repetition
  static const TextStyle _baseTextStyle = TextStyle(
    color: AppColors.black900,
    fontFamily: FontFamily.poppins,
    fontWeight: FontWeight.w400,
  );

  // static final EdgeInsets _buttonPadding = EdgeInsets.symmetric(vertical: 30.h);

  static OutlineInputBorder _outlineBorder(Color borderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.textFieldRadius),
      borderSide: BorderSide.none,
      gapPadding: 12.0.w,
    );
  }

  static ThemeData lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: AppColors.primarySwatch,
      ),
      primaryColor: AppColors.primary,
      fontFamily: FontFamily.poppins,

      textTheme: TextTheme(
        displayLarge: _baseTextStyle.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.white,
          fontFamily: FontFamily.poppins,
        ),
        displayMedium: _baseTextStyle.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.blackText,
          fontFamily: FontFamily.poppins,
        ),
        displaySmall: _baseTextStyle.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.blueText,
          fontFamily: FontFamily.poppins,
        ),
        bodyLarge: _baseTextStyle.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.blackText,
          fontFamily: FontFamily.poppins,
        ),
        bodyMedium: _baseTextStyle.copyWith(
          fontSize: 16.sp,
          color: AppColors.unSelectedText,
          fontFamily: FontFamily.poppins,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: _baseTextStyle.copyWith(fontSize: 16.sp),
          fixedSize: Size(
            AppSizes.authButtonWidth.w,
            AppSizes.authButtonHeight.h,
          ),
          alignment: Alignment.center,
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.disabledButtonBackground,

          // padding: _buttonPadding,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: _outlineBorder(AppColors.lightGray02),
        disabledBorder: _outlineBorder(AppColors.unSelectedGrey),
        focusedBorder: _outlineBorder(AppColors.primary),
        border: _outlineBorder(AppColors.lightGray02),
        errorBorder: _outlineBorder(AppColors.darkRed),
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        helperStyle: _baseTextStyle.copyWith(
          fontSize: 14.sp,
          color: AppColors.primary,
          fontWeight: FontWeight.w400,
          fontFamily: FontFamily.instrumentSan,
        ),
        errorStyle: _baseTextStyle.copyWith(
          fontSize: 14.sp,
          color: AppColors.darkRed,
          fontWeight: FontWeight.w400,
          fontFamily: FontFamily.instrumentSan,
        ),
        // contentPadding: EdgeInsets.symmetric(horizontal: 60.w),
        hintStyle: _baseTextStyle.copyWith(
          fontSize: 14.sp,
          color: AppColors.greyText,
          fontWeight: FontWeight.w400,
          fontFamily: FontFamily.instrumentSan,
        ),
        labelStyle: _baseTextStyle.copyWith(
          fontSize: 14.sp,
          color: AppColors.primary,
          fontWeight: FontWeight.w400,
          fontFamily: FontFamily.instrumentSan,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.black900,
          textStyle: _baseTextStyle.copyWith(fontSize: 14.sp),
        ),
      ),
      // Add this to your ThemeData inside lightTheme()
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          iconColor: WidgetStateProperty.all(AppColors.white),
          backgroundColor: WidgetStatePropertyAll(AppColors.primary),
          overlayColor: WidgetStateProperty.all(
            AppColors.primary.withValues(alpha: 0.1),
          ),
          shadowColor: WidgetStateProperty.all(Color(0x66000000)),
          elevation: WidgetStateProperty.all(4),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.textFieldRadius),
            ),
          ),
        ),
      ),

      scaffoldBackgroundColor: AppColors.scaffoldColor,
    );
  }
}

@Riverpod(keepAlive: true)
ThemeData appTheme(Ref ref) {
  return AppTheme.lightTheme();
}
