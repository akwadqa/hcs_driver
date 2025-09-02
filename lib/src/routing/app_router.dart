import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      initial: true,
      page: IntroRoute.page,
      children: [
        AutoRoute(page: LoginRoute.page),
        AutoRoute(
          page: MainRoute.page,
          children: [
            AutoRoute(
              initial: true,
              page: MyOrdersRoute.page,
              children: [
                AutoRoute(initial: true, page: MyOrdersContentRoute.page),
                AutoRoute(page: AppoinmentRoute.page),
                AutoRoute(page: OrderDetailsRoute.page),
                AutoRoute(page: OrderStatusRoute.page),
              ],
            ),
            AutoRoute(page: SettingsRoute.page),
            AutoRoute(page: PaymentSummaryRoute.page),
          ],
        ),
      ],
    ),
  ];
}
