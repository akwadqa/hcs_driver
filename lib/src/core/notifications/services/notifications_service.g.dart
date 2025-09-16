// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationsServiceHash() =>
    r'1210ccb08dd4d5c8d2554af87f4ed41ee14ed8e5';

/// Riverpod provider for NotificationsService
///
/// Copied from [notificationsService].
@ProviderFor(notificationsService)
final notificationsServiceProvider = Provider<NotificationsService>.internal(
  notificationsService,
  name: r'notificationsServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationsServiceRef = ProviderRef<NotificationsService>;
String _$deviceTokenControllerHash() =>
    r'248339f0b48dae2382cd1e27e3ebbbbe1c95e6db';

/// Controller to send device token to backend
///
/// Copied from [DeviceTokenController].
@ProviderFor(DeviceTokenController)
final deviceTokenControllerProvider =
    AutoDisposeAsyncNotifierProvider<DeviceTokenController, void>.internal(
      DeviceTokenController.new,
      name: r'deviceTokenControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$deviceTokenControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DeviceTokenController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
