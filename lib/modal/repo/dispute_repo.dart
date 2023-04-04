import 'package:humanscoring/modal/apiModel/res_model/dispute_res_model.dart';
import 'package:humanscoring/modal/services/api_service.dart';
import 'package:humanscoring/modal/services/base_service.dart';
import 'package:humanscoring/utils/enum_utils.dart';

class DisputeRepo extends BaseService {
  Future<DisputeResModel> disputeRepo({
    required Map<String, dynamic>? body,
  }) async {
    final response = await ApiService()
        .getResponse(apiType: APIType.aPost, url: dispute, body: body);

    DisputeResModel disputeResModel = DisputeResModel.fromJson(response);

    return disputeResModel;
  }
}
