class OtpVerificationReqModel {
  String? verificationId;
  String? otp;

  OtpVerificationReqModel({this.verificationId, this.otp});

  OtpVerificationReqModel.fromJson(Map<String, dynamic> json) {
    verificationId = json['verificationId'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['verificationId'] = verificationId;
    data['otp'] = otp;
    return data;
  }
}
