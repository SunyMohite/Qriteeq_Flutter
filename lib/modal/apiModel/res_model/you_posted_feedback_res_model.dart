import 'package:humanscoring/modal/apiModel/res_model/my_feed_back_response_model.dart';

class YouPostedFeedBackResModel {
  int? status;
  bool? error;
  String? message;
  YouPostedFeedBackData? data;

  YouPostedFeedBackResModel({this.status, this.error, this.message, this.data});

  YouPostedFeedBackResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null
        ? YouPostedFeedBackData.fromJson(json['data'])
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

class YouPostedFeedBackData {
  YoursFeedback? feedback;

  YouPostedFeedBackData({this.feedback});

  YouPostedFeedBackData.fromJson(Map<String, dynamic> json) {
    feedback = json['feedback'] != null
        ? YoursFeedback.fromJson(json['feedback'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (feedback != null) {
      data['feedback'] = feedback!.toJson();
    }
    return data;
  }
}

class YoursFeedback {
  List<YoursFeedbackPostedResults>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  YoursFeedback(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  YoursFeedback.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <YoursFeedbackPostedResults>[];
      json['results'].forEach((v) {
        results!.add(YoursFeedbackPostedResults.fromJson(v));
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

class YoursFeedbackPostedResults {
  MetaData? metaData;
  String? status;
  String? feedText;
  String? sId;
  String? shareLink;
  Sender? sender;
  List<Document>? document;
  String? score;
  String? reviewType;
  String? relation;
  String? showText;
  String? text;
  String? shared;
  User? user;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? like;
  int? unlike;
  int? comment;
  bool? mylike;
  bool? myunlike;
  bool? mycomment;
  bool? disputeStatus;
  bool? anonymous;
  String? mylikeid;
  String? myunlikeid;
  DefaultStatus? defaultStatus;

  YoursFeedbackPostedResults(
      {this.metaData,
      this.status,
      this.sId,
      this.sender,
      this.document,
      this.score,
      this.shareLink,
      this.disputeStatus,
      this.reviewType,
      this.relation,
      this.showText,
      this.text,
      this.shared,
      this.user,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.like,
      this.unlike,
      this.comment,
      this.mylikeid,
      this.mylike,
      this.myunlike,
      this.myunlikeid,
      this.defaultStatus,
      this.anonymous,
      this.feedText,
      this.mycomment});

  YoursFeedbackPostedResults.fromJson(Map<String, dynamic> json) {
    metaData =
        json['metaData'] != null ? MetaData.fromJson(json['metaData']) : null;
    status = json['status'];
    shareLink = json['shareLink'] ?? '';
    sId = json['_id'];
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    if (json['document'] != null) {
      document = <Document>[];
      json['document'].forEach((v) {
        document!.add(Document.fromJson(v));
      });
    }
    score = json['score'];
    reviewType = json['reviewType'];
    disputeStatus = json['disputeStatus'];
    relation = json['relation'];
    showText = json['showText'];
    text = json['text'];
    shared = json['shared'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    like = json['like'];
    feedText = json['feedText'];
    unlike = json['unlike'];
    comment = json['comment'];
    anonymous = json['anonymous'] ?? false;
    mylike = json['mylike'];
    myunlike = json['myunlike'];
    mycomment = json['mycomment'];
    mylikeid = json['mylikeid'] ?? "";
    myunlikeid = json['myunlikeid'] ?? '';
    defaultStatus = json['defaultStatus'] != null
        ? DefaultStatus.fromJson(json['defaultStatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (metaData != null) {
      data['metaData'] = metaData!.toJson();
    }
    data['status'] = status;
    data['shareLink'] = shareLink;
    data['_id'] = sId;
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    if (document != null) {
      data['document'] = document!.map((v) => v.toJson()).toList();
    }
    data['score'] = score;
    data['reviewType'] = reviewType;
    data['relation'] = relation;
    data['showText'] = showText;
    data['disputeStatus'] = disputeStatus;
    data['text'] = text;
    data['feedText'] = feedText;
    data['shared'] = shared;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['like'] = like;
    data['unlike'] = unlike;
    data['comment'] = comment;
    data['anonymous'] = anonymous;
    data['mylike'] = mylike;
    data['myunlike'] = myunlike;
    data['mycomment'] = mycomment;
    data['mylikeid'] = mylikeid;
    data['myunlikeid'] = myunlikeid;
    if (defaultStatus != null) {
      data['defaultStatus'] = defaultStatus!.toJson();
    }
    return data;
  }
}

class MetaData {
  int? likeCount;
  int? unlikeCount;
  int? commentCount;
  int? flagCount;

  MetaData(
      {this.likeCount, this.unlikeCount, this.commentCount, this.flagCount});

  MetaData.fromJson(Map<String, dynamic> json) {
    likeCount = json['likeCount'];
    unlikeCount = json['unlikeCount'];
    commentCount = json['commentCount'];
    flagCount = json['flagCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['likeCount'] = likeCount;
    data['unlikeCount'] = unlikeCount;
    data['commentCount'] = commentCount;
    data['flagCount'] = flagCount;
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

class User {
  Location? location;
  LocationName? locationName;
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
  String? countryName;
  String? flagUrl;
  String? profileType;

  String? lastlogin;
  String? currentlogin;
  String? fcm;
  String? username;
  String? fullName;
  String? userIdentity;
  String? id;

  User(
      {this.location,
      this.locationName,
      this.url,
      this.role,
      this.avatar,
      this.anonymous,
      this.fullName,
      this.userIdentity,
      this.countryName,
      this.flagUrl,
      this.profileType,
      this.online,
      this.received,
      this.posted,
      this.active,
      this.subscribed,
      this.wallet,
      this.phone,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.fcm,
      this.username,
      this.id});

  User.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    url = json['url'];
    role = json['role'];
    avatar = json['avatar'] ?? '';
    fullName = json['fullName'];
    profileType = json['profileType'] ?? '';
    flagUrl = json['flagUrl'];
    countryName = json['countryName'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    anonymous = json['anonymous'];
    online = json['online'];
    active = json['active'];
    received = json['received'];
    posted = json['posted'];
    subscribed = json['subscribed'];
    wallet = json['wallet'];
    phone = json['phone'];
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    fcm = json['fcm'];
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
    data['fullName'] = fullName;
    data['userIdentity'] = userIdentity;
    data['avatar'] = avatar;
    data['anonymous'] = anonymous;
    data['online'] = online;
    data['received'] = received;
    data['posted'] = posted;
    data['active'] = active;
    data['countryName'] = countryName;
    data['flagUrl'] = flagUrl;
    data['profileType'] = profileType;
    data['subscribed'] = subscribed;
    data['wallet'] = wallet;
    data['phone'] = phone;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['fcm'] = fcm;
    data['username'] = username;
    data['id'] = id;
    return data;
  }
}
