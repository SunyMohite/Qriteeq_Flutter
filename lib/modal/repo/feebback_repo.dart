import 'package:humanscoring/modal/apiModel/req_model/read_feedback_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_comment_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_one_feed_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_scoring_reting_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/like_unlike_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/payment_coin_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/read_feedback_res_model.dart';
import 'package:humanscoring/modal/services/base_service.dart';

import '../../utils/enum_utils.dart';
import '../apiModel/res_model/amount_converted_res_model.dart';
import '../apiModel/res_model/delete_interaction_res_model.dart';
import '../apiModel/res_model/get_feedback_details_res_model.dart';
import '../apiModel/res_model/get_valid_phone_res_model.dart';
import '../apiModel/res_model/my_feed_back_response_model.dart';
import '../apiModel/res_model/you_posted_feedback_res_model.dart';
import '../services/api_service.dart';

class FeedBackRepo extends BaseService {
  Future<MyFeedBackResponseModel> getMyFeedBackRepo({
    required String? url,
  }) async {
    final response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);

    MyFeedBackResponseModel getJobRespModel =
        MyFeedBackResponseModel.fromJson(response);

    return getJobRespModel;
  }

  ///GET USER FEEDBACK DETAILS REPO.....
  Future<GetFeedBackDetailsResModel> getUserFeedBackRepo({
    required String? feedBackId,
  }) async {
    final url = 'feedback/$feedBackId';
    final response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);

    GetFeedBackDetailsResModel getFeedBackDetailsResModel =
        GetFeedBackDetailsResModel.fromJson(response);

    return getFeedBackDetailsResModel;
  }

  ///GET MY POSTED FEEDBACK......
  Future<YouPostedFeedBackResModel> getMyPostedFeedBackRepo({
    required String? url,
  }) async {
    final response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);

    // log("YouPostedFeedBackResModel Res... :${response}");
    YouPostedFeedBackResModel getJobRespModel =
        YouPostedFeedBackResModel.fromJson(response);

    return getJobRespModel;
  }

  ///======================FeedBackLike Repo=============================

  Future<dynamic> feedBackLDCRepo(Map<String, dynamic> model) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: feedbackLike,
      body: model,
    );
    FeedBackLikeUnLikeResModel feedBackLikeResModel =
        FeedBackLikeUnLikeResModel.fromJson(response);
    return feedBackLikeResModel;
  }

  ///======================FeedBackCommentFlagViewModelRes Repo=============================

  Future<dynamic> feedBackCommentFlagRepo(Map<String, dynamic> model) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: feedbackLike,
      body: model,
    );
    CommentFlagViewModelRes commentFlagViewModelRes =
        CommentFlagViewModelRes.fromJson(response);
    return commentFlagViewModelRes;
  }

  ///======================FeedBackLike Repo=============================

  Future<dynamic> paymentCoinRepo({String? feedBackId}) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: paymentCoin + feedBackId!, body: {});
    PaymentCoinResModel paymentCoinResModel =
        PaymentCoinResModel.fromJson(response);
    return paymentCoinResModel;
  }

  ///=====================Generat Raport==========================

  Future<dynamic> getScoreRating({String? sId, bool? isActive}) async {
    final String scoringRating =
        'feedback/report?${isActive == true ? "userId" : "url"}=';
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: scoringRating + sId!,
    );
    GetScoreRatingResModel getScoreRatingResModel =
        GetScoreRatingResModel.fromJson(response);
    return getScoreRatingResModel;
  }

  ///==================Comment Repo==============================

  Future getCommentRepo({required String? url}) async {
    final response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    GetCommentResModel getCommentResModel =
        GetCommentResModel.fromJson(response);
    return getCommentResModel;
  }

  ///==================Comment Repo==============================

  Future getValidPhoneNumberRepo({required String? url}) async {
    final response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    GetValidPhoneResModel getValidPhoneResModel =
        GetValidPhoneResModel.fromJson(response);
    return getValidPhoneResModel;
  }

  ///=====================GetOneFeed Repo==========================

  Future<dynamic> getOneFeedRepo() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: activeFeedBack,
    );
    GetOneFeedBackResModel getOneFeedBackResModel =
        GetOneFeedBackResModel.fromJson(response);
    return getOneFeedBackResModel;
  }

  ///=================ReadFeedBack Repo=========================

  Future<dynamic> readFeedBackRepo(ReadFeedBackReqModel model) async {
    Map<String, dynamic> body = model.toJson();

    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: readStatus,
      body: body,
    );
    ReadFeedBackResModel readFeedBackResModel =
        ReadFeedBackResModel.fromJson(response);

    return readFeedBackResModel;
  }

  ///=====================GetOneFeed Repo==========================

  Future<dynamic> amountConvertedRepo({required String amount}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: getAmount + amount,
    );
    AmountConvertedResModel amountConvertedResModel =
        AmountConvertedResModel.fromJson(response);
    return amountConvertedResModel;
  }

  ///=======================SubScribeDelete=====================

  Future interactionDelete(String? interactionId) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aDelete,
      url: deleteInteraction + interactionId!,
    );
    DeleteInteractionResModel deleteInteractionResModel =
        DeleteInteractionResModel.fromJson(response);
    return deleteInteractionResModel;
  }
}
