class NotificationReadReqModel {
  List<String>? data;

  NotificationReadReqModel({this.data});

  NotificationReadReqModel.fromJson(Map<String, dynamic> json) {
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    return data;
  }
}
