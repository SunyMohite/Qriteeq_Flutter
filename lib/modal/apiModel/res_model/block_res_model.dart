class BlockResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  BlockResModel({this.status, this.error, this.message, this.data});

  BlockResModel.fromJson(Map<String, dynamic> json) {
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
  bool? pin;
  bool? favorite;
  bool? hide;
  bool? block;
  String? type;
  String? by;
  String? to;
  String? blockMessage;
  int? position;
  String? id;

  Data(
      {this.pin,
      this.favorite,
      this.hide,
      this.block,
      this.type,
      this.by,
      this.to,
      this.blockMessage,
      this.position,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    pin = json['pin'];
    favorite = json['favorite'];
    hide = json['hide'];
    block = json['block'];
    type = json['type'];
    by = json['by'];
    to = json['to'];
    position = json['position'];
    blockMessage = json['blockMessage'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pin'] = pin;
    data['favorite'] = favorite;
    data['hide'] = hide;
    data['block'] = block;
    data['type'] = type;
    data['by'] = by;
    data['to'] = to;
    data['blockMessage'] = blockMessage;
    data['position'] = position;
    data['id'] = id;
    return data;
  }
}
