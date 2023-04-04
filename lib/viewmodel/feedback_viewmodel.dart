import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/modal/apiModel/req_model/read_feedback_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_comment_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_one_feed_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_scoring_reting_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/like_unlike_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/payment_coin_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/read_feedback_res_model.dart';
import 'package:humanscoring/utils/const_utils.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';

import '../common/commonWidget/custom_dialog.dart';
import '../modal/apiModel/res_model/amount_converted_res_model.dart';
import '../modal/apiModel/res_model/delete_interaction_res_model.dart';
import '../modal/apiModel/res_model/get_feedback_details_res_model.dart';
import '../modal/apiModel/res_model/get_valid_phone_res_model.dart';
import '../modal/apiModel/res_model/my_feed_back_response_model.dart';
import '../modal/apiModel/res_model/you_posted_feedback_res_model.dart';
import '../modal/apis/api_response.dart';
import '../modal/repo/feebback_repo.dart';
import '../utils/assets/lotti_animation_json.dart';
import '../utils/variable_utils.dart';

class InteractionStatus {
  String? feedbackId, interactionId;
  bool? interactionStatus;
  int? count;

  InteractionStatus(
      {this.feedbackId,
      this.interactionId,
      this.interactionStatus,
      this.count});
}

class FeedBackViewModel extends GetxController {
  TextEditingController commentController = TextEditingController();

  ReadFeedBackReqModel readFeedBackReqModel = ReadFeedBackReqModel();

  ApiResponse getFeedBackApiResponse = ApiResponse.initial('Initial');
  ApiResponse getFeedBackDeepLinkApiResponse = ApiResponse.initial('Initial');
  ApiResponse getMyPostedFeedBackApiResponse = ApiResponse.initial('Initial');
  ApiResponse feedBackCommentFlagApiResponse = ApiResponse.initial('Initial');
  ApiResponse feedBackLikeApiResponse = ApiResponse.initial('Initial');
  ApiResponse userFeedBackDetailsApiResponse = ApiResponse.initial('Initial');
  ApiResponse paymentCoinApiResponse = ApiResponse.initial('Initial');
  ApiResponse amountConvertedApiResponse = ApiResponse.initial('Initial');
  ApiResponse scoreRatingApiResponse = ApiResponse.initial('Initial');
  ApiResponse getOneFeedApiResponse = ApiResponse.initial('Initial');
  ApiResponse readFeedBackApiResponse = ApiResponse.initial('Initial');
  ApiResponse commentApiResponse = ApiResponse.initial('Initial');
  ApiResponse interactionDeleteApiResponse = ApiResponse.initial('Initial');
  ApiResponse getValidPhoneNumberApiResponse = ApiResponse.initial('Initial');

  /// ===========================insidePostLikeMap============================
  int _postCommentCount = 0;

  int get postCommentCount => _postCommentCount;

  set postCommentCount(int value) {
    _postCommentCount = value;
    update();
  }

  set initPostCommentCount(int value) {
    _postCommentCount = value;
  }

  ///===========================inside All Like================
  Map<String, InteractionStatus> insideAllLikeMap =
      <String, InteractionStatus>{};

  ///===========================inside You DisLike================
  Map<String, InteractionStatus> insideAllDisLikeMap =
      <String, InteractionStatus>{};

  ///==================LOGIN USER POSTED AND RECEIVED COUNT.....===============

  int _myPostedCount = 0;
  int _myReceivedCount = 0;
  int _myFavoriteCount = 0;

  int get myFavoriteCount => _myFavoriteCount;

  set myFavoriteCount(int value) {
    _myFavoriteCount = value;
    update();
  }

  int get myPostedCount => _myPostedCount;

  set myPostedCount(int value) {
    _myPostedCount = value;
    update();
  }

  int get myReceivedCount => _myReceivedCount;

  set myReceivedCount(int value) {
    _myReceivedCount = value;
    update();
  }

  ///==================LOGIN USER POSTED AND RECEIVED COUNT.....===============

  String _interactionId = '';

  String get interactionId => _interactionId;

  set setInteractionId(String value) {
    _interactionId = value;
    update();
  }

  set initInteractionId(String value) {
    _interactionId = value;
  }

  bool _nonExistsUserFav = false;

  bool get nonExistsUserFav => _nonExistsUserFav;

  set initNonExistsUserFav(bool value) {
    _nonExistsUserFav = value;
  }

