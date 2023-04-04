import 'dart:developer';

import 'package:get/get.dart';
import 'package:humanscoring/modal/apiModel/req_model/avatar_username_req_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/avatar_username_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_avatar_username_res_model.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/modal/repo/auth_repo.dart';

class AvatarUserNameController extends GetxController {
  ///======================UseNameViewModel=======================

  ApiResponse getAvatarUserNameApiResponse = ApiResponse.initial('Initial');
  ApiResponse avatarUserNameApiResponse = ApiResponse.initial('Initial');

  Future<void> getAvatarUserNameViewModel() async {
    getAvatarUserNameApiResponse = ApiResponse.loading('Loading');
    try {
      GetAvatarUserNameResModel response =
          await AuthRepo().getAvatarUserNameRepo();
      getAvatarUserNameApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('getAvatarApiResponse.......$e');
      getAvatarUserNameApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///======================UseNameViewModel=======================

  Future<void> avatarUserNameViewModel(AvatarUserNameReqModel model) async {
    avatarUserNameApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      AvatarUserNameResModel response =
          await AuthRepo().avatarUserNameRepo(model);
      avatarUserNameApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('avatarUserNameApiResponse.......$e');
      avatarUserNameApiResponse = ApiResponse.error('error');
    }
    update();
  }

  int _setPageIndex = 0;

  int get setPageIndex => _setPageIndex;

  set setPageIndex(int value) {
    _setPageIndex = value;
    update();
  }

  set initSetPageIndex(int value) {
    _setPageIndex = value;
  }

  bool _isLogout = false;

  bool get isLogout => _isLogout;

  set setIsLogout(bool value) {
    _isLogout = value;
    update();
  }

  String? selectedUrl;

  List<String> title = [
    'OFF',
    'ON',
  ];
  int _tabSelector = 0;

  int get tabSelector => _tabSelector;

  set tabSelector(int value) {
    _tabSelector = value;
    update();
  }
}
