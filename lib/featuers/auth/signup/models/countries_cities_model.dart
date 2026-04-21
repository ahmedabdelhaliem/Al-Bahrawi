import 'package:equatable/equatable.dart';

class CountriesCitiesModel extends Equatable {
  const CountriesCitiesModel({
    required this.data,
    required this.message,
    required this.code,
    required this.status,
  });

  final List<CountryModel> data;
  final String? message;
  final int? code;
  final String? status;

  CountriesCitiesModel copyWith({
    List<CountryModel>? data,
    String? message,
    int? code,
    String? status,
  }) {
    return CountriesCitiesModel(
      data: data ?? this.data,
      message: message ?? this.message,
      code: code ?? this.code,
      status: status ?? this.status,
    );
  }

  factory CountriesCitiesModel.fromJson(Map<String, dynamic> json){
    return CountriesCitiesModel(
      data: json["data"] == null ? [] : List<CountryModel>.from(json["data"]!.map((x) => CountryModel.fromJson(x))),
      message: json["message"],
      code: json["code"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "data": data.map((x) => x.toJson()).toList(),
    "message": message,
    "code": code,
    "status": status,
  };

  @override
  List<Object?> get props => [
    data, message, code, status, ];
}

class CountryModel extends Equatable {
  const CountryModel({
    required this.id,
    required this.name,
    required this.cities,
    required this.status,
  });

  final int? id;
  final String? name;
  final List<CityModel>? cities;
  final String? status;

  CountryModel copyWith({
    int? id,
    String? name,
    List<CityModel>? cities,
    String? status,
  }) {
    return CountryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cities: cities ?? this.cities,
      status: status ?? this.status,
    );
  }

  factory CountryModel.fromJson(Map<String, dynamic> json){
    return CountryModel(
      id: json["id"],
      name: json["name"],
      cities: json["ctites"] == null ? [] : List<CityModel>.from(json["ctites"]!.map((x) => CityModel.fromJson(x))),
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "ctites": cities?.map((x) => x.toJson()).toList(),
    "status": status,
  };

  @override
  List<Object?> get props => [id, name, cities, status];
}

class CityModel extends Equatable {
  const CityModel({
    required this.id,
    required this.name,
  });

  final int? id;
  final String? name;

  CityModel copyWith({
    int? id,
    String? name,
  }) {
    return CityModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory CityModel.fromJson(Map<String, dynamic> json){
    return CityModel(
      id: json["id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

  @override
  List<Object?> get props => [
    id, name, ];
}

