class FeedLikePinResponseModel {
  int? status;
  bool? error;
  String? message;
  FeedLikePinData? data;

  FeedLikePinResponseModel({this.status, this.error, this.message, this.data});

  FeedLikePinResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? FeedLikePinData.fromJson(json['data']) : null;
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

class FeedLikePinData {
  bool? pin;
  bool? favorite;
  bool? hide;
  bool? block;
  String? type;
  String? sId;
  String? by;
  String? to;
  String? createdAt;
  String? updatedAt;
  int? iV;

  FeedLikePinData(
      {this.pin,
      this.favorite,
      this.hide,
      this.block,
      this.type,
      this.sId,
      this.by,
      this.to,
      this.createdAt,
      this.updatedAt,
      this.iV});

  FeedLikePinData.fromJson(Map<String, dynamic> json) {
    pin = json['pin'];
    favorite = json['favorite'];
    hide = json['hide'];
    block = json['block'];
    type = json['type'];
    sId = json['_id'];
    by = json['by'];
    to = json['to'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pin'] = pin;
    data['favorite'] = favorite;
    data['hide'] = hide;
    data['block'] = block;
    data['type'] = type;
    data['_id'] = sId;
    data['by'] = by;
    data['to'] = to;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
