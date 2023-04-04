import 'dart:developer';

import 'package:get/get.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/modal/repo/user_activity_repo.dart';

import '../modal/apiModel/res_model/posted_feedback_res_model.dart';

class PostFeedBackViewModel extends GetxController {
  ApiResponse postFeedBackApiResponse = ApiResponse.initial('Initial');

  List<MyFeedBackResults> getFeedBackPostedList = [];

  int feedBackPostedPage = 1;
  int feedBackPostedTotalData = 0;
  bool isFeedBackPostedFirstLoading = true;
  bool _isFeedBackPostedMoreLoading = false;

  bool get isFeedBackPostedMoreLoading => _isFeedBackPostedMoreLoading;

  Future<void> getFeedBackPosted({bool? initLoad = true}) async {
    if (getFeedBackPostedList.length >= feedBackPostedTotalData &&
        getFeedBackPostedList.isNotEmpty) {
      return;
    }
    postFeedBackApiResponse = ApiResponse.loading('Loading');
    _isFeedBackPostedMoreLoading = true;
    if (initLoad == true) {
      update();
    }
    try {
      String url = "feedback/activity?type=feedback&page=$feedBackPostedPage";

      final resModel = await UserActivityRepo().postedFeedBackRepo(url: url);
      postFeedBackApiResponse = ApiResponse.complete(resModel);
      feedBackPostedTotalData = resModel.data!.totalResults!;

      feedBackPostedPage += 1;
      getFeedBackPostedList.addAll(resModel.data!.results!);
      isFeedBackPostedFirstLoading = false;
      _isFeedBackPostedMoreLoading = false;
    } catch (e) {
      log('FeedBackPostedResApiResponse posted**** ERROR=>$e');
      isFeedBackPostedFirstLoading = false;
      _isFeedBackPostedMoreLoading = false;
      postFeedBackApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
