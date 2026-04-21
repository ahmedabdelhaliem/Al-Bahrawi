import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:base_project/app/app_prefs.dart';
import 'package:base_project/app/di.dart';
import 'package:base_project/common/network/failure.dart';
import 'package:base_project/common/resources/app_router.dart';
import 'package:base_project/common/resources/strings_manager.dart';

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error){
    if(error is DioException){
      failure = _handleError(error);
    }
    else{
      failure = DataSource.unKnown.getFailure();
    }
  }

  Failure _handleError(DioException error){
    switch(error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.connectionTimeout.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.sendTimeout.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.receiveTimeout.getFailure();
      case DioExceptionType.badCertificate:
        return DataSource.badCertificate.getFailure();
      case DioExceptionType.badResponse:
        if(error.response != null){
          if(error.response?.statusCode == 415){
            return ActiveAccountFailure(status: 415, message: error.response?.data['message'] ?? AppStrings.verifyYourAccount.tr());
          }
          if (error.response?.statusCode == 401) {
            instance<AppPreferences>().logout();
            navigatorKey.currentContext?.push(AppRouters.login,extra: {
              "showLoginFirstToast": true
            });
          }
          String errorMessage = error.response?.data['message'] ?? AppStrings.unKnownError.tr();
          return Failure(error.response?.statusCode??0, errorMessage);
        }else{
          return DataSource.unKnown.getFailure();
        }
      case DioExceptionType.cancel:
        return DataSource.cancel.getFailure();
      case DioExceptionType.connectionError:
        return DataSource.connectionError.getFailure();
      case DioExceptionType.unknown:
        return DataSource.unKnown.getFailure();
    }
  }
}

enum DataSource {
  connectionTimeout,
  receiveTimeout,
  sendTimeout,
  badCertificate,
  connectionError,
  cancel,
  cacheError,
  noInternetConnection,
  unKnown,
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.connectionTimeout:
        return Failure(
            0, ResponseMessage.connectionTimeout);
      case DataSource.cancel:
        return Failure(0, ResponseMessage.cancel);
      case DataSource.receiveTimeout:
        return Failure(
            0, ResponseMessage.receiveTimeout);
      case DataSource.sendTimeout:
        return Failure(0, ResponseMessage.sendTimeout);
      case DataSource.cacheError:
        return Failure(0, ResponseMessage.cacheError);
      case DataSource.noInternetConnection:
        return Failure(0,
            ResponseMessage.noInternetConnection);
      case DataSource.unKnown:
        return Failure(0, ResponseMessage.unKnown);
      case DataSource.badCertificate:
        return Failure(0, ResponseMessage.badCertificate);
      case DataSource.connectionError:
        return Failure(0, ResponseMessage.badCertificate);
    }
  }
}

class ResponseMessage{
  static const String connectionTimeout = AppStrings.timeoutError;
  static const String cancel = AppStrings.requestCanceled;
  static const String receiveTimeout = AppStrings.timeoutError;
  static const String sendTimeout = AppStrings.timeoutError;
  static const String cacheError = AppStrings.cacheError;
  static String noInternetConnection = AppStrings.noInternetError.tr();
  static String unKnown = AppStrings.unKnownError.tr();
  static const String badCertificate = AppStrings.badCertificate;
  static const String connectionError = AppStrings.connectionError;
}