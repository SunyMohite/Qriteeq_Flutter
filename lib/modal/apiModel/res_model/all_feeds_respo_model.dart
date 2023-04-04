class AllFeedsRespoModel {
  int? status;
  bool? error;
  String? message;
  Data? data;

  AllFeedsRespoModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  AllFeedsRespoModel.fromJson(Map<String, dynamic> json) {
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
  FeedYou? you;
  List<All>? pin;
  List<Unread>? unread;
  List<All>? all;

  Data({
    this.you,
    this.pin,
    this.unread,
    this.all,
  });

  Data.fromJson(Map<String, dynamic> json) {
    you = json['you'] != null ? FeedYou.fromJson(json['you']) : null;
    if (json['pin'] != null) {
      pin = <All>[];
      json['pin'].forEach((v) {
        pin!.add(All.fromJson(v));
      });
    }
    if (json['unread'] != null) {
      unread = <Unread>[];
      json['unread'].forEach((v) {
        unread!.add(Unread.fromJson(v));
      });
    }
    if (json['all'] != null) {
      all = <All>[];
      json['all'].forEach((v) {
        all!.add(All.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (you != null) {
      data['you'] = you!.toJson();
    }
    if (pin != null) {
      data['pin'] = pin!.map((v) => v.toJson()).toList();
    }
    if (unread != null) {
      data['unread'] = unread!.map((v) => v.toJson()).toList();
    }
    if (all != null) {
      data['all'] = all!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class FeedYou {
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
  String? sId;
  String? phone;
  String? referral;
  String? lastlogin;
  String? currentlogin;
  String? createdAt;
  String? updatedAt;
  String? receiveDate;
  int? iV;
  String? fcm;
  String? flagUrl;
  String? fullName;
  String? username;
  String? userIdentity;
  String? feedStatus;
  int? unread;
  String? feedText;

  int? receivedCount;
  int? postedCount;

  FeedYou(
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
      this.sId,
      this.phone,
      this.referral,
      this.lastlogin,
      this.currentlogin,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.fcm,
      this.receiveDate,
      this.flagUrl,
      this.fullName,
      this.username,
      this.userIdentity,
      this.feedStatus,
      this.unread,
      this.receivedCount,
      this.postedCount,
      this.feedText});

  FeedYou.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
    url = json['url'];
    role = json['role'];
    avatar = json['avatar'] ?? '';

    anonymous = json['anonymous'] ?? false;
    online = json['online'];
    received = json['received'];
    posted = json['posted'];
    subscribed = json['subscribed'];
    wallet = json['wallet'];
    active = json['active'];
    sId = json['_id'];
    phone = json['phone'] ?? "";
    referral = json['referral'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    fcm = json['fcm'];
    flagUrl = json['flagUrl'];
    fullName = json['fullName'];
    username = json['username'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    feedStatus = json['feedStatus'];
    unread = json['unread'];
    feedText = json['feedText'];
    postedCount = json['postedCount'];
    receivedCount = json['receivedCount'];
    receiveDate = json['receiveDate'];
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

    data['_id'] = sId;
    data['phone'] = phone;
    data['referral'] = referral;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['fcm'] = fcm;
    data['flagUrl'] = flagUrl;
    data['fullName'] = fullName;
    data['username'] = username;
    data['userIdentity'] = userIdentity;
    data['feedStatus'] = feedStatus;
    data['unread'] = unread;
    data['feedText'] = feedText;
    data['receivedCount'] = receivedCount;
    data['receiveDate'] = receiveDate;
    data['postedCount'] = postedCount;
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
  bool? active;
  String? phone;
  String? referral;
  String? username;
  String? userIdentity;
  String? id;

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
      this.active,
      this.phone,
      this.referral,
      this.username,
      this.userIdentity,
      this.id});

  To.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    url = json['url'];
    role = json['role'];
    avatar = json['avatar'] ?? '';
    anonymous = json['anonymous'] ?? false;
    online = json['online'];
    received = json['received'];
    posted = json['posted'];
    subscribed = json['subscribed'];
    wallet = json['wallet'];
    active = json['active'];
    phone = json['phone'] ?? '';
    referral = json['referral'];
    username = json['username'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
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
    data['username'] = username;
    data['userIdentity'] = userIdentity;
    data['id'] = id;
    return data;
  }
}

class Unread {
  Id? iId;
  int? received;
  Id? user;
  String? receiveDate;
  String? sender;
  String? feedStatus;
  InteractionStatus? status;
  int? unread;
  bool? connected;
  bool? exist;
  String? feedText;
  int? receivedCount;
  int? postedCount;
  Unread(
      {this.iId,
      this.received,
      this.user,
      this.receiveDate,
      this.sender,
      this.feedStatus,
      this.status,
      this.unread,
      this.connected,
      this.exist,
      this.receivedCount,
      this.postedCount,
      this.feedText});

  Unread.fromJson(Map<String, dynamic> json) {
    iId = json['_id'] != null ? Id.fromJson(json['_id']) : null;
    received = json['received'];
    user = json['user'] != null ? Id.fromJson(json['user']) : null;
    receiveDate = json['receiveDate'];
    sender = json['sender'];
    feedStatus = json['feedStatus'];
    status = json['status'] != null
        ? InteractionStatus.fromJson(json['status'])
        : null;
    unread = json['unread'];
    connected = json['connected'];
    exist = json['exist'];
    feedText = json['feedText'];
    postedCount = json['postedCount'];
    receivedCount = json['receivedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (iId != null) {
      data['_id'] = iId!.toJson();
    }
    data['received'] = received;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['receiveDate'] = receiveDate;
    data['sender'] = sender;
    data['feedStatus'] = feedStatus;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    data['unread'] = unread;
    data['connected'] = connected;
    data['exist'] = exist;
    data['feedText'] = feedText;
    data['receivedCount'] = receivedCount;
    data['postedCount'] = postedCount;
    return data;
  }
}

class Id {
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
  bool? active;
  String? phone;
  String? email;
  String? profileUrl;
  String? referral;
  String? username;
  String? userIdentity;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? lastlogin;
  String? currentlogin;
  String? fcm;
  String? flagUrl;
  String? fullName;
  LocationName? locationName;

  Id(
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
      this.active,
      this.phone,
      this.profileUrl,
      this.email,
      this.referral,
      this.fullName,
      this.username,
      this.userIdentity,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.lastlogin,
      this.currentlogin,
      this.fcm,
      this.flagUrl,
      this.locationName});

  Id.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    url = json['url'];
    role = json['role'];
    avatar = json['avatar'] ?? '';
    anonymous = json['anonymous'] ?? false;
    online = json['online'];
    received = json['received'];
    posted = json['posted'];
    subscribed = json['subscribed'];
    wallet = json['wallet'];
    active = json['active'];
    phone = json['phone'] ?? '';
    profileUrl = json['profileUrl'] ?? '';
    email = json['email'] ?? '';
    referral = json['referral'];
    username = json['username'];
    userIdentity = json['userIdentity'] != null
        ? json['userIdentity'].toString().trimLeft()
        : '';
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    lastlogin = json['lastlogin'];
    currentlogin = json['currentlogin'];
    fcm = json['fcm'];
    flagUrl = json['flagUrl'];
    fullName = json['fullName'];
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (location != null) {
      data['location'] = location!.toJson();
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
    data['username'] = username;
    data['userIdentity'] = userIdentity;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['lastlogin'] = lastlogin;
    data['currentlogin'] = currentlogin;
    data['fcm'] = fcm;
    data['flagUrl'] = flagUrl;
    data['fullName'] = fullName;
    if (locationName != null) {
      data['locationName'] = locationName!.toJson();
    }
    return data;
  }
}

class InteractionStatus {
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
  String? url;

  InteractionStatus(
      {this.pin,
      this.favorite,
      this.hide,
      this.block,
      this.flag,
      this.type,
      this.by,
      this.to,
      this.id,
      this.position,
      this.url});

  InteractionStatus.fromJson(Map<String, dynamic> json) {
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
    url = json['url'];
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
    if (to != null) {
      data['to'] = to!.toJson();
    }
    data['id'] = id;
    data['position'] = position;
    data['url'] = url;
    return data;
  }
}

class All {
  Id? iId;
  int? received;
  Id? user;
  String? receiveDate;
  String? sender;
  String? feedStatus;
  InteractionStatus? status;
  int? unread;
  bool? connected;
  bool? exist;
  String? feedText;
  int? receivedCount;
  int? postedCount;
  All(
      {this.iId,
      this.received,
      this.user,
      this.receiveDate,
      this.sender,
      this.feedStatus,
      this.status,
      this.unread,
      this.connected,
      this.exist,
      this.receivedCount,
      this.postedCount,
      this.feedText});

  All.fromJson(Map<String, dynamic> json) {
    iId = json['_id'] != null ? Id.fromJson(json['_id']) : null;
    received = json['received'];
    user = json['user'] != null ? Id.fromJson(json['user']) : null;
    receiveDate = json['receiveDate'];
    sender = json['sender'];
    feedStatus = json['feedStatus'];
    status = json['status'] != null
        ? InteractionStatus.fromJson(json['status'])
        : null;
    unread = json['unread'];
    connected = json['connected'];
    exist = json['exist'];
    feedText = json['feedText'];
    postedCount = json['postedCount'];
    receivedCount = json['receivedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (iId != null) {
      data['_id'] = iId!.toJson();
    }
    data['received'] = received;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['receiveDate'] = receiveDate;
    data['sender'] = sender;
    data['feedStatus'] = feedStatus;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    data['unread'] = unread;
    data['connected'] = connected;
    data['exist'] = exist;
    data['feedText'] = feedText;
    data['receivedCount'] = receivedCount;
    data['postedCount'] = postedCount;
    return data;
  }
}
