import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/utils/assets/images_utils.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/viewmodel/payment_view_model.dart';
import 'package:sizer/sizer.dart';

import '../../../common/circular_progress_indicator.dart';
import '../../../common/commonWidget/custom_header.dart';
import '../../../common/commonWidget/nodatafound_widget.dart';
import '../../../modal/apiModel/res_model/get_user_transactions_res_model.dart';

class UserTransactionScreen extends StatefulWidget {
  const UserTransactionScreen({Key? key}) : super(key: key);

  @override
  State<UserTransactionScreen> createState() => _UserTransactionScreenState();
}

class _UserTransactionScreenState extends State<UserTransactionScreen> {
  PaymentViewModel paymentViewModel = Get.find<PaymentViewModel>();

  @override
  void initState() {
    paymentViewModel.getPaymentTransactionsViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const CustomHeaderWidget(
              headerTitle: VariableUtils.myTransactions,
            ),
            Expanded(
              child: GetBuilder<PaymentViewModel>(
                builder: (paymentViewModel) {
                  if (paymentViewModel.paymentTransactionsApiResponse.status ==
                      Status.LOADING) {
                    return const CircularIndicator();
                  }
                  if (paymentViewModel.paymentTransactionsApiResponse.status ==
                      Status.ERROR) {
                    return const NoDataFoundWidget(
                        message: "You Have No transaction Yet");
                  }
                  GetUserTransactionsResModel getUserTransactionsResModel =
                      paymentViewModel.paymentTransactionsApiResponse.data;

                  return getUserTransactionsResModel.data!.isEmpty
                      ? Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.w),
                                child: ImagesWidgets.svgNotification,
                              ),
                            ),
                            Text(
                              "You Have No transaction Yet",
                              style: FontTextStyle.poppinsBlackLightNormal
                                  .copyWith(
                                color: ColorUtils.blue41.withOpacity(0.6),
                              ),
                            ),
                          ],
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            paymentViewModel.getPaymentTransactionsViewModel();
                          },
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: getUserTransactionsResModel.data!.length,
                            itemBuilder: (context, index) {
                              var data =
                                  getUserTransactionsResModel.data![index];
                              return getUserTransactionsResModel
                                              .data![index].reason ==
                                          null &&
                                      getUserTransactionsResModel
                                              .data![index].message ==
                                          null
                                  ? const SizedBox()
                                  : Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.w),
                                      child: Container(
                                        width: Get.width,
                                        color: ColorUtils.white,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.w, vertical: 1.h),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: 4.5.w,
                                                backgroundColor: ColorUtils
                                                    .lightGrey7A
                                                    .withOpacity(0.2),
                                                child: data.paymentType ==
                                                        'debit'
                                                    ? Image.asset(
                                                        'assets/icon/debited.webp')
                                                    : data.paymentType ==
                                                            'credit'
                                                        ? Image.asset(
                                                            'assets/icon/credit.webp')
                                                        : const SizedBox(),
                                              ),
                                              SizeConfig.sW5,
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                "${data.reason ?? data.message ?? ''}\n",
                                                            style: FontTextStyle
                                                                .poppinsDarkBlackSp11SemiB
                                                                .copyWith(
                                                              color: ColorUtils
                                                                  .blue2B,
                                                              fontWeight:
                                                                  FontWeightClass
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                            },
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