  set nonExistsUserFav(bool value) {
    _nonExistsUserFav = value;
    update();
  }

  UserObj _userObje = UserObj();

  UserObj get userObje => _userObje;

  set userObje(UserObj value) {
    _userObje = value;
    update();
  }

  set initUserObje(UserObj value) {
    _userObje = value;
  }

  String _totalTrustScore = '';

  String get totalTrustScore => _totalTrustScore;

  set initTotalTrustScore(String value) {
    _totalTrustScore = value;
  }

  set totalTrustScore(String value) {
    _totalTrustScore = value;
    update();
  }

  String _trustScore = '';

  String get trustScore => _trustScore;

  set initTrustScore(String value) {
    _trustScore = value;
  }

  set trustScore(String value) {
    _trustScore = value;
    update();
  }

  /// NON EXISTS USER ACTIVE STATUS
  bool _nonExistsUserActive = false;

  bool get nonExistsUserActive => _nonExistsUserActive;

  set initNonExistsUserActive(bool value) {
    _nonExistsUserActive = value;
  }

  set nonExistsUserActive(bool value) {
    _nonExistsUserActive = value;
    update();
  }

  int _postedCount = 0;

  int get postedCount => _postedCount;

  set postedCount(int value) {
    _postedCount = value;
    update();
  }

  set initPostedCount(int value) {
    _postedCount = value;
  }

  bool _isUserBlock = false;

  bool get isUserBlock => _isUserBlock;

  set isUserBlock(bool value) {
    _isUserBlock = value;
    update();
  }

  ///FLAG PROFILE....
  bool _isUserFlagProfile = false;

  bool get isUserFlagProfile => _isUserFlagProfile;

  set isUserFlagProfile(bool value) {
    _isUserFlagProfile = value;
    update();
  }

  int _receivedCount = 0;

  int get receivedCount => _receivedCount;

  set receivedCount(int value) {
    _receivedCount = value;
    update();
  }

  set initReceivedCount(int value) {
    _receivedCount = value;
  }

  bool _hideOptions = false;

  bool get hideOptions => _hideOptions;

  set hideOptions(bool value) {
    _hideOptions = value;
    update();
  }

  String _profileShareLink = '';

  String get profileShareLink => _profileShareLink;

  set profileShareLink(String value) {
    _profileShareLink = value;
    update();
  }

  MyFeedBackData _myFeedBackData = MyFeedBackData();

  MyFeedBackData get myFeedBackData => _myFeedBackData;

  set myFeedBackData(MyFeedBackData value) {
    _myFeedBackData = value;
    update();
  }

  List<MyFeedBackResults> myFeedBackResultList = [];
  List<YoursFeedbackPostedResults> yoursFeedbackPostedResults = [];
  List<String> feedBackId = [];
  int applicantPage = 1;
  int applicantTotalData = 0;
  bool isFeedScrollLoading = true;
  bool _isApplicantMoreLoading = false;

  bool get isApplicantMoreLoading => _isApplicantMoreLoading;

