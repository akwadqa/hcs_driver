import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/enums/service_type.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class ServiceCard extends StatelessWidget {
  final ServiceType? serviceType;
  final bool enabled;

  const ServiceCard({super.key, this.serviceType, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    // Wrap in AbsorbPointer when disabled
    Widget card = Container(
      width: 342.w,
      height: 150.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(Assets.images.dummycard.path),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        width: 342.w,
        height: 150.h,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(
          top: 85.h,
          bottom: 15.h,
          left: 50.w,
          right: 50.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: AppColors.serviceCardGradient,
        ),
        child: serviceType != null
            ? Text(
                serviceTypeToString(serviceType!),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );

    if (!enabled) {
      // Dim and block interactions
      card = Opacity(opacity: 0.5, child: AbsorbPointer(child: card));
    }

    return card;
  }
}
