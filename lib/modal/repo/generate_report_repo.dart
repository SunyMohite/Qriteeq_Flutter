import '../../utils/enum_utils.dart';
import '../apiModel/res_model/generate_report_res_model.dart';
import '../apiModel/res_model/user_generate_report_res_model.dart';
import '../services/api_service.dart';
import '../services/base_service.dart';

class GenerateReportRepo extends BaseService {
  ///==========================GenerateReport List Repo====================

  Future<GenerateReportResModel> generateReportRepo({String? url}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: url,
    );
    GenerateReportResModel generateReportResModel =
        GenerateReportResModel.fromJson(response);
    return generateReportResModel;
  }

  ///==========================UserGenerateReport List Repo====================

  Future userGenerateReportListRepo({required String url}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: url,
    );
    UserGenerateReportResModel userGenerateReportResModel =
        UserGenerateReportResModel.fromJson(response);
    return userGenerateReportResModel;
  }
}
