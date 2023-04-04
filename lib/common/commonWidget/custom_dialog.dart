import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:open_store/open_store.dart';
import 'package:sizer/sizer.dart';
import '../../modal/repo/auth_repo.dart';
import '../../utils/color_utils.dart';
import '../../utils/decoration_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/shared_preference_utils.dart';
import '../../utils/size_config_utils.dart';
import '../../utils/variable_utils.dart';
import '../../viewmodel/avatar_user_name_controller.dart';
import 'custom_button.dart';

openDialog({
  required String animation,
  required String title,
  required String message,
}) {
  Get.defaultDialog(
    backgroundColor: Colors.white,
    title: title,
    radius: 20,
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    content: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Lottie.asset(
            animation,
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.5.w),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp),
          ),
        )
      ],
    ),
    contentPadding: EdgeInsets.zero,
  );
}

void forceUpdateDialog() {
  AuthRepo authRepo = AuthRepo();

  Get.defaultDialog(
      title: VariableUtils.appName,
      titleStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14.sp,
          color: ColorUtils.primaryColor,
          fontWeight: FontWeight.bold),
      barrierDismissible: false,
      onWillPop: () {
        return Future.value(false);
      },
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Please download the latest app for a seamless experience.",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12.sp,
                color: Colors.black,
                fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        GetBuilder<AvatarUserNameController>(
          builder: (userNameController) {
            return InkWell(
              onTap: () async {
                OpenStore.instance.open(
                  appStoreId: VariableUtils.appStoreID,
                  // AppStore id of your app
                  androidAppBundleId:
                      'com.qriteeq.qriteeqapp', // Android app bundle package name
                );
              },
              child: Container(
                height: 13.w,
                margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.w),
                padding: EdgeInsets.only(
                  left: 2.w,
                  right: 2.w,
                ),
                decoration: DecorationUtils.allBorderAndColorDecorationBox(
                    radius: 7, colors: ColorUtils.primaryColor),
                child: Center(
                  child: Text(
                    userNameController.isLogout == true
                        ? "Loading...."
                        : "Update Now ",
                    style: FontTextStyle.poppinsWhite10bold,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            );
          },
        ),
      ]);
}

Future commonSuccessDialog({String? msg, String? assets}) async {
  return Get.defaultDialog(
      title: '',
      content: Column(
        children: [
          Lottie.asset('assets/json/done.json'),
          Text(msg!),
        ],
      ));
}

void appPermissionDialog() {
  Get.defaultDialog(
    title: 'QriteeQ App',
    onWillPop: () {
      return Future.value(false);
    },
    titleStyle: TextStyle(
        fontSize: 14.sp,
        color: ColorUtils.primaryColor,
        fontWeight: FontWeight.bold),
    barrierDismissible: false,
    content: SizedBox(
      height: Get.height / 1.5,
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  'assets/icon/appIconBG.webp',
                  scale: 5.w,
                ),
              ),
              SizeConfig.sH1,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Allow 'QriteeQ App' Permission",
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: ColorUtils.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizeConfig.sH1,
              permissionListTile(
                  title: '1. Contacts',
                  content:
                      'We need user contact details as it’s a community of users and users may want to interact with their contacts on this platform. They may also want to invite other users to the app for which they will have to access their contacts.'),
              permissionListTile(
                  title: '2. Camera',
                  content:
                      'Customer may want to take a picture using his camera and may want to post the photo on the social media platform.'),
              permissionListTile(
                  title: '3. Location',
                  content:
                      'We need access to the location as a user may want to see people who are nearby and may want to post about them.'),
              permissionListTile(
                  title: '4. File and Media',
                  content:
                      'We are a social media platform. We need access to photos as customers may want to post these photos from his image gallery on to the social media platform.'),
            ],
          ),
        ),
      ),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(bottom: 2.5.w),
        child: CustomButtons(
          buttonName: 'Yes I agree',
          onTap: () async {
            await PreferenceManagerUtils.setPermissionDialog("yes");

            Get.back();
          },
        ),
      ),
    ],
  );
}

Widget permissionListTile({required String title, required String content}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12.sp),
      ),
      SizeConfig.sH1,
      Text(
        content,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 10.sp),
      ),
      SizeConfig.sH2,
    ],
  );
}
