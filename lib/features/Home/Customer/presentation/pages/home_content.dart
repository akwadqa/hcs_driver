import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Availability/presentation/controllers/availability_controller.dart';
import 'package:hcs_driver/features/Home/Customer/presentation/widgets/service_card.dart';
import 'package:hcs_driver/src/enums/service_type.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';
import 'package:hcs_driver/src/shared_widgets/custom_appbar.dart';

@RoutePage()
class HomeContentScreen extends ConsumerStatefulWidget {
  const HomeContentScreen({super.key});

  @override
  ConsumerState<HomeContentScreen> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<HomeContentScreen> {
  List<ServiceType> list = [
    ServiceType.onCall,
    ServiceType.packages,
    ServiceType.deepClean,
    ServiceType.maintenance,
  ];

  @override
  void initState() {
    super.initState();
    // Future(() => ref.read(customerControllerProvider.notifier).fetchCostumers());
  }

  @override
  Widget build(BuildContext context) {
    // final homeState = ref.watch(customerControllerProvider);
    debugPrint('qteg ${context.router}');

    return Scaffold(
      // body: homeState.homeStates == RequestStates.loaded
      //     ? _buildContent(homeState.homeBlock!)
      //     : homeState.homeStates == RequestStates.loading
      //     ? const Center(child: FadeCircleLoadingIndicator())
      //     : homeState.homeStates == RequestStates.error
      //     ? AppErrorWidget(
      //         onTap: () => Future(
      //           () =>
      //               ref.read(customerControllerProvider.notifier).fetchHomeBlocks(),
      //         ),
      //       )
      //     : SizedBox.shrink(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 32.h),
                child: Text(
                  context.tr(AppStrings.chooseServices),
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium!.copyWith(fontSize: 20.sp),
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  var availabilityNotifier = ref.read(
                    availabilityControllerProvider.notifier,
                  );

                  return ListView.separated(
                    itemCount: 4,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: index < 2
                            ? () {
                                availabilityNotifier.selectService(
                                  serviceTypeToString(list[index]),
                                );

                                context.pushRoute(
                                  CustomerRoute(serviceType: list[index]),
                                );
                              }
                            : null,

                        child: ServiceCard(
                          serviceType: list[index],
                          enabled: index < 2,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return 24.verticalSpace;
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: CustomAppbar(isHome: true),
    );
  }
}
