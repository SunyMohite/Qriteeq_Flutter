class UserFeedBackReqModel {
  String? url;
  String? user;
  String? sender;
  String? score;
  String? reviewType;
  String? relation;
  String? text;
  String? shared;

  UserFeedBackReqModel(
      {this.url,
      this.user,
      this.sender,
      this.score,
      this.reviewType,
      this.relation,
      this.text,
      this.shared});

  UserFeedBackReqModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    user = json['user'];
    sender = json['sender'];
    score = json['score'];
    reviewType = json['reviewType'];
    relation = json['relation'];
    text = json['text'];
    shared = json['shared'];
  }

  Map<String, dynamic> toJsonUserExist() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['sender'] = sender;
    data['score'] = score;
    data['reviewType'] = reviewType;
    data['relation'] = relation;
    data['text'] = text;
    data['shared'] = shared;
    return data;
  }

  Map<String, dynamic> toJsonUserDoesExist() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['sender'] = sender;
    data['score'] = score;
    data['reviewType'] = reviewType;
    data['relation'] = relation;
    data['text'] = text;
    data['shared'] = shared;
    return data;
  }
}
