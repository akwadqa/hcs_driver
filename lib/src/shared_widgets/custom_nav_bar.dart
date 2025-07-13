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
    AppStrings.home.tr(),
    AppStrings.myOrders.tr(),
    AppStrings.settings.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> icons = [
      Assets.images.homeSelected.path,
      Assets.images.myordersSelected.path,
      Assets.images.settingsSelected.path,
    ];
    return SafeArea(
      bottom: true,
      child: Container(
        padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
        height: 85.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Row(
          children: List.generate(3, (index) {
            final isSelected = widget.currentIndex == index;
            return Expanded(
              child: InkWell(
                onTap: () => widget.onTap(index),

                child: Column(
                  children: [
                    SvgPicture.asset(
                      icons[index],
                      height: 24.h,
                      width: 24.h,
                      colorFilter: ColorFilter.mode(
                        isSelected
                            ? AppColors.blueText
                            : AppColors.blueText.withValues(alpha: 0.5),
                        BlendMode.srcIn,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      titles[index].tr(),
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 12.sp,
                        color: isSelected
                            ? AppColors.blueText
                            : AppColors.blueText.withValues(alpha: 0.5),
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
