class OtpVerificationResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  OtpVerificationResModel({this.status, this.error, this.message, this.data});

  OtpVerificationResModel.fromJson(Map<String, dynamic> json) {
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
  String? token;
  String? qrLink;
  String? referralLink;
  User? user;

  Data({this.token, this.user, this.referralLink, this.qrLink});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    referralLink = json['referralLink'] ?? '';
    qrLink = json['qrLink'] ?? '';
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['referralLink'] = referralLink;
    data['qrLink'] = qrLink;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  Location? location;
  LocationName? locationName;
  String? url;
  String? role;
  bool? anonymous;
  bool? online;
  int? received;
  int? posted;
  int? subscribed;
  String? phone;
  int? wallet;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? fcm;
  String? avatar;
  String? username;
  String? flagUrl;
  String? countryName;
  String? userIdentity;
  String? fullName;
  String? id;

  User(
      {this.location,
      this.locationName,
      this.url,
      this.userIdentity,
      this.role,
      this.wallet,
      this.anonymous,
      this.online,
      this.flagUrl,
      this.countryName,
      this.received,
      this.posted,
      this.subscribed,
      this.phone,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.fcm,
      this.avatar,
      this.username,
      this.fullName,
      this.id});

  User.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    url = json['url'] ?? '';
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    wallet = json['wallet'];
    role = json['role'];
    anonymous = json['anonymous'];
    countryName = json['countryName'] ?? '';
    flagUrl = json['flagUrl'] ?? '';
    online = json['online'];
    received = json['received'];
    posted = json['posted'];
    subscribed = json['subscribed'];
    phone = json['phone'];
    referral = json['referral'] ?? '';
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    fcm = json['fcm'];
    avatar = json['avatar'] ?? '';
    username = json['username'] ?? '';
    fullName = json['fullName'] ?? '';
    id = json['id'] ?? '';
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
    data['userIdentity'] = userIdentity;
    data['role'] = role;
    data['wallet'] = wallet;
    data['anonymous'] = anonymous;
    data['online'] = online;
    data['received'] = received;
    data['posted'] = posted;
    data['flagUrl'] = flagUrl;
    data['countryName'] = countryName;
    data['subscribed'] = subscribed;
    data['phone'] = phone;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['fcm'] = fcm;
    data['avatar'] = avatar;
    data['username'] = username;
    data['fullName'] = fullName;
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
