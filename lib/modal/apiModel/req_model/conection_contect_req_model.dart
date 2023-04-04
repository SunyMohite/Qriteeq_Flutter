class ConnectionContactReqModel {
  String? by;
  List<String>? toUserList;
  String? type;

  ConnectionContactReqModel({this.by, this.toUserList, this.type});

  ConnectionContactReqModel.fromJson(Map<String, dynamic> json) {
    by = json['by'];
    toUserList = json['to'].cast<String>();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['by'] = by;
    data['to'] = toUserList;
    data['type'] = type;
    return data;
  }
}
