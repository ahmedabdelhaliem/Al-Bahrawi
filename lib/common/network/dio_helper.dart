import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:base_project/app/app_constants.dart';
import 'package:base_project/app/app_prefs.dart';
import 'package:base_project/app/di.dart';
import 'package:flutter/foundation.dart';
import 'package:base_project/common/network/either.dart';
import 'package:base_project/common/network/error_handler.dart';
import 'package:base_project/common/network/failure.dart';
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

  static void headers() {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Language': _appPreferences.getAppLanguage(),
      if(_appPreferences.getToken().isNotEmpty) 'Authorization': "Bearer ${_appPreferences.getToken()}",
    };
  }

  static Future<Either<Failure, T>>  getData<T>({
    required String url,
    Map<String, dynamic>? query,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    headers();
      try{
      Response response = await dio!.get(
        url,
        queryParameters: query,
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
  }) async {
    headers();
      try{
        Response response = await dio!.post(
      url,
      data: data,
      queryParameters: query,
    );
        T result = fromJson(response.data);
        return Right(result);
      }catch(e){
        return Left(ErrorHandler.handle(e).failure);
      }
  }

  static Future<Either<Failure, T>> putData<T>({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    headers();
      try{
        Response response = await dio!.put(
      url,
      data: data,
      queryParameters: query,
    );
        T result = fromJson(response.data);
        return Right(result);
      }catch(e){
        return Left(ErrorHandler.handle(e).failure);
      }
  }

  static Future<Either<Failure, T>> deleteData<T>({
    required String url,
    Map<String, dynamic>? query,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    headers();
      try{
        Response response = await dio!.delete(
      url,
      queryParameters: query,
    );
        T result = fromJson(response.data);
        return Right(result);
      }catch(e){
        return Left(ErrorHandler.handle(e).failure);
      }
  }
}
