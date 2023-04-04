class NotificationCountResModel {
  int? status;
  bool? error;
  String? message;
  NotificationCountData? data;

  NotificationCountResModel({this.status, this.error, this.message, this.data});

  NotificationCountResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null
        ? NotificationCountData.fromJson(json['data'])
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

class NotificationCountData {
  Location? location;
  LocationName? locationName;
  String? url;
  String? role;
  bool? anonymous;
  bool? online;
  int? received;
  int? posted;
  int? subscribed;
  int? wallet;
  String? sId;
  String? phone;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? fcm;
  String? avatar;
  String? username;
  String? customerId;
  int? notification;

  NotificationCountData(
      {this.location,
      this.locationName,
      this.url,
      this.role,
      this.anonymous,
      this.online,
      this.received,
      this.posted,
      this.subscribed,
      this.wallet,
      this.sId,
      this.phone,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.fcm,
      this.avatar,
      this.username,
      this.customerId,
      this.notification});

  NotificationCountData.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    url = json['url'];
    role = json['role'];
    anonymous = json['anonymous'];
    online = json['online'];
    received = json['received'];
    posted = json['posted'];
    subscribed = json['subscribed'];
    wallet = json['wallet'];
    sId = json['_id'];
    phone = json['phone'];
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    fcm = json['fcm'];
    avatar = json['avatar'] ?? '';
    username = json['username'];
    customerId = json['customerId'];
    notification = json['notification'];
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
    data['anonymous'] = anonymous;
    data['online'] = online;
    data['received'] = received;
    data['posted'] = posted;
    data['subscribed'] = subscribed;
    data['wallet'] = wallet;
    data['_id'] = sId;
    data['phone'] = phone;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['fcm'] = fcm;
    data['avatar'] = avatar;
    data['username'] = username;
    data['customerId'] = customerId;
    data['notification'] = notification;
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

class LocationName {
  String? state;
  String? country;

  LocationName({this.state, this.country});

  LocationName.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state'] = state;
    data['country'] = country;
    return data;
  }
}