  Future<void> getMyFeed(
      {String? userId,
      String? queryKey,
      String? queryValue,
      String? campignId,
      bool? initLoad = true,
      bool? isExistsUser}) async {
    if (myFeedBackResultList.length >= applicantTotalData &&
        myFeedBackResultList.isNotEmpty) {
      return;
    }
    if (getFeedBackApiResponse.status != Status.COMPLETE) {
      getFeedBackApiResponse = ApiResponse.loading('Loading');
    } else {
      _isApplicantMoreLoading = true;
    }
    if (initLoad == true) {
      update();
    }
    try {
      if (queryKey == VariableUtils.phone) {
        queryValue = queryValue!.replaceAll("+", "%2B").replaceAll(" ", "");
      }
      String? url;
      if ((queryKey != null && queryValue != null) &&
          (queryKey.isNotEmpty && queryValue.isNotEmpty)) {
        url = "feedback?$queryKey=$queryValue&limit=10&page=$applicantPage";
      } else if (campignId != null && campignId.isNotEmpty) {
        url = "feedback?campaignId=$campignId&limit=10&page=$applicantPage";
      }
      final resModel = await FeedBackRepo().getMyFeedBackRepo(url: url);
      getFeedBackApiResponse = ApiResponse.complete(resModel);
      myFeedBackData = resModel.data!;
      applicantTotalData = resModel.data!.feedback!.totalResults!;
      postedCount = resModel.data!.postedCount!;
      receivedCount = resModel.data!.receivedCount!;
      trustScore = resModel.data!.trustScore!;
      totalTrustScore = resModel.data!.totalTrustScore!;
      hideOptions = resModel.data!.hideOptions!;
      profileShareLink = resModel.data!.profileShareLink!;

      if (resModel.data!.userObj != null) {
        initUserObje = resModel.data!.userObj!;
        initNonExistsUserFav = resModel.data!.userStatus!.favorite!;
        initNonExistsUserActive = resModel.data!.userObj!.active!;
        isUserBlock = resModel.data!.userObj!.defaultStatus!.block!;
        isUserFlagProfile = resModel.data!.userObj!.defaultStatus!.flag!;
      } else {
        initNonExistsUserActive = false;
        initNonExistsUserFav = false;
        initUserObje = UserObj();
      }
      List<MyFeedBackResults> feedId = resModel.data!.feedback!.results!;

      for (var element in feedId) {
        feedBackId.add(element.sId!);
      }
      readFeedBackReqModel.feedbackId = feedBackId;
      readFeedBackReqModel.read = true;
      readFeedBackViewModel(readFeedBackReqModel);
      applicantPage += 1;
      myFeedBackResultList.addAll(resModel.data!.feedback!.results!);
      isFeedScrollLoading = false;
      _isApplicantMoreLoading = false;
    } catch (e) {
      myFeedBackResultList.clear();
      isFeedScrollLoading = false;
      _isApplicantMoreLoading = false;
      initNonExistsUserActive = false;
      initNonExistsUserFav = false;
      initUserObje = UserObj();
      log('getFeedBackApiResponse ERROR=>$e');
      getFeedBackApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> getMyFeedDeepLink(
      {String? userId,
      String? queryKey,
      String? queryValue,
      String? campignId,
      bool? initLoad = true,
      bool? isExistsUser}) async {
    getFeedBackDeepLinkApiResponse = ApiResponse.initial('Loading');

    try {
      if (queryKey == VariableUtils.phone) {
        queryValue = queryValue!.replaceAll("+", "%2B").replaceAll(" ", "");
      }
      String? url;
      if ((queryKey != null && queryValue != null) &&
          (queryKey.isNotEmpty && queryValue.isNotEmpty)) {
        url = "feedback?$queryKey=$queryValue&limit=10&page=$applicantPage";
      }
      else if (campignId != null && campignId.isEmpty) {
        url = "feedback?campaignId=$campignId&limit=10&page=$applicantPage";
      }

      final resModel = await FeedBackRepo().getMyFeedBackRepo(url: url);
      getFeedBackDeepLinkApiResponse = ApiResponse.complete(resModel);
      myFeedBackData = resModel.data!;
      applicantTotalData = resModel.data!.feedback!.totalResults!;
      postedCount = resModel.data!.postedCount!;
      receivedCount = resModel.data!.receivedCount!;
      trustScore = resModel.data!.trustScore!;
      totalTrustScore = resModel.data!.totalTrustScore!;
      hideOptions = resModel.data!.hideOptions!;
      profileShareLink = resModel.data!.profileShareLink!;
      if (resModel.data!.userObj != null) {
        initUserObje = resModel.data!.userObj!;
        initNonExistsUserFav = resModel.data!.userStatus!.favorite!;
        initNonExistsUserActive = resModel.data!.userObj!.active!;
        isUserBlock = resModel.data!.userObj!.defaultStatus!.block!;
        isUserFlagProfile = resModel.data!.userObj!.defaultStatus!.flag!;
      } else {
        initNonExistsUserActive = false;
        initNonExistsUserFav = false;
        initUserObje = UserObj();
      }
    } catch (e) {
      myFeedBackResultList.clear();
      isFeedScrollLoading = false;
      _isApplicantMoreLoading = false;
      initNonExistsUserActive = false;
      initNonExistsUserFav = false;
      initUserObje = UserObj();

      log('getFeedBackDeepLinkApiResponse ERROR=>$e');
      getFeedBackDeepLinkApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> getMyPostedFeed(
      {bool? initLoad = true,
      String? userId,
      String? fromScreen,
      String? queryKey,
      String? queryValue,
      bool? isExistsUser}) async {
    if (yoursFeedbackPostedResults.length >= applicantTotalData &&
        yoursFeedbackPostedResults.isNotEmpty) {
      return;
    }
    if (getMyPostedFeedBackApiResponse.status != Status.COMPLETE) {
      getMyPostedFeedBackApiResponse = ApiResponse.loading('Loading');
    } else {
      _isApplicantMoreLoading = true;
    }
    if (initLoad == true) {
      update();
    }
    try {
      String url;
      if (queryKey == VariableUtils.phone) {
        queryValue = queryValue!.replaceAll("+", "%2B").replaceAll(" ", "");
      }
      logs(
          "queryValue =======  ${queryValue} PreferenceManagerUtils.getLoginId() ========= ${PreferenceManagerUtils.getLoginId()}");
      if (fromScreen == 'YouInside' ||
          queryValue == PreferenceManagerUtils.getLoginId()) {
        url = "feedback/postedFeedback?limit=5&page=$applicantPage";
      } else {
        url =
            "feedback/postedFeedback?$queryKey=$queryValue&limit=5&page=$applicantPage";
      }

      final resModel = await FeedBackRepo().getMyPostedFeedBackRepo(url: url);
      getMyPostedFeedBackApiResponse = ApiResponse.complete(resModel);
      applicantTotalData = resModel.data!.feedback!.totalResults!;
      List<YoursFeedbackPostedResults> feedId =
          resModel.data!.feedback!.results!;

      for (var element in feedId) {
        feedBackId.add(element.sId!);
      }
      readFeedBackReqModel.feedbackId = feedBackId;
      readFeedBackReqModel.read = true;
      readFeedBackViewModel(readFeedBackReqModel);

      applicantPage += 1;
      yoursFeedbackPostedResults.addAll(resModel.data!.feedback!.results!);
      isFeedScrollLoading = false;
      _isApplicantMoreLoading = false;
    } catch (e) {
      yoursFeedbackPostedResults.clear();
      isFeedScrollLoading = false;
      _isApplicantMoreLoading = false;
      log('yoursFeedbackPostedResults ERROR=>$e');
      getMyPostedFeedBackApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///======================FeedLikeDisLikeComment=====================
  Future<void> feedBackLDCViewModel(Map<String, dynamic> model) async {
    feedBackLikeApiResponse = ApiResponse.loading('Loading');
    try {
      FeedBackLikeUnLikeResModel response =
          await FeedBackRepo().feedBackLDCRepo(model);
      feedBackLikeApiResponse = ApiResponse.complete(response);
      setInteractionId = response.data!.sId!;
    } catch (e) {
      log('feedBackLikeUnLikeViewModel.......$e');
      feedBackLikeApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///======================FeedCommentFlag=====================
  Future<void> feedBackCommentFlagViewModel(Map<String, dynamic> model) async {
    feedBackCommentFlagApiResponse = ApiResponse.loading('Loading');
    try {
      CommentFlagViewModelRes response =
          await FeedBackRepo().feedBackCommentFlagRepo(model);
      feedBackCommentFlagApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('feedBackCommentFlagApiResponse.......$e');
      feedBackCommentFlagApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///======================UserFeedBackDetails=====================
  Future<GetFeedBackDetailsResModel?> userFeedBackDetailsViewModel(
      String? feedBackId) async {
    userFeedBackDetailsApiResponse = ApiResponse.loading('Loading');
    // update();
    try {
      GetFeedBackDetailsResModel response =
          await FeedBackRepo().getUserFeedBackRepo(feedBackId: feedBackId);

      userFeedBackDetailsApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('userFeedBackDetailsApiResponse.......$e');
      userFeedBackDetailsApiResponse = ApiResponse.error('error');
    }
    update();
    return null;
  }

  ///======================PAYMENT ViewModel=====================
  Future<void> paymentCoinViewModel({String? feedBackId}) async {
    paymentCoinApiResponse = ApiResponse.loading('Loading');
    try {
      PaymentCoinResModel response =
          await FeedBackRepo().paymentCoinRepo(feedBackId: feedBackId);
      paymentCoinApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('paymentCoinApiResponse.......$e');
      paymentCoinApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///======================FeedLikeDisLikeComment =====================
  Future<void> getScoreRatingViewModel({String? sId, bool? isActive}) async {
    scoreRatingApiResponse = ApiResponse.loading('Loading');
    try {
      GetScoreRatingResModel response = await FeedBackRepo().getScoreRating(
        sId: sId,
        isActive: isActive,
      );
      scoreRatingApiResponse = ApiResponse.complete(response);
      if (response.data!.transaction != null) {
        Material(
          child: openDialog(
              animation: successfulPaperPlaneAnimation,
              title: "Your Report",
              message: '${response.data!.transaction!.message}'),
        );
        Future.delayed(const Duration(seconds: 2), () {
          Get.back();
        });
      }
    } catch (e) {
      log('getScoreRatingViewModel.......$e');
      scoreRatingApiResponse = ApiResponse.error('error');
    }
    update();
  }

  bool likeSelected = false;
  int? tapped;
  String? selected;

  ///=====================FeedLikeDisLikeComment=====================

  int commentPage = 1;
  int commentTotalPage = 1;
  List<GetCommentResults> myCommentList = [];
  bool _commentIsLoading = false, _commentInitLoading = true;

  bool get commentInitLoading => _commentInitLoading;

  bool get commentIsLoading => _commentIsLoading;

  void commentClear() {
    commentPage = 1;
    myCommentList.clear();
    // update();
  }

  Future<void> getCommentViewModel(
      {required String userId, bool fromInit = false}) async {

    if (myCommentList.length >= commentTotalPage && myCommentList.isNotEmpty) {
      return;
    }
    commentApiResponse = ApiResponse.loading('Loading');
    if (!fromInit) {
      _commentIsLoading = true;
      // update();
    }

    try {
      String url =
          "feedback/interaction?feedbackId=$userId&type=comment&limit=5&page=$commentPage";
      GetCommentResModel response =
          await FeedBackRepo().getCommentRepo(url: url);
      commentApiResponse = ApiResponse.complete(response);
      commentTotalPage = response.data!.totalResults!;
      if (response.data!.results!.isNotEmpty) {
        commentPage += 1;
        myCommentList.addAll(response.data!.results!);
      }

      _commentIsLoading = false;
      _commentInitLoading = false;
    } catch (e) {
      log('feedBackCommentViewModel.......$e');
      commentApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> getValidPhoneNumberApiResponseViewModel(
      {required String phoneNumber}) async {
    getValidPhoneNumberApiResponse = ApiResponse.loading('Loading');
    try {
      String url = "feedback/checkphone?phone=$phoneNumber";
      GetValidPhoneResModel response =
          await FeedBackRepo().getValidPhoneNumberRepo(url: url);
      getValidPhoneNumberApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('getValidPhoneNumberApiResponse.......$e');
      getValidPhoneNumberApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///======================FeedLikeDisLikeComment Repo=====================
  Future getOneFeedViewModel() async {
    getOneFeedApiResponse = ApiResponse.loading('Loading');
    try {
      GetOneFeedBackResModel response = await FeedBackRepo().getOneFeedRepo();
      getOneFeedApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('GetOneFeedBackResModel.......$e');
      getOneFeedApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///======================FeedLikeDisLikeComment Repo=====================
  Future readFeedBackViewModel(ReadFeedBackReqModel model) async {
    readFeedBackApiResponse = ApiResponse.loading('Loading');
    try {
      ReadFeedBackResModel response =
          await FeedBackRepo().readFeedBackRepo(model);
      readFeedBackApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('readFeedBackViewModel.......$e');
      readFeedBackApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///======================amountConvertedApiResponse Repo=====================
  Future amountConvertedViewModel({required String amount}) async {
    amountConvertedApiResponse = ApiResponse.loading('Loading');
    try {
      AmountConvertedResModel response =
          await FeedBackRepo().amountConvertedRepo(amount: amount);
      amountConvertedApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('amountConvertedApiResponse.......$e');
      amountConvertedApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///======================Delete interaction Repo=====================
  Future interactionDeleteViewModel({String? interactionId}) async {
    interactionDeleteApiResponse = ApiResponse.loading('Loading');
    try {
      DeleteInteractionResModel response =
          await FeedBackRepo().interactionDelete(interactionId);
      interactionDeleteApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('interactionDeleteApiResponse.......$e');
      interactionDeleteApiResponse = ApiResponse.error('error');
    }
    update();
  }

  void apiInit() {
    getFeedBackDeepLinkApiResponse = ApiResponse.initial('Initial');
    refresh();
  }
}
