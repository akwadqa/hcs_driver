import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hcs_driver/features/MyOrders/presentation/pages/today_orders_section.dart';
import 'package:hcs_driver/features/MyOrders/presentation/pages/tomorrow_orders_section.dart';
import 'package:hcs_driver/features/MyOrders/presentation/pages/yesterday_orders_section.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/shared_widgets/custom_appbar.dart';

@RoutePage()
class MyOrdersContentScreen extends StatefulWidget {
  const MyOrdersContentScreen({super.key});

  @override
  State<MyOrdersContentScreen> createState() => _MyOrdersContentState();
}

class _MyOrdersContentState extends State<MyOrdersContentScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        hasBackArrow: false,
        title: context.tr(AppStrings.myOrders),
        withTabs: true,

        tabController: _tabController,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          YesterdayOrdersScreen(),
          TodayOrdersScreen(),
          TomorrowOrdersScreen(),
        ],
      ),
    );
  }
}
