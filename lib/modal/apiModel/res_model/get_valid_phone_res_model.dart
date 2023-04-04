class GetValidPhoneResModel {
  int? status;
  bool? error;
  String? message;
  String? dataMessage;

  GetValidPhoneResModel(
      {this.status, this.error, this.message, this.dataMessage});

  GetValidPhoneResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    dataMessage = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    data['message'] = message;
    data['data'] = dataMessage;
    return data;
  }
}
