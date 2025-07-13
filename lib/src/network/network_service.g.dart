// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dioHash() => r'2a7ca585989877f37d3870ac0c9969c57a9b73d5';

/// See also [dio].
@ProviderFor(dio)
final dioProvider = Provider<Dio>.internal(
  dio,
  name: r'dioProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DioRef = ProviderRef<Dio>;
String _$networkServiceHash() => r'7aecc727f9e648c49709ba09cd80c82e38d00614';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [networkService].
@ProviderFor(networkService)
const networkServiceProvider = NetworkServiceFamily();

/// See also [networkService].
class NetworkServiceFamily extends Family<NetworkService> {
  /// See also [networkService].
  const NetworkServiceFamily();

  /// See also [networkService].
  NetworkServiceProvider call([Dio? dio]) {
    return NetworkServiceProvider(dio);
  }

  @override
  NetworkServiceProvider getProviderOverride(
    covariant NetworkServiceProvider provider,
  ) {
    return call(provider.dio);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'networkServiceProvider';
}

/// See also [networkService].
class NetworkServiceProvider extends Provider<NetworkService> {
  /// See also [networkService].
  NetworkServiceProvider([Dio? dio])
    : this._internal(
        (ref) => networkService(ref as NetworkServiceRef, dio),
        from: networkServiceProvider,
        name: r'networkServiceProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$networkServiceHash,
        dependencies: NetworkServiceFamily._dependencies,
        allTransitiveDependencies:
            NetworkServiceFamily._allTransitiveDependencies,
        dio: dio,
      );

  NetworkServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dio,
  }) : super.internal();

  final Dio? dio;

  @override
  Override overrideWith(
    NetworkService Function(NetworkServiceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NetworkServiceProvider._internal(
        (ref) => create(ref as NetworkServiceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dio: dio,
      ),
    );
  }

  @override
  ProviderElement<NetworkService> createElement() {
    return _NetworkServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NetworkServiceProvider && other.dio == dio;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dio.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NetworkServiceRef on ProviderRef<NetworkService> {
  /// The parameter `dio` of this provider.
  Dio? get dio;
}

class _NetworkServiceProviderElement extends ProviderElement<NetworkService>
    with NetworkServiceRef {
  _NetworkServiceProviderElement(super.provider);

  @override
  Dio? get dio => (origin as NetworkServiceProvider).dio;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
