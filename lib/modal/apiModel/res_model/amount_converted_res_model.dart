class AmountConvertedResModel {
  int? status;
  bool? error;
  String? message;
  AmountConvertedData? data;

  AmountConvertedResModel({this.status, this.error, this.message, this.data});

  AmountConvertedResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null
        ? AmountConvertedData.fromJson(json['data'])
        : null;
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

class AmountConvertedData {
  var cent;
  var dollar;
  String? showText;
  AmountConvertedData({this.cent, this.dollar, this.showText});

  AmountConvertedData.fromJson(Map<String, dynamic> json) {
    cent = json['cent'];
    dollar = json['dollar'];
    showText = json['showText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cent'] = cent;
    data['dollar'] = dollar;
    data['showText'] = showText;
    return data;
  }
}
