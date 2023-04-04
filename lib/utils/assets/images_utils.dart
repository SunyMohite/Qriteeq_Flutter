import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:sizer/sizer.dart';

String baseImgPath = 'assets/image/';

///PNG IMAGE

String profileBackgroundImg = "assets/image/avatarUsernameBg.webp";
String leaderboardBackgroundImg = "assets/image/leaderboard.webp";
String wiinersecondImg = "assets/image/winersecond.webp";
String winnerfirstImg = "assets/image/winnerfirst.webp";
String winnerthirdImg = "assets/image/winnerthird.webp";
String crownImg = "assets/image/crown.webp";

///EMOJI
String amazingImg = "assets/image/amazing.webp";
String greatImg = "assets/image/great.webp";
String fineImg = "assets/image/fine.webp";
String poorImg = "assets/image/poor.webp";
String badImg = "assets/image/bad.webp";
String phoneImg = "assets/image/mobile.webp";

class ImagesWidgets {
  static String unDrawUpgrade = baseImgPath + "undrawUpgrade.webp";
  static String unDrawUpgrade1 = baseImgPath + "undrawUpgrade1.webp";
  static String bgImage = baseImgPath + "bg.webp";

  static final appbarBackground = Image.asset(
    '${baseImgPath}appbarbg.webp',
    height: 20.w,
    width: Get.width,
    fit: BoxFit.fill,
  );
  static final appbarBackgroundReferEarn = Image.asset(
    '${baseImgPath}appbarbg.webp',
    height: 10.h,
    width: Get.width,
    fit: BoxFit.fill,
  );

  // static Widget imageWithSvg = SvgPicture.asset(
  //   "${basePath}ImageWithSvg.svg",
  // );

  static Image onBoardImage = Image.asset(
    "${baseImgPath}onBoard.webp",
    fit: BoxFit.fill,
  );

  static Image onBoard1Image = Image.asset(
    "${baseImgPath}onboard1.webp",
    fit: BoxFit.fill,
  );
  static Image onBoard2Image = Image.asset(
    "${baseImgPath}onboard2.webp",
    fit: BoxFit.fill,
  );
  static Image onBoard3Image = Image.asset(
    "${baseImgPath}onboard3.webp",
    fit: BoxFit.fill,
  );
  static Image onBoard4Image = Image.asset(
    "${baseImgPath}onboard4.webp",
    fit: BoxFit.fill,
  );

  static Image campaignImage = Image.asset(
    "${baseImgPath}campaign.webp",
    fit: BoxFit.fill,
    scale: 2,
  );

  static Image news = Image.asset(
    "${baseImgPath}news.webp",
    fit: BoxFit.fill,
    scale: 1.w,
  );

  static Image blueCircle = Image.asset(
    "${baseImgPath}blueCirlce.webp",
    scale: 1.w,
    color: ColorUtils.blue14,
  );

  static Widget rankNum1 = Image.asset(
    "${baseImgPath}rankNum1.webp",
    scale: 1.w,
  );
  static Widget rankNum2 = Image.asset(
    "${baseImgPath}rankNum2.webp",
    scale: 1.w,
  );
  static Widget rankNum3 = Image.asset(
    "${baseImgPath}rankNum3.webp",
    scale: 1.w,
  );

  static Widget undrawMailSent = SvgPicture.asset(
    "${baseImgPath}undrawMailSent.svg",
  );

  static Widget unDrawUpgradeMisSile = SvgPicture.asset(
    "${baseImgPath}undrawUpgradeMissile.svg",
  );
  static Widget unDrawFlagged = SvgPicture.asset(
    "${baseImgPath}undrawFlagged.svg",
    height: 25.w,
    width: 25.w,
  );

  static Widget facebookIcon = Image.asset(
    "${baseImgPath}facebook.webp",
    scale: 1.w,
  );

  static Widget referAndEarn = Image.asset(
    "${baseImgPath}referAndEarn.webp",
    scale: 1.w,
  );
  static Widget rotatedRectangle = Image.asset(
    "${baseImgPath}rotetedRectengle.webp",
    scale: 1.w,
  );
  static Widget scanner = Image.asset(
    "${baseImgPath}scanner.webp",
    scale: 0.5.w,
  );

  static Widget svgNotification = SvgPicture.asset(
    "${baseImgPath}svgNotification.svg",
  );
  static Widget pngEmptyComments = Image.asset("${baseImgPath}emptyComment.webp", width: 40.w,
    height: 40.w,);
}