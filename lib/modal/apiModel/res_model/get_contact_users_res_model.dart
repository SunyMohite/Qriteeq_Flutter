class GetContactUsersResModel {
  int? status;
  bool? error;
  String? message;
  GetContactUsersData? data;

  GetContactUsersResModel({this.status, this.error, this.message, this.data});

  GetContactUsersResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null
        ? GetContactUsersData.fromJson(json['data'])
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

class GetContactUsersData {
  List<GetContactUsersResults>? results;
  int? totalResults;
  int? totalPages;
  int? limit;
  int? page;

  GetContactUsersData(
      {this.results,
      this.totalResults,
      this.totalPages,
      this.limit,
      this.page});

  GetContactUsersData.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <GetContactUsersResults>[];
      json['results'].forEach((v) {
        results!.add(GetContactUsersResults.fromJson(v));
      });
    }
    totalResults = json['totalResults'];
    totalPages = json['totalPages'];
    limit = json['limit'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['totalResults'] = totalResults;
    data['totalPages'] = totalPages;
    data['limit'] = limit;
    data['page'] = page;
    return data;
  }
}

class GetContactUsersResults {
  Location? location;
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
  String? referral;
  String? fullName;
  String? username;
  String? userIdentity;
  DefaultStatus? defaultStatus;
  String? id;

  GetContactUsersResults(
      {this.location,
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
      this.autoApprove,
      this.trustScoreStatic,
      this.generateReportOption,
      this.active,
      this.phone,
      this.referral,
      this.fullName,
      this.username,
      this.userIdentity,
      this.defaultStatus,
      this.id});

  GetContactUsersResults.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    url = json['url'];
    role = json['role'];
    avatar = json['avatar'];
    anonymous = json['anonymous'];
    online = json['online'];
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
    fullName = json['fullName'];
    username = json['username'];
    userIdentity = json['userIdentity'];
    defaultStatus = json['defaultStatus'] != null
        ? DefaultStatus.fromJson(json['defaultStatus'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['url'] = url;
    data['role'] = role;
    data['avatar'] = avatar;
    data['anonymous'] = anonymous;
    data['online'] = online;
    data['received'] = received;
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
    data['fullName'] = fullName;
    data['username'] = username;
    data['userIdentity'] = userIdentity;
    if (defaultStatus != null) {
      data['defaultStatus'] = defaultStatus!.toJson();
    }
    data['id'] = id;
    return data;
  }
}

class Location {
  List<int>? coordinates;
  String? type;

  Location({this.coordinates, this.type});

  Location.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<int>();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    data['type'] = type;
    return data;
  }
}

class DefaultStatus {
  bool? pin;
  bool? favorite;
  bool? hide;
  bool? block;
  bool? flag;
  String? type;
  String? by;
  To? to;
  String? id;
  int? position;

  DefaultStatus(
      {this.pin,
      this.favorite,
      this.hide,
      this.block,
      this.flag,
      this.type,
      this.by,
      this.to,
      this.id,
      this.position});

  DefaultStatus.fromJson(Map<String, dynamic> json) {
    pin = json['pin'];
    favorite = json['favorite'];
    hide = json['hide'];
    block = json['block'];
    flag = json['flag'];
    type = json['type'];
    by = json['by'];
    to = json['to'] != null ? To.fromJson(json['to']) : null;
    id = json['id'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pin'] = pin;
    data['favorite'] = favorite;
    data['hide'] = hide;
    data['block'] = block;
    data['flag'] = flag;
    data['type'] = type;
    data['by'] = by;
    if (to != null) {
      data['to'] = to!.toJson();
    }
    data['id'] = id;
    data['position'] = position;
    return data;
  }
}

class To {
  Location? location;
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
  String? referral;
  String? fullName;
  String? username;
  String? userIdentity;
  String? id;

  To(
      {this.location,
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
      this.autoApprove,
      this.trustScoreStatic,
      this.generateReportOption,
      this.active,
      this.phone,
      this.referral,
      this.fullName,
      this.username,
      this.userIdentity,
      this.id});

  To.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    url = json['url'];
    role = json['role'];
    avatar = json['avatar'];
    anonymous = json['anonymous'];
    online = json['online'];
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
    fullName = json['fullName'];
    username = json['username'];
    userIdentity = json['userIdentity'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['url'] = url;
    data['role'] = role;
    data['avatar'] = avatar;
    data['anonymous'] = anonymous;
    data['online'] = online;
    data['received'] = received;
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
    data['fullName'] = fullName;
    data['username'] = username;
    data['userIdentity'] = userIdentity;
    data['id'] = id;
    return data;
  }
}
