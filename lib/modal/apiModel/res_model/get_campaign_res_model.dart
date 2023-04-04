class GetCampaignResModel {
  GetCampaignResModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  GetCampaignResModel.fromJson(dynamic json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int? status;
  bool? error;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['error'] = error;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    this.results,
    this.page,
    this.limit,
    this.totalPages,
    this.totalResults,
  });

  Data.fromJson(dynamic json) {
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(GetCampaign.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
  }
  List<GetCampaign>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (results != null) {
      map['results'] = results?.map((v) => v.toJson()).toList();
    }
    map['page'] = page;
    map['limit'] = limit;
    map['totalPages'] = totalPages;
    map['totalResults'] = totalResults;
    return map;
  }
}

class GetCampaign {
  GetCampaign({
    this.title,
    this.user,
    this.description,
    this.startDate,
    this.endDate,
    this.campaignLink,
    this.id,
  });

  GetCampaign.fromJson(dynamic json) {
    title = json['title'];
    user = json['user'];
    description = json['description'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    campaignLink = json['campaignLink'];
    feedbacksReceivedCount = json['feedbacksReceivedCount'];
    id = json['id'];
  }
  String? title;
  String? user;
  String? description;
  String? startDate;
  String? endDate;
  String? campaignLink;
  String? feedbacksReceivedCount;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['user'] = user;
    map['description'] = description;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['campaignLink'] = campaignLink;
    map['feedbacksReceivedCount'] = feedbacksReceivedCount;
    map['id'] = id;
    return map;
  }
}
