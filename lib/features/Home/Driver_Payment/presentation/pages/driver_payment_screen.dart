import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Availability/presentation/controllers/availability_controller.dart';
import 'package:hcs_driver/features/Home/Driver_Payment/presentation/controllers/drivers_payment_controllers.dart';
import 'package:hcs_driver/features/Home/Driver_Payment/presentation/widgets/discount_dropdown.dart';
import 'package:hcs_driver/features/Home/Driver_Payment/presentation/widgets/paginated_dropdown_drivers.dart';
import 'package:hcs_driver/features/Home/Driver_Payment/presentation/widgets/payment_method_chips.dart';
import 'package:hcs_driver/features/Home/Driver_Payment/presentation/widgets/yes_no_answer.dart';
import 'package:hcs_driver/features/Home/Submit_Service/presentation/submit_service_controller.dart';
import 'package:hcs_driver/features/Home/Submit_Service/presentation/submit_service_state.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/enums/request_state.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';
import 'package:hcs_driver/src/shared_widgets/custom_appbar.dart';
import 'package:hcs_driver/src/shared_widgets/custom_button.dart';
import 'package:hcs_driver/src/shared_widgets/row_error_widget.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';
import 'package:hcs_driver/src/shared_widgets/fade_circle_loading_indicator.dart';

@RoutePage()
class DriverPaymentScreen extends ConsumerStatefulWidget {
  const DriverPaymentScreen({super.key});

  @override
  ConsumerState<DriverPaymentScreen> createState() =>
      _DriverPaymentScreenState();
}

