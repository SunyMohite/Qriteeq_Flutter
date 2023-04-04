class FeedBackLikeUnLikeReqModel {
  String? user;
  String? feedback;
  String? ftype;
  String? text;
  String? reason;
  String? flagged;

  FeedBackLikeUnLikeReqModel(
      {this.user, this.feedback, this.ftype, this.reason, this.flagged});

  FeedBackLikeUnLikeReqModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    feedback = json['feedback'];
    ftype = json['ftype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['feedback'] = feedback;
    data['ftype'] = ftype;
    return data;
  }

  Map<String, dynamic> toJsonComment() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['feedback'] = feedback;
    data['ftype'] = ftype;
    data['text'] = text;
    return data;
  }

  Map<String, dynamic> toJsonFlag() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['feedback'] = feedback;
    data['ftype'] = ftype;
    data['reason'] = reason;
    return data;
  }

  Map<String, dynamic> toJsonCommentFlag() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['feedback'] = feedback;
    data['ftype'] = ftype;
    data['reason'] = reason;
    data['flagged'] = flagged;

    return data;
  }
}
