class YourInteractionsResModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  YourInteractionsResModel({this.status, this.error, this.message, this.data});

  YourInteractionsResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<YourInteractionsData>? results;
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
      results = <YourInteractionsData>[];
      json['results'].forEach((v) {
        results!.add(YourInteractionsData.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
  }
}

class YourInteractionsData {
  String? sId;
  int? count;
  List<YourInteractionsDataCount>? data;

  YourInteractionsData({this.sId, this.count, this.data});

  YourInteractionsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    count = json['count'];
    if (json['data'] != null) {
      data = <YourInteractionsDataCount>[];
      json['data'].forEach((v) {
        data!.add(YourInteractionsDataCount.fromJson(v));
      });
    }
  }
}

class YourInteractionsDataCount {
  String? sId;
  String? status;
  List<String>? othersWhoFlagged;
  User? user;
  Feedback? feedback;
  String? ftype;
  String? reason;
  String? flagged;
  String? createdAt;
  String? updatedAt;
  int? iV;
  FeedbackUser? feedbackUser;
  String? date;
  String? showText;
  DefaultStatus? defaultStatus;
  BlockStatus? blockStatus;

  YourInteractionsDataCount(
      {this.sId,
      this.status,
      this.othersWhoFlagged,
      this.user,
      this.feedback,
      this.ftype,
      this.reason,
      this.flagged,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.feedbackUser,
      this.date,
      this.showText,
      this.defaultStatus,
      this.blockStatus});

  YourInteractionsDataCount.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    status = json['status'];
    othersWhoFlagged = json['othersWhoFlagged'].cast<String>();
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    feedback =
        json['feedback'] != null ? Feedback.fromJson(json['feedback']) : null;
    ftype = json['ftype'];
    reason = json['reason'];
    flagged = json['flagged'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    feedbackUser = json['feedback_user'] != null
        ? FeedbackUser.fromJson(json['feedback_user'])
        : null;
    date = json['date'];
    showText = json['showText'];
    defaultStatus = json['defaultStatus'] != null
        ? DefaultStatus.fromJson(json['defaultStatus'])
        : null;
    blockStatus = json['blockStatus'] != null
        ? BlockStatus.fromJson(json['blockStatus'])
        : null;
  }
}

class User {
  String? sId;
  Location? location;
  String? url;
  String? role;
  String? avatar;
  bool? anonymous;
  bool? online;
  int? received;
  int? posted;
  int? subscribed;
  int? wallet;
  int? referralBalance;
  int? recentCoins;
  bool? autoApprove;
  bool? active;
  String? phone;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? countryCode;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? userIdentity;
  String? fcm;
  String? flagUrl;
  String? fullName;
  LocationName? locationName;
  String? username;
  String? lastOnlineTime;
  String? lastFeedbackTime;
  bool? generateReportOption;

