import 'dart:developer';

import 'package:get/get.dart';
import 'package:humanscoring/modal/apiModel/req_model/payment_init_req_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/payment_init_res_model.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/modal/repo/payment_init_repo.dart';

import '../modal/apiModel/res_model/get_user_transactions_res_model.dart';
import '../modal/apiModel/res_model/post_payment_res_model.dart';
import '../modal/apiModel/res_model/user_wallet_res_model.dart';

class PaymentViewModel extends GetxController {
  ApiResponse paymentInitApiResponse = ApiResponse.initial('Initial');
  ApiResponse postPaymentApiResponse = ApiResponse.initial('Initial');
  ApiResponse userWalletApiResponse = ApiResponse.initial('Initial');
  ApiResponse paymentTransactionsApiResponse = ApiResponse.initial('Initial');

  ///======================PaymentInitViewModel Repo=====================

  Future paymentInitViewModel(PaymentInitReqModel model) async {
    paymentInitApiResponse = ApiResponse.loading('Loading');
    try {
      PaymentInitResModel response = await PaymentRepo().paymentInitRepo(model);
      paymentInitApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('paymentInitApiResponse.......$e');
      paymentInitApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future postPaymentViewModel({String? intentId, String? methodId}) async {
    postPaymentApiResponse = ApiResponse.loading('Loading');
    try {
      PostPaymentResModel response = await PaymentRepo()
          .postPaymentRepo(intentId: intentId, methodId: methodId);
      postPaymentApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('postPaymentApiResponse.......$e');
      postPaymentApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///TRANSACTION VIEW MODEL....
  Future<void> getPaymentTransactionsViewModel() async {
    paymentTransactionsApiResponse = ApiResponse.loading('Loading');
    try {
      GetUserTransactionsResModel response =
          await PaymentRepo().getUserTransactionsRepo();
      paymentTransactionsApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('paymentTransactionsApiResponse.......$e');
      paymentTransactionsApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///Get User Wallet Balance...
  Future<void> getUserWalletViewModel() async {
    userWalletApiResponse = ApiResponse.loading('Loading');
    try {
      GetUserProfileResModel response = await PaymentRepo().getUserWalletRepo();
      userWalletApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('userWalletApiResponse.......$e');
      userWalletApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
