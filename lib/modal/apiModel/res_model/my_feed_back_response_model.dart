import 'global_feedback_res_model.dart';

class MyFeedBackResponseModel {
  int? status;
  bool? error;
  String? message;
  MyFeedBackData? data;

  MyFeedBackResponseModel({this.status, this.error, this.message, this.data});

  MyFeedBackResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? MyFeedBackData.fromJson(json['data']) : null;
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

class MyFeedBackData {
  You? you;
  Feedback? feedback;
  UserStatus? userStatus;
  int? postedCount;
  int? receivedCount;
  String? trustScore;
  String? totalTrustScore;
  String? profileShareLink;
  UserObj? userObj;
  bool? hideOptions;

  MyFeedBackData(
      {this.you,
      this.feedback,
      this.userStatus,
      this.postedCount,
      this.receivedCount,
      this.userObj,
      this.totalTrustScore,
      this.trustScore,
      this.profileShareLink,
      this.hideOptions});

  MyFeedBackData.fromJson(Map<String, dynamic> json) {
    // you = json['you'] != null ? You.fromJson(json['you']) : null;
    feedback =
        json['feedback'] != null ? Feedback.fromJson(json['feedback']) : null;
    userStatus =
        json['status'] != null ? UserStatus.fromJson(json['status']) : null;
    postedCount = json['postedCount'] ?? 0;
    receivedCount = json['receivedCount'] ?? 0;
    hideOptions = json['hideOptions'] ?? false;
    trustScore = json['trustScore'] ?? "0";
    totalTrustScore = json['totalTrustScore'] ?? "0";
    profileShareLink = json['profileShareLink'] ?? '';

    userObj =
        json['userObj'] != null ? UserObj.fromJson(json['userObj']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // if (this.you != null) {
    //   data['you'] = this.you!.toJson();
    // }
    if (feedback != null) {
      data['feedback'] = feedback!.toJson();
    }
    if (userStatus != null) {
      data['status'] = userStatus!.toJson();
    }
    data['receivedCount'] = receivedCount;
    data['postedCount'] = postedCount;
    data['hideOptions'] = hideOptions;
    data['totalTrustScore'] = totalTrustScore;
    data['trustScore'] = trustScore;
    data['profileShareLink'] = profileShareLink;

    if (userObj != null) {
      data['userObj'] = userObj!.toJson();
    }

    return data;
  }
}

class UserStatus {
  bool? pin;
  bool? favorite;
  bool? flag;
  bool? hide;
  bool? block;
  int? position;

  UserStatus({this.pin, this.favorite, this.hide, this.block, this.position});

  UserStatus.fromJson(Map<String, dynamic> json) {
    pin = json['pin'];
    favorite = json['favorite'];
    hide = json['hide'];
    flag = json['flag'];
    block = json['block'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['pin'] = pin;
    data['favorite'] = favorite;
    data['hide'] = hide;
    data['flag'] = flag;
    data['block'] = block;
    data['position'] = position;

    return data;
  }
}

class You {
  List<String>? document;
  String? status;
  String? sId;
  User? user;
  User? sender;
  String? score;
  String? reviewType;
  String? relation;
  String? text;
  String? shared;
  String? createdAt;
  String? updatedAt;
  String? profileShareLink;
  int? iV;
  int? like;
  int? unlike;
  int? comment;
  bool? mylike;
  bool? myunlike;
  bool? mycomment;

  You(
      {this.document,
      this.sId,
      this.status,
      this.user,
      this.sender,
      this.score,
      this.reviewType,
      this.relation,
      this.text,
      this.shared,
      this.createdAt,
      this.updatedAt,
      this.profileShareLink,
      this.iV,
      this.like,
      this.unlike,
      this.comment,
      this.mylike,
      this.myunlike,
      this.mycomment});

