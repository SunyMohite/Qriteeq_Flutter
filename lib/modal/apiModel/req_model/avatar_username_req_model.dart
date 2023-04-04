class AvatarUserNameReqModel {
  String? username;
  String? fullName;
  String? avatar;
  String? fcm;
  String? flagUrl;
  String? referral;
  bool? anonymous;
  LocationMap? location;
  LocationName? locationName;

  AvatarUserNameReqModel(
      {this.username,
      this.avatar,
      this.anonymous,
      this.flagUrl,
      this.location,
      this.fullName,
      this.referral,
      this.locationName});

  AvatarUserNameReqModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    fullName = json['fullName'];
    avatar = json['avatar'] ?? '';
    referral = json['referral'];
    flagUrl = json['flagUrl'];
    anonymous = json['anonymous'];
    fcm = json['fcm'];
    location = json['location'] != null
        ? LocationMap.fromJson(json['location'])
        : null;
    locationName = json['locationName'] != null
        ? LocationName.fromJson(json['locationName'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['fullName'] = fullName;
    data['referral'] = referral;
    data['flagUrl'] = flagUrl;
    data['avatar'] = avatar;
    data['fcm'] = fcm;
    data['anonymous'] = anonymous;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (locationName != null) {
      data['locationName'] = locationName!.toJson();
    }
    return data;
  }
}

class LocationName {
  String? address;
  String? state;
  String? counter;
  String? dialCode;

  LocationName({this.address, this.state, this.counter, this.dialCode});

  LocationName.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    state = json['state'];
    counter = json['counter'];
    dialCode = json['countryCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['state'] = state;
    data['counter'] = counter;
    data['countryCode'] = dialCode;
    return data;
  }
}

class LocationMap {
  List<String>? coordinates;

  LocationMap({this.coordinates});

  LocationMap.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    return data;
  }
}
