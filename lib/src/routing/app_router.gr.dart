// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:hcs_driver/features/app/intro_screen.dart' as _i1;
import 'package:hcs_driver/features/app/main_screen.dart' as _i3;
import 'package:hcs_driver/features/Auth/presentation/pages/login_screen.dart'
    as _i2;
import 'package:hcs_driver/features/MyOrders/presentation/pages/myorders_content.dart'
    as _i4;
import 'package:hcs_driver/features/MyOrders/presentation/pages/myorders_screen.dart'
    as _i5;
import 'package:hcs_driver/features/MyOrders/presentation/pages/order_details_screen.dart'
    as _i6;
import 'package:hcs_driver/features/MyOrders/presentation/pages/order_status_screen.dart'
    as _i7;
import 'package:hcs_driver/features/settings/presentation/pages/settings_screen.dart'
    as _i8;

/// generated route for
/// [_i1.IntroScreen]
class IntroRoute extends _i9.PageRouteInfo<void> {
  const IntroRoute({List<_i9.PageRouteInfo>? children})
    : super(IntroRoute.name, initialChildren: children);

  static const String name = 'IntroRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i1.IntroScreen();
    },
  );
}

/// generated route for
/// [_i2.LoginScreen]
class LoginRoute extends _i9.PageRouteInfo<void> {
  const LoginRoute({List<_i9.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i2.LoginScreen();
    },
  );
}

/// generated route for
/// [_i3.MainScreen]
class MainRoute extends _i9.PageRouteInfo<void> {
  const MainRoute({List<_i9.PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i3.MainScreen();
    },
  );
}

/// generated route for
/// [_i4.MyOrdersContentScreen]
class MyOrdersContentRoute extends _i9.PageRouteInfo<void> {
  const MyOrdersContentRoute({List<_i9.PageRouteInfo>? children})
    : super(MyOrdersContentRoute.name, initialChildren: children);

  static const String name = 'MyOrdersContentRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i4.MyOrdersContentScreen();
    },
  );
}

/// generated route for
/// [_i5.MyOrdersScreen]
class MyOrdersRoute extends _i9.PageRouteInfo<void> {
  const MyOrdersRoute({List<_i9.PageRouteInfo>? children})
    : super(MyOrdersRoute.name, initialChildren: children);

  static const String name = 'MyOrdersRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i5.MyOrdersScreen();
    },
  );
}

/// generated route for
/// [_i6.OrderDetailsScreen]
class OrderDetailsRoute extends _i9.PageRouteInfo<OrderDetailsRouteArgs> {
  OrderDetailsRoute({
    _i10.Key? key,
    required String serviceOrderID,
    List<_i9.PageRouteInfo>? children,
  }) : super(
         OrderDetailsRoute.name,
         args: OrderDetailsRouteArgs(key: key, serviceOrderID: serviceOrderID),
         initialChildren: children,
       );

  static const String name = 'OrderDetailsRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderDetailsRouteArgs>();
      return _i6.OrderDetailsScreen(
        key: args.key,
        serviceOrderID: args.serviceOrderID,
      );
    },
  );
}

class OrderDetailsRouteArgs {
  const OrderDetailsRouteArgs({this.key, required this.serviceOrderID});

  final _i10.Key? key;

  final String serviceOrderID;

  @override
  String toString() {
    return 'OrderDetailsRouteArgs{key: $key, serviceOrderID: $serviceOrderID}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderDetailsRouteArgs) return false;
    return key == other.key && serviceOrderID == other.serviceOrderID;
  }

  @override
  int get hashCode => key.hashCode ^ serviceOrderID.hashCode;
}

/// generated route for
/// [_i7.OrderStatusScreen]
class OrderStatusRoute extends _i9.PageRouteInfo<OrderStatusRouteArgs> {
  OrderStatusRoute({
    _i10.Key? key,
    required String? statusOrderType,
    required String serviceOrderID,
    List<_i9.PageRouteInfo>? children,
  }) : super(
         OrderStatusRoute.name,
         args: OrderStatusRouteArgs(
           key: key,
           statusOrderType: statusOrderType,
           serviceOrderID: serviceOrderID,
         ),
         initialChildren: children,
       );

  static const String name = 'OrderStatusRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderStatusRouteArgs>();
      return _i7.OrderStatusScreen(
        key: args.key,
        statusOrderType: args.statusOrderType,
        serviceOrderID: args.serviceOrderID,
      );
    },
  );
}

class OrderStatusRouteArgs {
  const OrderStatusRouteArgs({
    this.key,
    required this.statusOrderType,
    required this.serviceOrderID,
  });

  final _i10.Key? key;

  final String? statusOrderType;

  final String serviceOrderID;

  @override
  String toString() {
    return 'OrderStatusRouteArgs{key: $key, statusOrderType: $statusOrderType, serviceOrderID: $serviceOrderID}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderStatusRouteArgs) return false;
    return key == other.key &&
        statusOrderType == other.statusOrderType &&
        serviceOrderID == other.serviceOrderID;
  }

  @override
  int get hashCode =>
      key.hashCode ^ statusOrderType.hashCode ^ serviceOrderID.hashCode;
}

/// generated route for
/// [_i8.SettingsScreen]
class SettingsRoute extends _i9.PageRouteInfo<void> {
  const SettingsRoute({List<_i9.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i8.SettingsScreen();
    },
  );
}
