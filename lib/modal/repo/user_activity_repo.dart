import 'package:humanscoring/modal/apiModel/res_model/posted_feedback_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/your_interactions_res_model.dart';
import 'package:humanscoring/modal/services/api_service.dart';
import 'package:humanscoring/utils/enum_utils.dart';
import '../services/base_service.dart';

class UserActivityRepo extends BaseService {
  ///==========================LeaderBoard Repo====================

  Future<PostedFeedBackResModel> postedFeedBackRepo({String? url}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: url,
    );
    PostedFeedBackResModel postedFeedBackResModel =
        PostedFeedBackResModel.fromJson(response);
    return postedFeedBackResModel;
  }
  ///==========================YourInteraction Repo====================

  Future<YourInteractionsResModel> yourInteractionsRepo({String? url}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: url,
    );
    YourInteractionsResModel yourInteractionsResModel =
        YourInteractionsResModel.fromJson(response);
    return yourInteractionsResModel;
  }
}
