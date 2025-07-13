import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/src/extenssions/int_extenssion.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

import '../../gen/assets.gen.dart';

class AppErrorWidget extends StatelessWidget {
  final void Function()? onTap;
  const AppErrorWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.images.error404Min.image(width: 300.w, height: 350.h),
            20.verticalSpace,
            Text(
              context.tr(AppStrings.pressToRefreash),
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: AppColors.unSelectedText,
                fontSize: 22.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
