class GetUserProfileResModel {
  int? status;
  bool? error;
  String? message;
  UserProfileData? data;

  GetUserProfileResModel({this.status, this.error, this.message, this.data});

  GetUserProfileResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? UserProfileData.fromJson(json['data']) : null;
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

class UserProfileData {
  User? user;
  int? postedCount;
  int? receivedCount;
  int? favoriteCount;
  String? trustScore;
  String? totalTrustScore;

  UserProfileData(
      {this.user,
      this.postedCount,
      this.receivedCount,
      this.favoriteCount,
      this.totalTrustScore,
      this.trustScore});

  UserProfileData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    postedCount = json['postedCount'];
    receivedCount = json['receivedCount'];
    favoriteCount = json['favoriteCount'];
    trustScore = json['trustScore'];
    totalTrustScore = json['totalTrustScore'] ?? "5";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['postedCount'] = postedCount;
    data['receivedCount'] = receivedCount;
    data['favoriteCount'] = favoriteCount;
    data['trustScore'] = trustScore;
    data['totalTrustScore'] = totalTrustScore;
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
  String? lastOnlineTime;
  String? flagUrl;
  String? fullName;
  String? username;
  String? lastFeedbackTime;
  String? trustScore;
  String? countryName;
  String? profileType;
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
      this.trustScore,
      this.countryName,
      this.profileType,
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
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    countryCode = json['countryCode'];
    userIdentity = json['userIdentity'];
    fcm = json['fcm'];
    lastOnlineTime = json['lastOnlineTime'];
    flagUrl = json['flagUrl'];
    fullName = json['fullName'];
    username = json['username'];
    lastFeedbackTime = json['lastFeedbackTime'];
    trustScore = json['trustScore'];
    countryName = json['countryName'];
    profileType = json['profileType'];
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
    data['trustScore'] = trustScore;
    data['countryName'] = countryName;
    data['profileType'] = profileType;
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

///USER WALLET.............
class UserWalletResModel {
  int? status;
  bool? error;
  String? message;
  UserWalletData? data;

  UserWalletResModel({this.status, this.error, this.message, this.data});

  UserWalletResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? UserWalletData.fromJson(json['data']) : null;
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

class UserWalletData {
  int? wallet;

  UserWalletData({this.wallet});

  UserWalletData.fromJson(Map<String, dynamic> json) {
    wallet = json['wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wallet'] = wallet;
    return data;
  }
}
