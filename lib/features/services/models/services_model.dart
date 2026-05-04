import 'package:equatable/equatable.dart';

class ServicesModel extends Equatable {
  const ServicesModel({
    required this.code,
    required this.message,
    required this.data,
  });

  final int? code;
  final String? message;
  final List<ServiceModel>? data;

  ServicesModel copyWith({
    int? code,
    String? message,
    List<ServiceModel>? data,
  }) {
    return ServicesModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    return ServicesModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null
          ? null
          : List<ServiceModel>.from(
              json["data"].map((x) => ServiceModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [code, message, data];
}

class ServiceDetailsModel extends Equatable {
  const ServiceDetailsModel({
    required this.code,
    required this.message,
    required this.data,
  });

  final int? code;
  final String? message;
  final ServiceModel? data;

  ServiceDetailsModel copyWith({
    int? code,
    String? message,
    ServiceModel? data,
  }) {
    return ServiceDetailsModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailsModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? null : ServiceModel.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };

  @override
  List<Object?> get props => [code, message, data];
}

class ServiceModel extends Equatable {
  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.serviceType,
    required this.goals,
  });

  final int? id;
  final String? name;
  final String? description;
  final bool? isActive;
  final ServiceTypeModel? serviceType;
  final List<GoalModel>? goals;

  ServiceModel copyWith({
    int? id,
    String? name,
    String? description,
    bool? isActive,
    ServiceTypeModel? serviceType,
    List<GoalModel>? goals,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      serviceType: serviceType ?? this.serviceType,
      goals: goals ?? this.goals,
    );
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      isActive: json["is_active"],
      serviceType: json["service_type"] == null
          ? null
          : ServiceTypeModel.fromJson(json["service_type"]),
      goals: json["goals"] == null
          ? null
          : List<GoalModel>.from(
              json["goals"].map((x) => GoalModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "is_active": isActive,
        "service_type": serviceType?.toJson(),
        "goals": goals == null
            ? null
            : List<dynamic>.from(goals!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [id, name, description, isActive, serviceType, goals];
}

class GoalModel extends Equatable {
  const GoalModel({
    required this.id,
    required this.name,
    required this.title,
    required this.isActive,
  });

  final int? id;
  final String? name;
  final String? title;
  final bool? isActive;

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json["id"],
      name: json["name"],
      title: json["title"],
      isActive: json["is_active"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "title": title,
        "is_active": isActive,
      };

  @override
  List<Object?> get props => [id, name, title, isActive];
}

class ServiceTypeModel extends Equatable {
  const ServiceTypeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
  });

  final int? id;
  final String? name;
  final String? description;
  final bool? isActive;

  ServiceTypeModel copyWith({
    int? id,
    String? name,
    String? description,
    bool? isActive,
  }) {
    return ServiceTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }

  factory ServiceTypeModel.fromJson(Map<String, dynamic> json) {
    return ServiceTypeModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      isActive: json["is_active"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "is_active": isActive,
      };

  @override
  List<Object?> get props => [id, name, description, isActive];
}
