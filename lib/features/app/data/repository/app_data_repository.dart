import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/app/data/remote/app_data_source.dart';
import 'package:hcs_driver/features/app/domain/version_update.dart';
import 'package:hcs_driver/src/constants/api_response.dart';
import 'package:hcs_driver/src/network/network_service.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_data_repository.g.dart';

@Riverpod(keepAlive: true)
AppDataRepository appDataRepository(Ref ref) {
  final networkService = ref.watch(networkServiceProvider());
  return AppDataRepository(AppDataSource(networkService));
}

class AppDataRepository {
  final AppDataSource _remoteDataSource;

  AppDataRepository(this._remoteDataSource);

  Future<ApiResponse<VersionUpdate>> getAppVersion() async {
    final response = await _remoteDataSource.getAppVersion();

    if (response.status == 200) {
      return response;
    }

    throw AppException(response.message);
  }
}
