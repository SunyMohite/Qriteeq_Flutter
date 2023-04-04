class GetLeaderBoardResModel {
  int? status;
  bool? error;
  String? message;
  LeaderBoardData? data;

  GetLeaderBoardResModel({this.status, this.error, this.message, this.data});

  GetLeaderBoardResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? LeaderBoardData.fromJson(json['data']) : null;
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

class LeaderBoardData {
  List<LeaderBoardResults>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  LeaderBoardData(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  LeaderBoardData.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <LeaderBoardResults>[];
      json['results'].forEach((v) {
        results!.add(LeaderBoardResults.fromJson(v));
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

class LeaderBoardResults {
  User? user;
  int? postedCount;
  int? receivedCount;
  DefaultStatus? defaultStatus;
  BlockStatus? blockStatus;

  LeaderBoardResults(
      {this.user,
      this.postedCount,
      this.receivedCount,
      this.defaultStatus,
      this.blockStatus});

  LeaderBoardResults.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    postedCount = json['postedCount'];
    receivedCount = json['receivedCount'];
    defaultStatus = json['defaultStatus'] != null
        ? DefaultStatus.fromJson(json['defaultStatus'])
        : null;
    blockStatus = json['blockStatus'] != null
        ? BlockStatus.fromJson(json['blockStatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['postedCount'] = postedCount;
    data['receivedCount'] = receivedCount;
    if (defaultStatus != null) {
      data['defaultStatus'] = defaultStatus!.toJson();
    }
    if (blockStatus != null) {
      data['blockStatus'] = blockStatus!.toJson();
    }
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
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? countryCode;
  String? userIdentity;
  String? fcm;
  String? flagUrl;
  String? fullName;
  String? username;
  String? lastOnlineTime;
  String? lastFeedbackTime;
  String? profileType;
  String? countryName;
  String? id;
  String? customerId;
  String? email;
  String? trustScore;

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
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.countryCode,
      this.userIdentity,
      this.fcm,
      this.flagUrl,
      this.fullName,
      this.username,
      this.lastOnlineTime,
      this.lastFeedbackTime,
      this.profileType,
      this.countryName,
      this.id,
      this.customerId,
      this.email,
      this.trustScore});

  User.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    url = json['url'];
    role = json['role'];
    avatar = json['avatar'] ?? "";
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
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    countryCode = json['countryCode'];
    userIdentity = json['userIdentity'];
    fcm = json['fcm'];
    flagUrl = json['flagUrl'];
    fullName = json['fullName'];
    username = json['username'];
    lastOnlineTime = json['lastOnlineTime'];
    lastFeedbackTime = json['lastFeedbackTime'];
    profileType = json['profileType'];
    countryName = json['countryName'];
    id = json['id'];
    customerId = json['customerId'];
    email = json['email'];
    trustScore = json['trustScore'];
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
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['countryCode'] = countryCode;
    data['userIdentity'] = userIdentity;
    data['fcm'] = fcm;
    data['flagUrl'] = flagUrl;
    data['fullName'] = fullName;
    data['username'] = username;
    data['lastOnlineTime'] = lastOnlineTime;
    data['lastFeedbackTime'] = lastFeedbackTime;
    data['profileType'] = profileType;
    data['countryName'] = countryName;
    data['id'] = id;
    data['customerId'] = customerId;
    data['email'] = email;
    data['trustScore'] = trustScore;
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

class DefaultStatus {
  bool? pin;
  bool? favorite;
  bool? hide;
  bool? block;
  int? position;
  bool? flag;
  String? type;
  String? by;
  User? to;
  String? id;
  String? url;

  DefaultStatus(
      {this.pin,
      this.favorite,
      this.hide,
      this.block,
      this.position,
      this.flag,
      this.type,
      this.by,
      this.to,
      this.id,
      this.url});

  DefaultStatus.fromJson(Map<String, dynamic> json) {
    pin = json['pin'];
    favorite = json['favorite'];
    hide = json['hide'];
    block = json['block'];
    position = json['position'];
    flag = json['flag'];
    type = json['type'];
    by = json['by'];
    to = json['to'] != null ? User.fromJson(json['to']) : null;
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pin'] = pin;
    data['favorite'] = favorite;
    data['hide'] = hide;
    data['block'] = block;
    data['position'] = position;
    data['flag'] = flag;
    data['type'] = type;
    data['by'] = by;
    if (to != null) {
      data['to'] = to!.toJson();
    }
    data['id'] = id;
    data['url'] = url;
    return data;
  }
}

class BlockStatus {
  bool? hideUser;
  String? hideUserMessage;

  BlockStatus({this.hideUser, this.hideUserMessage});

  BlockStatus.fromJson(Map<String, dynamic> json) {
    hideUser = json['hideUser'];
    hideUserMessage = json['hideUserMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hideUser'] = hideUser;
    data['hideUserMessage'] = hideUserMessage;
    return data;
  }
}
