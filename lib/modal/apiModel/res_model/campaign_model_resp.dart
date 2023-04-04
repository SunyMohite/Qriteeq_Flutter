class CampaignModelResponse {
  int? status;
  bool? error;
  String? message;
  CampaignData? data;

  CampaignModelResponse({this.status, this.error, this.message, this.data});

  CampaignModelResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? CampaignData.fromJson(json['data']) : null;
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

class CampaignData {
  String? title;
  String? user;
  String? description;
  String? startDate;
  String? endDate;
  String? id;

  CampaignData(
      {this.title,
      this.user,
      this.description,
      this.startDate,
      this.endDate,
      this.id});

  CampaignData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    user = json['user'];
    description = json['description'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['user'] = user;
    data['description'] = description;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['id'] = id;
    return data;
  }
}
