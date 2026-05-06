class StatisticsModel {
  int? code;
  String? message;
  List<StatisticData>? data;

  StatisticsModel({this.code, this.message, this.data});

  StatisticsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StatisticData>[];
      json['data'].forEach((v) {
        data!.add(StatisticData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatisticData {
  int? id;
  String? title;
  String? count;
  String? icon;

  StatisticData({this.id, this.title, this.count, this.icon});

  StatisticData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    count = json['count'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['count'] = count;
    data['icon'] = icon;
    return data;
  }
}
