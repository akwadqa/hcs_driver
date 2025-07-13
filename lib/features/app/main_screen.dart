import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hcs_driver/src/shared_widgets/custom_nav_bar.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [HomeRoute(), MyOrdersRoute(), SettingsRoute()],
      bottomNavigationBuilder: (context, tabsRouter) => CustomNavBar(
        currentIndex: AutoTabsRouter.of(context).activeIndex,
        onTap: (index) => AutoTabsRouter.of(context).setActiveIndex(index),
      ),
    );
  }
}
