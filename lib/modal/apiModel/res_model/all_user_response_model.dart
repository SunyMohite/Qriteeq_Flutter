class AllUserResponseModel {
  int? status;
  bool? error;
  String? message;
  List<AllUserData>? data;

  AllUserResponseModel({this.status, this.error, this.message, this.data});

  AllUserResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AllUserData>[];
      json['data'].forEach((v) {
        data!.add(AllUserData.fromJson(v));
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

class AllUserData {
  Location? location;
  String? url;
  String? role;
  String? avatar;
  bool? anonymous;
  bool? online;
  bool? active;
  int? received;
  int? posted;
  int? subscribed;
  int? wallet;
  String? phone;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? id;
  String? fcm;
  LocationName? locationName;
  String? username;
  String? email;
  String? customerId;
  String? flagUrl;
  String? fullName;
  String? userIdentity;
  Connection? connection;

  AllUserData(
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
      this.phone,
      this.active,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.id,
      this.fcm,
      this.locationName,
      this.username,
      this.email,
      this.customerId,
      this.flagUrl,
      this.fullName,
      this.userIdentity,
      this.connection});

  AllUserData.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    url = json['url'];
    role = json['role'];
    avatar = json['avatar'] ?? '';
    anonymous = json['anonymous'];
    online = json['online'];
    received = json['received'];
    posted = json['posted'];
    subscribed = json['subscribed'];
    wallet = json['wallet'];
    active = json['active'];
    phone = json['phone'];
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    id = json['id'];
    fcm = json['fcm'];
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    username = json['username'];
    email = json['email'];
    customerId = json['customerId'];
    flagUrl = json['flagUrl'];
    fullName = json['fullName'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    connection = json['connection'] != null
        ? Connection.fromJson(json['connection'])
        : null;
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
    data['active'] = active;
    data['posted'] = posted;
    data['subscribed'] = subscribed;
    data['wallet'] = wallet;
    data['phone'] = phone;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['id'] = id;
    data['fcm'] = fcm;
    if (locationName != null) {
      data['locationName'] = locationName!.toJson();
    }
    data['username'] = username;
    data['email'] = email;
    data['customerId'] = customerId;
    data['flagUrl'] = flagUrl;
    data['fullName'] = fullName;
    data['userIdentity'] = userIdentity;
    if (connection != null) {
      data['connection'] = connection!.toJson();
    }
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
  String? address;
  String? state;
  String? country;

  LocationName({this.address, this.state, this.country});

  LocationName.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    state = json['state'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['state'] = state;
    data['country'] = country;
    return data;
  }
}

class Connection {
  bool? pin;
  bool? favorite;
  bool? hide;
  bool? block;
  String? type;
  String? by;
  String? to;
  String? id;

  Connection(
      {this.pin,
      this.favorite,
      this.hide,
      this.block,
      this.type,
      this.by,
      this.to,
      this.id});

  Connection.fromJson(Map<String, dynamic> json) {
    pin = json['pin'];
    favorite = json['favorite'];
    hide = json['hide'];
    block = json['block'];
    type = json['type'];
    by = json['by'];
    to = json['to'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pin'] = pin;
    data['favorite'] = favorite;
    data['hide'] = hide;
    data['block'] = block;
    data['type'] = type;
    data['by'] = by;
    data['to'] = to;
    data['id'] = id;
    return data;
  }
}
