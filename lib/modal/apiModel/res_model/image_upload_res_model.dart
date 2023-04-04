class ImageUploadResModel {
  int? status;
  bool? error;
  String? message;
  String? data;
  String? ext;

  ImageUploadResModel(
      {this.status, this.error, this.message, this.data, this.ext});

  ImageUploadResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'];
    ext = json['ext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    data['message'] = message;
    data['data'] = this.data;
    data['ext'] = ext;
    return data;
  }
}
