import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/commonWidget/snackbar.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/assets/icons_utils.dart';
import '../../../utils/assets/images_utils.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/decoration_utils.dart';
import '../../../utils/font_style_utils.dart';
import '../../../utils/size_config_utils.dart';
import '../../../utils/variable_utils.dart';
import '../../modal/apiModel/res_model/amount_converted_res_model.dart';
import '../../utils/validation_utils.dart';
import '../../view/home/feed_post_screen.dart';
import '../../view/paymentScreen/confrim_payment_screen.dart';
import '../../viewmodel/feedback_viewmodel.dart';
import '../my_clip_path.dart';

///=============UNLOCK FEEDBACK BOTTOM SHEET============
class InstantViewModel extends GetxController {
  TextEditingController balanceController = TextEditingController();

  ///Insufficient Balance Dialog
  bool _isRequiredAmountCheck = true;

  bool get isRequiredAmountCheck => _isRequiredAmountCheck;

  set isRequiredAmountCheck(bool value) {
    _isRequiredAmountCheck = value;
    update();
  }

  int _selectAmountIndex = 0;

  int get selectAmountIndex => _selectAmountIndex;

  set selectAmountIndex(int value) {
    _selectAmountIndex = value;
    update();
  }
}

Widget unlockFeedBackBottomSheet(BuildContext context,
    {required String contentTitle}) {
  List amountList = [
    '10',
    '25',
    '100',
  ];
  InstantViewModel controller = Get.find();
  controller.selectAmountIndex = -1;
  controller.balanceController.text = '';
  return ClipRRect(
    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
    child: Container(
      height: 125.w,
      color: ColorUtils.white,
      child: GetBuilder<InstantViewModel>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipPath(
                          clipper: MyClipPath(),
                          child: Container(
                              height: 60.w,
                              width: Get.width,
                              color: ColorUtils.lightCyan,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 9.w,
                                  horizontal: 3.w,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(),
                                    ImagesWidgets.unDrawUpgradeMisSile,
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: IconsWidgets.close,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Text(
                            contentTitle,
                            style: FontTextStyle.poppins15darkBluesemiB,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizeConfig.sH2,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.h),
                      child: Text(
                        "Quickly head over to the payments section to unlock the $contentTitle and read it.",
                        textAlign: TextAlign.center,
                        style: FontTextStyle.poppins14SemiBDarkBlack.copyWith(
                          fontWeight: FontWeightClass.regular,
                          color: ColorUtils.blackLightTextField,
                        ),
                      ),
                    ),
                    SizeConfig.sH3,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: TextFormField(
                          controller: controller.balanceController,
                          style: FontTextStyle.proxima14Regular.copyWith(
                              color: ColorUtils.primaryColor),
                          cursorColor: ColorUtils.primaryColor,
                          keyboardType: TextInputType.number,
                          onChanged: (String value) {},
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(RegularExpression.leadingZero)),
                          ],
                          //readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Enter Your coins',
                            //prefixText: VariableUtils.rs,
                            prefixStyle:
                                FontTextStyle.proxima14Regular.copyWith(
                                    color: ColorUtils.primaryColor),
                            isDense: true,
                            contentPadding: EdgeInsets.all(3.w),
                            focusColor: ColorUtils.grey,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: ColorUtils.grey, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: ColorUtils.grey, width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: ColorUtils.grey, width: 1)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: ColorUtils.red, width: 1)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: ColorUtils.red, width: 1)),
                            fillColor: ColorUtils.white,
                            filled: true,
                          )),
                    ),
                    SizeConfig.sH1,
                    SizedBox(
                      height: 10.w,
                      width: Get.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(amountList.length, (index) {
                          return InkWell(
                            onTap: () {
                              controller.selectAmountIndex = index;
                              controller.balanceController.text =
                                  "${amountList[index]}";
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Container(
                                height: 12.w,
                                width: 20.w,
                                decoration: BoxDecoration(
                                  color: controller.selectAmountIndex == index
                                      ? ColorUtils.blue14
                                      : null,
                                  border: Border.all(
                                      color: ColorUtils.primaryColor),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "+${amountList[index]}",
                                        style: FontTextStyle.poppinsWhite10bold
                                            .copyWith(
                                                fontSize: 8.sp,
                                                color: controller
                                                            .selectAmountIndex ==
                                                        index
                                                    ? null
                                                    : ColorUtils.blue14),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "Coins",
                                        style: FontTextStyle.poppinsWhite10bold
                                            .copyWith(
                                                fontSize: 9.sp,
                                                color: controller
                                                            .selectAmountIndex ==
                                                        index
                                                    ? null
                                                    : ColorUtils.blue14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizeConfig.sH1,
                    GetBuilder<FeedBackViewModel>(
                      builder: (feedBackViewModel) {
                        return InkWell(
                          onTap: () async {
                            if (controller.balanceController.text.isEmpty) {
                              showSnackBar(message: 'Invalid coins');
                              return;
                            }
                            await feedBackViewModel.amountConvertedViewModel(
                                amount: controller.balanceController.text);
                            if (feedBackViewModel
                                    .amountConvertedApiResponse.status ==
                                Status.ERROR) {
                              showSnackBar(message: 'Something went to wrong');
                              return;
                            }
                            if (feedBackViewModel
                                    .amountConvertedApiResponse.status ==
                                Status.COMPLETE) {
                              AmountConvertedResModel amountConvertedResModel =
                                  feedBackViewModel
                                      .amountConvertedApiResponse.data;
                              if (amountConvertedResModel.data != null &&
                                  amountConvertedResModel.data!.cent != null &&
                                  amountConvertedResModel.data!.cent != 0) {
                                await Get.to(ConfirmPaymentScreen(
                                  amount: amountConvertedResModel.data!.cent,
                                  displayAmount:
                                      amountConvertedResModel.data!.dollar,
                                  showText:
                                      amountConvertedResModel.data!.showText,
                                ));
                                Get.back();
                              } else {
                                showSnackBar(
                                    message: 'Something went to wrong');
                              }
                            }
                          },
                          child: Container(
                            height: 10.w,
                            width: 65.w,
                            decoration:
                                DecorationUtils.allBorderAndColorDecorationBox(
                              colors: ColorUtils.blue14,
                              radius: 5,
                            ),
                            child: Center(
                              child: Text(
                                VariableUtils.makePayment,
                                style: FontTextStyle.poppinsWhite10bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                GetBuilder<FeedBackViewModel>(
                  builder: (feedBackViewModel) {
                    return feedBackViewModel
                                .amountConvertedApiResponse.status ==
                            Status.LOADING
                        ? const CircularProgressIndicator()
                        : const SizedBox();
                  },
                )
              ],
            ),
          );
        },
      ),
    ),
  );
}

addUserNameBottomSheet(
    {required String userName,
    final String? id,
    required String? mobile,
    String? email = '',
    String? profileUrl = '',
    required bool? connect}) {
  TextEditingController fullNameController = TextEditingController();
  if (mobile!.isNotEmpty) {
    fullNameController.text = userName;
  }
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.w),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            'assets/image/rafiki.webp',
            width: 35.w,
            height: 30.w,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 6.w,
        ),
        mobile.isNotEmpty
            ? RichText(
                text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "This user is saved as ",
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)),
                TextSpan(
                    text: userName,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                      color: Colors.black,
                    )),
                TextSpan(
                    text: " in your contact book.",
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)),
              ]))
            : RichText(
                text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "Please provide a name for ",
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)),
                TextSpan(
                    text: userName,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                      color: Colors.black,
                    )),
              ])),
        SizedBox(
          height: 2.w,
        ),
        mobile.isNotEmpty
            ? Text(
                "Do you wish to change how it appears to other app users?",
                style: TextStyle(
                    fontSize: 9.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
              )
            : const SizedBox(),
        SizedBox(
          height: 2.w,
        ),
        TextField(
          controller: fullNameController,
          keyboardType: TextInputType.text,
          style: FontTextStyle.poppinsBlack10Medium,
          textCapitalization: TextCapitalization.sentences,
          inputFormatters: [
            LengthLimitingTextInputFormatter(100),
          ],
          decoration: InputDecoration(
            hintText: "Enter Name here",
            hintStyle: TextStyle(fontSize: 9.sp),
          ),
        ),
        SizedBox(
          height: 9.w,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                gotoFeedPostScreen(
                    fullNameController: fullNameController.text,
                    id: id!,
                    connect: connect!,
                    mobile: mobile,
                    email: email ?? '',
                    profileUrl: profileUrl ?? '');
              },
              child: Container(
                height: 10.w,
                width: 40.w,
                decoration: BoxDecoration(
                    border: Border.all(color: ColorUtils.primaryColor),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.white38),
                child: const Center(
                  child: Text(
                    VariableUtils.skip,
                    style: TextStyle(color: ColorUtils.primaryColor),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                gotoFeedPostScreen(
                    fullNameController: fullNameController.text,
                    id: id ?? '',
                    connect: connect!,
                    mobile: mobile,
                    email: email ?? '',
                    profileUrl: profileUrl ?? '');
              },
              child: Container(
                height: 10.w,
                width: 40.w,
                decoration: BoxDecoration(
                    border: Border.all(color: ColorUtils.primaryColor),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    color: ColorUtils.primaryColor),
                child: const Center(
                  child: Text(
                    VariableUtils.proceed,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void gotoFeedPostScreen(
    {required String fullNameController,
    required String mobile,
    required String id,
    required String email,
    required String profileUrl,
    required bool connect}) {
  if (fullNameController.isBlank!) {
    showSnackBar(message: 'Name is required...', snackColor: Colors.red);
    return;
  }

  Get.back();

  Get.to(FeedPostScreen(
    connect: connect,
    id: id,
    mobile: mobile,
    userName: fullNameController.trimLeft(),
    email: email,
    profileUrl: profileUrl,
  ));
}
