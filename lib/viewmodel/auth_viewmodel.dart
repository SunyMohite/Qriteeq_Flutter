import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/commonWidget/snackbar.dart';
import 'package:humanscoring/modal/apiModel/req_model/fcm_req_model.dart';
import 'package:humanscoring/modal/apiModel/req_model/otp_verification_req_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/fcm_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/otp_verification_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/register_res_model.dart';
import 'package:humanscoring/modal/repo/auth_repo.dart';

import '../modal/apiModel/res_model/user_name_availability_res_model.dart';
import '../modal/apis/api_response.dart';

class AuthViewModel extends GetxController {
  ApiResponse registerApiResponse = ApiResponse.initial('Initial');
  ApiResponse otpVerificationApiResponse = ApiResponse.initial('Initial');
  ApiResponse fcmApiResponse = ApiResponse.initial('Initial');
  ApiResponse userNameAvailabilityResponse = ApiResponse.initial('Initial');

  ///=====================Login ViewModel===================

  Future<void> registerViewModel(Map<String, dynamic> model) async {
    registerApiResponse = ApiResponse.loading('Loading');
    update();
    RegisterResModel response = RegisterResModel();
    try {
      response = await AuthRepo().logInRepo(model);
      registerApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('registerApiResponse******.......$e');
      showSnackBar(message: 'Something went wrong');
      registerApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///=====================OtpVerification ViewModel===================

  Future<void> otpVerificationViewModel(OtpVerificationReqModel model) async {
    otpVerificationApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      OtpVerificationResModel response =
          await AuthRepo().otpVerificationRepo(model);
      otpVerificationApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('registerApiResponse.......$e');
      otpVerificationApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///=====================OtpVerification ViewModel===================

  Future<void> fcmViewModel(FcmReqModel model) async {
    fcmApiResponse = ApiResponse.loading('Loading');
    try {
      FcmResModel response = await AuthRepo().fcmRepo(model);
      fcmApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('fcmApiResponse.......$e');
      fcmApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///=====================userNameAvailability ViewModel===================

  Future<void> userNameAvailability(String userName) async {
    userNameAvailabilityResponse = ApiResponse.loading('Loading');
    update();
    try {
      UserNameAvailabilityResModel response =
          await AuthRepo().getUserNameAvailabilityRepo(userName: userName);
      userNameAvailabilityResponse = ApiResponse.complete(response);
    } catch (e) {
      log('userNameAvailabilityResponse.......$e');
      userNameAvailabilityResponse = ApiResponse.error('error');
    }
    update();
  }

  bool _userStatus = false;

  bool get userStatus => _userStatus;

  set userStatus(bool value) {
    _userStatus = value;
    update();
  }

  PageController pageController = PageController(initialPage: 0);

  bool _focused = false;

  bool get focused => _focused;

  set focused(bool value) {
    _focused = value;
    update();
  }

  bool _setSignSelected = false;

  bool get getSignInSelected => _setSignSelected;

  void setSignSelected(bool value) {
    _setSignSelected = value;
    update();
  }

  int _pageSelector = 0;

  int get pageSelector => _pageSelector;

  set pageSelector(int value) {
    _pageSelector = value;
    update();
  }

  /// ===================CarouselSlider==================

  int _carouselSliderIndex = 0;

  int get carouselSliderIndex => _carouselSliderIndex;

  void setSliderIndex(int val) {
    _carouselSliderIndex = val;
    update();
  }
}
