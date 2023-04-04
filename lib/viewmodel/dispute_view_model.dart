import 'dart:developer';

import 'package:get/get.dart';
import 'package:humanscoring/modal/apiModel/res_model/dispute_res_model.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/modal/repo/dispute_repo.dart';

class DisputeViewModel extends GetxController {
  ApiResponse disputeApiResponse = ApiResponse.initial('Initial');

  Future<void> disputeViewModel(
      {required String feedbackId, required String? dateTime}) async {
    disputeApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      Map<String, dynamic> body = {
        "feedbackId": feedbackId,
        "dateTime": dateTime
      };

      DisputeResModel response = await DisputeRepo().disputeRepo(body: body);
      disputeApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('disputeApiResponse.......$e');
      disputeApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
