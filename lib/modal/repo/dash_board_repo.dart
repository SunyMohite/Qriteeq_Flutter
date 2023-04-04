import 'package:humanscoring/modal/apiModel/req_model/block_req_model.dart';
import 'package:humanscoring/modal/apiModel/req_model/subscribe_req_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/block_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/dash_boared_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/feed_like_pin_response_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/feedback_delete_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/subscribe_delte_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/subscribe_res_model.dart';
import 'package:humanscoring/modal/services/api_service.dart';
import 'package:humanscoring/utils/enum_utils.dart';
import '../apiModel/req_model/feed_like_request_model.dart';
import '../apiModel/req_model/feed_pin_request_model.dart';
import '../apiModel/res_model/all_feeds_respo_model.dart';
import '../services/base_service.dart';

class DashBoardRepo extends BaseService {
  ///==========================AddressBook GetRepo====================

  Future<dynamic> dashBoardRepo(Map<String, dynamic> model) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: dashBoard,
      body: model,
    );
    DashBoardResModel dashBoardResModel = DashBoardResModel.fromJson(response);
    return dashBoardResModel;
  }
  ///==========================All feeds GetRepo====================

  Future<dynamic> allFeedsRepo() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: allFeed,
    );
    AllFeedsRespoModel allFeedsResModel = AllFeedsRespoModel.fromJson(response);
    return allFeedsResModel;
  }
  ///==========================feedLikeRepo ====================

  Future feedLikeRepo(FeedLikeRequestModel model,
      {String? connectionUrl}) async {
    Map<String, dynamic> body;
    if (connectionUrl != null) {
      body = model.toJsonNonExistsUser();
    } else {
      body = model.toJson();
    }
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: connectionUrl ?? connection,
      body: body,
    );
    FeedLikePinResponseModel feedLikeResponseModel =
        FeedLikePinResponseModel.fromJson(response);
    return feedLikeResponseModel;
  }
  ///==========================feedPinRepo ====================

  Future feedPinRepo(FeedPinRequestModel model) async {
    Map<String, dynamic> body = model.toJson();

    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: connection,
      body: body,
    );
    FeedLikePinResponseModel feedPinResponseModel =
        FeedLikePinResponseModel.fromJson(response);
    return feedPinResponseModel;
  }
  ///=====================FeedBack SubScribe========

  Future subscribeFeedBack(SubscribeReqModel model) async {
    Map<String, dynamic> body = model.toJson();

    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: connection,
      body: body,
    );
    SubscribeResModel subscribeResModel = SubscribeResModel.fromJson(response);
    return subscribeResModel;
  }
  ///=======================SubScribeDelete=====================

  Future subscribeDelete(String? id) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aDelete,
      url: deleteConnection + id!,
    );
    SubscribeDeleteResModel subscribeDeleteResModel =
        SubscribeDeleteResModel.fromJson(response);
    return subscribeDeleteResModel;
  }
  ///========================FeedDelete==================

  Future deleteFeedBack({Map<String, dynamic>? body}) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aPost, url: connection, body: body);
    FeedbackDeleteResModel feedbackDeleteResModel =
        FeedbackDeleteResModel.fromJson(response);
    return feedbackDeleteResModel;
  }
  ///==============================User Block/Unblock===========================

  Future blockUnBlockUser(BlockReqModel model) async {
    Map<String, dynamic> body = model.toJson();

    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: connection,
      body: body,
    );
    BlockResModel blockResModel = BlockResModel.fromJson(response);
    return blockResModel;
  }

  Future flagUserProfile(FlagProfileReqModel model) async {
    Map<String, dynamic> body = model.toJson();

    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: connection,
      body: body,
    );
    BlockResModel blockResModel = BlockResModel.fromJson(response);
    return blockResModel;
  }
}
