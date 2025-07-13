import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Availability/presentation/controllers/availability_controller.dart';
import 'package:hcs_driver/features/Home/Employees/presentation/controllers/employees_controller.dart';
import 'package:hcs_driver/features/Home/Employees/presentation/widgets/employee_bar_chips.dart';
import 'package:hcs_driver/features/Home/Employees/presentation/widgets/search_field.dart';
import 'package:hcs_driver/features/Home/Employees/presentation/widgets/service_category.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/enums/request_state.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';
import 'package:hcs_driver/src/shared_widgets/app_error_widget.dart';
import 'package:hcs_driver/src/shared_widgets/custom_appbar.dart';
import 'package:hcs_driver/src/shared_widgets/custom_button.dart';
import 'package:hcs_driver/src/shared_widgets/fade_circle_loading_indicator.dart';

@RoutePage()
class EmployeesScreen extends ConsumerStatefulWidget {
  const EmployeesScreen({super.key});

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // pagination listener only once:
    _scrollController.addListener(() {
      final max = _scrollController.position.maxScrollExtent;
      final pos = _scrollController.position.pixels;
      final nextPage = ref
          .read(employeesControllerProvider)
          .currentEmployeesPage;

      if (pos == max && nextPage != null) {
        ref.read(employeesControllerProvider.notifier).onLoadMoreEmployees();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
      appBar: CustomAppbar(hasBackArrow: true),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SearchField(
                          onFieldSubmitted: (value) {
                            var epmloyeeNotifier = ref.read(
                              employeesControllerProvider.notifier,
                            );

                            epmloyeeNotifier.searchEmployee(value);
                          },
                        ),
                        24.verticalSpace,
                        Text(
                          context.tr(AppStrings.serviceCategory),
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        16.verticalSpace,
                        Consumer(
                          builder: (context, ref, child) {
                            var selectedServiceType = ref.watch(
                              availabilityControllerProvider.select(
                                (value) => value.selectedServiceType,
                              ),
                            );
                            return ServiceCategoryChips(
                              selectedChip: selectedServiceType!,
                            );
                          },
                        ),
                        44.verticalSpace,
                        Text(
                          context.tr(AppStrings.employees),
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        16.verticalSpace,
                        Consumer(
                          builder: (context, ref, child) {
                            final employeesState = ref.watch(
                              employeesControllerProvider,
                            );

                            if (employeesState.employeesStates ==
                                RequestStates.loaded) {
                              if (employeesState.employees.isEmpty) {
                                return Assets.images.noDataMin.image();
                              }
                              return SizedBox(
                                height: 304.h,
                                child: ListView.separated(
                                  controller: _scrollController,
                                  itemCount:
                                      employeesState.employees.length + 1,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (index ==
                                        employeesState.employees.length) {
                                      // Check if currentEmployeesPage is null and state is loaded
                                      if (employeesState.currentEmployeesPage ==
                                          null) {
                                        return Center(
                                          child: Text(
                                            'No More Employees',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: FadeCircleLoadingIndicator(),
                                        );
                                      }
                                    } else {
                                      return EmployeeBarChip(
                                        employee:
                                            employeesState.employees[index],
                                        enabled: employeesState
                                            .selectedEmployees
                                            .contains(
                                              employeesState.employees[index],
                                            ),
                                      );
                                    }
                                  },
                                  separatorBuilder: (_, __) => 16.verticalSpace,
                                ),
                              );
                            } else if (employeesState.employeesStates ==
                                RequestStates.error) {
                              return AppErrorWidget(
                                onTap: () => ref
                                    .read(employeesControllerProvider.notifier)
                                    .fetchEmployees(),
                              );
                            } else if (employeesState.employeesStates ==
                                RequestStates.loading) {
                              return Center(
                                child: FadeCircleLoadingIndicator(),
                              );
                            }

                            return SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 25.h,
                      horizontal: 22.w,
                    ),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final selectedEmployees = ref.watch(
                          employeesControllerProvider.select(
                            (value) => value.selectedEmployees,
                          ),
                        );

                        return CustomButton(
                          title: tr(context: context, AppStrings.next),
                          onPressed: selectedEmployees.isEmpty
                              ? null
                              : () {
                                  context.pushRoute(DriverPaymentRoute());
                                  // if (_formKey.currentState!.validate()) {}
                                },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
