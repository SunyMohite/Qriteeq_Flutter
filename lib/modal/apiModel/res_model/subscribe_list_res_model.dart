class SubscribeListResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  SubscribeListResModel({this.status, this.error, this.message, this.data});

  SubscribeListResModel.fromJson(Map<String, dynamic> json) {
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
  Fav? fav;
  SubscribeData? data;

  Data({this.fav, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    fav = json['fav'] != null ? Fav.fromJson(json['fav']) : null;
    data = json['data'] != null ? SubscribeData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fav != null) {
      data['fav'] = fav!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Fav {
  List<String>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  Fav(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  Fav.fromJson(Map<String, dynamic> json) {
    results = json['results'].cast<String>();
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = results;
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    return data;
  }
}

class SubscribeData {
  List<SubScribeResults>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  SubscribeData(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  SubscribeData.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <SubScribeResults>[];
      json['results'].forEach((v) {
        results!.add(SubScribeResults.fromJson(v));
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

class SubScribeResults {
  bool? pin;
  bool? favorite;
  bool? hide;
  bool? block;
  String? type;
  By? by;
  By? to;
  String? id;

  SubScribeResults(
      {this.pin,
      this.favorite,
      this.hide,
      this.block,
      this.type,
      this.by,
      this.to,
      this.id});

  SubScribeResults.fromJson(Map<String, dynamic> json) {
    pin = json['pin'];
    favorite = json['favorite'];
    hide = json['hide'];
    block = json['block'];
    type = json['type'];
    by = json['by'] != null ? By.fromJson(json['by']) : null;
    to = json['to'] != null ? By.fromJson(json['to']) : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pin'] = pin;
    data['favorite'] = favorite;
    data['hide'] = hide;
    data['block'] = block;
    data['type'] = type;
    if (by != null) {
      data['by'] = by!.toJson();
    }
    if (to != null) {
      data['to'] = to!.toJson();
    }
    data['id'] = id;
    return data;
  }
}

class By {
  SubscribeDataLocation? location;
  SubscribeDataLocationName? locationName;
  String? url;
  String? role;
  bool? anonymous;
  bool? online;
  int? received;
  int? posted;
  int? subscribed;
  String? phone;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? fcm;
  String? avatar;
  String? username;
  String? id;

  By(
      {this.location,
      this.locationName,
      this.url,
      this.role,
      this.anonymous,
      this.online,
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
      this.id});

  By.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? SubscribeDataLocation.fromJson(json['location'])
        : null;
    locationName = json['locationName'] != null
        ? SubscribeDataLocationName.fromJson(json['locationName'])
        : null;
    url = json['url'];
    role = json['role'];
    anonymous = json['anonymous'];
    online = json['online'];
    received = json['received'];
    posted = json['posted'];
    subscribed = json['subscribed'];
    phone = json['phone'];
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    fcm = json['fcm'];
    avatar = json['avatar'] ?? '';
    username = json['username'];
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
    data['anonymous'] = anonymous;
    data['online'] = online;
    data['received'] = received;
    data['posted'] = posted;
    data['subscribed'] = subscribed;
    data['phone'] = phone;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['fcm'] = fcm;
    data['avatar'] = avatar;
    data['username'] = username;
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

class SubscribeDataLocation {
  List<int>? coordinates;
  String? type;

  SubscribeDataLocation({this.coordinates, this.type});

  SubscribeDataLocation.fromJson(Map<String, dynamic> json) {
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

class SubscribeDataLocationName {
  String? address;
  String? state;
  String? country;

  SubscribeDataLocationName({this.address, this.state, this.country});

  SubscribeDataLocationName.fromJson(Map<String, dynamic> json) {
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
