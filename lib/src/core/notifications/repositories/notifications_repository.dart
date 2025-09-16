import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/src/constants/api_constance.dart';
import 'package:hcs_driver/src/constants/services_urls.dart';
import 'package:hcs_driver/src/network/app_response.dart';
import 'package:hcs_driver/src/network/network_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'notifications_repository.g.dart';

@riverpod
NotificationsRepository notificationsRepository(
    Ref ref) {
  final dio = ref.watch(dioProvider);
  final newDio = Dio(dio.options.copyWith(baseUrl:       ApiConstance.baseUrl
));
  newDio.interceptors.addAll(dio.interceptors);

  final NetworkService networkService =
      ref.watch(networkServiceProvider(newDio));

  return NotificationsRepository(networkService);
}

class NotificationsRepository {
  final NetworkService _networkService;

  NotificationsRepository(this._networkService);

  Future<void> sendFCMToken(String token, String userId) async {
    final response = await _networkService.post(

        ApiConstance.sendFcmToken,{'device_token': token, 'user_id': userId});

    final AppResponse appResponse =
        AppResponse.fromJson(response.data, (json) => null);

    if (appResponse.error == 1) {
      throw AppException(appResponse.message);
    }
  }
}
