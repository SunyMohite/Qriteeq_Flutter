import 'dart:developer';

import 'package:get/get.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_referral_bal_res_model.dart';
import 'package:humanscoring/modal/repo/referral_repo.dart';

import '../modal/apis/api_response.dart';

class ReferralViewModel extends GetxController {
  ApiResponse referralBalApiResponse = ApiResponse.initial('Initial');

  Future<void> referralViewModel() async {
    referralBalApiResponse = ApiResponse.loading('Loading');
    update();

    try {
      GetReferralBalResModel response = await ReferralRepo().referralRepo();
      referralBalApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('referralBalApiResponse.......$e');
      referralBalApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
