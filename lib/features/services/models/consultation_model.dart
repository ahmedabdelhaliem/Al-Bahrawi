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

  ConsultationsResponseModel({this.code, this.message, this.data});

  ConsultationsResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ConsultationModel>[];
      json['data'].forEach((v) {
        data!.add(ConsultationModel.fromJson(v));
      });
    }
  }
}
