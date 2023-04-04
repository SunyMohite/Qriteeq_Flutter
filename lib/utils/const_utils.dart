import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:humanscoring/modal/apiModel/res_model/country_flag_res_model.dart';
import 'package:humanscoring/utils/assets/icons_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

FirebaseAuth kFirebaseAuth = FirebaseAuth.instance;
FirebaseFirestore kFirebaseFirestore = FirebaseFirestore.instance;
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;
void logs(String message) {
  if (kDebugMode) {
    log(message);
  }
}

class ConstUtils {
  /// DOCFILENAME
  static String kGetFileName(String path) {
    return path.substring(path.lastIndexOf('/') + 1);
  }

  /// TEXT FIELD LENGTH VALIDATION

  static String otpController = '';
  static String? mobileEditingController = '';
  static String? emailEditingController = '';
  static String aapVersion = '';
  static String displayAapVersion = "2.0.0";
  static int aapBuildVersion = 1;

  static const kPasswordLength = 6;
  static const kPhoneNumberLength = 10;
  static const appName = 'App name';
  static const privacyPolicyUrl = 'https://www.qriteeq.com/privacy-policy';
  static const termsConditionUrl = 'https://www.qriteeq.com/terms-of-service';
  static const faqUrl = 'https://www.qriteeq.com/faq';

  static String? title;
  static bool? isNewUser = false;
  static String locationPermission = '';
  static List<CountryFlagResModel>? body = [];

  /// ===================Emoji list======================

  static List<EmojiIcon> emojiIcon = [
    EmojiIcon(icon: 'assets/icon/angryHighlight.webp', title: 'Bad'),
    EmojiIcon(icon: 'assets/icon/sadHighlight.webp', title: 'Poor'),
    EmojiIcon(icon: 'assets/icon/smileHighlight.webp', title: 'Fine'),
    EmojiIcon(icon: 'assets/icon/happyHighlight.webp', title: 'Great'),
    EmojiIcon(icon: 'assets/icon/amazingHighlight.webp', title: 'Amazing'),
  ];

  static List<DrawerScreen> drawerScreen = [
    DrawerScreen(
        icon: IconsWidgets.shareViaQr, title: VariableUtils.shareViaQr),
    DrawerScreen(
        icon: IconsWidgets.checkDPRating, title: VariableUtils.checkDPRating),
    DrawerScreen(
        icon: IconsWidgets.chatwithModerator, title: VariableUtils.chatwithModerator),
    DrawerScreen(
        icon: IconsWidgets.userActivitylightGrey7A,
        title: VariableUtils.userActivity),
    DrawerScreen(
        icon: IconsWidgets.leaderboard, title: VariableUtils.leaderboard),
    DrawerScreen(
        icon: IconsWidgets.pdfDownload, title: VariableUtils.userReport),
    DrawerScreen(
        icon: IconsWidgets.featureReqIcon, title: VariableUtils.featureRequest),
    DrawerScreen(icon: IconsWidgets.faqs, title: VariableUtils.fAQs),
    // DrawerScreen(
    //     icon: IconsWidgets.transaction, title: VariableUtils.myTransactions),
    DrawerScreen(icon: IconsWidgets.logOut, title: VariableUtils.logOut),
    DrawerScreen(
        icon: IconsWidgets.deleteSvg, title: VariableUtils.deleteAccount),
  ];

  static List userActivity = [
    UserActivity(
      title: VariableUtils.all,
      selectedIcon: IconsWidgets.userActivity,
      unSelectedIcon: IconsWidgets.grayUserActivity,
    ),
    UserActivity(
      title: VariableUtils.agree,
      selectedIcon: IconsWidgets.purpleLike,
      unSelectedIcon: IconsWidgets.grayLike,
    ),
    UserActivity(
      title: VariableUtils.disAgree,
      selectedIcon: IconsWidgets.purpleDisLike,
      unSelectedIcon: IconsWidgets.grayDislike,
    ),
    UserActivity(
      title: VariableUtils.comments,
      selectedIcon: IconsWidgets.purpleComment,
      unSelectedIcon: IconsWidgets.grayComment,
    ),
  ];
}

class EmojiIcon {
  final String? icon;
  final String? title;

  EmojiIcon({this.icon, this.title});
}

class ContactsNumber {
  final String? title;
  final String? number;

  ContactsNumber({this.number, this.title});
}

class DrawerScreen {
  final String? title;
  final Widget? icon;
  DrawerScreen({this.title, this.icon});
}

class FrequentlyAndQuestion {
  final String? question;
  final String? answer;
  FrequentlyAndQuestion({this.answer, this.question});
}

class UserActivity {
  final Widget? unSelectedIcon;
  final Widget? selectedIcon;
  final String? title;
  UserActivity({this.title, this.selectedIcon, this.unSelectedIcon});
}
