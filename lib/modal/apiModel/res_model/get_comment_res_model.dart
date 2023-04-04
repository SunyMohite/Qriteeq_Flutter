import 'my_feed_back_response_model.dart';

class GetCommentResModel {
  int? status;
  bool? error;
  String? message;
  GetCommentData? data;

  GetCommentResModel({this.status, this.error, this.message, this.data});

  GetCommentResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? GetCommentData.fromJson(json['data']) : null;
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

class GetCommentData {
  List<GetCommentResults>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  GetCommentData(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  GetCommentData.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <GetCommentResults>[];
      json['results'].forEach((v) {
        results!.add(GetCommentResults.fromJson(v));
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

class GetCommentResults {
  String? status;
  CommentUser? user;
  CommentFeedback? feedback;
  String? ftype;
  String? text;
  String? id;
  String? createdAt;
  String? updatedAt;
  DefaultSender? defaultStatus;
  BlockStatus? blockStatus;

  GetCommentResults(
      {this.status,
      this.user,
      this.feedback,
      this.ftype,
      this.text,
      this.id,
      this.defaultStatus,
      this.blockStatus,
      this.updatedAt,
      this.createdAt});

  GetCommentResults.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? CommentUser.fromJson(json['user']) : null;
    feedback = json['feedback'] != null
        ? CommentFeedback.fromJson(json['feedback'])
        : null;
    ftype = json['ftype'];
    text = json['text'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    id = json['_id'];
    defaultStatus = json['defaultStatus'] != null
        ? DefaultSender.fromJson(json['defaultStatus'])
        : null;
    blockStatus = json['blockStatus'] != null
        ? BlockStatus.fromJson(json['blockStatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (defaultStatus != null) {
      data['defaultStatus'] = defaultStatus!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (feedback != null) {
      data['feedback'] = feedback!.toJson();
    }
    data['ftype'] = ftype;
    data['text'] = text;
    data['id'] = id;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    if (blockStatus != null) {
      data['blockStatus'] = blockStatus!.toJson();
    }
    return data;
  }
}

class CommentUser {
  CommentLocation? location;
  CommentLocationName? locationName;
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
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? fcm;
  String? flagUrl;
  String? countryName;
  String? fullName;
  String? userIdentity;
  String? username;
  String? id;
  String? profileType;

  CommentUser(
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
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.fcm,
      this.flagUrl,
      this.countryName,
      this.fullName,
      this.userIdentity,
      this.profileType,
      this.username,
      this.id});

  CommentUser.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? CommentLocation.fromJson(json['location'])
        : null;
    locationName = json['locationName'] != null
        ? CommentLocationName.fromJson(json['locationName'])
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
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    countryName = json['countryName'];
    currentlogin = json['currentlogin'];
    fcm = json['fcm'];
    flagUrl = json['flagUrl'];
    fullName = json['fullName'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    username = json['username'];
    profileType = json['profileType'] ?? '';
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
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['fcm'] = fcm;
    data['flagUrl'] = flagUrl;
    data['fullName'] = fullName;
    data['userIdentity'] = userIdentity;
    data['username'] = username;
    data['countryName'] = countryName;
    data['profileType'] = profileType;
    data['id'] = id;
    return data;
  }
}

class FeedBackUser {
  CommentLocation? location;
  CommentLocationName? locationName;
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
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? fcm;
  String? flagUrl;
  String? fullName;
  String? userIdentity;
  String? username;
  String? id;

  FeedBackUser(
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
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.fcm,
      this.flagUrl,
      this.fullName,
      this.userIdentity,
      this.username,
      this.id});

  FeedBackUser.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? CommentLocation.fromJson(json['location'])
        : null;
    locationName = json['locationName'] != null
        ? CommentLocationName.fromJson(json['locationName'])
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
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    fcm = json['fcm'];
    flagUrl = json['flagUrl'];
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
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['fcm'] = fcm;
    data['flagUrl'] = flagUrl;
    data['fullName'] = fullName;
    data['userIdentity'] = userIdentity;
    data['username'] = username;
    data['id'] = id;
    return data;
  }
}

class CommentLocation {
  List<double>? coordinates;
  String? type;

  CommentLocation({this.coordinates, this.type});

  CommentLocation.fromJson(Map<String, dynamic> json) {
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

class CommentLocationName {
  String? address;
  String? state;

  CommentLocationName({this.address, this.state});

  CommentLocationName.fromJson(Map<String, dynamic> json) {
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

class CommentFeedback {
  MetaData? metaData;
  String? status;
  FeedBackUser? user;
  String? sender;
  List<Document>? document;
  String? score;
  String? reviewType;
  String? relation;
  String? text;
  String? shared;
  String? moderator;
  String? id;

  CommentFeedback(
      {this.metaData,
      this.status,
      this.user,
      this.sender,
      this.document,
      this.score,
      this.reviewType,
      this.relation,
      this.text,
      this.shared,
      this.moderator,
      this.id});

  CommentFeedback.fromJson(Map<String, dynamic> json) {
    metaData =
        json['metaData'] != null ? MetaData.fromJson(json['metaData']) : null;
    status = json['status'];
    user = json['user'] != null ? FeedBackUser.fromJson(json['user']) : null;
    sender = json['sender'];
    if (json['document'] != null) {
      document = <Document>[];
      json['document'].forEach((v) {
        document!.add(Document.fromJson(v));
      });
    }
    score = json['score'];
    reviewType = json['reviewType'];
    relation = json['relation'];
    text = json['text'];
    shared = json['shared'];
    moderator = json['moderator'];
    id = json['id'];
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
    data['sender'] = sender;
    if (document != null) {
      data['document'] = document!.map((v) => v.toJson()).toList();
    }
    data['score'] = score;
    data['reviewType'] = reviewType;
    data['relation'] = relation;
    data['text'] = text;
    data['shared'] = shared;
    data['moderator'] = moderator;
    data['id'] = id;
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
