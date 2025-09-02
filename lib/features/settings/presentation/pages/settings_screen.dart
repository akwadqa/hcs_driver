import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Auth/presentation/controller/auth_controller.dart';
import 'package:hcs_driver/features/settings/presentation/pages/payment_summary.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/extenssions/widget_extensions.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';
import 'package:hcs_driver/src/shared_widgets/custom_button.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/shared_widgets/custom_appbar.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

@RoutePage()
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    // Register listener exactly once
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      if (next is AsyncData) {
        context.router.replaceAll([IntroRoute()]);
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    return Scaffold(
      appBar: CustomAppbar(
        hasBackArrow: false,
        isHome: true,
        title: context.tr(AppStrings.settings),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
         Expanded(
  child: ListView(
    // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    children: [
      _buildMenuItem(context, "Payment Summary", onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_)=>PaymentSummaryScreen())
        );
//  context.pushRoute(
//                   PaymentSummaryRoute()
//                   // OrderDetailsRoute(
//                   //   serviceOrderID:
//                   //       ordersState.pendingOrders[index].serviceOrderId,
//                   // ),
//                 );     
                 }).symmetricPadding(horizontal: 10),
      20.verticalSpace,
      Assets.images.byebye.image(
        fit: BoxFit.fitWidth,
        height: 0.4.sh,
      ),
      20.verticalSpace,
      Container(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          tr(context: context, AppStrings.goodBye),
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 30.sp,
          ),
        ),
      ),
    ],
  ),
),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 25.h),
            child: CustomButton(
              title: tr(context: context, AppStrings.logOut),
              onPressed: ref.read(authControllerProvider) is AsyncLoading
                  ? null
                  : () {
                      ref.read(authControllerProvider.notifier).logout();
                    },
            ),
          ),
        ],
      ),
    );
  }

Widget _buildMenuItem(
  BuildContext context,
  String title, {
  required VoidCallback onTap,
  bool showDivider = true,
}) {
  return Column(
    children: [
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: Icon(Icons.settings, color: AppColors.primary), // ✅
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: AppColors.black900,
              ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
      if (showDivider)
        const Divider(
          height: 1,
          indent: 12,
          endIndent: 12,
          color: AppColors.lightGray,
        ),
    ],
  );
}

}
