class FeedBackCommentResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  FeedBackCommentResModel({this.status, this.error, this.message, this.data});

  FeedBackCommentResModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? user;
  String? feedback;
  String? ftype;
  String? text;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.user,
      this.feedback,
      this.ftype,
      this.text,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    feedback = json['feedback'];
    ftype = json['ftype'];
    text = json['text'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['feedback'] = feedback;
    data['ftype'] = ftype;
    data['text'] = text;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
