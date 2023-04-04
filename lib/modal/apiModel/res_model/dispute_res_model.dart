class DisputeResModel {
  DisputeResModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  DisputeResModel.fromJson(dynamic json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int? status;
  bool? error;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['error'] = error;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    this.title,
    this.date,
    this.showText,
    this.serialNumber,
  });

  Data.fromJson(dynamic json) {
    title = json['title'];
    date = json['date'];
    showText = json['showText'];
    serialNumber = json['serialNumber'];
  }
  String? title;
  String? date;
  String? showText;
  int? serialNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['date'] = date;
    map['showText'] = showText;
    map['serialNumber'] = serialNumber;
    return map;
  }
}
