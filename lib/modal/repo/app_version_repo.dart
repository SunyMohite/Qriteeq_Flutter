import '../../utils/enum_utils.dart';
import '../apiModel/res_model/app_version_res_model.dart';
import '../services/api_service.dart';
import '../services/base_service.dart';

class AppVersionRepo extends BaseService {
  ///=====================AppVersionRepo==========================

  Future<dynamic> getAppVersionRepo() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: appVersion,
    );
    AppVersionResModel appVersionResModel =
        AppVersionResModel.fromJson(response);
    return appVersionResModel;
  }
}