class _DriverPaymentScreenState extends ConsumerState<DriverPaymentScreen> {
  final _dropdownKey = GlobalKey<PaginatedDriverDropdownState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(driversPaymentControllerProvider.notifier).fetchDrivers();
      ref.read(driversPaymentControllerProvider.notifier).getDiscountType();
    });
  }

  @override
  Widget build(BuildContext context) {
    final driversPaymentState = ref.watch(driversPaymentControllerProvider);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        // 3) First close the overlay if it's open
        _dropdownKey.currentState?.closeOverlay();
        // 4) Then allow the pop to happen
      },
      child: Scaffold(
        appBar: CustomAppbar(hasBackArrow: true),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                24.verticalSpace,
                Text(
                  context.tr(AppStrings.driverName),
                  style: Theme.of(context).textTheme.displayMedium!,
                ),
                8.verticalSpace,
                Consumer(
                  builder: (context, ref, child) {
                    if (driversPaymentState.driversStates ==
                        RequestStates.loaded) {
                      return PaginatedDriverDropdown(
                        key: _dropdownKey,
                        // onChanged: (cust) {
                        //   setState(() => _chosenDriver = cust);
                        //   ref
                        //       .read(driversPaymentControllerProvider.notifier)
                        //       .selectDriver(cust);

                        // },
                      );
                    } else if (driversPaymentState.driversStates ==
                        RequestStates.loading) {
                      return const FadeCircleLoadingIndicator();
                    } else if (driversPaymentState.driversStates ==
                        RequestStates.error) {
                      return SimpleErrorWidget(
                        onTap: () => ref
                            .read(driversPaymentControllerProvider.notifier)
                            .fetchDrivers(),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),

                32.verticalSpace,
                Divider(height: 0.1, color: AppColors.dividerGrey),
                32.verticalSpace,

                Consumer(
                  builder: (context, ref, child) {
                    if (driversPaymentState.discountStates ==
                        RequestStates.loaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          DiscountDropdown(
                            items: driversPaymentState.discountType,
                            selectedItem: driversPaymentState.selectedDiscount,
                            onSelected: (p0) {
                              Future(
                                () => ref
                                    .read(
                                      driversPaymentControllerProvider.notifier,
                                    )
                                    .selectDiscount(p0),
                              );
                            },
                          ),
                          driversPaymentState.selectedDiscount != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    16.verticalSpace,
                                    Text(
                                      context.tr(AppStrings.discountPercentage),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.displayMedium,
                                    ),
                                    8.verticalSpace,
                                    TextFormField(
                                      controller: TextEditingController(
                                        text: driversPaymentState
                                            .discountPercentage
                                            .toString(),
                                      ),
                                      enabled:
                                          driversPaymentState
                                              .selectedDiscount
                                              ?.discountPercentage !=
                                          0,
                                      keyboardType: TextInputType.number,
                                      onFieldSubmitted: (value) {
                                        double? doubleDiscount =
                                            double.tryParse(value);
                                        ref
                                            .read(
                                              driversPaymentControllerProvider
                                                  .notifier,
                                            )
                                            .calculateTotalCost(doubleDiscount);
                                      },
                                      decoration: InputDecoration(
                                        hintStyle: Theme.of(
                                          context,
                                        ).inputDecorationTheme.hintStyle,
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                          10.verticalSpace,
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Total Cost: ',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displayMedium,
                                ),
                                TextSpan(
                                  text:
                                      '${driversPaymentState.discountedCost} ',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displaySmall,
                                ),

                                TextSpan(
                                  text: driversPaymentState.originalCost
                                      .toString(),
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 13.sp,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          32.verticalSpace,
                        ],
                      );
                    } else if (driversPaymentState.discountStates ==
                        RequestStates.loading) {
                      return const FadeCircleLoadingIndicator();
                    } else if (driversPaymentState.discountStates ==
                        RequestStates.error) {
                      return SimpleErrorWidget(
                        onTap: () => ref
                            .read(driversPaymentControllerProvider.notifier)
                            .getDiscountType(),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),

                PaymentMethodChips(),
                32.verticalSpace,
                Divider(height: 0.1, color: AppColors.dividerGrey),
                32.verticalSpace,
                Consumer(
                  builder: (context, ref, child) {
                    var selectedServiceType = ref.watch(
                      availabilityControllerProvider.select(
                        (value) => value.selectedServiceType,
                      ),
                    );

                    return selectedServiceType != "Packages"
                        ? AreCleaningSuppliesAvailable()
                        : SizedBox.shrink();
                  },
                ),
                50.verticalSpace,

                Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.h),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final drvierDiscountState = ref.watch(
                          driversPaymentControllerProvider,
                        );
                        final selectedServiceType = ref.watch(
                          availabilityControllerProvider.select(
                            (value) => value.selectedServiceType,
                          ),
                        );
                        final submitServiceStates = ref.watch(
                          submitServiceControllerProvider.select(
                            (value) => value.submitServiceStates,
                          ),
                        );
                        ref.listen<
                          SubmitServiceState
                        >(submitServiceControllerProvider, (previous, next) {
                          if (next.submitServiceStates ==
                              RequestStates.loaded) {
                            context.router.replaceAll([
                              MainRoute(children: [HomeRoute()]),
                            ]);

                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: selectedServiceType == "On Call"
                                    ? Assets.images.greenSuccessful.svg(
                                        width: 100,
                                        height: 100,
                                      )
                                    : Assets.images.successful.svg(),
                                content: Text(
                                  'Service has been\n requested successfully.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(fontSize: 20.sp),
                                ),
                              ),
                            );
                          }

                          if (next.submitServiceStates == RequestStates.error) {
                            _dropdownKey.currentState?.closeOverlay();

                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Assets.images.errorX.svg(),
                                content: Text(
                                  next.submitServiceMessage ??
                                      "An unexpected error occurred. Please try again.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(fontSize: 20.sp),
                                ),
                              ),
                            );
                          }
                        });
                        return CustomButton(
                          title: tr(context: context, AppStrings.submit),
                          onPressed:
                              drvierDiscountState.selectedDriver == null ||
                                  submitServiceStates == RequestStates.loading
                              ? null
                              : () {
                                  _dropdownKey.currentState?.closeOverlay();

                                  ref
                                      .watch(
                                        submitServiceControllerProvider
                                            .notifier,
                                      )
                                      .submitService();
                                },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
