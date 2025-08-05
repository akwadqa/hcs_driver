import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class AppointmentCard extends StatelessWidget {
  final String orderNumber;
  final String driverStatus;
  final String servicetype;
  final String date;
  final String employeeName;
  const AppointmentCard({
    super.key,
    required this.orderNumber,
    required this.driverStatus,
    required this.servicetype,
    required this.date,
    required this.employeeName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 18.w),
        child: Column(
          children: [
            AppoinmentInfoRow(
              'Order Number:',
              value: orderNumber,
              image: Assets.images.numberVector.path,
            ),
            AppoinmentInfoRow(
              'Driver Status:',
              value: driverStatus,
              image: Assets.images.driverStatus.path,
            ),
            AppoinmentInfoRow(
              'Service type:',
              value: servicetype,
              image: Assets.images.serviceType.path,
            ),
            AppoinmentInfoRow(
              'Date:',
              value: date,
              image: Assets.images.date.path,
            ),
            AppoinmentInfoRow(
              'Employee Name:',
              value: employeeName,
              image: Assets.images.employeeName.path,
            ),
          ],
        ),
      ),
    );
  }
}

class AppoinmentInfoRow extends StatelessWidget {
  final String? title;
  final String? value;
  final Widget? widget;
  final String image;

  const AppoinmentInfoRow(
    this.title, {
    super.key,
    this.value,
    this.widget,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title != null)
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  SizedBox(
                    height: 15.sp,
                    width: 15.sp,
                    child: SvgPicture.asset(image, height: 15.sp, width: 15.sp),

                    //  image?.svg(
                    //   fit: BoxFit.contain,
                    //   width: 15.sp,
                    //   height: 15.sp,
                    // ),
                  ),
                  11.horizontalSpace,
                  Text(
                    title!,
                    softWrap: true,
                    style: Theme.of(
                      context,
                    ).textTheme.displayMedium!.copyWith(fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          SizedBox(width: 16.w),
          Expanded(
            flex: 2,
            child:
                widget ??
                Text(
                  "$value",
                  softWrap: true,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.greyText,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
