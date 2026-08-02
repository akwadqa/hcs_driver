import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Auth/application/auth_service.dart';
import 'package:hcs_driver/src/shared_widgets/custom_back_arrow_widget.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

import '../extenssions/widget_extensions.dart';
import 'filter_status_menue.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasBackArrow;
  final bool isHome;
  final bool withTabs;
  final String title;
  final List<Widget>? actions;
  final TabController? tabController;
  final ValueChanged<int>? onTabTap;
  final VoidCallback? onBakPressed;
  final int? currentTabIndex;
  final bool withFilter;

  const CustomAppbar({
    super.key,
    this.hasBackArrow = false,
    this.isHome = false,
    this.withTabs = false,
    this.actions,
    required this.title,
    this.tabController,
    this.onTabTap,
    this.onBakPressed,
    this.currentTabIndex,
    this.withFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: UniqueKey(),
      leading: isHome
          ? null
          : hasBackArrow
              ? CustomBackArrowWidget(
                  onBakPressed: onBakPressed,
                )
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
                  onTap: onTabTap,
                  labelColor: AppColors.blueTitle,
                  unselectedLabelColor: AppColors.greyText,
                  indicatorColor: AppColors.blueTitle,
                  labelStyle: Theme.of(context).textTheme.displayMedium,
                  unselectedLabelStyle: Theme.of(
                    context,
                  ).textTheme.displayMedium,
                  tabs: [
                    Tab(
                      icon: SizedBox(
                        child: Icon(
                          Icons.date_range_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    //? Dont forget it :
                    // Tab(text: 'Yesterday'),
                    Tab(text: 'today'.tr()),
                    Tab(text: 'tomorrow'.tr()),
                  ],
                ),
              ),
            )
          : null,
      title: Consumer(
        builder: (context, ref, child) {
          final user = ref.watch(userDataProvider);
          return isHome
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: AppColors.blueTitle),
                        10.horizontalSpace,
                        Text(
                          user?.$2 ?? "driveer",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ],
                )
              : Text(
                  title,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                );
        },
      ),
      actions: isHome
          ? withFilter
              ? [
                  Consumer(
                    builder: (context, ref, _) {
                      return GestureDetector(
                        onTap: () {
                          showOrderFilterMenu(
                            context,
                            ref,
                            currentTabIndex ?? 0,
                          );
                        },
                        child: Icon(
                          Icons.filter_alt_rounded,
                          color: AppColors.primary,
                          size: 33,
                        ),
                      ).onlyPadding(end: 8);
                    },
                  ),
                ]
              : null
          : actions,
      actionsPadding: EdgeInsets.symmetric(horizontal: 31.w),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(withTabs ? kToolbarHeight + 48 : kToolbarHeight);
}
