import 'dart:developer';

import 'package:get/get.dart';
import 'package:humanscoring/modal/apiModel/req_model/block_req_model.dart';
import 'package:humanscoring/modal/apiModel/req_model/feed_like_request_model.dart';
import 'package:humanscoring/modal/apiModel/req_model/feed_pin_request_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/block_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/dash_boared_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/feed_like_pin_response_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/feedback_delete_res_model.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/modal/repo/dash_board_repo.dart';
import 'package:humanscoring/utils/variable_utils.dart';

import '../modal/apiModel/res_model/all_feeds_respo_model.dart';
import 'address_book_viewmodel.dart';

class DashBoardViewModel extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    AddressBookViewModel().getContactAddToAPIList();

    allFeedsViewModel();

    super.onInit();
  }

  bool _anonymous = false;

  bool get anonymous => _anonymous;

  set anonymous(bool value) {
    _anonymous = value;
    update();
  }

  set initAnonymous(bool value) {
    _anonymous = value;
  }

  bool _isUserFavourite = false;

  bool get getIsUserFavourite => _isUserFavourite;

  set setIsUserFavourite(bool value) {
    _isUserFavourite = value;
    update();
  }

  set initIsUserFavourite(bool value) {
    _isUserFavourite = value;
  }

  ApiResponse dashBoardApiResponse = ApiResponse.initial('Initial');
  ApiResponse allFeedsApiResponse = ApiResponse.initial('Initial');
  ApiResponse feedLikeApiResponse = ApiResponse.initial('Initial');
  ApiResponse feedPinApiResponse = ApiResponse.initial('Initial');
  ApiResponse subScribeApiResponse = ApiResponse.initial('Initial');
  ApiResponse deleteFeedApiResponse = ApiResponse.initial('Initial');
  ApiResponse subScribeDeleteApiResponse = ApiResponse.initial('Initial');
  ApiResponse blockFeedApiResponse = ApiResponse.initial('Initial');
  ApiResponse flagProfileApiResponse = ApiResponse.initial('Initial');

  Future<void> dashBoardViewModel(Map<String, dynamic> model) async {
    dashBoardApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      DashBoardResModel response = await DashBoardRepo().dashBoardRepo(model);
      dashBoardApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('DashBoardResModel.......$e');
      dashBoardApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> allFeedsViewModel() async {
    allFeedsApiResponse = ApiResponse.loading('Loading');
    try {
      AllFeedsRespoModel response = await DashBoardRepo().allFeedsRepo();
      allFeedsApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('allFeedsApiResponse.......$e');
      allFeedsApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future feedLikeViewModel(FeedLikeRequestModel model,
      {String? connectionUrl}) async {
    feedLikeApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      FeedLikePinResponseModel response = await DashBoardRepo()
          .feedLikeRepo(model, connectionUrl: connectionUrl);
      feedLikeApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('DashBoardResModel.......$e');
      feedLikeApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> feedPinViewModel(FeedPinRequestModel model) async {
    feedPinApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      FeedLikePinResponseModel response =
          await DashBoardRepo().feedPinRepo(model);
      feedPinApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('DashBoardResModel.......$e');
      feedPinApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///==============================DeleteFeed===========================

  Future feedDeleteViewModel({Map<String, dynamic>? body}) async {
    deleteFeedApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      FeedbackDeleteResModel response =
          await DashBoardRepo().deleteFeedBack(body: body);
      deleteFeedApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('DashBoardResModel.......$e');
      deleteFeedApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///==============================User Block/Unblock===========================

  Future userBlockUnblockViewModel(BlockReqModel model) async {
    blockFeedApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      BlockResModel response = await DashBoardRepo().blockUnBlockUser(model);
      blockFeedApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('DashBoardResModel.......$e');
      blockFeedApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///==============================User Flag profile===========================

  Future flagProfileViewModel(FlagProfileReqModel model) async {
    flagProfileApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      BlockResModel response = await DashBoardRepo().flagUserProfile(model);
      flagProfileApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('DashBoardResModel.......$e');
      flagProfileApiResponse = ApiResponse.error('error');
    }
    update();
  }

  int? _anonySelector = 0;

  set anonySelector(int? value) {
    _anonySelector = value;
    update();
  }

  int? get anonySelector => _anonySelector;

  int? _relationSelector = 0;

  int? get relationSelector => _relationSelector;

  set relationSelector(int? value) {
    _relationSelector = value;
    update();
  }

  String? _selectedRelation;

  String get selectedRelation => _selectedRelation ?? "Select Relation";

  set selectedRelation(String value) {
    _selectedRelation = value;
    update();
  }

  String? _selectedReview;

  String get selectedReview => _selectedReview ?? VariableUtils.typeOfReview;

  set selectedReview(String value) {
    _selectedReview = value;
    update();
  }

  List visibleData = [];

  void dataList(String? id) {
    if (visibleData.contains(id)) {
    } else {
      visibleData.add(id);
    }
    update();
  }

  Map pinData = {};

  void pinList(String? id, bool? value) {
    if (pinData.keys.toList().contains(id)) {
      pinData[id] = !pinData[id];
    } else {
      pinData.addAll({id: value});
    }
    update();
  }
}
