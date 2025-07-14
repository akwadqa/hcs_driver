import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class CustomNavBar extends StatefulWidget {
  final void Function(int) onTap;
  final int currentIndex;

  const CustomNavBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  final List<String> titles = [
    AppStrings.myOrders.tr(),
    AppStrings.settings.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> icons = [
      Assets.images.myordersSelected.path,
      Assets.images.settingsSelected.path,
    ];
    return SafeArea(
      bottom: true,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        height: 80.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(2, (index) {
            final isSelected = widget.currentIndex == index;
            return InkWell(
              onTap: () => widget.onTap(index),

              child: Container(
                // height: 40.h,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 39.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      icons[index],
                      height: 24,
                      width: 24,
                      colorFilter: ColorFilter.mode(
                        isSelected ? AppColors.white : AppColors.lightBlueText,
                        BlendMode.srcIn,
                      ),
                    ),
                    10.horizontalSpace,
                    Text(
                      titles[index].tr(),
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 14.sp,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.lightBlueText,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
