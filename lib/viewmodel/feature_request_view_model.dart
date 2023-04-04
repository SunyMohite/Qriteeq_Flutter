import 'dart:developer';

import 'package:get/get.dart';

import '../modal/apiModel/res_model/feature_request_res_model.dart';
import '../modal/apis/api_response.dart';
import '../modal/repo/feature_request_repo.dart';

class FeatureRequestViewModel extends GetxController {
  ApiResponse featureRequestApiResponse = ApiResponse.initial('Initial');

  Future<void> featureRequestViewModel({String? msg}) async {
    featureRequestApiResponse = ApiResponse.loading('Loading');
    update();

    try {
      FeatureRequestResModel response =
          await FeatureRequestRepo().yourInteractionsRepo(msg: msg);
      featureRequestApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('featureRequestApiResponse.......$e');
      featureRequestApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
