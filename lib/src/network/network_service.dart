import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/Auth/application/auth_service.dart';
import 'package:hcs_driver/src/localization/current_language.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/services_urls.dart';
import '../routing/app_router_provider.dart';

part 'network_service.g.dart';

abstract class NetworkService<T> {
  Future<T> get(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });
  Future<T> post(
    String url, [
    dynamic data,
    Map<String, dynamic>? queryParameters,
  ]);
  Future<T> put(
    String url,
    dynamic data, [
    Map<String, dynamic>? queryParameters,
  ]);

  Future<T> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
}

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  const duration = Duration(milliseconds: 120000);
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ServicesUrls.baseUrl,
      receiveTimeout: duration,
      connectTimeout: duration,
      sendTimeout: duration,
    ),
  );

  final languageCode = ref.watch(currentLanguageProvider);
  final userData = ref.watch(userDataProvider);
  dio.interceptors.addAll({
    DioAppInterceptors(
      languageCode: languageCode,
      token: userData?.$1,
      ref:ref,
      onUnauthorized: () {},
    ),
  });
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      // logPrint: (object) => log(object.toString())
    ),
  );

  return dio;
}

@Riverpod(keepAlive: true)
NetworkService networkService(Ref ref, [Dio? dio]) =>
    DioNetworkService(dio ?? ref.watch(dioProvider));

class DioNetworkService implements NetworkService<Response> {
  final Dio _dio;

  DioNetworkService(this._dio);

  @override
  Future<Response> get(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) => _dio.get(
    endpoint,
    data: data,
    queryParameters: queryParameters,
    cancelToken: cancelToken,
  );

  @override
  Future<Response> post(
    String endpoint, [
    dynamic data,
    Map<String, dynamic>? queryParameters,
  ]) => _dio.post(endpoint, data: data, queryParameters: queryParameters);

  @override
  Future<Response> put(
    String endpoint,
    dynamic data, [
    Map<String, dynamic>? queryParameters,
  ]) => _dio.put(endpoint, data: data, queryParameters: queryParameters);

  @override
  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) => _dio.delete(endpoint, data: data, queryParameters: queryParameters);
}

class DioAppInterceptors extends Interceptor {
  final String languageCode;
  final String? token;
  final void Function() onUnauthorized;
final Ref ref;
  DioAppInterceptors({
    required this.languageCode,
    required this.token,
    required this.onUnauthorized,
    required this.ref,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (token != null) {
      options.headers['Authorization'] = 'token $token';
    }
      // options.headers['Authorization'] = 'token 049cd06055b57ac:fcab89611347807';

    options.queryParameters['sl'] = languageCode;
    super.onRequest(options, handler);
  }
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint("🟢 [DIO RESPONSE]");
    debugPrint("✅ ${response.statusCode} ${response.requestOptions.uri}");
    debugPrint("📦 Response data: ${_prettyJson(response.data)}");

    handler.next(response);
  }
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      debugPrint(err.response!.data.toString());
    }
        final request = err.requestOptions;


    debugPrint("🔴 [DIO ERROR]");
    debugPrint("⛔️ ${err.type} for ${request.method} ${request.uri}");
    debugPrint("📥 Response data: ${_prettyJson(err.response?.data)}");
    final String? message = err.response?.data['message'];
    
    final statusCode = err.response?.statusCode;
    final responseData = err.response?.data;
       // ✅ تحقق من إذا كان Unauthorized
    final isUnauthorized = statusCode == 401 ||
        (responseData is Map &&
            responseData['message']?.toString().toLowerCase().contains("unauthorized") == true);

    if (isUnauthorized) {
      debugPrint("🚪 Session expired → redirect to Login");

      // 1. مسح بيانات المستخدم (التوكن)
      ref.read(userDataProvider.notifier).removeData();

      // 2. توجيه المستخدم لصفحة تسجيل الدخول
      ref.read(appRouterProvider).replaceAll([const LoginRoute()]);
      // لو تستخدم GoRouter:
      // ref.read(goRouterProvider).go('/login');
    }

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions, message);
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(err.requestOptions, message);
          case 401:
            throw UnauthorizedException(err.requestOptions, message);
          case 403:
            onUnauthorized();
            throw AccessForbiddenException(err.requestOptions, message);
          case 404:
            throw NotFoundException(err.requestOptions, message);
          case 409:
            throw ConflictException(err.requestOptions, message);
          case 422:
            throw UnprocessableEntityException(err.requestOptions, message);
          case 500:
            throw InternalServerErrorException(err.requestOptions, message);
          default:
            throw BadResponseException(err.requestOptions, message);
        }
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        throw NoInternetConnectionException(err.requestOptions, message);
      case DioExceptionType.badCertificate:
        throw BadCertificateException(err.requestOptions, message);
      case DioExceptionType.connectionError:
        throw ConnectionErrorException(err.requestOptions, message);
    }
    return handler.next(err);
  }
    String _prettyJson(dynamic data) {
    try {
      if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
      return data.toString();
    } catch (_) {
      return 'Invalid JSON';
    }
  }
}

class ApiException extends DioException {
  ApiException(RequestOptions requestOptions, [this.customMessage])
    : super(requestOptions: requestOptions, error: customMessage);

  final String? customMessage;

  String get defaultErrorString => 'requestError'.tr();

  @override
  String toString() {
    return customMessage ?? defaultErrorString;
  }
}

class BadRequestException extends ApiException {
  BadRequestException(super.requestOptions, [super.message]);

  @override
  String get defaultErrorString => 'badRequest'.tr();
}

class UnprocessableEntityException extends ApiException {
  UnprocessableEntityException(super.requestOptions, [super.message]);

  @override
  String get defaultErrorString => 'unprocessableEntity'.tr();
}

class InternalServerErrorException extends ApiException {
  InternalServerErrorException(super.requestOptions, [super.message]);

  @override
  String get defaultErrorString => 'internalServerError'.tr();
}

class ConflictException extends ApiException {
  ConflictException(super.requestOptions, [super.message]);

  @override
  String get defaultErrorString => 'conflictConnection'.tr();
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.requestOptions, [super.message]);

  @override
  String get defaultErrorString => 'unauthorized'.tr();
}

class NotFoundException extends ApiException {
  NotFoundException(super.requestOptions, [super.message]);

  @override
  String get defaultErrorString => 'notFound'.tr();
}

class NoInternetConnectionException extends ApiException {
  NoInternetConnectionException(super.requestOptions, [super.message]);

  @override
  String get defaultErrorString => 'noInternetConnection'.tr();
}

class DeadlineExceededException extends ApiException {
  DeadlineExceededException(super.requestOptions, [super.message]);

  @override
  String get defaultErrorString => 'deadlineExceeded'.tr();
}

class AccessForbiddenException extends ApiException {
  AccessForbiddenException(super.requestOptions, [super.message]);

  @override
  String get defaultErrorString => 'accessForbidden'.tr();
}

class BadCertificateException extends ApiException {
  BadCertificateException(super.requestOptions, [super.message]);
  @override
  String get defaultErrorString => 'badCertificate'.tr();
}

class ConnectionErrorException extends ApiException {
  ConnectionErrorException(super.requestOptions, [super.message]);
  @override
  String get defaultErrorString => 'connectionError'.tr();
}

class BadResponseException extends ApiException {
  BadResponseException(super.requestOptions, [super.message]);
  @override
  String get defaultErrorString => 'freiendlyErrorMessage'.tr();
}

class AppException implements Exception {
  final dynamic message;

  AppException([this.message]);

  @override
  String toString() {
    return message == null ? '' : message.toString();
  }
}
