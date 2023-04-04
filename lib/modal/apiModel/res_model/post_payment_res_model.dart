class PostPaymentResModel {
  int? status;
  bool? error;
  String? message;

  PostPaymentResModel({
    this.status,
    this.error,
    this.message,
  });

  PostPaymentResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    data['message'] = message;

    return data;
  }
}
