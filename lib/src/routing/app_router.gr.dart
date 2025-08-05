// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i11;
import 'package:hcs_driver/features/app/intro_screen.dart' as _i2;
import 'package:hcs_driver/features/app/main_screen.dart' as _i4;
import 'package:hcs_driver/features/Auth/presentation/pages/login_screen.dart'
    as _i3;
import 'package:hcs_driver/features/MyOrders/presentation/pages/appointment_screen.dart'
    as _i1;
import 'package:hcs_driver/features/MyOrders/presentation/pages/myorders_content.dart'
    as _i5;
import 'package:hcs_driver/features/MyOrders/presentation/pages/myorders_screen.dart'
    as _i6;
import 'package:hcs_driver/features/MyOrders/presentation/pages/order_details_screen.dart'
    as _i7;
import 'package:hcs_driver/features/MyOrders/presentation/pages/order_status_screen.dart'
    as _i8;
import 'package:hcs_driver/features/settings/presentation/pages/settings_screen.dart'
    as _i9;

/// generated route for
/// [_i1.AppoinmentScreen]
class AppoinmentRoute extends _i10.PageRouteInfo<AppoinmentRouteArgs> {
  AppoinmentRoute({
    _i11.Key? key,
    required String serviceOrderID,
    List<_i10.PageRouteInfo>? children,
  }) : super(
         AppoinmentRoute.name,
         args: AppoinmentRouteArgs(key: key, serviceOrderID: serviceOrderID),
         initialChildren: children,
       );

  static const String name = 'AppoinmentRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppoinmentRouteArgs>();
      return _i1.AppoinmentScreen(
        key: args.key,
        serviceOrderID: args.serviceOrderID,
      );
    },
  );
}

class AppoinmentRouteArgs {
  const AppoinmentRouteArgs({this.key, required this.serviceOrderID});

  final _i11.Key? key;

  final String serviceOrderID;

  @override
  String toString() {
    return 'AppoinmentRouteArgs{key: $key, serviceOrderID: $serviceOrderID}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppoinmentRouteArgs) return false;
    return key == other.key && serviceOrderID == other.serviceOrderID;
  }

  @override
  int get hashCode => key.hashCode ^ serviceOrderID.hashCode;
}

/// generated route for
/// [_i2.IntroScreen]
class IntroRoute extends _i10.PageRouteInfo<void> {
  const IntroRoute({List<_i10.PageRouteInfo>? children})
    : super(IntroRoute.name, initialChildren: children);

  static const String name = 'IntroRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i2.IntroScreen();
    },
  );
}

/// generated route for
/// [_i3.LoginScreen]
class LoginRoute extends _i10.PageRouteInfo<void> {
  const LoginRoute({List<_i10.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i3.LoginScreen();
    },
  );
}

/// generated route for
/// [_i4.MainScreen]
class MainRoute extends _i10.PageRouteInfo<void> {
  const MainRoute({List<_i10.PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i4.MainScreen();
    },
  );
}

/// generated route for
/// [_i5.MyOrdersContentScreen]
class MyOrdersContentRoute extends _i10.PageRouteInfo<void> {
  const MyOrdersContentRoute({List<_i10.PageRouteInfo>? children})
    : super(MyOrdersContentRoute.name, initialChildren: children);

  static const String name = 'MyOrdersContentRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i5.MyOrdersContentScreen();
    },
  );
}

/// generated route for
/// [_i6.MyOrdersScreen]
class MyOrdersRoute extends _i10.PageRouteInfo<void> {
  const MyOrdersRoute({List<_i10.PageRouteInfo>? children})
    : super(MyOrdersRoute.name, initialChildren: children);

  static const String name = 'MyOrdersRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i6.MyOrdersScreen();
    },
  );
}

/// generated route for
/// [_i7.OrderDetailsScreen]
class OrderDetailsRoute extends _i10.PageRouteInfo<OrderDetailsRouteArgs> {
  OrderDetailsRoute({
    _i11.Key? key,
    required String serviceOrderID,
    required String appointmentID,
    List<_i10.PageRouteInfo>? children,
  }) : super(
         OrderDetailsRoute.name,
         args: OrderDetailsRouteArgs(
           key: key,
           serviceOrderID: serviceOrderID,
           appointmentID: appointmentID,
         ),
         initialChildren: children,
       );

  static const String name = 'OrderDetailsRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderDetailsRouteArgs>();
      return _i7.OrderDetailsScreen(
        key: args.key,
        serviceOrderID: args.serviceOrderID,
        appointmentID: args.appointmentID,
      );
    },
  );
}

class OrderDetailsRouteArgs {
  const OrderDetailsRouteArgs({
    this.key,
    required this.serviceOrderID,
    required this.appointmentID,
  });

  final _i11.Key? key;

  final String serviceOrderID;

  final String appointmentID;

  @override
  String toString() {
    return 'OrderDetailsRouteArgs{key: $key, serviceOrderID: $serviceOrderID, appointmentID: $appointmentID}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderDetailsRouteArgs) return false;
    return key == other.key &&
        serviceOrderID == other.serviceOrderID &&
        appointmentID == other.appointmentID;
  }

  @override
  int get hashCode =>
      key.hashCode ^ serviceOrderID.hashCode ^ appointmentID.hashCode;
}

/// generated route for
/// [_i8.OrderStatusScreen]
class OrderStatusRoute extends _i10.PageRouteInfo<OrderStatusRouteArgs> {
  OrderStatusRoute({
    _i11.Key? key,
    required String? statusOrderType,
    required String appointmentID,
    List<_i10.PageRouteInfo>? children,
  }) : super(
         OrderStatusRoute.name,
         args: OrderStatusRouteArgs(
           key: key,
           statusOrderType: statusOrderType,
           appointmentID: appointmentID,
         ),
         initialChildren: children,
       );

  static const String name = 'OrderStatusRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderStatusRouteArgs>();
      return _i8.OrderStatusScreen(
        key: args.key,
        statusOrderType: args.statusOrderType,
        appointmentID: args.appointmentID,
      );
    },
  );
}

class OrderStatusRouteArgs {
  const OrderStatusRouteArgs({
    this.key,
    required this.statusOrderType,
    required this.appointmentID,
  });

  final _i11.Key? key;

  final String? statusOrderType;

  final String appointmentID;

  @override
  String toString() {
    return 'OrderStatusRouteArgs{key: $key, statusOrderType: $statusOrderType, appointmentID: $appointmentID}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderStatusRouteArgs) return false;
    return key == other.key &&
        statusOrderType == other.statusOrderType &&
        appointmentID == other.appointmentID;
  }

  @override
  int get hashCode =>
      key.hashCode ^ statusOrderType.hashCode ^ appointmentID.hashCode;
}

/// generated route for
/// [_i9.SettingsScreen]
class SettingsRoute extends _i10.PageRouteInfo<void> {
  const SettingsRoute({List<_i10.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i9.SettingsScreen();
    },
  );
}
