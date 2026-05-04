class AboutUsModel {
  int? code;
  String? message;
  AboutUsData? data;

  AboutUsModel({this.code, this.message, this.data});

  AboutUsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? AboutUsData.fromJson(json['data']) : null;
  }
}

class AboutUsData {
  String? banner;
  String? title;
  String? description;
  String? image;
  String? updatedAt;

  AboutUsData({
    this.banner,
    this.title,
    this.description,
    this.image,
    this.updatedAt,
  });

  AboutUsData.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    updatedAt = json['updated_at'];
  }
}
