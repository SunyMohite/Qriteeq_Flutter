import 'package:humanscoring/modal/apiModel/req_model/payment_init_req_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/payment_init_res_model.dart';
import 'package:humanscoring/modal/services/api_service.dart';
import 'package:humanscoring/modal/services/base_service.dart';
import 'package:humanscoring/utils/enum_utils.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';

import '../apiModel/res_model/get_user_transactions_res_model.dart';
import '../apiModel/res_model/post_payment_res_model.dart';
import '../apiModel/res_model/user_wallet_res_model.dart';

class PaymentRepo extends BaseService {
  String? paymentUrl;

  Future paymentInitRepo(PaymentInitReqModel model) async {
    Map<String, dynamic> body = model.toJson();

    if (PreferenceManagerUtils.getCustomerId().isEmpty) {
      paymentUrl = "payment/init?version=2020-08-27";
    } else {
      paymentUrl =
          "payment/init?version=2020-08-27&id=${PreferenceManagerUtils.getCustomerId()}";
    }
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: paymentUrl, body: body, withToken: true);
    PaymentInitResModel paymentInitResModel =
        PaymentInitResModel.fromJson(response);
    return paymentInitResModel;
  }

  Future postPaymentRepo({String? intentId, String? methodId}) async {
    paymentUrl = "payment/done?id=$intentId&method=$methodId";
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: paymentUrl, body: {}, withToken: true);
    PostPaymentResModel postPaymentResModel =
        PostPaymentResModel.fromJson(response);
    return postPaymentResModel;
  }
  ///==========================GetUserTransactions Repo====================

  Future getUserTransactionsRepo() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: getUserTransactions,
    );
    GetUserTransactionsResModel getUserTransactionsResModel =
        GetUserTransactionsResModel.fromJson(response);
    return getUserTransactionsResModel;
  }
  ///==========================GetUserWallet Repo====================

  Future getUserWalletRepo() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: getUserProfile,
    );
    GetUserProfileResModel getUserProfileResModel =
        GetUserProfileResModel.fromJson(response);
    return getUserProfileResModel;
  }
}
