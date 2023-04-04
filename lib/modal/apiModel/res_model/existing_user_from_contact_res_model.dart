class ExistingUserFromContactResModel {
  int? status;
  bool? error;
  String? message;
  List<ExistingUserFromContactData>? data;

  ExistingUserFromContactResModel(
      {this.status, this.error, this.message, this.data});

  ExistingUserFromContactResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ExistingUserFromContactData>[];
      json['data'].forEach((v) {
        data!.add(ExistingUserFromContactData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExistingUserFromContactData {
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
  bool? active;
  String? phone;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? fcm;
  String? flagUrl;
  String? fullName;
  String? username;
  String? customerId;
  String? email;
  String? profileUrl;
  String? countryCode;
  String? userIdentity;
  String? lastOnlineTime;
  String? lastFeedbackTime;
  String? id;
  DefaultStatus? defaultStatus;

  ExistingUserFromContactData(
      {this.locationName,
      this.url,
      this.role,
      this.defaultStatus,
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
      this.active,
      this.phone,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.fcm,
      this.flagUrl,
      this.fullName,
      this.username,
      this.customerId,
      this.email,
      this.profileUrl,
      this.countryCode,
      this.userIdentity,
      this.lastOnlineTime,
      this.lastFeedbackTime,
      this.id});

  ExistingUserFromContactData.fromJson(Map<String, dynamic> json) {
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
    active = json['active'];
    phone = json['phone'];
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    fcm = json['fcm'];
    flagUrl = json['flagUrl'];
    fullName = json['fullName'];
    username = json['username'] ?? '';
    customerId = json['customerId'];
    email = json['email'];
    profileUrl = json['profileUrl'];
    countryCode = json['countryCode'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    lastOnlineTime = json['lastOnlineTime'];
    lastFeedbackTime = json['lastFeedbackTime'];
    id = json['id'];
    defaultStatus = json['defaultStatus'] != null
        ? DefaultStatus.fromJson(json['defaultStatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

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
    data['active'] = active;
    data['phone'] = phone;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['fcm'] = fcm;
    data['flagUrl'] = flagUrl;
    data['fullName'] = fullName;
    data['username'] = username;
    data['customerId'] = customerId;
    data['email'] = email;
    data['profileUrl'] = profileUrl;
    data['countryCode'] = countryCode;
    data['userIdentity'] = userIdentity;
    data['lastOnlineTime'] = lastOnlineTime;
    data['lastFeedbackTime'] = lastFeedbackTime;
    data['id'] = id;
    if (defaultStatus != null) {
      data['defaultStatus'] = defaultStatus!.toJson();
    }
    return data;
  }
}

class DefaultStatus {
  bool? pin;
  bool? favorite;
  bool? hide;
  bool? block;
  bool? flag;
  int? position;

  DefaultStatus(
      {this.pin,
      this.favorite,
      this.hide,
      this.block,
      this.position,
      this.flag});

  DefaultStatus.fromJson(Map<String, dynamic> json) {
    pin = json['pin'];
    favorite = json['favorite'];
    hide = json['hide'];
    block = json['block'];
    flag = json['flag'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pin'] = pin;
    data['favorite'] = favorite;
    data['hide'] = hide;
    data['block'] = block;
    data['flag'] = flag;
    data['position'] = position;
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
