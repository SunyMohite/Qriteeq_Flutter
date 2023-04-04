import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_referral_bal_res_model.dart';
import 'package:humanscoring/utils/assets/images_utils.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/viewmodel/referral_virwmodel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../common/commonWidget/custom_header.dart';
import '../../common/commonWidget/snackbar.dart';
import '../../modal/apis/api_response.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({Key? key}) : super(key: key);

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  ReferralViewModel viewModel = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      viewModel.referralViewModel();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeaderWidget(
              headerTitle: VariableUtils.referEndEarn,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizeConfig.sH1,
                      ImagesWidgets.referAndEarn,
                      SizeConfig.sH2,

                      /// Your Referral Balance
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 3.w),
                        decoration: BoxDecoration(
                          color: const Color(0xffE8EBFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Coins Earned",
                                // "Your Referral Balance",
                                style: TextStyle(
                                    color: ColorUtils.blue14,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizeConfig.sW5,
                            Image.asset(
                              'assets/icon/coin.webp',
                              scale: 5,
                            ),
                            SizeConfig.sW3,
                            GetBuilder<ReferralViewModel>(
                              builder: (controller) {
                                if (controller.referralBalApiResponse.status ==
                                    Status.LOADING) {
                                  return Text(
                                    "0",
                                    style: TextStyle(
                                        color: ColorUtils.blue14,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                  );
                                }
                                if (controller.referralBalApiResponse.status ==
                                    Status.ERROR) {
                                  return Text(
                                    "0",
                                    style: TextStyle(
                                        color: ColorUtils.blue14,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                  );
                                }
                                if (controller.referralBalApiResponse.status ==
                                    Status.COMPLETE) {
                                  GetReferralBalResModel res =
                                      controller.referralBalApiResponse.data;
                                  return Text(
                                    res.data!.referralBalance!.toString(),
                                    style: TextStyle(
                                        color: ColorUtils.blue14,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                  );
                                }
                                return Text(
                                  "0",
                                  style: TextStyle(
                                      color: ColorUtils.blue14,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                );
                              },
                            ),
                            SizeConfig.sW2
                          ],
                        ),
                      ),
                      SizeConfig.sH3,
                      Text(
                        VariableUtils.referralCode,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      SizeConfig.sH1,
                      PreferenceManagerUtils.getReferralCode().isEmpty
                          ? const SizedBox()
                          : Container(
                              // margin: EdgeInsets.symmetric(horizontal: 3.w),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 3.w),
                              decoration: BoxDecoration(
                                color: const Color(0xffEEEEEE),
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      PreferenceManagerUtils.getReferralCode(),
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      if (PreferenceManagerUtils
                                              .getReferralCodeDeepLink()
                                          .isEmpty) {
                                        showSnackBar(
                                            message: "Something went to wrong");
                                        return;
                                      }
                                      await Share.share(
                                          "Hey there! ${PreferenceManagerUtils.getAvatarUserName()} is inviting you to join QriteeQ. Click on this link to Download the App: ${PreferenceManagerUtils.getReferralCodeDeepLink()} to visit his profile.\nRegards,\nTeam QriteeQ");
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.w, vertical: 3.w),
                                      decoration: BoxDecoration(
                                          color: ColorUtils.blue14,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        "SHARE",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      SizeConfig.sH2,
                      Center(
                        child: Text(
                          "Earn coins",
                          style: TextStyle(
                              color: ColorUtils.blueDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp),
                        ),
                      ),
                      SizeConfig.sH1,

                      Center(
                          child: Text(
                        "Upon referring and posting feedbacks ",
                        style: TextStyle(
                            color: ColorUtils.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp),
                      )),
                      SizeConfig.sH2,

                      const Divider(
                        height: 5,
                        color: Colors.grey,
                      ),

                      ///REFERRAL BALANCE SHOW CASE....
                      SizeConfig.sH2,
                      commonWork(
                        subtitle: VariableUtils.referAFriendMessage,
                      ),
                      SizeConfig.sH3,
                      commonWork(
                        subtitle: VariableUtils.creditReviewMessage,
                      ),
                      SizeConfig.sH3,
                      commonWork(
                        subtitle: VariableUtils.creditReportMessage,
                      ),
                      SizeConfig.sH2,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row commonWork({String? subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImagesWidgets.rotatedRectangle,
        SizeConfig.sW2,
        Expanded(
          child: Text(
            subtitle!,
            style: FontTextStyle.poppinsBlack12medium.copyWith(
              fontSize: 10.sp,
              color: const Color(0xff404040),
              fontWeight: FontWeightClass.regular,
            ),
          ),
        ),
      ],
    );
  }
}
