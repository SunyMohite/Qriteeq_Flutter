import 'package:humanscoring/modal/apiModel/res_model/get_search_res_model.dart';
import 'package:humanscoring/modal/services/api_service.dart';
import 'package:humanscoring/utils/enum_utils.dart';
import '../services/base_service.dart';

class SearchFeedBackRepo extends BaseService {
  ///==========================All feeds GetRepo====================

  Future<dynamic> searchFeedBackRepo(String? title) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: search+title!,
    );
    GetSearchResModel getSearchResModel = GetSearchResModel.fromJson(response);
    return getSearchResModel;
  }
}