  You.fromJson(Map<String, dynamic> json) {
    document = json['document'].cast<String>() ?? "";
    sId = json['_id'];
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    sender = json['sender'] != null ? User.fromJson(json['sender']) : null;
    score = json['score'];
    reviewType = json['reviewType'];
    relation = json['relation'];
    text = json['text'];
    shared = json['shared'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    profileShareLink = json['profileShareLink'] ?? '';
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
    data['document'] = document;
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    data['score'] = score;
    data['reviewType'] = reviewType;
    data['relation'] = relation;
    data['text'] = text;
    data['shared'] = shared;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['profileShareLink'] = profileShareLink;
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
  bool? active;
  int? received;
  int? posted;
  String? phone;
  String? referral;
  String? profileType;
  String? lastlogin;
  String? currentlogin;
  String? fcm;
  String? avatar;
  String? flagUrl;
  LocationName? locationName;
  String? username;
  String? id;
  String? fullName;
  String? userIdentity;
  String? countryName;

  User(
      {this.location,
      this.role,
      this.anonymous,
      this.online,
      this.fullName,
      this.userIdentity,
      this.received,
      this.posted,
      this.countryName,
      this.active,
      this.phone,
      this.profileType,
      this.referral,
      this.flagUrl,
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
    active = json['active'];
    anonymous = json['anonymous'];
    online = json['online'];
    flagUrl = json['flagUrl'];
    fullName = json['fullName'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    countryName = json['countryName'];
    profileType = json['profileType'] ?? '';
    received = json['received'];
    posted = json['posted'];
    phone = json['phone'];
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    fcm = json['fcm'] ?? "";
    avatar = json['avatar'] ?? '';
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
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
    data['fullName'] = fullName;
    data['userIdentity'] = userIdentity;
    data['received'] = received;
    data['posted'] = posted;
    data['active'] = active;
    data['profileType'] = profileType;
    data['phone'] = phone;
    data['referral'] = referral;
    data['countryName'] = countryName;
    data['flagUrl'] = flagUrl;
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

class Feedback {
  List<MyFeedBackResults>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  Feedback(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  Feedback.fromJson(Map<String, dynamic> json) {
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
  String? status;
  String? showText;
  String? url;
  String? sId;
  String? shareLink;
  User? user;
  Sender? sender;
  DefaultStatusGlobal? defaultStatus;
  BlockStatus? blockStatus;

  List<Document>? document;
  String? score;
  String? reviewType;
  String? relation;
  String? text;
  String? shared;
  String? createdAt;
  String? updatedAt;
  String? mylikeid;
  String? myunlikeid;
  String? mycommentid;
  int? iV;
  int? like;
  int? unlike;
  int? comment;
  bool? mylike;
  bool? myunlike;
  bool? mycomment;
  bool? isUnlocked;
  bool? anonymous;

  MyFeedBackResults({
    this.status,
    this.showText,
    this.sId,
    this.user,
    this.url,
    this.sender,
    this.document,
    this.score,
    this.reviewType,
    this.relation,
    this.text,
    this.shared,
    this.shareLink,
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
    this.myunlikeid,
    this.mycommentid,
    this.isUnlocked,
    this.defaultStatus,
    this.blockStatus,
    this.anonymous,
  });

  MyFeedBackResults.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    showText = json['showText'];
    sId = json['_id'];
    url = json['url'];
    shareLink = json['shareLink'] ?? '';
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    if (json['document'] != null) {
      document = <Document>[];
      json['document'].forEach((v) {
        document!.add(Document.fromJson(v));
      });
    }
    defaultStatus = json['defaultStatus'] != null
        ? DefaultStatusGlobal.fromJson(json['defaultStatus'])
        : null;
    blockStatus = json['blockStatus'] != null
        ? BlockStatus.fromJson(json['blockStatus'])
        : null;
    score = json['score'] ?? '';
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
    isUnlocked = json['isUnlocked'];
    mycomment = json['mycomment'];
    mylikeid = json['mylikeid'] ?? '';
    myunlikeid = json['myunlikeid'] ?? '';
    mycommentid = json['mycommentid'] ?? '';
    anonymous = json['anonymous'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['showText'] = showText;
    data['_id'] = sId;
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
    if (blockStatus != null) {
      data['blockStatus'] = blockStatus!.toJson();
    }
    data['score'] = score;
    data['url'] = url;
    data['reviewType'] = reviewType;
    data['relation'] = relation;
    data['text'] = text;
    data['shareLink'] = shareLink;
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
    data['mycommentid'] = mycommentid;
    data['isUnlocked'] = isUnlocked;
    data['anonymous'] = anonymous;

    return data;
  }
}

class DefaultStatus {
  DefaultSender? sender;
  DefaultReceiver? receiver;

  DefaultStatus({this.sender, this.receiver});

  DefaultStatus.fromJson(Map<String, dynamic> json) {
    sender =
        json['sender'] != null ? DefaultSender.fromJson(json['sender']) : null;

    receiver = json['receiver'] != null
        ? DefaultReceiver.fromJson(json['receiver'])
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

class BlockStatus {
  bool? hideUser;
  String? hideUserMessage;

  BlockStatus({this.hideUser, this.hideUserMessage});

  BlockStatus.fromJson(Map<String, dynamic> json) {
    hideUser = json['hideUser'];
    hideUserMessage = json['hideUserMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hideUser'] = hideUser;
    data['hideUserMessage'] = hideUserMessage;
    return data;
  }
}

class DefaultSender {
  bool? pin;
  bool? favorite;
  bool? hide;
  bool? block;
  bool? flag;
  String? type;
  String? by;
  String? id;

  DefaultSender(
      {this.pin,
      this.favorite,
      this.hide,
      this.block,
      this.flag,
      this.type,
      this.by,
      this.id});

  DefaultSender.fromJson(Map<String, dynamic> json) {
    pin = json['pin'];
    favorite = json['favorite'];
    hide = json['hide'];
    block = json['block'];
    flag = json['flag'];
    type = json['type'];
    by = json['by'];
    id = json['id'];
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

    data['id'] = id;
    return data;
  }
}

class DefaultReceiver {
  bool? pin;
  bool? favorite;
  bool? hide;
  bool? block;
  bool? flag;
  String? type;
  String? by;
  String? id;
  // CommentUser? toUser;

  DefaultReceiver(
      {this.pin,
      this.favorite,
      this.hide,
      this.block,
      this.flag,
      this.type,
      this.by,
      // this.toUser,
      this.id});

  DefaultReceiver.fromJson(Map<String, dynamic> json) {
    pin = json['pin'];
    favorite = json['favorite'];
    hide = json['hide'];
    block = json['block'];
    flag = json['flag'];
    type = json['type'];
    by = json['by'];
    id = json['id'];
    // toUser = (json['to'] != null ? CommentUser.fromJson(json['to']) : null)!;
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
    // if (toUser != null) {
    //   data['to'] = toUser!.toJson();
    // }
    data['id'] = id;
    return data;
  }
}

class Coordinates {
  Coordinates();

  Coordinates.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

class Sender {
  Location? location;
  LocationName? locationName;
  String? url;
  String? role;
  String? profileType;
  String? flagUrl;
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
  String? lastlogin;
  String? currentlogin;
  String? avatar;
  String? fcm;
  String? username;
  String? fullName;
  String? userIdentity;
  String? id;

  Sender(
      {this.location,
      this.locationName,
      this.url,
      this.role,
      this.anonymous,
      this.online,
      this.profileType,
      this.active,
      this.fullName,
      this.userIdentity,
      this.received,
      this.flagUrl,
      this.posted,
      this.countryName,
      this.subscribed,
      this.wallet,
      this.phone,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.avatar,
      this.fcm,
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
    flagUrl = json['flagUrl'];
    anonymous = json['anonymous'];
    online = json['online'];
    countryName = json['countryName'];
    active = json['active'];
    profileType = json['profileType'] ?? '';
    fullName = json['fullName'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    received = json['received'];
    posted = json['posted'];
    subscribed = json['subscribed'];
    wallet = json['wallet'];
    phone = json['phone'];
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    avatar = json['avatar'] ?? '';
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
    data['flagUrl'] = flagUrl;
    data['fullName'] = fullName;
    data['userIdentity'] = userIdentity;
    data['active'] = active;
    data['profileType'] = profileType;
    data['anonymous'] = anonymous;
    data['online'] = online;
    data['countryName'] = countryName;
    data['received'] = received;
    data['posted'] = posted;
    data['subscribed'] = subscribed;
    data['wallet'] = wallet;
    data['phone'] = phone;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['avatar'] = avatar;
    data['fcm'] = fcm;
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
    ext = json['ext'] ?? '';
    url = json['url'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['ext'] = ext;
    data['url'] = url;
    return data;
  }
}

class UserObj {
  Location? location;
  LocationName? locationName;
  String? url;
  String? role;
  String? avatar;
  bool? anonymous;
  bool? online;
  bool? generateReportOption;
  int? received;
  int? posted;
  int? subscribed;
  int? wallet;
  int? referralBalance;
  int? recentCoins;
  bool? autoApprove;
  bool? active;
  String? phone;
  String? email;
  String? profileUrl;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? fcm;
  String? flagUrl;
  String? fullName;
  String? username;
  String? customerId;
  String? countryCode;
  String? userIdentity;
  String? lastOnlineTime;
  String? lastFeedbackTime;
  String? id;
  UserObjDefaultStatus? defaultStatus;

  UserObj(
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
      this.email,
      this.generateReportOption,
      this.referralBalance,
      this.recentCoins,
      this.profileUrl,
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
      this.customerId,
      this.countryCode,
      this.userIdentity,
      this.lastOnlineTime,
      this.lastFeedbackTime,
      this.defaultStatus,
      this.id});

  UserObj.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    url = json['url'];
    role = json['role'];
    avatar = json['avatar'] ?? '';
    generateReportOption = json['generateReportOption'];
    anonymous = json['anonymous'];
    online = json['online'];
    received = json['received'];
    posted = json['posted'];
    profileUrl = json['profileUrl'];
    subscribed = json['subscribed'];
    email = json['email'];
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
    flagUrl = json['flagUrl'] ?? '';
    fullName = json['fullName'];
    username = json['username'];
    customerId = json['customerId'];
    countryCode = json['countryCode'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    lastOnlineTime = json['lastOnlineTime'];
    lastFeedbackTime = json['lastFeedbackTime'];
    id = json['id'];
    defaultStatus = json['defaultStatus'] != null
        ? UserObjDefaultStatus.fromJson(json['defaultStatus'])
        : null;
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
    data['email'] = email;
    data['profileUrl'] = profileUrl;
    data['posted'] = posted;
    data['generateReportOption'] = generateReportOption;
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
    data['customerId'] = customerId;
    data['countryCode'] = countryCode;
    data['userIdentity'] = userIdentity;
    data['lastOnlineTime'] = lastOnlineTime;
    data['lastFeedbackTime'] = lastFeedbackTime;
    data['id'] = id;
    if (defaultStatus != null) {
      data['defaultStatus'] = defaultStatus!.toJson();
    }
    return data;
  }
}

class UserObjDefaultStatus {
  bool? pin;
  bool? favorite;
  bool? hide;
  bool? block;
  bool? flag;
  String? type;
  String? by;

  UserObjDefaultStatus(
      {this.pin, this.favorite, this.hide, this.block, this.type, this.by});

  UserObjDefaultStatus.fromJson(Map<String, dynamic> json) {
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
