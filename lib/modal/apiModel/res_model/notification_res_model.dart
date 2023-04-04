class NotificationResModel {
  int? status;
  bool? error;
  String? message;
  List<NotificationData>? data;

  NotificationResModel({this.status, this.error, this.message, this.data});

  NotificationResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  Redirect? redirect;
  bool? read;
  String? sId;
  Sender? sender;
  String? title;
  String? body;
  Sender? user;
  String? createdAt;
  String? updatedAt;
  int? iV;

  NotificationData(
      {this.redirect,
      this.read,
      this.sId,
      this.sender,
      this.title,
      this.body,
      this.user,
      this.createdAt,
      this.updatedAt,
      this.iV});

  NotificationData.fromJson(Map<String, dynamic> json) {
    redirect =
        json['redirect'] != null ? Redirect.fromJson(json['redirect']) : null;
    read = json['read'];
    sId = json['_id'];
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    title = json['title'];
    body = json['body'];
    user = json['user'] != null ? Sender.fromJson(json['user']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (redirect != null) {
      data['redirect'] = redirect!.toJson();
    }
    data['read'] = read;
    data['_id'] = sId;
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    data['title'] = title;
    data['body'] = body;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Redirect {
  String? tag;
  String? id;
  bool? isUnlocked;

  Redirect({this.tag, this.id, this.isUnlocked});

  Redirect.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    id = json['id'];
    isUnlocked = json['isUnlocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tag'] = tag;
    data['id'] = id;
    data['isUnlocked'] = isUnlocked;
    return data;
  }
}

class Sender {
  String? avatar;
  String? id;

  Sender({this.avatar, this.id});

  Sender.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'] ?? '';
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avatar'] = avatar;
    data['id'] = id;
    return data;
  }
}
