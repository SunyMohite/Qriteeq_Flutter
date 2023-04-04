import 'dart:developer';

import 'package:get/get.dart';
import 'package:humanscoring/modal/apis/api_response.dart';

import '../modal/apiModel/res_model/global_feedback_res_model.dart';
import '../modal/repo/global_feedback_repo.dart';

class GlobalFeedBackViewModel extends GetxController {
  ApiResponse globalFeedBackApiResponse = ApiResponse.initial('Initial');

  List<GlobalFeedBackDataResults> globalFeedBackDataResults = [];

  int globalFeedBackPostedPage = 1;
  int globalFeedBackPostedTotalData = 0;
  bool isGlobalFeedBackPostedFirstLoading = true;
  bool _isGlobalFeedBackPostedMoreLoading = false;

  bool get isFeedBackPostedMoreLoading => _isGlobalFeedBackPostedMoreLoading;

  Future<void> getGlobalFeedBackPosted({bool? initLoad = true}) async {
    if (globalFeedBackDataResults.length >= globalFeedBackPostedTotalData &&
        globalFeedBackDataResults.isNotEmpty) {
      return;
    }
    globalFeedBackApiResponse = ApiResponse.loading('Loading');
    _isGlobalFeedBackPostedMoreLoading = true;
    if (initLoad == true) {
      update();
    }
    try {
      String url =
          "admin/feedback?status=all&limit=5&page=$globalFeedBackPostedPage";
      final resModel =
          await GlobalFeedBackRepo().globalFeedBackRepo(globalFeedUrl: url);
      globalFeedBackApiResponse = ApiResponse.complete(resModel);
      globalFeedBackPostedTotalData = resModel.data!.totalResults!;

      globalFeedBackPostedPage += 1;
      globalFeedBackDataResults.addAll(resModel.data!.results!);

      isGlobalFeedBackPostedFirstLoading = false;

      _isGlobalFeedBackPostedMoreLoading = false;
    } catch (e) {
      isGlobalFeedBackPostedFirstLoading = false;
      _isGlobalFeedBackPostedMoreLoading = false;
      log('FeedBackPostedResApiResponse ERROR=>$e');
      globalFeedBackApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
