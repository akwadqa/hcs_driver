import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Availability/presentation/controllers/availability_controller.dart';
import 'package:hcs_driver/features/Home/Availability/presentation/widgets/date_selection_widget.dart';
import 'package:hcs_driver/features/Home/Availability/presentation/widgets/packages_dropdown.dart';
import 'package:hcs_driver/features/Home/Availability/presentation/widgets/service_type_widget.dart';
import 'package:hcs_driver/features/Home/Availability/presentation/widgets/shift_type_chips.dart';
import 'package:hcs_driver/src/enums/request_state.dart';
import 'package:hcs_driver/src/enums/service_type.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';
import 'package:hcs_driver/src/shared_widgets/app_error_widget.dart';
import 'package:hcs_driver/src/shared_widgets/custom_appbar.dart';
import 'package:hcs_driver/src/shared_widgets/custom_button.dart';
import 'package:hcs_driver/src/shared_widgets/fade_circle_loading_indicator.dart';

@RoutePage()
class ServiceConfigurationScreen extends ConsumerStatefulWidget {
  const ServiceConfigurationScreen({super.key});

  @override
  ConsumerState<ServiceConfigurationScreen> createState() =>
      _ServiceConfigurationScreenState();
}

class _ServiceConfigurationScreenState
    extends ConsumerState<ServiceConfigurationScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future(
      () => ref.read(availabilityControllerProvider.notifier).fetchPackages(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availabilityState = ref.watch(
      availabilityControllerProvider.select((value) => value.packagesStates),
    );
    return Scaffold(
      body: availabilityState == RequestStates.loaded
          ? _buildContent()
          : availabilityState == RequestStates.loading
          ? const Center(child: FadeCircleLoadingIndicator())
          : availabilityState == RequestStates.error
          ? AppErrorWidget(
              onTap: () => Future(
                () => ref
                    .read(availabilityControllerProvider.notifier)
                    .fetchPackages(),
              ),
            )
          : SizedBox.shrink(),
      appBar: CustomAppbar(hasBackArrow: true),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        physics: BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ServiceTypeMenu(),
              24.verticalSpace,

              Consumer(
                builder: (context, ref, child) {
                  var packagesState = ref.watch(
                    availabilityControllerProvider.select(
                      (value) => value.packages,
                    ),
                  );
                  var selectedPackageState = ref.watch(
                    availabilityControllerProvider.select(
                      (value) => value.selectedPackage,
                    ),
                  );
                  var selectedServiceType = ref.watch(
                    availabilityControllerProvider.select(
                      (value) => value.selectedServiceType,
                    ),
                  );

                  return stringToServiceType(selectedServiceType!) ==
                          ServiceType.packages
                      ? Column(
                          children: [
                            PackagesDropdown(
                              items: packagesState,
                              selectedPackage: selectedPackageState,
                              onSelected: (p0) {
                                Future(
                                  () => ref
                                      .read(
                                        availabilityControllerProvider.notifier,
                                      )
                                      .selecPackage(p0),
                                );
                              },
                            ),
                            24.verticalSpace,
                          ],
                        )
                      : SizedBox.shrink();
                },
              ),

              ShiftTypeChips(),
              24.verticalSpace,

              Consumer(
                builder: (context, ref, child) {
                  var selectedDateState = ref.watch(
                    availabilityControllerProvider.select(
                      (value) => value.selectedDate,
                    ),
                  );
                  return DateFormField(
                    // labelText: 'Date',
                    initialDate: DateFormat(
                      'yyyy-MM-dd',
                    ).parse(selectedDateState),
                    onDateSelected: (dt) {
                      // do something with the chosen date
                      final formattedDate = DateFormat('yyyy-MM-dd').format(dt);
                      ref
                          .read(availabilityControllerProvider.notifier)
                          .selectDate(formattedDate);
                    },
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 22.w),
                child: Consumer(
                  builder: (context, ref, child) {
                    // var availabilityState = ref.watch(
                    //   availabilityControllerProvider,
                    // );
                    var selectedPackageState = ref.watch(
                      availabilityControllerProvider.select(
                        (value) => value.selectedPackage,
                      ),
                    );
                    var selectedServiceType = ref.watch(
                      availabilityControllerProvider.select(
                        (value) => value.selectedServiceType,
                      ),
                    );
                    return CustomButton(
                      title:
                          stringToServiceType(selectedServiceType!) ==
                              ServiceType.packages
                          ? tr(context: context, AppStrings.next)
                          : tr(context: context, AppStrings.checkAvailability),
                      onPressed: selectedPackageState == null
                          ? null
                          : () {
                              selectedPackageState.id == 'Daily'
                                  ? context.pushRoute(EmployeesRoute())
                                  : context.pushRoute(DaysSelectionRoute());
                              if (_formKey.currentState!.validate()) {}
                            },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
