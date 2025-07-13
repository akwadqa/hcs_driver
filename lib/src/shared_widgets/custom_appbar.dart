import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Availability/presentation/controllers/availability_controller.dart';
import 'package:hcs_driver/src/enums/service_type.dart';
import 'package:hcs_driver/src/shared_widgets/custom_back_arrow_widget.dart';
import 'package:hcs_driver/gen/assets.gen.dart'; // for your SVG assets
import 'package:hcs_driver/src/theme/app_colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasBackArrow;
  final bool isHome;
  final bool withTabs;
  final String? title;
  final List<Widget>? actions;
  final TabController? tabController;

  const CustomAppbar({
    super.key,
    this.hasBackArrow = false,
    this.isHome = false,
    this.withTabs = false,
    this.actions,
    this.title,
    this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: UniqueKey(),
      leading: isHome
          ? null
          : hasBackArrow
          ? const CustomBackArrowWidget()
          : null,
      centerTitle: true,
      backgroundColor: AppColors.white,
      elevation: 0,
      bottom: withTabs && tabController != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(48.h),
              child: Container(
                color: AppColors.tabBarColor,
                child: TabBar(
                  controller: tabController,
                  labelColor: AppColors.blueTitle,
                  unselectedLabelColor: AppColors.greyText,
                  indicatorColor: AppColors.blueTitle,
                  labelStyle: Theme.of(context).textTheme.displayMedium,
                  unselectedLabelStyle: Theme.of(
                    context,
                  ).textTheme.displayMedium,

                  tabs: const [
                    Tab(text: 'Accept'),
                    Tab(text: 'Pending'),
                    Tab(text: 'Cancelled'),
                  ],
                ),
              ),
            )
          : null,

      title: Consumer(
        builder: (context, ref, child) {
          var selectedServiceTypeState = ref.watch(
            availabilityControllerProvider.select(
              (value) => value.selectedServiceType,
            ),
          );
          return title != null
              ? Text(
                  title!,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : isHome
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Assets.images.logo.image(
                      height: 50.h,
                      width: 70.w,
                      fit: BoxFit.fitWidth,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "${serviceTypeToString(ServiceType.home)} Service",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Text(
                  "$selectedServiceTypeState Service",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                );
        },
      ),
      actions: isHome ? null : actions,
      actionsPadding: EdgeInsets.symmetric(horizontal: 31.w),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(withTabs ? kToolbarHeight + 48 : kToolbarHeight);
}
