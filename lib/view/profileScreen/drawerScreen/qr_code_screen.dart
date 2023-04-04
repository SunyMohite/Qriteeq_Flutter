import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/commonWidget/octo_image_widget.dart';
import 'package:humanscoring/utils/assets/images_utils.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/decoration_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/profileScreen/campaign/campaign_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../common/commonWidget/custom_header.dart';
import '../../../common/commonWidget/snackbar.dart';

class QrCodeScreen extends StatelessWidget {
  QrCodeScreen({Key? key}) : super(key: key);

  final dynamicLinks = FirebaseDynamicLinks.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.whiteE5,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const CustomHeaderWidget(
                headerTitle: VariableUtils.qrCode,
              ),
              SizeConfig.sH2,
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      width: 80.w,
                      decoration: BoxDecoration(
                          color: ColorUtils.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: ColorUtils.gray,
                              blurRadius: 15,
                              offset: Offset(1, 3),
                            )
                          ]),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizeConfig.sH6,
                            Text(
                              PreferenceManagerUtils.getAvatarUserName(),
                              style: FontTextStyle.poppinsBlue14SemiB.copyWith(
                                  fontSize: 14.sp, color: ColorUtils.black),
                            ),
                            SizeConfig.sH2,
                            Container(
                              color: Colors.white,
                              child: QrImage(
                                data: PreferenceManagerUtils
                                    .getQrCodeUrlDeepLink(),
                                version: QrVersions.auto,
                                size: 150.0,
                              ),
                            ),
                            SizeConfig.sH5,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: OctoImageWidget(
                      profileLink: PreferenceManagerUtils.getUserAvatar(),
                    ),
                  ),
                ],
              ),
              SizeConfig.sH2,
              Text(
                "Get yourself review from anyone by sharing \nthis code",
                style: FontTextStyle.poppinsDarkBlack9Regular.copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeightClass.medium,
                ),
                textAlign: TextAlign.center,
              ),
              SizeConfig.sH2,
              InkWell(
                onTap: () async {
                  if (PreferenceManagerUtils.getQrCodeUrlDeepLink().isEmpty) {
                    showSnackBar(message: "Something went to wrong");
                    return;
                  }
                  await Share.share(
                      "Hey there! ${PreferenceManagerUtils.getAvatarUserName()} is inviting you to post a review for them on QriteeQ. Click on this link: ${PreferenceManagerUtils.getQrCodeUrlDeepLink()} to visit his profile.\nRegards,\nTeam QriteeQ");
                  // await Share.share(link!);
                },
                child: Container(
                  height: 10.w,
                  width: 30.w,
                  decoration: DecorationUtils.allBorderAndColorDecorationBox(
                    radius: 5,
                    colors: ColorUtils.orangeF87A,
                  ),
                  child: Center(
                    child: Text(
                      VariableUtils.share,
                      style: FontTextStyle.poppinsWhite10bold,
                    ),
                  ),
                ),
              ),
              SizeConfig.sH2,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    VariableUtils.createCampaign,
                    style: FontTextStyle.poppinsDarkBlack9Regular.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeightClass.bold,
                        color: ColorUtils.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // ImagesWidgets.campaignImage,
              Image.asset(
                "${baseImgPath}campaign.webp",
                fit: BoxFit.fill,
                scale: 3.5,
              ),
              SizeConfig.sH3,
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    Get.to(() => const CampaignScreen());
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          VariableUtils.viewCampaigns,
                          style: FontTextStyle.poppinsDarkBlack9Regular
                              .copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeightClass.bold,
                                  color: ColorUtils.blue14),
                          textAlign: TextAlign.center,
                        ),
                        const Icon(Icons.arrow_forward,
                            color: ColorUtils.blue14)
                      ],
                    ),
                  ),
                ),
              ),
              SizeConfig.sH5,
            ],
          ),
        ),
      ),
    );
  }
}
