import 'package:equatable/equatable.dart';

class TaskResponse extends Equatable {
  final int code;
  final String message;
  final List<TaskModel> data;
  final PaginationModel? pagination;

  const TaskResponse({
    required this.code,
    required this.message,
    required this.data,
    this.pagination,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] != null
          ? PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [code, message, data, pagination];
}

class TaskModel extends Equatable {
  final int id;
  final String status;
  final String? startedAt;
  final String? completedAt;
  final bool canComplete;
  final bool canCancel;
  final ServiceInfoModel? service;
  final ConsultationInfoModel? consultation;
  final List<TaskFileModel> files;
  final List<AssignmentModel> assignments;

  const TaskModel({
    required this.id,
    required this.status,
    this.startedAt,
    this.completedAt,
    required this.canComplete,
    required this.canCancel,
    this.service,
    this.consultation,
    required this.files,
    required this.assignments,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      startedAt: json['started_at'],
      completedAt: json['completed_at'],
      canComplete: json['can_complete'] ?? false,
      canCancel: json['can_cancel'] ?? false,
      service: json['service'] != null
          ? ServiceInfoModel.fromJson(json['service'] as Map<String, dynamic>)
          : null,
      consultation: json['consultation'] != null
          ? ConsultationInfoModel.fromJson(json['consultation'] as Map<String, dynamic>)
          : null,
      files: (json['files'] as List? ?? [])
          .map((e) => TaskFileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      assignments: (json['assignments'] as List? ?? [])
          .map((e) => AssignmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        status,
        startedAt,
        completedAt,
        canComplete,
        canCancel,
        service,
        consultation,
        files,
        assignments,
      ];
}

class ServiceInfoModel extends Equatable {
  final int id;
  final String name;

  const ServiceInfoModel({required this.id, required this.name});

  factory ServiceInfoModel.fromJson(Map<String, dynamic> json) {
    return ServiceInfoModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name];
}

class ConsultationInfoModel extends Equatable {
  final int id;
  final String description;
  final String consultationType;

  const ConsultationInfoModel({
    required this.id,
    required this.description,
    required this.consultationType,
  });

  factory ConsultationInfoModel.fromJson(Map<String, dynamic> json) {
    return ConsultationInfoModel(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      consultationType: json['consultation_type'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, description, consultationType];
}

class TaskFileModel extends Equatable {
  final int id;
  final String fileName;
  final String downloadUrl;

  const TaskFileModel({
    required this.id,
    required this.fileName,
    required this.downloadUrl,
  });

  factory TaskFileModel.fromJson(Map<String, dynamic> json) {
    return TaskFileModel(
      id: json['id'] ?? 0,
      fileName: json['file_name'] ?? '',
      downloadUrl: json['download_url'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, fileName, downloadUrl];
}

class AssignmentModel extends Equatable {
  final String assignedAt;
  final EmployeeShortModel? employee;

  const AssignmentModel({required this.assignedAt, this.employee});

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      assignedAt: json['assigned_at'] ?? '',
      employee: json['employee'] != null
          ? EmployeeShortModel.fromJson(json['employee'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [assignedAt, employee];
}

class EmployeeShortModel extends Equatable {
  final int id;
  final String name;
  final String phone;

  const EmployeeShortModel({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory EmployeeShortModel.fromJson(Map<String, dynamic> json) {
    return EmployeeShortModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, phone];
}

class PaginationModel extends Equatable {
  final int total;
  final int currentPage;
  final int lastPage;

  const PaginationModel({
    required this.total,
    required this.currentPage,
    required this.lastPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json['total'] ?? 0,
      currentPage: json['current_page'] ?? 0,
      lastPage: json['last_page'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [total, currentPage, lastPage];
}
