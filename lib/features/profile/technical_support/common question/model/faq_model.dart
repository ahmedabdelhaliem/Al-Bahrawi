class FaqModel {
  String? question;
  String? answer;

  FaqModel({this.question, this.answer});

  FaqModel.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }
}

class FaqResponseModel {
  int? code;
  String? message;
  List<FaqModel>? data;
  PaginationModel? pagination;

  FaqResponseModel({this.code, this.message, this.data, this.pagination});

  FaqResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FaqModel>[];
      json['data'].forEach((v) {
        data!.add(FaqModel.fromJson(v));
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
