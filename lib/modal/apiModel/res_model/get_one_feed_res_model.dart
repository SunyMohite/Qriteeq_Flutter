class GetOneFeedBackResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  GetOneFeedBackResModel({this.status, this.error, this.message, this.data});

  GetOneFeedBackResModel.fromJson(Map<String, dynamic> json) {
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
  List<Results>? results;
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
  String? sId;
  User? user;
  String? sender;
  String? score;
  String? reviewType;
  String? relation;
  String? text;
  String? shared;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? like;
  int? unlike;
  int? comment;
  bool? mylike;
  bool? myunlike;
  bool? mycomment;

  Results(
      {this.sId,
      this.user,
      this.sender,
      this.score,
      this.reviewType,
      this.relation,
      this.text,
      this.shared,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.like,
      this.unlike,
      this.comment,
      this.mylike,
      this.myunlike,
      this.mycomment});

  Results.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    sender = json['sender'];
    score = json['score'];
    reviewType = json['reviewType'];
    relation = json['relation'];
    text = json['text'];
    shared = json['shared'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    like = json['like'];
    unlike = json['unlike'];
    comment = json['comment'];
    mylike = json['mylike'];
    myunlike = json['myunlike'];
    mycomment = json['mycomment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['sender'] = sender;
    data['score'] = score;
    data['reviewType'] = reviewType;
    data['relation'] = relation;
    data['text'] = text;
    data['shared'] = shared;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['like'] = like;
    data['unlike'] = unlike;
    data['comment'] = comment;
    data['mylike'] = mylike;
    data['myunlike'] = myunlike;
    data['mycomment'] = mycomment;
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

class User {
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
  String? fcm;

  User(
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
      this.id,
      this.fcm});

  User.fromJson(Map<String, dynamic> json) {
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
    avatar = json['avatar'] ?? '';
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    username = json['username'] ?? '';
    username = json['username'];
    id = json['id'];
    fcm = json['fcm'];
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
    data['fcm'] = fcm;
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
