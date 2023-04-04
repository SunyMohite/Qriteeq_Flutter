class FeedPinRequestModel {
  String? by;
  String? toPin;
  String? url;
  bool? pin;
  int? position;

  FeedPinRequestModel({this.by, this.toPin, this.pin, this.position});

  FeedPinRequestModel.fromJson(Map<String, dynamic> json) {
    by = json['by'];
    toPin = json['to'];
    pin = json['pin'];
    url = json['url'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['by'] = by;
    data['to'] = toPin;
    data['pin'] = pin;
    data['url'] = url;
    data['position'] = position;
    return data;
  }
}
