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

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.country,
    required this.city,
    required this.isSubscribed,
    required this.subscriptionPrice,
    required this.subscriptionEndsAt,
    required this.role,
  });

  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? image;
  final int? country;
  final int? city;
  final bool? isSubscribed;
  final num? subscriptionPrice;
  final String? subscriptionEndsAt;
  final UserRole? role;

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? image,
    int? country,
    int? city,
    bool? isSubscribed,
    num? subscriptionPrice,
    String? subscriptionEndsAt,
    UserRole? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      country: country ?? this.country,
      city: city ?? this.city,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      subscriptionPrice: subscriptionPrice ?? this.subscriptionPrice,
      subscriptionEndsAt: subscriptionEndsAt ?? this.subscriptionEndsAt,
      role: role ?? this.role,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json){
    final price = json["subscription_price"];
    return UserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      image: json["image"],
      country: json["country"],
      city: json["city"],
      isSubscribed: json["is_subscribed"] == true,
      subscriptionPrice: price is num ? price : (price != null ? num.tryParse(price.toString()) : null),
      subscriptionEndsAt: json["subscription_ends_at"]?.toString(),
      role: json["role"] == 'seller' ? UserRole.captain : UserRole.passenger,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "image": image,
    "country": country,
    "city": city,
    "is_subscribed": isSubscribed,
    "subscription_price": subscriptionPrice,
    "subscription_ends_at": subscriptionEndsAt,
    "role": role == UserRole.captain ? 'seller' : 'buyer',
  };

  @override
  List<Object?> get props => [id, name, email, phone, image, country, city, isSubscribed, subscriptionPrice, subscriptionEndsAt, role];
}

enum UserRole {passenger, captain}
