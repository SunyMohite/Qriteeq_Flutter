class GetCampaignIdResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  GetCampaignIdResModel({this.status, this.error, this.message, this.data});

  GetCampaignIdResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  String? title;
  String? user;
  String? description;
  String? startDate;
  String? endDate;
  String? campaignLink;
  String? feedbacksReceivedCount;
  String? id;

  Data(
      {this.title,
      this.user,
      this.description,
      this.startDate,
      this.endDate,
      this.campaignLink,
      this.feedbacksReceivedCount,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    user = json['user'];
    description = json['description'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    campaignLink = json['campaignLink'];
    feedbacksReceivedCount = json['feedbacksReceivedCount'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['user'] = user;
    data['description'] = description;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['campaignLink'] = campaignLink;
    data['feedbacksReceivedCount'] = feedbacksReceivedCount;
    data['id'] = id;
    return data;
  }
}
