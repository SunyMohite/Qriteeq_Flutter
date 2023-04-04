import 'package:humanscoring/modal/apiModel/res_model/subscribe_list_res_model.dart';
import 'package:humanscoring/modal/services/api_service.dart';
import 'package:humanscoring/utils/enum_utils.dart';
import '../apiModel/res_model/my_favourite_res_model.dart';
import '../services/base_service.dart';

class SubScribeListRepo extends BaseService {
  ///==========================SubScribe List Repo====================

  Future<SubscribeListResModel> subScribeListRepo({String? url}) async {
    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    SubscribeListResModel subscribeListResModel =
        SubscribeListResModel.fromJson(response);
    return subscribeListResModel;
  }

  Future getMyFavoriteBookRepo({String? url}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: url,
    );
    MyFavouriteResModel myFavouriteResModel =
        MyFavouriteResModel.fromJson(response);
    return myFavouriteResModel;
  }
}
