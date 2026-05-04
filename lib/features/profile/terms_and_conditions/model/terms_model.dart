class TermsModel {
  int? code;
  String? message;
  TermsData? data;

  TermsModel({this.code, this.message, this.data});

  TermsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? TermsData.fromJson(json['data']) : null;
  }
}

class TermsData {
  String? banner;
  String? title;
  String? description;
  String? image;
  String? updatedAt;

  TermsData({
    this.banner,
    this.title,
    this.description,
    this.image,
    this.updatedAt,
  });

  TermsData.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    updatedAt = json['updated_at'];
  }
}
