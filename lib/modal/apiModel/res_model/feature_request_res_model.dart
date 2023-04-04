class FeatureRequestResModel {
  FeatureRequestResModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  FeatureRequestResModel.fromJson(dynamic json) {
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
    this.user,
    this.feature,
    this.id,
  });

  Data.fromJson(dynamic json) {
    user = json['user'];
    feature = json['feature'];
    id = json['id'];
  }
  String? user;
  String? feature;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user'] = user;
    map['feature'] = feature;
    map['id'] = id;
    return map;
  }
}
