class ReadFeedBackReqModel {
  List<String>? feedbackId;
  bool? read;

  ReadFeedBackReqModel({this.feedbackId, this.read});

  ReadFeedBackReqModel.fromJson(Map<String, dynamic> json) {
    feedbackId = json['feedbackId'].cast<String>();
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['feedbackId'] = feedbackId;
    data['read'] = read;
    return data;
  }
}
