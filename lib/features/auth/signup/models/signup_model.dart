import 'package:equatable/equatable.dart';

class SignupModel extends Equatable {
  const SignupModel({
    this.phone,
    this.message,
    this.code,
  });

  // API returns only phone inside data: { "phone": "..." }
  final String? phone;
  final String? message;
  final int? code;

  SignupModel copyWith({
    String? phone,
    String? message,
    int? code,
  }) {
    return SignupModel(
      phone: phone ?? this.phone,
      message: message ?? this.message,
      code: code ?? this.code,
    );
  }

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"] as Map<String, dynamic>?;
    return SignupModel(
      phone: data?["phone"]?.toString(),
      message: json["message"]?.toString(),
      code: json["code"] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    "data": {"phone": phone},
    "message": message,
    "code": code,
  };

  @override
  List<Object?> get props => [phone, message, code];
}

enum UserRole { user, employee, admin }

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    this.userType,
    this.isOfficeClient,
    required this.role,
  });

  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? image;
  final String? userType;
  final bool? isOfficeClient;
  final UserRole? role;

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? image,
    String? userType,
    bool? isOfficeClient,
    UserRole? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      userType: userType ?? this.userType,
      isOfficeClient: isOfficeClient ?? this.isOfficeClient,
      role: role ?? this.role,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String type = json["user_type"] ?? '';
    UserRole userRole;
    if (type == 'employee') {
      userRole = UserRole.employee;
    } else if (type == 'admin') {
      userRole = UserRole.admin;
    } else {
      userRole = UserRole.user;
    }

    return UserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      image: json["image"],
      userType: type,
      isOfficeClient: json["is_office_client"] == true,
      role: userRole,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
        "user_type": userType,
        "is_office_client": isOfficeClient,
        "role": role?.name,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        image,
        userType,
        isOfficeClient,
        role,
      ];
}
