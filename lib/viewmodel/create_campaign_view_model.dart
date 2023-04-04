import 'dart:developer';

import 'package:get/get.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_campaign_id_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_campaign_res_model.dart';

import '../modal/apiModel/res_model/campaign_model_resp.dart';
import '../modal/apis/api_response.dart';
import '../modal/repo/create_campaign_repo.dart';

class CreateCampaignRequestViewModel extends GetxController {
  ApiResponse createCampaignRequestApiResponse = ApiResponse.initial('Initial');
  ApiResponse getCampaignApiResponse = ApiResponse.initial('Initial');
  ApiResponse getCampaignIdApiResponse = ApiResponse.initial('Initial');

  /// =================createCampaignRequestViewModel=========================
  Future<void> createCampaignRequestViewModel(
      {required Map<String, dynamic> requestBody}) async {
    createCampaignRequestApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      CampaignModelResponse response = await CreateCampaignRequestRepo()
          .createCampaignRepo(requestBody: requestBody);
      createCampaignRequestApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('createCampaignRequestApiResponse.......$e');
      createCampaignRequestApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// =================getCampaignIdViewModel=========================
  Future<void> getCampaignIdViewModel({required String id}) async {
    getCampaignIdApiResponse = ApiResponse.loading('Loading');

    update();
    try {
      GetCampaignIdResModel response =
          await CreateCampaignRequestRepo().getCampaignIdRepo(id: id);

      getCampaignIdApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('getCampaignIdApiResponse.......$e');
      getCampaignIdApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// =================createCampaignRequestViewModel=========================

  List<GetCampaign> getCampaignList = [];
  int getCampaignPage = 1;
  int getCampaignTotalData = 0;
  bool isGetCampaignFirstLoading = true;
  bool _isGetCampaignMoreLoading = false;

  bool get isGetCampaignMoreLoading => _isGetCampaignMoreLoading;

  Future<void> getCampaignViewModel(
      {bool? initLoad = true, bool? active}) async {
    if (getCampaignList.length >= getCampaignTotalData &&
        getCampaignList.isNotEmpty) {
      return;
    }

    getCampaignApiResponse = ApiResponse.loading('Loading');
    _isGetCampaignMoreLoading = true;

    if (initLoad == true) {
      update();
    }
    try {
      String url = "campaign?active=$active&page=$getCampaignPage";
      GetCampaignResModel response =
          await CreateCampaignRequestRepo().getCampaignRepo(url: url);
      getCampaignApiResponse = ApiResponse.complete(response);
      getCampaignTotalData = response.data!.totalResults!;

      getCampaignPage += 1;
      getCampaignList.addAll(response.data!.results!);
      isGetCampaignFirstLoading = false;
      _isGetCampaignMoreLoading = false;
    } catch (e) {
      getCampaignList.clear();
      isGetCampaignFirstLoading = false;
      _isGetCampaignMoreLoading = false;
      log('getCampaignApiResponse.......$e');
      getCampaignApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
