class GenerateReportResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  GenerateReportResModel({this.status, this.error, this.message, this.data});

  GenerateReportResModel.fromJson(Map<String, dynamic> json) {
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
  List<GenerateReportData>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  Data(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <GenerateReportData>[];
      json['results'].forEach((v) {
        results!.add(GenerateReportData.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    return data;
  }
}

class GenerateReportData {
  Location? location;
  LocationName? locationName;
  String? url;
  String? role;
  String? avatar;
  bool? anonymous;
  bool? online;
  int? received;
  int? posted;
  int? subscribed;
  int? wallet;
  int? referralBalance;
  int? recentCoins;
  bool? autoApprove;
  bool? trustScoreStatic;
  bool? generateReportOption;
  bool? active;
  String? phone;
  String? showText;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? countryCode;
  String? userIdentity;
  String? fcm;
  String? lastOnlineTime;
  String? flagUrl;
  String? fullName;
  String? username;
  String? lastFeedbackTime;
  int? reportCount;
  String? id;

  GenerateReportData(
      {this.location,
      this.locationName,
      this.url,
      this.role,
      this.avatar,
      this.anonymous,
      this.online,
      this.received,
      this.posted,
      this.subscribed,
      this.wallet,
      this.referralBalance,
      this.recentCoins,
      this.showText,
      this.autoApprove,
      this.trustScoreStatic,
      this.generateReportOption,
      this.active,
      this.phone,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.countryCode,
      this.userIdentity,
      this.fcm,
      this.lastOnlineTime,
      this.flagUrl,
      this.fullName,
      this.username,
      this.lastFeedbackTime,
      this.reportCount,
      this.id});

  GenerateReportData.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    url = json['url'];
    role = json['role'];
    avatar = json['avatar'] ?? '';
    anonymous = json['anonymous'];
    online = json['online'];
    showText = json['showText'];
    received = json['received'];
    posted = json['posted'];
    subscribed = json['subscribed'];
    wallet = json['wallet'];
    referralBalance = json['referralBalance'];
    recentCoins = json['recentCoins'];
    autoApprove = json['autoApprove'];
    trustScoreStatic = json['trustScoreStatic'];
    generateReportOption = json['generateReportOption'];
    active = json['active'];
    phone = json['phone'];
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    countryCode = json['countryCode'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    fcm = json['fcm'];
    lastOnlineTime = json['lastOnlineTime'];
    flagUrl = json['flagUrl'];
    fullName = json['fullName'];
    username = json['username'];
    lastFeedbackTime = json['lastFeedbackTime'];
    reportCount = json['reportCount'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (locationName != null) {
      data['locationName'] = locationName!.toJson();
    }
    data['url'] = url;
    data['role'] = role;
    data['avatar'] = avatar;
    data['anonymous'] = anonymous;
    data['online'] = online;
    data['received'] = received;
    data['showText'] = showText;
    data['posted'] = posted;
    data['subscribed'] = subscribed;
    data['wallet'] = wallet;
    data['referralBalance'] = referralBalance;
    data['recentCoins'] = recentCoins;
    data['autoApprove'] = autoApprove;
    data['trustScoreStatic'] = trustScoreStatic;
    data['generateReportOption'] = generateReportOption;
    data['active'] = active;
    data['phone'] = phone;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['countryCode'] = countryCode;
    data['userIdentity'] = userIdentity;
    data['fcm'] = fcm;
    data['lastOnlineTime'] = lastOnlineTime;
    data['flagUrl'] = flagUrl;
    data['fullName'] = fullName;
    data['username'] = username;
    data['lastFeedbackTime'] = lastFeedbackTime;
    data['reportCount'] = reportCount;
    data['id'] = id;
    return data;
  }
}

class Location {
  List<double>? coordinates;
  String? type;

  Location({this.coordinates, this.type});

  Location.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    data['type'] = type;
    return data;
  }
}

class LocationName {
  String? address;
  String? state;

  LocationName({this.address, this.state});

  LocationName.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['state'] = state;
    return data;
  }
}
