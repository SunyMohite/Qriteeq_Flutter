import 'my_feed_back_response_model.dart';

class PostedFeedBackResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  PostedFeedBackResModel({this.status, this.error, this.message, this.data});

  PostedFeedBackResModel.fromJson(Map<String, dynamic> json) {
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
  List<MyFeedBackResults>? results;
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
      results = <MyFeedBackResults>[];
      json['results'].forEach((v) {
        results!.add(MyFeedBackResults.fromJson(v));
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

class MyFeedBackResults {
  List<Document>? document;
  String? sId;
  String? url;
  String? shareLink;
  // String? sender;
  String? score;
  String? reviewType;
  String? relation;
  String? text;
  String? status;
  String? showText;
  String? shared;
  String? createdAt;
  String? updatedAt;
  User? user;
  Sender? senderUser;

  DefaultStatus? defaultStatus;
  BlockStatus? blockStatus;

  int? iV;
  int? like;
  int? unlike;
  int? comment;
  bool? mylike;
  bool? myunlike;
  bool? mycomment;
  bool? anonymous;
  String? mylikeid;
  String? myunlikeid;

  MyFeedBackResults(
      {this.document,
      this.sId,
      this.url,
      this.shareLink,
      this.status,
      // this.sender,
      this.senderUser,
      this.score,
      this.reviewType,
      this.relation,
      this.text,
      this.shared,
      this.showText,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.like,
      this.unlike,
      this.comment,
      this.mylike,
      this.myunlike,
      this.mycomment,
      this.mylikeid,
      this.anonymous,
      this.myunlikeid,
      this.defaultStatus,
      this.blockStatus,
      this.user});

  MyFeedBackResults.fromJson(Map<String, dynamic> json) {
    if (json['document'] != null) {
      document = <Document>[];
      json['document'].forEach((v) {
        document!.add(Document.fromJson(v));
      });
    }
    defaultStatus = json['defaultStatus'] != null
        ? DefaultStatus.fromJson(json['defaultStatus'])
        : null;
    sId = json['_id'];
    url = json['url'];
    showText = json['showText'];
    shareLink = json['shareLink'] ?? '';
    status = json['status'];
    // sender = json['sender'];
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
    myunlikeid = json['myunlikeid'];
    mylikeid = json['mylikeid'];
    anonymous = json['anonymous'] ?? false;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    senderUser =
        json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    blockStatus = json['blockStatus'] != null
        ? BlockStatus.fromJson(json['blockStatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (document != null) {
      data['document'] = document!.map((v) => v.toJson()).toList();
    }
    data['_id'] = sId;
    data['url'] = url;
    data['shareLink'] = shareLink;
    // data['sender'] = sender;
    data['status'] = status;
    if (defaultStatus != null) {
      data['defaultStatus'] = defaultStatus!.toJson();
    }
    data['score'] = score;
    data['showText'] = showText;
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
    data['mycomment'] = mycomment;
    data['anonymous'] = anonymous;
    data['myunlikeid'] = myunlikeid;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (senderUser != null) {
      data['sender'] = senderUser!.toJson();
    }
    if (blockStatus != null) {
      data['blockStatus'] = blockStatus!.toJson();
    }
    return data;
  }
}

class Sender {
  Location? location;
  LocationName? locationName;
  String? url;
  String? role;
  String? avatar;
  String? phone;
  bool? anonymous;
  bool? online;
  bool? active;
  int? received;
  int? posted;
  int? subscribed;
  int? wallet;
  String? countryName;
  String? flagUrl;
  String? profileType;
  String? email;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? fcm;
  String? fullName;
  String? userIdentity;
  String? username;
  String? id;

  Sender(
      {this.location,
      this.locationName,
      this.url,
      this.role,
      this.avatar,
      this.anonymous,
      this.online,
      this.profileType,
      this.flagUrl,
      this.countryName,
      this.active,
      this.received,
      this.posted,
      this.phone,
      this.subscribed,
      this.wallet,
      this.email,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.fcm,
      this.fullName,
      this.userIdentity,
      this.username,
      this.id});

  Sender.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    url = json['url'];
    role = json['role'];
    avatar = json['avatar'] ?? "";
    anonymous = json['anonymous'] ?? false;
    online = json['online'];
    phone = json['phone'];
    countryName = json['countryName'];
    flagUrl = json['flagUrl'];
    profileType = json['profileType'] ?? '';
    received = json['received'];
    posted = json['posted'];
    subscribed = json['subscribed'];
    wallet = json['wallet'];
    email = json['email'];
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    fcm = json['fcm'];
    fullName = json['fullName'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    username = json['username'];
    active = json['active'];
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
    data['phone'] = phone;
    data['role'] = role;
    data['avatar'] = avatar;
    data['anonymous'] = anonymous;
    data['online'] = online;
    data['profileType'] = profileType;
    data['flagUrl'] = flagUrl;
    data['countryName'] = countryName;
    data['received'] = received;
    data['posted'] = posted;
    data['subscribed'] = subscribed;
    data['wallet'] = wallet;
    data['email'] = email;
    data['referral'] = referral;
    data['active'] = active;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['fcm'] = fcm;
    data['fullName'] = fullName;
    data['userIdentity'] = userIdentity;
    data['username'] = username;
    data['id'] = id;
    return data;
  }
}

class Document {
  String? sId;
  String? ext;
  String? url;

  Document({this.sId, this.ext, this.url});

  Document.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    ext = json['ext'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['ext'] = ext;
    data['url'] = url;
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
  bool? active;
  int? received;

  int? posted;
  String? phone;
  String? referral;
  String? profileType;
  String? flagUrl;
  String? countryName;
  String? lastlogin;
  String? currentlogin;
  String? fcm;
  String? avatar;
  LocationName? locationName;
  String? username;
  String? fullName;
  String? userIdentity;
  String? id;

  User(
      {this.location,
      this.role,
      this.anonymous,
      this.online,
      this.profileType,
      this.fullName,
      this.countryName,
      this.userIdentity,
      this.active,
      this.flagUrl,
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

  User.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    role = json['role'];
    anonymous = json['anonymous'];
    online = json['online'];
    received = json['received'];
    profileType = json['profileType'] ?? '';
    flagUrl = json['flagUrl'];
    posted = json['posted'];
    active = json['active'];
    countryName = json['countryName'];
    fullName = json['fullName'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    phone = json['phone'];
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    fcm = json['fcm'] ?? "";
    avatar = json['avatar'] ?? '';
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    username = json['username'] ?? '';
    username = json['username'] ?? "";

    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['role'] = role;
    data['fullName'] = fullName;
    data['userIdentity'] = userIdentity;
    data['anonymous'] = anonymous;
    data['online'] = online;
    data['profileType'] = profileType;
    data['received'] = received;
    data['posted'] = posted;
    data['flagUrl'] = flagUrl;
    data['phone'] = phone;
    data['countryName'] = countryName;
    data['referral'] = referral;
    data['active'] = active;
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
