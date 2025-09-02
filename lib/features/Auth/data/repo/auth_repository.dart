import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/Auth/data/models/login_response_model.dart';
import 'package:hcs_driver/features/Auth/data/models/login_params.dart';
import 'package:hcs_driver/src/constants/api_constance.dart';
import 'package:hcs_driver/src/network/network_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(networkServiceProvider()));

class AuthRepository {
  final NetworkService _networkService;

  AuthRepository(this._networkService);

  // /// Handle API response and only allow access to message and status_code
  // Future<String> _handleAuthResponse(Map<String, dynamic> responseData) async {
  //   final int? statusCode = responseData['status_code'];
  //   final String? message = responseData['message'];

  //   if (statusCode == 200) {
  //     return message ?? "";
  //   } else {
  //     throw Exception(message ?? "An unknown error occurred");
  //   }
  // }

  /// Login API request
  Future<(String,String)> login(LoginParams params) async {
    var formData = FormData.fromMap({
      'email': params.email,
      'password': params.pass,
      "action":"driver",
    });

    final response = await _networkService.post(
      ApiConstance.loginPath,
      formData,
    );

    final data = json.encode(response.data);
    if (response.statusCode == 200) {
      return( loginResponseFromJson(data).data.token,loginResponseFromJson(data).fullName);
    } else {
      throw Exception(response.message ?? "An unknown error occurred");
    }
    // return await _handleAuthResponse(response.data);
  }

  Future<bool> forgotPassword(String email) async {
    var formData = FormData.fromMap({'email': email});

    final response = await _networkService.post(
      ApiConstance.forgotPassword(email),
      formData,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.message ?? "An unknown error occurred");
    }
    // return await _handleAuthResponse(response.data);
  }
}
