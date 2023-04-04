import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/shared_preference_utils.dart';
import '../view/detailsScreen/feed_back_details_screen.dart';
import '../view/home/feed_inside_page/deeplink_user_profile_screen.dart';
import '../view/home/feed_post_screen.dart';
import '../view/loginScreen/login_screen.dart';

List<String> deepLinkData = [];
bool isEqualStatus = false, isAndStatus = false;

class DynamicLink {
  static FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  static void listenDynamicLinks(BuildContext context) async {
    dynamicLinks.onLink.listen((event) async {
      log("INIT DEEPLINK CALL listenDynamicLinks ${event.link.toString()}");

      final strName = event.link.toString();
      deepLinkData.clear();
      isEqualStatus = false;
      String str = '';
      for (int i = 0; i < strName.length + 1; i++) {
        if (strName.length == i) {
          deepLinkData.add(str);
          break;
        }
        if (isEqualStatus) {
          if (strName[i] != '&') {
            str += strName[i];
          } else {
            deepLinkData.add(str.trim());
            str = '';
            isEqualStatus = false;
          }
        } else if (strName[i] == '=') {
          isEqualStatus = true;
        }
      }
      if (kDebugMode) {
        print('PreferenceManagerUtils.getLoginId() ${PreferenceManagerUtils.getLoginId()}');
        print('LOGIN LINK CAL>>>>>>>>>>>......... $deepLinkData');
      }
     if (PreferenceManagerUtils.getLoginId().isNotEmpty) {
        if (deepLinkData[0] == 'QrCodeScreen') {
          Get.to(FeedPostScreen(
            connect: true,
            id: deepLinkData[1],
            userName: deepLinkData[2],
          ));
        }else if (deepLinkData[0] == 'CampaignScreen') {
          Get.to(FeedPostScreen(
            connect: true,
            id: deepLinkData[1],
            userName: deepLinkData[2],
            campaignId: deepLinkData[3],
          ));
        }
        else if (deepLinkData[0] == 'FeedBackDetails') {
          Get.to(FeedBackDetailsScreen(
            feedBackId: deepLinkData[1],
            isCommentTap: false,
          ));
        }
        else if (deepLinkData[0] == 'ReferralCode') {
          await PreferenceManagerUtils.setDeepLinkReferral(deepLinkData[1]);
        }
        else if (deepLinkData[0] == 'ViewUserProfile') {
          Get.to(
              DeeplinkUserProfileScreen(
            userId: deepLinkData[1],
                key: ValueKey(deepLinkData[1]),
          ));

        }
      }
      else{
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    }).onError((error) {
      if (kDebugMode) {
        print('DYNAMIC LINK LISTING ERROR :=>${error.message}');
      }
    });
  }
}

