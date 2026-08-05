import 'package:flutter/material.dart';
import 'package:hcs_driver/features/app/domain/version_update.dart';
import 'package:hcs_driver/src/constants/api_constance.dart';
import 'package:hcs_driver/src/constants/api_response.dart';
import 'package:hcs_driver/src/network/network_service.dart';


class AppDataSource {
  final NetworkService _networkService;

  AppDataSource(this._networkService);

  Future<ApiResponse<VersionUpdate>> getAppVersion() async {
    try {
      final response = await _networkService.get(
        ApiConstance.getVersion,
        queryParameters: {},
      );

      if (response.data == null || response.statusCode != 200) {
        throw Exception('Failed to load data');
      }

      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => VersionUpdate.fromJson(json as Map<String, dynamic>),
        dataKey: 'app_version_driver',
      );
    } catch (e) {
      debugPrint('Error in getData: e');
      rethrow;
    }
  }
}
