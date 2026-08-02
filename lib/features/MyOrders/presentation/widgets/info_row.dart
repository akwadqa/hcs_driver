import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class InfoRow extends StatelessWidget {
  final String? title;
  final String? value;
  final Widget? widget;
  final bool? important;

  const InfoRow(
    this.title, {
    super.key,
    this.value,
    this.widget,
    this.important,
  });

  @override
  Widget build(BuildContext context) {
    return value != null
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 27.w,
                  height: 27.w,
                  padding: EdgeInsets.all(6.w),
                  decoration: const BoxDecoration(
                    color: AppColors.iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Assets.images.customerIc.svg(),
                ),
                15.horizontalSpace,
                if (title != null && title!.isNotEmpty)
                  Expanded(
                    child: Text(
                      title!,
                      softWrap: true,
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                color: AppColors.labelGrey,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ),
                Expanded(
                  child: widget ??
                      Text(
                        "$value",
                        softWrap: true,

                        // textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                              fontWeight: important == true
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: important == true ? AppColors.green : null,
                            ),
                      ),
                ),
              ],
            ),
          )
        : SizedBox();
  }
}
