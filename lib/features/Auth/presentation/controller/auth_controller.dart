import 'package:hcs_driver/features/Auth/application/auth_service.dart';
import 'package:hcs_driver/features/Auth/data/models/login_params.dart';
import 'package:hcs_driver/features/Auth/data/repo/auth_repository.dart';
import 'package:hcs_driver/src/core/notifications/repositories/notifications_repository.dart';
import 'package:hcs_driver/src/core/notifications/services/notifications_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() => null;

  Future<void> login(LoginParams params) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.watch(authRepositoryProvider);
      final data = await authRepo.login(params);
      ref.read(userDataProvider.notifier).setData(data.$1, data.$2, data.$3);
      ref.read(notificationsServiceProvider).sendDeviceToken(data.$3);
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      ref.read(userDataProvider.notifier).removeData();
    });
  }

  Future<void> forgotPassword(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.watch(authRepositoryProvider);
      await authRepo.forgotPassword(email);
    });
  }
}
