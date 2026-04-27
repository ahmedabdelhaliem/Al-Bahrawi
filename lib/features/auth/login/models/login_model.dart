import 'package:equatable/equatable.dart';
import 'package:base_project/features/auth/signup/models/signup_model.dart';

class LoginModel extends Equatable {
  const LoginModel({
    required this.code,
    required this.message,
    required this.data,
  });

  final int? code;
  final String? message;
  final LoginDataModel? data;

  LoginModel copyWith({
    int? code,
    String? message,
    LoginDataModel? data,
  }) {
    return LoginModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory LoginModel.fromJson(Map<String, dynamic> json){
    return LoginModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? null : LoginDataModel.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data?.toJson(),
  };

  @override
  List<Object?> get props => [
    code, message, data, ];
}

class LoginDataModel extends Equatable {
  const LoginDataModel({
    required this.user,
    required this.token,
  });

  final UserModel? user;
  final String? token;

  LoginDataModel copyWith({
    UserModel? user,
    String? token,
  }) {
    return LoginDataModel(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

  factory LoginDataModel.fromJson(Map<String, dynamic> json){
    return LoginDataModel(
      user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "token": token,
  };

  @override
  List<Object?> get props => [
    user, token, ];
}
