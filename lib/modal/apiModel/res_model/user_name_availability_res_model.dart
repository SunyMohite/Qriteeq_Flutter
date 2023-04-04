class UserNameAvailabilityResModel {
  UserNameAvailabilityResModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  UserNameAvailabilityResModel.fromJson(dynamic json) {
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
    this.usernameTaken,
  });

  Data.fromJson(dynamic json) {
    usernameTaken = json['usernameTaken'];
  }
  bool? usernameTaken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['usernameTaken'] = usernameTaken;
    return map;
  }
}
