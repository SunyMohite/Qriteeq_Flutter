class DashBoardReqModel {
  String? user;
  String? url;
  String? email;
  String? profileUrl;
  String? sender;
  String? score;
  String? reviewType;
  String? fullName;
  String? relation;
  String? text;
  List<DashBoardDocument>? document;
  String? shared;
  bool? anonymous;
  String? campaignId;

  DashBoardReqModel(
      {this.user,
      this.sender,
      this.email,
      this.profileUrl,
      this.score,
      this.reviewType,
      this.fullName,
      this.relation,
      this.text,
      this.document,
      this.campaignId,
      this.anonymous,
      this.shared});

  DashBoardReqModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    profileUrl = json['profileUrl'];
    email = json['email'];
    sender = json['sender'];
    score = json['score'];
    fullName = json['fullName'];
    reviewType = json['reviewType'];
    relation = json['relation'];
    text = json['text'];
    shared = json['shared'];
    campaignId = json['campaignId'];
    anonymous = json['anonymous'];
  }

  Map<String, dynamic> toJsonDoesExist() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['sender'] = sender;
    if (document != null) {
      data['document'] = document!.map((v) => v.toJson()).toList();
    }
    data['score'] = score;
    data['fullName'] = fullName;

    data['reviewType'] = reviewType;
    data['relation'] = relation;
    data['text'] = text;
    data['shared'] = shared;
    data['anonymous'] = anonymous;
    return data;
  }

  Map<String, dynamic> toJsonDoesExistWithCampaignId() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['sender'] = sender;
    if (document != null) {
      data['document'] = document!.map((v) => v.toJson()).toList();
    }
    data['score'] = score;
    data['fullName'] = fullName;
    data['reviewType'] = reviewType;
    data['relation'] = relation;
    data['text'] = text;
    data['shared'] = shared;
    data['campaignId'] = campaignId;
    data['anonymous'] = anonymous;
    return data;
  }

  Map<String, dynamic> toJsonUserDoesNotExist() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = url;
    data['sender'] = sender;
    if (document != null) {
      data['document'] = document!.map((v) => v.toJson()).toList();
    }
    data['score'] = score;
    data['fullName'] = fullName;

    data['reviewType'] = reviewType;
    data['relation'] = relation;
    data['text'] = text;
    data['shared'] = shared;
    data['anonymous'] = anonymous;
    return data;
  }

  Map<String, dynamic> toJsonEmailExist() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['sender'] = sender;
    if (document != null) {
      data['document'] = document!.map((v) => v.toJson()).toList();
    }
    data['score'] = score;
    data['fullName'] = fullName;

    data['reviewType'] = reviewType;
    data['relation'] = relation;
    data['text'] = text;
    data['shared'] = shared;
    data['anonymous'] = anonymous;
    return data;
  }

  Map<String, dynamic> toJsonProfileUrlExist() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profileUrl'] = profileUrl;
    data['sender'] = sender;
    if (document != null) {
      data['document'] = document!.map((v) => v.toJson()).toList();
    }
    data['score'] = score;
    data['fullName'] = fullName;

    data['reviewType'] = reviewType;
    data['relation'] = relation;
    data['text'] = text;
    data['shared'] = shared;
    data['anonymous'] = anonymous;
    return data;
  }
}

class DashBoardDocument {
  String? ext;
  String? url;

  DashBoardDocument({this.ext, this.url});

  DashBoardDocument.fromJson(Map<String, dynamic> json) {
    ext = json['ext'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ext'] = ext;
    data['url'] = url;
    return data;
  }
}
