class RegisterReqModel {
  String? verificationId;
  String? referral;
  String? countryCode;

  RegisterReqModel({this.verificationId, this.referral, this.countryCode});

  RegisterReqModel.fromJson(Map<String, dynamic> json) {
    verificationId = json['verificationId'];
    referral = json['referral'];
    countryCode = json['countryCode'];
  }
  ///FOR MOBILE NUMBER REQUEST ONLY
  Map<String, dynamic> toMobileNumberJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['verificationId'] = verificationId;
    data['countryCode'] = countryCode;
    return data;
  }
  ///FOR MOBILE NUMBER WITH REFERRAL ONLY
  Map<String, dynamic> toWithMobileNumberReferralJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['verificationId'] = verificationId;
    data['referral'] = referral;
    data['countryCode'] = countryCode;
    return data;
  }
  ///FOR EMAIL REQUEST ONLY
  Map<String, dynamic> toEmailRequestJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['verificationId'] = verificationId;
    data['countryCode'] = countryCode;
    return data;
  }
  ///FOR EMAIL REQUEST ONLY when country code is empty or null
  Map<String, dynamic> toEmailRequestOnlyJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['verificationId'] = verificationId;
    return data;
  }
  ///FOR EMAIL WITH REFERRAL ONLY
  Map<String, dynamic> toWithEmailReferralJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['verificationId'] = verificationId;
    data['referral'] = referral;
    data['countryCode'] = countryCode;
    return data;
  }
  ///FOR EMAIL WITH REFERRAL ONLY
  Map<String, dynamic> toWithEmailReferralOnlyJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['verificationId'] = verificationId;
    data['referral'] = referral;
    return data;
  }
}
