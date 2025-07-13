import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Availability/presentation/controllers/availability_controller.dart';
import 'package:hcs_driver/features/Home/Availability/presentation/widgets/days_selctions_chips.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';
import 'package:hcs_driver/src/shared_widgets/custom_appbar.dart';
import 'package:hcs_driver/src/shared_widgets/custom_button.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

@RoutePage()
class DaysSelectionScreen extends ConsumerStatefulWidget {
  const DaysSelectionScreen({super.key});

  @override
  ConsumerState<DaysSelectionScreen> createState() =>
      _DaysSelectionScreenState();
}

class _DaysSelectionScreenState extends ConsumerState<DaysSelectionScreen> {
  @override
  void initState() {
    super.initState();
    Future(
      () => ref
          .read(availabilityControllerProvider.notifier)
          .calculateVisitDates(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final availabilityState = ref.watch(availabilityControllerProvider);

    return Scaffold(
      // body: availabilityState.packagesStates == RequestStates.loaded
      //     ? _buildContent(homeState.homeBlock!)
      //     : availabilityState.packagesStates == RequestStates.loading
      //     ? const Center(child: FadeCircleLoadingIndicator())
      //     : availabilityState.packagesStates == RequestStates.error
      //     ? AppErrorWidget(
      //         onTap: () => Future(
      //           () =>
      //               ref.read(availabilityControllerProvider.notifier).fetchPackages(),
      //         ),
      //       )
      //     : SizedBox.shrink(),
      body: _buildContent(context),
      appBar: CustomAppbar(hasBackArrow: true),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              context.tr(AppStrings.chooseDays),
              style: Theme.of(context).textTheme.displayMedium!,
            ),
            16.verticalSpace,
            DaysSelectionChips(),

            Consumer(
              builder: (context, ref, child) {
                final firstVisitDate = ref.watch(
                  availabilityControllerProvider.select(
                    (value) => value.firstVisitDate,
                  ),
                );
                final lastVisitDate = ref.watch(
                  availabilityControllerProvider.select(
                    (value) => value.lastVisitDate,
                  ),
                );

                if (firstVisitDate.isNotEmpty && lastVisitDate.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      30.verticalSpace,
                      Text(
                        context.tr(AppStrings.firstVisitDate),
                        style: Theme.of(context).textTheme.displayMedium!,
                      ),
                      8.verticalSpace,
                      TextFormField(
                        controller: TextEditingController(text: firstVisitDate),
                        enabled: false,
                        decoration: InputDecoration(
                          fillColor: AppColors.unSelectedGrey,
                          filled: true,
                          hintStyle: Theme.of(context)
                              .inputDecorationTheme
                              .hintStyle!
                              .copyWith(color: AppColors.greyText),
                        ),
                      ),
                      24.verticalSpace,
                      Text(
                        context.tr(AppStrings.toDate),
                        style: Theme.of(context).textTheme.displayMedium!,
                      ),
                      8.verticalSpace,
                      TextFormField(
                        controller: TextEditingController(text: lastVisitDate),
                        enabled: false,
                        decoration: InputDecoration(
                          fillColor: AppColors.unSelectedGrey,
                          filled: true,
                          hintStyle: Theme.of(context)
                              .inputDecorationTheme
                              .hintStyle!
                              .copyWith(color: AppColors.greyText),
                        ),
                      ),
                    ],
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
            30.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Consumer(
                builder: (context, ref, child) {
                  final selectedDaysState = ref.watch(
                    availabilityControllerProvider.select(
                      (value) => value.selectedDays.isEmpty,
                    ),
                  );

                  return CustomButton(
                    title: tr(context: context, AppStrings.checkAvailability),
                    onPressed: selectedDaysState
                        ? null
                        : () {
                            // context.pushRoute(
                            //   EmployeesRoute(serviceType: serviceType),
                            // );

                            context.pushRoute(EmployeesRoute());
                            // : ref
                            //       .watch(
                            //         availabilityControllerProvider.notifier,
                            //       )
                            //       .calculateVisitDates();
                            // if (_formKey.currentState!.validate()) {
                            // ref
                            //     .read(authControllerProvider.notifier)
                            //     .login(
                            //       LoginParams(
                            //         email: _emailController.text,
                            //         pass: _passwordController.text,
                            //       ),
                            //     );
                            // }
                          },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
