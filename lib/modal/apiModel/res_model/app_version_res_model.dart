class AppVersionResModel {
  int? status;
  bool? error;
  String? message;
  AppData? data;

  AppVersionResModel({this.status, this.error, this.message, this.data});

  AppVersionResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? AppData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AppData {
  String? androidVersion;
  String? iosVersion;

  AppData({this.androidVersion, this.iosVersion});

  AppData.fromJson(Map<String, dynamic> json) {
    androidVersion = json['androidVersion'];
    iosVersion = json['iosVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['androidVersion'] = androidVersion;
    data['iosVersion'] = iosVersion;
    return data;
  }
}