  User(
      {this.sId,
      this.location,
      this.url,
      this.role,
      this.avatar,
      this.anonymous,
      this.online,
      this.received,
      this.posted,
      this.subscribed,
      this.wallet,
      this.referralBalance,
      this.recentCoins,
      this.autoApprove,
      this.active,
      this.phone,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.countryCode,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.userIdentity,
      this.fcm,
      this.flagUrl,
      this.fullName,
      this.locationName,
      this.username,
      this.lastOnlineTime,
      this.lastFeedbackTime,
      this.generateReportOption});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
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
    referralBalance = json['referralBalance'];
    recentCoins = json['recentCoins'];
    autoApprove = json['autoApprove'];
    active = json['active'];
    phone = json['phone'];
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    countryCode = json['countryCode'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    fcm = json['fcm'];
    flagUrl = json['flagUrl'];
    fullName = json['fullName'];
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    username = json['username'];
    lastOnlineTime = json['lastOnlineTime'];
    lastFeedbackTime = json['lastFeedbackTime'];
    generateReportOption = json['generateReportOption'];
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

class Feedback {
  String? sId;
  MetaData? metaData;
  String? status;
  String? user;
  String? sender;
  List<Document>? document;
  String? score;
  String? reviewType;
  String? relation;
  String? text;
  String? shared;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? shareLink;
  String? moderator;

  Feedback(
      {this.sId,
      this.metaData,
      this.status,
      this.user,
      this.sender,
      this.document,
      this.score,
      this.reviewType,
      this.relation,
      this.text,
      this.shared,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.shareLink,
      this.moderator});

  Feedback.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    metaData =
        json['metaData'] != null ? MetaData.fromJson(json['metaData']) : null;
    status = json['status'];
    user = json['user'];
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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    shareLink = json['shareLink'];
    moderator = json['moderator'];
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
}

class FeedbackUser {
  String? sId;
  Location? location;
  String? url;
  String? role;
  String? avatar;
  bool? anonymous;
  bool? online;
  int? received;
  int? posted;
  int? subscribed;
  int? wallet;
  int? referralBalance;
  int? recentCoins;
  bool? autoApprove;
  bool? trustScoreStatic;
  bool? generateReportOption;
  bool? active;
  String? profileUrl;
  String? profileUrlType;
  String? referral;
  String? fullName;
  String? username;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? userIdentity;
  String? phone;
  String? lastlogin;
  String? currentlogin;
  String? countryCode;
  String? fcm;
  String? flagUrl;
  LocationName? locationName;
  String? lastOnlineTime;
  String? lastFeedbackTime;

  FeedbackUser(
      {this.sId,
      this.location,
      this.url,
      this.role,
      this.avatar,
      this.anonymous,
      this.online,
      this.received,
      this.posted,
      this.subscribed,
      this.wallet,
      this.referralBalance,
      this.recentCoins,
      this.autoApprove,
      this.trustScoreStatic,
      this.generateReportOption,
      this.active,
      this.profileUrl,
      this.profileUrlType,
      this.referral,
      this.fullName,
      this.username,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.userIdentity,
      this.phone,
      this.lastlogin,
      this.currentlogin,
      this.countryCode,
      this.fcm,
      this.flagUrl,
      this.locationName,
      this.lastOnlineTime,
      this.lastFeedbackTime});

  FeedbackUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
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
    referralBalance = json['referralBalance'];
    recentCoins = json['recentCoins'];
    autoApprove = json['autoApprove'];
    trustScoreStatic = json['trustScoreStatic'];
    generateReportOption = json['generateReportOption'];
    active = json['active'];
    profileUrl = json['profileUrl'];
    profileUrlType = json['profileUrlType'];
    referral = json['referral'];
    fullName = json['fullName'];
    username = json['username'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    phone = json['phone'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    countryCode = json['countryCode'];
    fcm = json['fcm'];
    flagUrl = json['flagUrl'];
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    lastOnlineTime = json['lastOnlineTime'];
    lastFeedbackTime = json['lastFeedbackTime'];
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
}

class DefaultStatus {
  bool? pin;
  bool? favorite;
  bool? hide;
  bool? block;
  bool? flag;
  String? type;
  String? by;
  To? to;
  String? id;
  int? position;

  DefaultStatus(
      {this.pin,
      this.favorite,
      this.hide,
      this.block,
      this.flag,
      this.type,
      this.by,
      this.to,
      this.id,
      this.position});

  DefaultStatus.fromJson(Map<String, dynamic> json) {
    pin = json['pin'];
    favorite = json['favorite'];
    hide = json['hide'];
    block = json['block'];
    flag = json['flag'];
    type = json['type'];
    by = json['by'];
    to = json['to'] != null ? To.fromJson(json['to']) : null;
    id = json['id'];
    position = json['position'];
  }
}

class To {
  Location? location;
  String? url;
  String? role;
  String? avatar;
  bool? anonymous;
  bool? online;
  int? received;
  int? posted;
  int? subscribed;
  int? wallet;
  int? referralBalance;
  int? recentCoins;
  bool? autoApprove;
  bool? trustScoreStatic;
  bool? generateReportOption;
  bool? active;
  String? profileUrl;
  String? profileUrlType;
  String? referral;
  String? fullName;
  String? username;
  String? userIdentity;
  String? id;
  String? phone;

  To(
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
      this.referralBalance,
      this.recentCoins,
      this.autoApprove,
      this.trustScoreStatic,
      this.generateReportOption,
      this.active,
      this.profileUrl,
      this.profileUrlType,
      this.referral,
      this.fullName,
      this.username,
      this.userIdentity,
      this.id,
      this.phone});

  To.fromJson(Map<String, dynamic> json) {
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
    referralBalance = json['referralBalance'];
    recentCoins = json['recentCoins'];
    autoApprove = json['autoApprove'];
    trustScoreStatic = json['trustScoreStatic'];
    generateReportOption = json['generateReportOption'];
    active = json['active'];
    profileUrl = json['profileUrl'];
    profileUrlType = json['profileUrlType'];
    referral = json['referral'];
    fullName = json['fullName'];
    username = json['username'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    id = json['id'];
    phone = json['phone'];
  }
}

class BlockStatus {
  bool? hideUser;
  String? hideUserMessage;

  BlockStatus({this.hideUser, this.hideUserMessage});

  BlockStatus.fromJson(Map<String, dynamic> json) {
    hideUser = json['hideUser'];
    hideUserMessage = json['hideUserMessage'];
  }
}
