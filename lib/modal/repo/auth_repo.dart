import 'package:humanscoring/modal/apiModel/req_model/avatar_username_req_model.dart';
import 'package:humanscoring/modal/apiModel/req_model/fcm_req_model.dart';
import 'package:humanscoring/modal/apiModel/req_model/otp_verification_req_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/avatar_username_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/fcm_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_avatar_username_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/otp_verification_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/register_res_model.dart';
import 'package:humanscoring/modal/services/api_service.dart';
import 'package:humanscoring/utils/const_utils.dart';
import 'package:humanscoring/utils/enum_utils.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';

import '../apiModel/res_model/user_name_availability_res_model.dart';
import '../apiModel/res_model/user_online_offline_resp_model.dart';
import '../services/base_service.dart';

class AuthRepo extends BaseService {
  ///==========================Login PostRepo====================
  Future<dynamic> logInRepo(Map<String, dynamic> model) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: registerURL,
      body: model,
      withToken: false,
    );
    RegisterResModel registerResModel = RegisterResModel.fromJson(response);
    ConstUtils.isNewUser = registerResModel.data!.isNewUser;
    return registerResModel;
  }
  ///==========================OtpVerification PostRepo====================

  Future<dynamic> otpVerificationRepo(OtpVerificationReqModel model) async {
    Map<String, dynamic> body = model.toJson();

    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: verifyOtp,
      body: body,
      withToken: false,
    );
    OtpVerificationResModel otpVerificationResModel =
        OtpVerificationResModel.fromJson(response);
    return otpVerificationResModel;
  }
  ///==========================Fcm PUTRepo====================

  Future<dynamic> fcmRepo(FcmReqModel model) async {
    Map<String, dynamic> body = model.toJson();

    var response = await ApiService().getResponse(
      apiType: APIType.aPut,
      url: userApi,
      body: body,
    );
    FcmResModel fcmResModel = FcmResModel.fromJson(response);
    return fcmResModel;
  }
  ///==========================AvatarUserName PutRepo====================

  Future<dynamic> avatarUserNameRepo(AvatarUserNameReqModel model) async {
    Map<String, dynamic> body = model.toJson();
    String? id = PreferenceManagerUtils.getLoginId();
    var response = await ApiService().getResponse(
      apiType: APIType.aPut,
      url: userName + id,
      body: body,
    );
    AvatarUserNameResModel avatarUserNameResModel =
        AvatarUserNameResModel.fromJson(response);
    return avatarUserNameResModel;
  }
  ///==========================AvatarUserName GetRepo====================

  Future<dynamic> getAvatarUserNameRepo() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: getUserName,
    );
    GetAvatarUserNameResModel avatarUserNameResModel =
        GetAvatarUserNameResModel.fromJson(response);
    return avatarUserNameResModel;
  }
  ///==========================getUserNameAvailability GetRepo====================

  Future<dynamic> getUserNameAvailabilityRepo({String? userName}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: userNameAvailability + userName!,
      withToken: false,
    );
    UserNameAvailabilityResModel userNameAvailabilityResModel =
        UserNameAvailabilityResModel.fromJson(response);
    return userNameAvailabilityResModel;
  }
  ///==========================AvatarUserName PutRepo====================

  Future<dynamic> loginUserOnlineOfflineRepo(Map<String, dynamic> body) async {
    String? id = PreferenceManagerUtils.getLoginId();

    var response = await ApiService().getResponse(
        apiType: APIType.aPut, url: userName + id, body: body, withToken: true);
    UserOnlineOfflineRespModel userOnlineOfflineRespModel =
        UserOnlineOfflineRespModel.fromJson(response);
    return userOnlineOfflineRespModel;
  }
}
