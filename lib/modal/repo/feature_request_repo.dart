import 'package:humanscoring/modal/services/base_service.dart';

import '../../utils/enum_utils.dart';
import '../apiModel/res_model/feature_request_res_model.dart';
import '../services/api_service.dart';

class FeatureRequestRepo extends BaseService {
  Future<FeatureRequestResModel> yourInteractionsRepo({String? msg}) async {
    Map<String, dynamic> body = {"feature": msg};

    var response = await ApiService()
        .getResponse(apiType: APIType.aPost, url: featureRequest, body: body);
    FeatureRequestResModel yourInteractionsResModel =
        FeatureRequestResModel.fromJson(response);

    return yourInteractionsResModel;
  }
}
