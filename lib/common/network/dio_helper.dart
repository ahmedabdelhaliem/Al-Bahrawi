import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:al_bahrawi/app/app_constants.dart';
import 'package:al_bahrawi/app/app_prefs.dart';
import 'package:al_bahrawi/app/di.dart';
import 'package:flutter/foundation.dart';
import 'package:al_bahrawi/common/network/either.dart';
import 'package:al_bahrawi/common/network/error_handler.dart';
import 'package:al_bahrawi/common/network/failure.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHelper {
  static final AppPreferences _appPreferences = instance<AppPreferences>();
  static Dio? dio;

  static Future<void> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );

    if (!kReleaseMode) {
      dio!.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        },
      );

      dio?.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }
  }

  static Map<String, dynamic> headers(
      {bool isPublic = false, bool isFormData = false}) {
    return {
      if (!isFormData) 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Language': _appPreferences.getAppLanguage(),
      if (!isPublic && _appPreferences.getToken().isNotEmpty)
        'Authorization': "Bearer ${_appPreferences.getToken()}",
    };
  }

  static Future<Either<Failure, T>> getData<T>({
    required String url,
    Map<String, dynamic>? query,
    required T Function(Map<String, dynamic> json) fromJson,
    bool isPublic = false,
  }) async {
    try {
      Response response = await dio!.get(
        url,
        queryParameters: query,
        options: Options(headers: headers(isPublic: isPublic)),
      );

      T result = fromJson(response.data);
      return Right(result);
      }catch(e){
        return Left(ErrorHandler.handle(e).failure);
      }
  }

  static Future<Either<Failure, T>> postData<T>({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    required T Function(Map<String, dynamic> json) fromJson,
    bool isPublic = false,
  }) async {
    try {
      bool isFormData = data is FormData;
      Response response = await dio!.post(
        url,
        data: data,
        queryParameters: query,
        options: Options(
          headers: headers(isPublic: isPublic, isFormData: isFormData),
          contentType: isFormData ? null : 'application/json',
        ),
      );
      T result = fromJson(response.data);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  static Future<Either<Failure, T>> putData<T>({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    required T Function(Map<String, dynamic> json) fromJson,
    bool isPublic = false,
  }) async {
    try {
      bool isFormData = data is FormData;
      Response response = await dio!.put(
        url,
        data: data,
        queryParameters: query,
        options: Options(
          headers: headers(isPublic: isPublic, isFormData: isFormData),
          contentType: isFormData ? null : 'application/json',
        ),
      );
      T result = fromJson(response.data);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  static Future<Either<Failure, T>> deleteData<T>({
    required String url,
    Map<String, dynamic>? query,
    required T Function(Map<String, dynamic> json) fromJson,
    bool isPublic = false,
  }) async {
    try {
      Response response = await dio!.delete(
        url,
        queryParameters: query,
        options: Options(headers: headers(isPublic: isPublic)),
      );
        T result = fromJson(response.data);
        return Right(result);
      }catch(e){
        return Left(ErrorHandler.handle(e).failure);
      }
  }
}
