class AttendanceModel {
  final int code;
  final String message;
  final dynamic data;

  AttendanceModel({
    required this.code,
    required this.message,
    this.data,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}
