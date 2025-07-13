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
              page: HomeRoute.page,
              children: [
                AutoRoute(initial: true, page: HomeContentRoute.page),
                AutoRoute(page: CustomerRoute.page),
                AutoRoute(page: ServiceConfigurationRoute.page),
                AutoRoute(page: EmployeesRoute.page),
                AutoRoute(page: DriverPaymentRoute.page),
                AutoRoute(page: DaysSelectionRoute.page),
              ],
            ),
            AutoRoute(
              page: MyOrdersRoute.page,
              children: [
                AutoRoute(initial: true, page: MyOrdersContentRoute.page),
                AutoRoute(page: OrderDetailsRoute.page),
              ],
            ),
            AutoRoute(
              page: SettingsRoute.page,
              children: [
                AutoRoute(initial: true, page: SettingsContentRoute.page),
              ],
            ),
          ],
        ),
      ],
    ),
  ];
}
