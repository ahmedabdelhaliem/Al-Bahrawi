import 'package:equatable/equatable.dart';

class NameIdListModel extends Equatable {
  const NameIdListModel({
    required this.code,
    required this.message,
    required this.data,
  });

  final int? code;
  final String? message;
  final List<NameIdModel> data;

  NameIdListModel copyWith({
    int? code,
    String? message,
    List<NameIdModel>? data,
  }) {
    return NameIdListModel(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory NameIdListModel.fromJson(Map<String, dynamic> json) {
    return NameIdListModel(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<NameIdModel>.from(
              json["data"]!.map((x) => NameIdModel.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
  };

  @override
  List<Object?> get props => [code, message, data];
}

class NameIdModel extends Equatable {
  const NameIdModel({required this.id, required this.name});

  final int? id;
  final String? name;

  NameIdModel copyWith({int? id, String? name}) {
    return NameIdModel(id: id ?? this.id, name: name ?? this.name);
  }

  factory NameIdModel.fromJson(Map<String, dynamic> json) {
    return NameIdModel(id: json["id"], name: json["name"]);
  }

  Map<String, dynamic> toJson() => {"id": id, "name": name};

  @override
  List<Object?> get props => [id, name];
}
