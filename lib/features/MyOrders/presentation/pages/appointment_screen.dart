import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_controller.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_state.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/appointment_card.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/enums/request_state.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';
import 'package:hcs_driver/src/shared_widgets/app_error_widget.dart';
import 'package:hcs_driver/src/shared_widgets/custom_appbar.dart';
import 'package:hcs_driver/src/shared_widgets/fade_circle_loading_indicator.dart';

@RoutePage()
class AppoinmentScreen extends ConsumerStatefulWidget {
  final String serviceOrderID;

  const AppoinmentScreen({super.key, required this.serviceOrderID});

  @override
  ConsumerState<AppoinmentScreen> createState() => _MyOrdersContentState();
}

class _MyOrdersContentState extends ConsumerState<AppoinmentScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  Timer? _loadMoreTimer;

  @override
  void initState() {
    super.initState();
    Future(
      () => ref
          .read(myOrdersControllerProvider.notifier)
          .fetchAppontments(serviceOrderID: widget.serviceOrderID),
    );

    _scrollController = ScrollController()..addListener(_onScroll);
  }

  _onScroll() {
    final appointmentsStates = ref.read(myOrdersControllerProvider);
    final hasMore = appointmentsStates.currentAppointmentsPage != null;

    if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent - 100 &&
        hasMore) {
      _loadMoreTimer?.cancel();
      _loadMoreTimer = Timer(const Duration(milliseconds: 500), () {
        ref
            .read(myOrdersControllerProvider.notifier)
            .onLoadMoreAppontments(serviceOrderID: widget.serviceOrderID);
      });
    }
  }

  @override
  void dispose() {
    _loadMoreTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ordersState = ref.watch(myOrdersControllerProvider);

    return Scaffold(
      appBar: CustomAppbar(
        hasBackArrow: true,
        title: AppStrings.appointmentDetails,
      ),
      body: buildBody(context, ordersState),
    );
  }

  Widget buildBody(BuildContext context, MyOrdersState ordersState) {
    if (ordersState.appointmentsStates == RequestStates.init ||
        ordersState.appointmentsStates == RequestStates.loading) {
      return Center(child: FadeCircleLoadingIndicator());
    } else if (ordersState.appointmentsStates == RequestStates.loaded) {
      if (ordersState.ordersAppointments.isEmpty) {
        return SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(myOrdersControllerProvider.notifier)
                  .fetchAppontments(serviceOrderID: widget.serviceOrderID);
            },
            child: Center(child: Assets.images.noDataMin.image()),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(myOrdersControllerProvider.notifier)
              .fetchAppontments(serviceOrderID: widget.serviceOrderID);
        },
        child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: ordersState.ordersAppointments.length + 1,
          itemBuilder: (context, index) {
            if (index >= ordersState.ordersAppointments.length) {
              if (ordersState.currentAppointmentsPage == null) {
                return Center(
                  child: Text(
                    'No More Appointments',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(child: FadeCircleLoadingIndicator()),
                );
              }
            }
            return GestureDetector(
              onTap: () {
                // if(ordersState.ordersAppointments[index].logStatus!="Canceled") {
                  context.pushRoute(
                  OrderDetailsRoute(
                    serviceOrderID: widget.serviceOrderID,
                    appointmentID: ordersState.ordersAppointments[index].logId,
                  ),
                );
                // }
              },
              child: AppointmentCard(

                appointmentData: ordersState.ordersAppointments[index],
                // orderDetailstData: ordersState.ordersDetails,
                
                // logStatus: ordersState.ordersAppointments[index].logStatus,
                orderId: widget.serviceOrderID,
                // driverStatus:
                //     ordersState.ordersAppointments[index].driverStatus ?? "",
                // servicetype: ordersState.ordersAppointments[index].serviceType,
                // date: ordersState.ordersAppointments[index].date,
                // employeeName:
                //     ordersState.ordersAppointments[index].employeeName,
              ),
            );
          },
        ),
      );
    } else if (ordersState.appointmentsStates == RequestStates.error) {
      return AppErrorWidget(
        onTap: () => Future(
          () => ref
              .read(myOrdersControllerProvider.notifier)
              .fetchAppontments(serviceOrderID: widget.serviceOrderID),
        ),
      );
    }
    return SizedBox.shrink();
  }
}

//     return Scaffold(
//       appBar: CustomAppbar(
//         hasBackArrow: true,
//         title: context.tr(AppStrings.appointmentDetails),
//       ),
//       body: ListView.builder(
//         // controller: _scrollController,
//         shrinkWrap: true,
//         itemCount: 3,
//         itemBuilder: (context, index) {
//           return InkWell(
//             onTap: () {
//               context.pushRoute(
//                 OrderDetailsRoute(serviceOrderID: widget.serviceOrderID),
//               );
//             },
//             child: AppointmentCard(),
//           );
//         },
//       ),
//     );
//   }
// }
