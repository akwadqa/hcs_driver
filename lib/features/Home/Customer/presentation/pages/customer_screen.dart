import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Customer/presentation/controllers/customer_controller.dart';
import 'package:hcs_driver/features/Home/Customer/presentation/controllers/customer_state.dart';
import 'package:hcs_driver/features/Home/Customer/presentation/widgets/add_customer_dialog.dart';
import 'package:hcs_driver/features/Home/Customer/presentation/widgets/custoemr_bar_chip.dart';
import 'package:hcs_driver/features/Home/Employees/presentation/widgets/search_field.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/enums/request_state.dart';
import 'package:hcs_driver/src/enums/service_type.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';
import 'package:hcs_driver/src/shared_widgets/app_error_widget.dart';
import 'package:hcs_driver/src/shared_widgets/custom_appbar.dart';
import 'package:hcs_driver/src/shared_widgets/custom_button.dart';
import 'package:hcs_driver/src/shared_widgets/fade_circle_loading_indicator.dart';

@RoutePage()
class CustomerScreen extends ConsumerStatefulWidget {
  final ServiceType serviceType;
  const CustomerScreen({super.key, required this.serviceType});

  @override
  ConsumerState<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ConsumerState<CustomerScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future(
      () => ref.read(customerControllerProvider.notifier).fetchCostumers(),
    );
    // pagination listener only once:
    _scrollController.addListener(() {
      final max = _scrollController.position.maxScrollExtent;
      final pos = _scrollController.position.pixels;
      final nextPage = ref
          .read(customerControllerProvider)
          .currentCustomersPage;

      if (pos == max && nextPage != null) {
        ref.read(customerControllerProvider.notifier).onLoadMoreCostumers();
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
    final customerState = ref.watch(customerControllerProvider);

    return Scaffold(
      body: customerState.customersStates == RequestStates.loaded
          ? _buildContent(customerState)
          : customerState.customersStates == RequestStates.loading
          ? const Center(child: FadeCircleLoadingIndicator())
          : customerState.customersStates == RequestStates.error
          ? AppErrorWidget(
              onTap: () => Future(
                () => ref
                    .read(customerControllerProvider.notifier)
                    .fetchCostumers(),
              ),
            )
          : SizedBox.shrink(),
      // body: _buildContent(CustomerState),
      appBar: CustomAppbar(hasBackArrow: true),
    );
  }

  Widget _buildContent(CustomerState customerState) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 16.h),
      child: Column(
        children: [
          // This Column will take available space
          Row(
            children: [
              Expanded(
                flex: 8,
                child: SearchField(
                  hintText: "Search Customers",
                  controller: TextEditingController(
                    text: customerState.customerSearchedFor,
                  ),
                  onFieldSubmitted: (value) {
                    var customerNotifier = ref.read(
                      customerControllerProvider.notifier,
                    );
                    customerNotifier.searchCustomer(value);
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Container(
                    height: kMinInteractiveDimension,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.transparent),
                    ),
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => const AddCustomerDialog(),
                        );
                      },
                      icon: const Icon(Icons.person_add),
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
          22.verticalSpace,
          Text(
            context.tr(AppStrings.customers),
            style: Theme.of(context).textTheme.displayMedium,
          ),
          16.verticalSpace,
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final customerState = ref.watch(customerControllerProvider);

                if (customerState.customersStates == RequestStates.loaded) {
                  if (customerState.customers.isEmpty) {
                    return Assets.images.noDataMin.image();
                  }
                  return ListView.separated(
                    controller: _scrollController,
                    itemCount: customerState.customers.length + 1,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index == customerState.customers.length) {
                        // Check if currentEmployeesPage is null and state is loaded
                        if (customerState.currentCustomersPage == null) {
                          return Center(
                            child: Text(
                              'No More Customers',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        } else {
                          return Center(child: FadeCircleLoadingIndicator());
                        }
                      } else {
                        return CustomerBarChip(
                          customer: customerState.customers[index],
                          isEnabled:
                              customerState.selectedCustomer?.customerId ==
                              customerState.customers[index].customerId,
                        );
                      }
                    },
                    separatorBuilder: (_, __) => 16.verticalSpace,
                  );
                } else if (customerState.customersStates ==
                    RequestStates.error) {
                  return AppErrorWidget(
                    onTap: () => ref
                        .read(customerControllerProvider.notifier)
                        .onLoadMoreCostumers(),
                  );
                } else if (customerState.customersStates ==
                    RequestStates.loading) {
                  return Center(child: FadeCircleLoadingIndicator());
                }

                return SizedBox.shrink();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
            child: Consumer(
              builder: (context, ref, child) {
                final selectedCustomerState = ref.watch(
                  customerControllerProvider.select(
                    (value) => value.selectedCustomer,
                  ),
                );

                return CustomButton(
                  title: tr(context: context, AppStrings.next),
                  onPressed: selectedCustomerState == null
                      ? null
                      : () {
                          context.pushRoute(ServiceConfigurationRoute());
                        },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
