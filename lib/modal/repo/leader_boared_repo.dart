import 'package:humanscoring/modal/services/api_service.dart';
import 'package:humanscoring/modal/services/base_service.dart';
import 'package:humanscoring/utils/enum_utils.dart';

import '../apiModel/res_model/get_leaderboard_filter_res_model.dart';

class LeaderBoardRepo extends BaseService {
  ///==========================LeaderBoard Repo====================

  Future leaderBoardRepo({
    required String url,
  }) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: url,
    );
    GetLeaderBoardResModel getLeaderBoardResModel =
        GetLeaderBoardResModel.fromJson(response);
    return getLeaderBoardResModel;
  }
}
