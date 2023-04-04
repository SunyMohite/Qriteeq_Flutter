class SubscribeReqModel {
  String? by;
  String? to;
  String? type;

  SubscribeReqModel({this.by, this.to, this.type});

  SubscribeReqModel.fromJson(Map<String, dynamic> json) {
    by = json['by'];
    to = json['to'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['by'] = by;
    data['to'] = to;
    data['type'] = type;
    return data;
  }
}
