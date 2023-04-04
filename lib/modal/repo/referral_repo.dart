import 'package:humanscoring/modal/apiModel/res_model/get_referral_bal_res_model.dart';
import 'package:humanscoring/modal/services/base_service.dart';

import '../../utils/enum_utils.dart';
import '../services/api_service.dart';

class ReferralRepo extends BaseService {
  ///==========================ReferralRepo Repo====================

  Future referralRepo() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: referralBalance,
    );
    GetReferralBalResModel notificationResModel =
        GetReferralBalResModel.fromJson(response);
    return notificationResModel;
  }
}
