class RegisterResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  RegisterResModel({this.status, this.error, this.message, this.data});

  RegisterResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  bool? isNewUser;

  Data({this.isNewUser});

  Data.fromJson(Map<String, dynamic> json) {
    isNewUser = json['new'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['new'] = isNewUser;
    return data;
  }
}
