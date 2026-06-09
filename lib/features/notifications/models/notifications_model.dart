import 'package:equatable/equatable.dart';

class NotificationsModel extends Equatable {
  const NotificationsModel({
    required this.code,
    required this.message,
    required this.notifications,
    required this.pagination,
  });

  final int? code;
  final String? message;
  final List<NotificationModel> notifications;
  final NotificationsPaginationModel? pagination;

  NotificationsModel copyWith({
    int? code,
    String? message,
    List<NotificationModel>? data,
    NotificationsPaginationModel? pagination,
  }) {
    return NotificationsModel(
      code: code ?? this.code,
      message: message ?? this.message,
      notifications: data ?? notifications,
      pagination: pagination ?? this.pagination,
    );
  }

  factory NotificationsModel.fromJson(Map<String, dynamic> json){
    return NotificationsModel(
      code: json["code"],
      message: json["message"],
      notifications: json["data"] == null ? [] : List<NotificationModel>.from(json["data"]!.map((x) => NotificationModel.fromJson(x))),
      pagination: json["pagination"] == null ? null : NotificationsPaginationModel.fromJson(json["pagination"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": notifications.map((x) => x.toJson()).toList(),
    "pagination": pagination?.toJson(),
  };

  @override
  List<Object?> get props => [
    code, message, notifications, pagination, ];
}

class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.readAt,
    this.metadata,
  });

  final String? id;
  final String? title;
  final String? body;
  final String? createdAt;
  final String? readAt;
  final Map<String, dynamic>? metadata;

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? createdAt,
    String? readAt,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      metadata: metadata ?? this.metadata,
    );
  }

  NotificationModel copyWithRead(String? readAt) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      readAt: readAt,
      metadata: metadata,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json){
    return NotificationModel(
      id: json["id"]?.toString(),
      title: json["title"],
      body: json["body"],
      createdAt: json["created_at"],
      readAt: json["read_at"],
      metadata: json["metadata"] is Map<String, dynamic> ? json["metadata"] : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body": body,
    "created_at": createdAt,
    "read_at": readAt,
    "metadata": metadata,
  };

  @override
  List<Object?> get props => [
    id, title, body, createdAt, readAt, metadata, ];
}

class NotificationsModelPagination extends Equatable {
  const NotificationsModelPagination({
    required this.pagination,
  });

  final NotificationsPaginationModel? pagination;

  NotificationsModelPagination copyWith({
    NotificationsPaginationModel? pagination,
  }) {
    return NotificationsModelPagination(
      pagination: pagination ?? this.pagination,
    );
  }

  factory NotificationsModelPagination.fromJson(Map<String, dynamic> json){
    return NotificationsModelPagination(
      pagination: json["pagination"] == null ? null : NotificationsPaginationModel.fromJson(json["pagination"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "pagination": pagination?.toJson(),
  };

  @override
  List<Object?> get props => [
    pagination, ];
}

class NotificationsPaginationModel extends Equatable {
  const NotificationsPaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  NotificationsPaginationModel copyWith({
    int? currentPage,
    int? lastPage,
    int? perPage,
    int? total,
  }) {
    return NotificationsPaginationModel(
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
    );
  }

  factory NotificationsPaginationModel.fromJson(Map<String, dynamic> json){
    return NotificationsPaginationModel(
      currentPage: json["current_page"],
      lastPage: json["last_page"],
      perPage: json["per_page"],
      total: json["total"],
    );
  }

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "last_page": lastPage,
    "per_page": perPage,
    "total": total,
  };

  @override
  List<Object?> get props => [
    currentPage, lastPage, perPage, total, ];
}
