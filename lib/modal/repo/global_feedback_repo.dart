import 'package:humanscoring/modal/services/api_service.dart';
import 'package:humanscoring/utils/enum_utils.dart';
import '../apiModel/res_model/global_feedback_res_model.dart';
import '../services/base_service.dart';

class GlobalFeedBackRepo extends BaseService {
  ///==========================globalFeedBackRepo====================

  Future<dynamic> globalFeedBackRepo({String? globalFeedUrl}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: globalFeedUrl,
    );
    GlobalFeedBackResModel globalFeedBackResModel =
        GlobalFeedBackResModel.fromJson(response);
    return globalFeedBackResModel;
  }
}
