class BlockReqModel {
  String? by;
  String? to;
  bool? block;

  BlockReqModel({this.by, this.to, this.block});

  BlockReqModel.fromJson(Map<String, dynamic> json) {
    by = json['by'];
    to = json['to'];
    block = json['block'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['by'] = by;
    data['to'] = to;
    data['block'] = block;
    return data;
  }
}

class FlagProfileReqModel {
  String? by;
  String? to;
  bool? profileFlag;

  FlagProfileReqModel({this.by, this.to, this.profileFlag});

  FlagProfileReqModel.fromJson(Map<String, dynamic> json) {
    by = json['by'];
    to = json['to'];
    profileFlag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['by'] = by;
    data['to'] = to;
    data['flag'] = profileFlag;
    return data;
  }
}
