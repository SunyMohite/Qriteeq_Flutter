import 'package:humanscoring/modal/apiModel/res_model/my_feed_back_response_model.dart';

import 'global_feedback_res_model.dart';

class GetFeedBackDetailsResModel {
  int? status;
  bool? error;
  String? message;
  GetFeedBackDetailsData? data;

  GetFeedBackDetailsResModel(
      {this.status, this.error, this.message, this.data});

  GetFeedBackDetailsResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null
        ? GetFeedBackDetailsData.fromJson(json['data'])
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

// 6311e3adc4441f233690b0fa
class GetFeedBackDetailsData {
  MetaData? metaData;
  String? status;
  User? user;
  User? sender;
  bool? anonymous;
  List<Document>? document;
  String? score;
  String? reviewType;
  String? relation;
  String? text;
  String? shared;
  String? shareLink;
  String? id;
  bool? mycomment;
  bool? mylike;
  bool? myunlike;
  bool? isUnlocked;
  bool? disputeStatus;
  String? feedText;
  String? mylikeid;
  String? myunlikeid;
  String? flagReason;
  DefaultStatus? defaultStatus;
  SenderReceiverBlockStatus? senderReceiverBlockStatus;

  GetFeedBackDetailsData(
      {this.metaData,
      this.status,
      this.user,
      this.sender,
      this.document,
      this.feedText,
      this.score,
      this.reviewType,
      this.relation,
      this.text,
      this.shared,
      this.shareLink,
      this.mycomment,
      this.mylike,
      this.myunlike,
      this.myunlikeid,
      this.mylikeid,
      this.defaultStatus,
      this.isUnlocked,
      this.flagReason,
      this.disputeStatus,
      this.senderReceiverBlockStatus,
      this.anonymous,
      this.id});

  GetFeedBackDetailsData.fromJson(Map<String, dynamic> json) {
    metaData =
        json['metaData'] != null ? MetaData.fromJson(json['metaData']) : null;
    defaultStatus = json['defaultStatus'] != null
        ? DefaultStatus.fromJson(json['defaultStatus'])
        : null;
    status = json['status'];
    feedText = json['feedText'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    sender = json['sender'] != null ? User.fromJson(json['sender']) : null;
    if (json['document'] != null) {
      document = <Document>[];
      json['document'].forEach((v) {
        document!.add(Document.fromJson(v));
      });
    }
    score = json['score'];
    reviewType = json['reviewType'];
    relation = json['relation'];
    flagReason = json['flagReason'];
    disputeStatus = json['disputeStatus'];
    text = json['text'];
    shared = json['shared'];
    shareLink = json['shareLink'] ?? '';
    mycomment = json['mycomment'];
    id = json['id'];
    mylike = json['mylike'];
    myunlike = json['myunlike'];
    isUnlocked = json['isUnlocked'] ?? false;
    anonymous = json['anonymous'] ?? false;
    myunlikeid = json['myunlikeid'] ?? "";
    mylikeid = json['mylikeid'] ?? "";
    senderReceiverBlockStatus = json['blockStatus'] != null
        ? SenderReceiverBlockStatus.fromJson(json['blockStatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (metaData != null) {
      data['metaData'] = metaData!.toJson();
    }
    data['status'] = status;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    if (document != null) {
      data['document'] = document!.map((v) => v.toJson()).toList();
    }
    if (defaultStatus != null) {
      data['defaultStatus'] = defaultStatus!.toJson();
    }
    data['feedText'] = feedText;
    data['score'] = score;
    data['reviewType'] = reviewType;
    data['relation'] = relation;
    data['disputeStatus'] = disputeStatus;
    data['text'] = text;
    data['flagReason'] = flagReason;
    data['shared'] = shared;
    data['shareLink'] = shareLink;
    data['id'] = id;
    data['mycomment'] = mycomment;
    data['mylike'] = mylike;
    data['myunlikeid'] = myunlikeid;
    data['mylikeid'] = mylikeid;
    data['anonymous'] = anonymous;
    data['isUnlocked'] = isUnlocked;
    if (senderReceiverBlockStatus != null) {
      data['blockStatus'] = senderReceiverBlockStatus!.toJson();
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

class User {
  Location? location;
  LocationName? locationName;
  String? url;
  String? role;
  String? avatar;
  bool? anonymous;
  bool? online;
  int? received;
  int? posted;
  int? subscribed;
  int? wallet;
  bool? active;
  String? phone;
  String? email;
  String? profileUrl;
  String? referral;
  String? countryName;
  String? flagUrl;
  String? profileType;
  String? lastlogin;
  String? currentlogin;
  String? fcm;

  String? fullName;
  String? userIdentity;
  String? username;
  String? id;

  User(
      {this.location,
      this.locationName,
      this.url,
      this.role,
      this.avatar,
      this.anonymous,
      this.online,
      this.received,
      this.posted,
      this.subscribed,
      this.wallet,
      this.active,
      this.phone,
      this.profileUrl,
      this.profileType,
      this.flagUrl,
      this.countryName,
      this.email,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.fcm,
      this.fullName,
      this.userIdentity,
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
    anonymous = json['anonymous'];
    online = json['online'];
    received = json['received'];
    posted = json['posted'];
    subscribed = json['subscribed'];
    wallet = json['wallet'];
    active = json['active'];
    phone = json['phone'];
    profileUrl = json['profileUrl'];
    email = json['email'];
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    fcm = json['fcm'];
    countryName = json['countryName'];
    flagUrl = json['flagUrl'];
    profileType = json['profileType'] ?? '';
    fullName = json['fullName'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
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
    data['avatar'] = avatar;
    data['anonymous'] = anonymous;
    data['online'] = online;
    data['received'] = received;
    data['posted'] = posted;
    data['subscribed'] = subscribed;
    data['wallet'] = wallet;
    data['active'] = active;
    data['phone'] = phone;
    data['email'] = email;
    data['profileUrl'] = profileUrl;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['fcm'] = fcm;
    data['profileType'] = profileType;
    data['flagUrl'] = flagUrl;
    data['countryName'] = countryName;
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
