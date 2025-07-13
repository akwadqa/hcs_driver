import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/Auth/application/auth_service.dart';
import 'package:hcs_driver/src/localization/current_language.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/services_urls.dart';

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

  DioAppInterceptors({
    required this.languageCode,
    required this.token,
    required this.onUnauthorized,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (token != null) {
      options.headers['Authorization'] = 'token $token';
    }
    options.queryParameters['sl'] = languageCode;
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      debugPrint(err.response!.data.toString());
    }
    final String? message = err.response?.data['message'];
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
