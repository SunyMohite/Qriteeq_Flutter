class GetAddressBookResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  GetAddressBookResModel({this.status, this.error, this.message, this.data});

  GetAddressBookResModel.fromJson(Map<String, dynamic> json) {
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
  UserData? userData;

  Data({this.fav, this.userData});

  Data.fromJson(Map<String, dynamic> json) {
    fav = json['fav'] != null ? Fav.fromJson(json['fav']) : null;
    userData = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fav != null) {
      data['fav'] = fav!.toJson();
    }
    if (userData != null) {
      data['data'] = userData!.toJson();
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

class UserData {
  List<Results>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  UserData(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  UserData.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
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

class Results {
  bool? pin;
  bool? favorite;
  bool? hide;
  bool? block;
  String? type;
  By? by;
  To? to;
  String? id;

  Results(
      {this.pin,
      this.favorite,
      this.hide,
      this.block,
      this.type,
      this.by,
      this.to,
      this.id});

  Results.fromJson(Map<String, dynamic> json) {
    pin = json['pin'];
    favorite = json['favorite'];
    hide = json['hide'];
    block = json['block'];
    type = json['type'];
    by = json['by'] != null ? By.fromJson(json['by']) : null;
    to = json['to'] != null ? To.fromJson(json['to']) : null;
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
  Location? location;
  String? role;
  bool? anonymous;
  bool? online;
  int? received;
  int? posted;
  String? phone;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? fcm;
  String? id;

  By(
      {this.location,
      this.role,
      this.anonymous,
      this.online,
      this.received,
      this.posted,
      this.phone,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.fcm,
      this.id});

  By.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    role = json['role'];
    anonymous = json['anonymous'];
    online = json['online'];
    received = json['received'];
    posted = json['posted'];
    phone = json['phone'];
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    fcm = json['fcm'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['role'] = role;
    data['anonymous'] = anonymous;
    data['online'] = online;
    data['received'] = received;
    data['posted'] = posted;
    data['phone'] = phone;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['fcm'] = fcm;
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

class To {
  Location? location;
  String? role;
  bool? anonymous;
  bool? online;
  int? received;
  int? posted;
  String? phone;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? avatar;
  LocationName? locationName;
  String? username;
  String? id;

  To(
      {this.location,
      this.role,
      this.anonymous,
      this.online,
      this.received,
      this.posted,
      this.phone,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.avatar,
      this.locationName,
      this.username,
      this.id});

  To.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    role = json['role'];
    anonymous = json['anonymous'];
    online = json['online'];
    received = json['received'];
    posted = json['posted'];
    phone = json['phone'].toString();
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    avatar = json['avatar'] ?? '';
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    username = json['username'] ?? '';
    username = json['username'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['role'] = role;
    data['anonymous'] = anonymous;
    data['online'] = online;
    data['received'] = received;
    data['posted'] = posted;
    data['phone'] = phone;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['avatar'] = avatar;
    data['locationName'] = locationName;
    data['username'] = username;
    data['id'] = id;
    return data;
  }
}
