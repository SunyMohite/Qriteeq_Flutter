class GetFavoriteResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  GetFavoriteResModel({this.status, this.error, this.message, this.data});

  GetFavoriteResModel.fromJson(Map<String, dynamic> json) {
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
  UnFavoriteData? unFavoriteData;

  Data({this.fav, this.unFavoriteData});

  Data.fromJson(Map<String, dynamic> json) {
    fav = json['fav'] != null ? Fav.fromJson(json['fav']) : null;
    unFavoriteData =
        json['data'] != null ? UnFavoriteData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fav != null) {
      data['fav'] = fav!.toJson();
    }
    if (unFavoriteData != null) {
      data['data'] = unFavoriteData!.toJson();
    }
    return data;
  }
}

class Fav {
  List<FavResults>? results;
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
    if (json['results'] != null) {
      results = <FavResults>[];
      json['results'].forEach((v) {
        results!.add(FavResults.fromJson(v));
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

class FavResults {
  bool? pin;
  bool? favorite;
  bool? hide;
  bool? block;
  bool? flag;
  String? type;
  By? by;
  By? to;
  String? id;
  String? maskData;

  FavResults(
      {this.pin,
      this.favorite,
      this.hide,
      this.block,
      this.flag,
      this.type,
      this.by,
      this.to,
      this.maskData,
      this.id});

  FavResults.fromJson(Map<String, dynamic> json) {
    pin = json['pin'];
    favorite = json['favorite'];
    hide = json['hide'];
    block = json['block'];
    flag = json['flag'];
    type = json['type'];
    by = json['by'] != null ? By.fromJson(json['by']) : null;
    to = json['to'] != null ? By.fromJson(json['to']) : null;
    id = json['id'];
    maskData = json['maskData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pin'] = pin;
    data['favorite'] = favorite;
    data['hide'] = hide;
    data['block'] = block;
    data['flag'] = flag;
    data['type'] = type;
    if (by != null) {
      data['by'] = by!.toJson();
    }
    if (to != null) {
      data['to'] = to!.toJson();
    }
    data['id'] = id;
    data['maskData'] = maskData;
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

class By {
  Location? location;
  String? role;
  bool? anonymous;
  bool? online;
  bool? active;
  int? received;
  int? posted;
  String? phone;
  String? email;
  String? profileUrl;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? fcm;
  String? fullName;
  String? userIdentity;
  String? avatar;
  LocationName? locationName;
  String? username;
  String? id;

  By(
      {this.location,
      this.role,
      this.anonymous,
      this.online,
      this.received,
      this.posted,
      this.phone,
      this.email,
      this.referral,
      this.fullName,
      this.userIdentity,
      this.lastlogin,
      this.active,
      this.currentlogin,
      this.fcm,
      this.profileUrl,
      this.avatar,
      this.locationName,
      this.username,
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
    email = json['email'];
    profileUrl = json['profileUrl'];
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    active = json['active'];
    fullName = json['fullName'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    fcm = json['fcm'] ?? "";
    avatar = json['avatar']??'';
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
    data['active'] = active;
    data['posted'] = posted;
    data['phone'] = phone;
    data['email'] = email;
    data['profileUrl'] = profileUrl;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['fcm'] = fcm;
    data['fullName'] = fullName;
    data['userIdentity'] = userIdentity;
    data['avatar'] = avatar;
    data['locationName'] = locationName;
    data['username'] = username;
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

class UnFavoriteData {
  List<DataResult>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  UnFavoriteData(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  UnFavoriteData.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <DataResult>[];
      json['results'].forEach((v) {
        results!.add(DataResult.fromJson(v));
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

class DataResult {
  bool? pin;
  bool? favorite;
  bool? hide;
  bool? block;
  String? type;
  DataBy? by;
  DataBy? to;
  String? id;

  DataResult(
      {this.pin,
      this.favorite,
      this.hide,
      this.block,
      this.type,
      this.by,
      this.to,
      this.id});

  DataResult.fromJson(Map<String, dynamic> json) {
    pin = json['pin'];
    favorite = json['favorite'];
    hide = json['hide'];
    block = json['block'];
    type = json['type'];
    by = json['by'] != null ? DataBy.fromJson(json['by']) : null;
    to = json['to'] != null ? DataBy.fromJson(json['to']) : null;
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

class DataBy {
  DataLocation? location;
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
  String? avatar;
  LocationName? locationName;
  String? username;
  String? id;

  DataBy(
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
      this.avatar,
      this.locationName,
      this.username,
      this.id});

  DataBy.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? DataLocation.fromJson(json['location'])
        : null;
    role = json['role'];
    anonymous = json['anonymous'];
    online = json['online'];
    received = json['received'];
    posted = json['posted'];
    phone = json['phone'];
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    fcm = json['fcm'] ?? "";
    avatar = json['avatar']??'';
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
    data['fcm'] = fcm;
    data['avatar'] = avatar;
    data['locationName'] = locationName;
    data['username'] = username;
    data['id'] = id;
    return data;
  }
}

class DataLocation {
  List<int>? coordinates;
  String? type;

  DataLocation({this.coordinates, this.type});

  DataLocation.fromJson(Map<String, dynamic> json) {
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
