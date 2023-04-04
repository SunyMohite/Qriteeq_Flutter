class GetReferralBalResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  GetReferralBalResModel({this.status, this.error, this.message, this.data});

  GetReferralBalResModel.fromJson(Map<String, dynamic> json) {
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
  int? referralBalance;

  Data({this.referralBalance});

  Data.fromJson(Map<String, dynamic> json) {
    referralBalance = json['referralBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['referralBalance'] = referralBalance;
    return data;
  }
}
