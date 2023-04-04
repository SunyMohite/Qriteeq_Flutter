import 'package:humanscoring/modal/apiModel/res_model/my_feed_back_response_model.dart';

class GlobalFeedBackResModel {
  int? status;
  bool? error;
  String? message;
  GlobalFeedBackData? data;

  GlobalFeedBackResModel({this.status, this.error, this.message, this.data});

  GlobalFeedBackResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data =
        json['data'] != null ? GlobalFeedBackData.fromJson(json['data']) : null;
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

class GlobalFeedBackData {
  List<GlobalFeedBackDataResults>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  GlobalFeedBackData(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  GlobalFeedBackData.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <GlobalFeedBackDataResults>[];
      json['results'].forEach((v) {
        results!.add(GlobalFeedBackDataResults.fromJson(v));
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

class GlobalFeedBackDataResults {
  MetaData? metaData;
  String? status;
  String? sId;
  String? shareLink;
  bool? anonymous;
  Sender? sender;
  List<Document>? document;
  DefaultStatusGlobal? defaultStatus;
  SenderReceiverBlockStatus? senderReceiverBlockStatus;
  String? score;
  String? reviewType;
  String? relation;
  String? text;
  String? shared;
  String? createdAt;
  String? updatedAt;
  int? iV;
  User? user;
  int? like;
  int? unlike;
  int? comment;
  bool? mylike;
  bool? myunlike;
  bool? mycomment;
  String? mylikeid;
  String? myunlikeid;
  String? showText;

  GlobalFeedBackDataResults({
    this.metaData,
    this.status,
    this.sId,
    this.sender,
    this.document,
    this.score,
    this.reviewType,
    this.relation,
    this.shareLink,
    this.text,
    this.shared,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.user,
    this.like,
    this.unlike,
    this.comment,
    this.mylike,
    this.myunlike,
    this.mycomment,
    this.mylikeid,
    this.myunlikeid,
    this.defaultStatus,
    this.senderReceiverBlockStatus,
    this.showText,
    this.anonymous,
  });

  GlobalFeedBackDataResults.fromJson(Map<String, dynamic> json) {
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
    relation = json['relation'];
    text = json['text'];
    shared = json['shared'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    like = json['like'];
    unlike = json['unlike'];
    comment = json['comment'];
    mylike = json['mylike'];
    myunlike = json['myunlike'];
    mycomment = json['mycomment'];
    myunlikeid = json['myunlikeid'];
    mylikeid = json['mylikeid'];
    showText = json['showText'];
    anonymous = json['anonymous'];
    defaultStatus = json['defaultStatus'] != null
        ? DefaultStatusGlobal.fromJson(json['defaultStatus'])
        : null;
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
    data['_id'] = sId;
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    if (document != null) {
      data['document'] = document!.map((v) => v.toJson()).toList();
    }
    data['showText'] = showText;
    data['shareLink'] = shareLink;
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
    data['mylikeid'] = mylikeid;
    data['myunlikeid'] = myunlikeid;
    data['anonymous'] = anonymous;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (defaultStatus != null) {
      data['defaultStatus'] = defaultStatus!.toJson();
    }
    if (senderReceiverBlockStatus != null) {
      data['blockStatus'] = senderReceiverBlockStatus!.toJson();
    }
    return data;
  }
}

class DefaultStatusGlobal {
  DefaultSender? sender;
  DefaultSender? receiver;

  DefaultStatusGlobal({this.sender, this.receiver});

  DefaultStatusGlobal.fromJson(Map<String, dynamic> json) {
    sender =
        json['sender'] != null ? DefaultSender.fromJson(json['sender']) : null;

    receiver = json['receiver'] != null
        ? DefaultSender.fromJson(json['receiver'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    if (receiver != null) {
      data['receiver'] = receiver!.toJson();
    }
    return data;
  }
}

class SenderReceiverBlockStatus {
  bool? hideUserSender;
  String? hideUserMessageSender;
  bool? hideUserReceiver;
  String? hideUserMessageReceiver;

  SenderReceiverBlockStatus(
      {this.hideUserSender,
      this.hideUserMessageSender,
      this.hideUserReceiver,
      this.hideUserMessageReceiver});

  SenderReceiverBlockStatus.fromJson(Map<String, dynamic> json) {
    hideUserSender = json['hideUserSender'];
    hideUserMessageSender = json['hideUserMessageSender'];
    hideUserReceiver = json['hideUserReceiver'];
    hideUserMessageReceiver = json['hideUserMessageReceiver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hideUserSender'] = hideUserSender;
    data['hideUserMessageSender'] = hideUserMessageSender;
    data['hideUserReceiver'] = hideUserReceiver;
    data['hideUserMessageReceiver'] = hideUserMessageReceiver;
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
  String? countryName;
  String? profileType;
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
  String? email;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? fcm;
  String? flagUrl;
  String? fullName;
  String? userIdentity;
  String? username;
  String? id;
  String? phone;

  Sender(
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
      this.referralBalance,
      this.recentCoins,
      this.countryName,
      this.profileType,
      this.autoApprove,
      this.active,
      this.email,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.fcm,
      this.flagUrl,
      this.fullName,
      this.userIdentity,
      this.username,
      this.id,
      this.phone});

  Sender.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    url = json['url'] ?? '';
    role = json['role'];
    avatar = json['avatar'] ?? '';
    anonymous = json['anonymous'];
    online = json['online'];
    profileType = json['profileType'] ?? '';
    countryName = json['countryName'];
    received = json['received'];
    posted = json['posted'];
    subscribed = json['subscribed'];
    wallet = json['wallet'];
    referralBalance = json['referralBalance'];
    recentCoins = json['recentCoins'];
    autoApprove = json['autoApprove'];
    active = json['active'];
    email = json['email'];
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
    phone = json['phone'];
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
    data['countryName'] = countryName;
    data['online'] = online;
    data['received'] = received;
    data['posted'] = posted;
    data['subscribed'] = subscribed;
    data['wallet'] = wallet;
    data['profileType'] = profileType;
    data['referralBalance'] = referralBalance;
    data['recentCoins'] = recentCoins;
    data['autoApprove'] = autoApprove;
    data['active'] = active;
    data['email'] = email;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['fcm'] = fcm;
    data['flagUrl'] = flagUrl;
    data['fullName'] = fullName;
    data['userIdentity'] = userIdentity;
    data['username'] = username;
    data['id'] = id;
    data['phone'] = phone;
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
    url = json['url'] ?? '';
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
  String? profileType;
  String? countryName;
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
  String? fcm;
  String? flagUrl;
  String? fullName;
  String? userIdentity;
  String? username;
  String? customerId;
  String? id;

  User(
      {this.location,
      this.locationName,
      this.url,
      this.role,
      this.avatar,
      this.profileType,
      this.anonymous,
      this.online,
      this.countryName,
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
      this.fcm,
      this.flagUrl,
      this.fullName,
      this.userIdentity,
      this.username,
      this.customerId,
      this.id});

  User.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    url = json['url'] ?? '';
    role = json['role'];
    avatar = json['avatar'] ?? '';
    anonymous = json['anonymous'];
    online = json['online'];
    countryName = json['countryName'];
    received = json['received'];
    posted = json['posted'];
    profileType = json['profileType'] ?? '';
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
    fcm = json['fcm'];
    flagUrl = json['flagUrl'];
    fullName = json['fullName'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    username = json['username'];
    customerId = json['customerId'];
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
    data['countryName'] = countryName;
    data['avatar'] = avatar;
    data['anonymous'] = anonymous;
    data['online'] = online;
    data['received'] = received;
    data['posted'] = posted;
    data['profileType'] = profileType;
    data['subscribed'] = subscribed;
    data['wallet'] = wallet;
    data['referralBalance'] = referralBalance;
    data['recentCoins'] = recentCoins;
    data['autoApprove'] = autoApprove;
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
    data['customerId'] = customerId;
    data['id'] = id;
    return data;
  }
}

class To {
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
  int? referralBalance;
  int? recentCoins;
  bool? autoApprove;
  bool? active;
  String? phone;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? fcm;
  String? flagUrl;
  String? fullName;
  String? username;
  String? countryCode;
  String? userIdentity;
  String? customerId;
  String? id;

  To(
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
      this.referralBalance,
      this.recentCoins,
      this.autoApprove,
      this.active,
      this.phone,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.fcm,
      this.flagUrl,
      this.fullName,
      this.username,
      this.countryCode,
      this.userIdentity,
      this.customerId,
      this.id});

  To.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    url = json['url'] ?? '';
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
    fcm = json['fcm'];
    flagUrl = json['flagUrl'];
    fullName = json['fullName'];
    username = json['username'];
    countryCode = json['countryCode'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    customerId = json['customerId'];
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
    data['referralBalance'] = referralBalance;
    data['recentCoins'] = recentCoins;
    data['autoApprove'] = autoApprove;
    data['active'] = active;
    data['phone'] = phone;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['fcm'] = fcm;
    data['flagUrl'] = flagUrl;
    data['fullName'] = fullName;
    data['username'] = username;
    data['countryCode'] = countryCode;
    data['userIdentity'] = userIdentity;
    data['customerId'] = customerId;
    data['id'] = id;
    return data;
  }
}
