class FeedBackCommentReqModel {
  String? user;
  String? feedback;
  String? ftype;
  String? text;

  FeedBackCommentReqModel({this.user, this.feedback, this.ftype, this.text});

  FeedBackCommentReqModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    feedback = json['feedback'];
    ftype = json['ftype'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['feedback'] = feedback;
    data['ftype'] = ftype;
    data['text'] = text;
    return data;
  }
}
