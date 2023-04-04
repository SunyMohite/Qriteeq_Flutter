class UserGenerateReportResModel {
  int? status;
  bool? error;
  String? message;
  UserGenerateReportData? data;

  UserGenerateReportResModel(
      {this.status, this.error, this.message, this.data});

  UserGenerateReportResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null
        ? UserGenerateReportData.fromJson(json['data'])
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

class UserGenerateReportData {
  List<UserGenerateReportResults>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  UserGenerateReportData(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  UserGenerateReportData.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <UserGenerateReportResults>[];
      json['results'].forEach((v) {
        results!.add(UserGenerateReportResults.fromJson(v));
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

class UserGenerateReportResults {
  Score? score;
  User? user;
  User? reportOf;
  int? feedbacksPostedCount;
  int? feedbacksReceivedCount;
  int? feedbacksPostedPercentage;
  int? feedbacksReceivedPercentage;
  String? showText;
  String? id;

  UserGenerateReportResults(
      {this.score,
      this.user,
      this.reportOf,
      this.feedbacksPostedCount,
      this.feedbacksReceivedCount,
      this.feedbacksPostedPercentage,
      this.feedbacksReceivedPercentage,
      this.showText,
      this.id});

  UserGenerateReportResults.fromJson(Map<String, dynamic> json) {
    score = json['score'] != null ? Score.fromJson(json['score']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    reportOf =
        json['reportOf'] != null ? User.fromJson(json['reportOf']) : null;
    feedbacksPostedCount = json['feedbacksPostedCount'];
    feedbacksReceivedCount = json['feedbacksReceivedCount'];
    feedbacksPostedPercentage = json['feedbacksPostedPercentage'];
    feedbacksReceivedPercentage = json['feedbacksReceivedPercentage'];
    showText = json['showText'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (score != null) {
      data['score'] = score!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (reportOf != null) {
      data['reportOf'] = reportOf!.toJson();
    }
    data['feedbacksPostedCount'] = feedbacksPostedCount;
    data['feedbacksReceivedCount'] = feedbacksReceivedCount;
    data['feedbacksPostedPercentage'] = feedbacksPostedPercentage;
    data['feedbacksReceivedPercentage'] = feedbacksReceivedPercentage;
    data['showText'] = showText;
    data['id'] = id;
    return data;
  }
}

class Score {
  String? sId;
  int? great;
  int? amazing;
  int? fine;
  int? bad;
  int? poor;

  Score({this.sId, this.great, this.amazing, this.fine, this.bad, this.poor});

  Score.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    great = json['great'];
    amazing = json['amazing'];
    fine = json['fine'];
    bad = json['bad'];
    poor = json['poor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['great'] = great;
    data['amazing'] = amazing;
    data['fine'] = fine;
    data['bad'] = bad;
    data['poor'] = poor;
    return data;
  }
}

class User {
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
  String? email;
  String? profileUrl;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? countryCode;
  String? userIdentity;
  String? lastOnlineTime;
  String? fullName;
  String? username;
  String? lastFeedbackTime;
  String? id;

  User(
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
      this.autoApprove,
      this.trustScoreStatic,
      this.generateReportOption,
      this.active,
      this.phone,
      this.profileUrl,
      this.email,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.countryCode,
      this.userIdentity,
      this.lastOnlineTime,
      this.fullName,
      this.username,
      this.lastFeedbackTime,
      this.id});

  User.fromJson(Map<String, dynamic> json) {
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
    email = json['email'];
    profileUrl = json['profileUrl'];
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    countryCode = json['countryCode'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    lastOnlineTime = json['lastOnlineTime'];
    fullName = json['fullName'];
    username = json['username'];
    lastFeedbackTime = json['lastFeedbackTime'];
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
    data['profileUrl'] = profileUrl;
    data['email'] = email;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['countryCode'] = countryCode;
    data['userIdentity'] = userIdentity;
    data['lastOnlineTime'] = lastOnlineTime;
    data['fullName'] = fullName;
    data['username'] = username;
    data['lastFeedbackTime'] = lastFeedbackTime;
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
