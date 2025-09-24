import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class InfoRow extends StatelessWidget {
  final String? title;
  final String? value;
  final Widget? widget;

  const InfoRow(this.title, {super.key, this.value, this.widget});

  @override
  Widget build(BuildContext context) {
    return value != null
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (title != null)
                  Expanded(
                    child: Text(
                      title!,
                      softWrap: true,
                      style: Theme.of(context).textTheme.displayMedium!
                          .copyWith(
                            color: AppColors.blueText,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                SizedBox(width: 16.w),
                Expanded(
                  child:
                      widget ??
                      Text(
                        "$value",
                        softWrap: true,

                        // textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                ),
              ],
            ),
          )
        : SizedBox();
  }
}
