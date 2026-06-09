class ConsultationModel {
  int? id;
  String? serviceId;
  String? serviceName;
  String? consultationType;
  String? description;
  String? filePath;
  String? price;
  String? notes;
  String? respondedAt;
  String? createdAt;

  ConsultationModel({
    this.id,
    this.serviceId,
    this.serviceName,
    this.consultationType,
    this.description,
    this.filePath,
    this.price,
    this.notes,
    this.respondedAt,
    this.createdAt,
  });

  ConsultationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id']?.toString();
    serviceName = json['service_name'];
    consultationType = json['consultation_type'];
    description = json['description'];
    filePath = json['file_path'];
    price = json['price']?.toString();
    notes = json['notes'];
    respondedAt = json['responded_at'];
    createdAt = json['created_at'];
  }
}

class ConsultationsResponseModel {
  int? code;
  String? message;
  List<ConsultationModel>? data;
  PaginationModel? pagination;

  ConsultationsResponseModel({this.code, this.message, this.data, this.pagination});

  ConsultationsResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ConsultationModel>[];
      json['data'].forEach((v) {
        data!.add(ConsultationModel.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? PaginationModel.fromJson(json['pagination'])
        : null;
  }
}

class PaginationModel {
  int? total;
  int? currentPage;
  int? lastPage;
  int? perPage;

  PaginationModel({this.total, this.currentPage, this.lastPage, this.perPage});

  PaginationModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
  }
}
