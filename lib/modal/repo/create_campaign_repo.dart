import 'package:humanscoring/modal/apiModel/res_model/get_campaign_res_model.dart';
import 'package:humanscoring/modal/services/base_service.dart';
import 'package:humanscoring/utils/const_utils.dart';

import '../../utils/enum_utils.dart';
import '../apiModel/res_model/campaign_model_resp.dart';
import '../apiModel/res_model/get_campaign_id_res_model.dart';
import '../services/api_service.dart';

class CreateCampaignRequestRepo extends BaseService {
  /// =================createCampaignRepo==================
  Future<CampaignModelResponse> createCampaignRepo(
      {required Map<String, dynamic> requestBody}) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aPost, url: campaign, body: requestBody);
    CampaignModelResponse campaignModelResponse =
        CampaignModelResponse.fromJson(response);

    return campaignModelResponse;
  }
  /// =================getCampaignRepo==================

  Future<GetCampaignResModel> getCampaignRepo({required String url}) async {
    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    GetCampaignResModel getCampaignResModel =
        GetCampaignResModel.fromJson(response);

    return getCampaignResModel;
  }
  ///=================getCampaignIdRepo==================
  Future<GetCampaignIdResModel> getCampaignIdRepo({required String id}) async {
    String url = campaign + '?id=$id';
    logs('===$url');

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    GetCampaignIdResModel getCampaignResIdModel =
        GetCampaignIdResModel.fromJson(response);

    return getCampaignResIdModel;
  }
}
