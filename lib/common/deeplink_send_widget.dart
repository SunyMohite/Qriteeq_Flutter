import 'dart:typed_data';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humanscoring/common/commonWidget/snackbar.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../utils/assets/icons_utils.dart';
import '../utils/color_utils.dart';
import '../utils/font_style_utils.dart';
import '../utils/shared_preference_utils.dart';
import '../utils/size_config_utils.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DeepLinkSendWidget extends StatelessWidget {
  final String? feedBackId;
  final String? isScreenFrom;
  final String? shareLink;
  final bool? isCompletedCamping;
   DeepLinkSendWidget(
      {Key? key, this.feedBackId, this.isScreenFrom, this.shareLink, this.isCompletedCamping=false})
      : super(key: key);
  final dynamicLinks = FirebaseDynamicLinks.instance;
  final controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return InkResponse(
      radius: 40,
      child: isScreenFrom == 'DetailsScreen'
          ? commonIconAndText(icon: IconsWidgets.shareGrey)
          : interactionWidget(
              svg: SvgPicture.asset(
                shareImg,
              ),
            ),
      onTap:isCompletedCamping!?null:() async {
        if (shareLink == null || shareLink!.isEmpty) {
          showSnackBar(message: "Something went to wrong...");
          return;
        }
        await Share.share(
            "Hey there! ${PreferenceManagerUtils.getAvatarUserName()}"
            " sent you a feedback... Check here."
            " $shareLink to visit his feedback.\nRegards,\nTeam QriteeQ");
      },
    );
  }

  Row interactionWidget({int? value, SvgPicture? svg}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        svg!,
        const SizedBox(
          width: 5,
        ),
        value == null
            ? const SizedBox()
            : Text(
                value.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColorUtils.grey,
                    fontSize: 10.sp),
              ),
      ],
    );
  }

  Row commonIconAndText({Widget? icon, String? title}) {
    return Row(
      children: [
        icon!,
        SizeConfig.sW1,
        Text(
          title ?? '',
          style: FontTextStyle.poppinsBlack12Sp9SemiB,
        ),
      ],
    );
  }
}
