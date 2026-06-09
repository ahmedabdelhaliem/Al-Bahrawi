import 'package:equatable/equatable.dart';

class SettingsModel extends Equatable {
  final int? code;
  final String? message;
  final List<SettingData>? data;

  const SettingsModel({this.code, this.message, this.data});

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      code: json['code'],
      message: json['message'],
      data: json['data'] == null
          ? null
          : List<SettingData>.from(
              json['data'].map((x) => SettingData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [code, message, data];
}

class SettingData extends Equatable {
  final String? name;
  final String? title;
  final String? desc;
  final String? address;
  final String? metaKey;
  final String? metaDesc;
  final String? phone;
  final String? whatsapp;
  final String? email;
  final String? support;
  final String? facebook;
  final String? xUrl;
  final String? youtube;
  final String? instagram;
  final String? tiktok;
  final String? linkedin;
  final String? logo;
  final String? favicon;
  final String? copyright;
  final String? promotion;

  const SettingData({
    this.name,
    this.title,
    this.desc,
    this.address,
    this.metaKey,
    this.metaDesc,
    this.phone,
    this.whatsapp,
    this.email,
    this.support,
    this.facebook,
    this.xUrl,
    this.youtube,
    this.instagram,
    this.tiktok,
    this.linkedin,
    this.logo,
    this.favicon,
    this.copyright,
    this.promotion,
  });

  factory SettingData.fromJson(Map<String, dynamic> json) {
    return SettingData(
      name: json['name'],
      title: json['title'],
      desc: json['desc'],
      address: json['address'],
      metaKey: json['metaKey'],
      metaDesc: json['metaDesc'],
      phone: json['phone'],
      whatsapp: json['whatsapp'],
      email: json['email'],
      support: json['support'],
      facebook: json['facebook'],
      xUrl: json['xUrl'],
      youtube: json['youtube'],
      instagram: json['instagram'],
      tiktok: json['tiktok'],
      linkedin: json['linkedin'],
      logo: json['logo'],
      favicon: json['favicon'],
      copyright: json['copyright'],
      promotion: json['promotion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'desc': desc,
      'address': address,
      'metaKey': metaKey,
      'metaDesc': metaDesc,
      'phone': phone,
      'whatsapp': whatsapp,
      'email': email,
      'support': support,
      'facebook': facebook,
      'xUrl': xUrl,
      'youtube': youtube,
      'instagram': instagram,
      'tiktok': tiktok,
      'linkedin': linkedin,
      'logo': logo,
      'favicon': favicon,
      'copyright': copyright,
      'promotion': promotion,
    };
  }

  @override
  List<Object?> get props => [
        name,
        title,
        desc,
        address,
        metaKey,
        metaDesc,
        phone,
        whatsapp,
        email,
        support,
        facebook,
        xUrl,
        youtube,
        instagram,
        tiktok,
        linkedin,
        logo,
        favicon,
        copyright,
        promotion,
      ];
}
