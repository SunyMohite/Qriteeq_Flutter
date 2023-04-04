class GetSearchResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  GetSearchResModel({this.status, this.error, this.message, this.data});

  GetSearchResModel.fromJson(Map<String, dynamic> json) {
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
  List<SearchResults>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  Data(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <SearchResults>[];
      json['results'].forEach((v) {
        results!.add(SearchResults.fromJson(v));
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

class SearchResults {
  Location? location;
  String? role;
  bool? anonymous;
  bool? online;
  bool? active;
  int? received;
  int? posted;
  String? sId;
  String? phone;
  String? email;
  String? maskData;
  String? profileUrl;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? avatar;
  LocationName? locationName;
  String? username;
  String? fcm;
  String? fullName;
  String? userIdentity;
  bool? connected;
  SearchDefaultStatus? defaultStatus;

  SearchResults(
      {this.location,
      this.role,
      this.anonymous,
      this.online,
      this.active,
      this.received,
      this.posted,
      this.sId,
      this.email,
      this.fullName,
      this.userIdentity,
      this.phone,
      this.maskData,
      this.profileUrl,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.avatar,
      this.locationName,
      this.username,
      this.fcm,
      this.defaultStatus,
      this.connected});

  SearchResults.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    role = json['role'];
    anonymous = json['anonymous'];
    online = json['online'];
    active = json['active'];
    received = json['received'];
    email = json['email'];
    posted = json['posted'];
    sId = json['_id'];
    phone = json['phone'];
    maskData = json['maskData'];
    profileUrl = json['profileUrl'];
    referral = json['referral'];
    fullName = json['fullName'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    avatar = json['avatar'] ?? '';
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    username = json['username'] ?? '';
    fcm = json['fcm'];
    connected = json['connected'];
    defaultStatus = json['defaultStatus'] != null
        ? SearchDefaultStatus.fromJson(json['defaultStatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['role'] = role;
    data['anonymous'] = anonymous;
    data['online'] = online;
    data['active'] = active;
    data['received'] = received;
    data['email'] = email;
    data['maskData'] = maskData;
    data['profileUrl'] = profileUrl;
    data['fullName'] = fullName;
    data['userIdentity'] = userIdentity;
    data['posted'] = posted;
    data['_id'] = sId;
    data['phone'] = phone;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['avatar'] = avatar;
    data['locationName'] = locationName;
    data['username'] = username;
    data['fcm'] = fcm;
    data['connected'] = connected;
    if (defaultStatus != null) {
      data['defaultStatus'] = defaultStatus!.toJson();
    }
    return data;
  }
}

class SearchDefaultStatus {
  bool? pin;
  bool? favorite;
  bool? hide;
  bool? block;
  bool? flag;
  String? type;
  String? by;

  SearchDefaultStatus(
      {this.pin, this.favorite, this.hide, this.block, this.type, this.by});

  SearchDefaultStatus.fromJson(Map<String, dynamic> json) {
    pin = json['pin'];
    favorite = json['favorite'];
    hide = json['hide'];
    block = json['block'];
    flag = json['flag'];
    type = json['type'];
    by = json['by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pin'] = pin;
    data['favorite'] = favorite;
    data['hide'] = hide;
    data['block'] = block;
    data['flag'] = flag;
    data['type'] = type;
    data['by'] = by;
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
