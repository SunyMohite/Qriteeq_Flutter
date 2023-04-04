import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/circular_progress_indicator.dart';
import 'package:humanscoring/utils/assets/icons_utils.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/const_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/loginScreen/login_screen.dart';
import 'package:humanscoring/view/profileScreen/drawerScreen/backupnew_leader_board.dart';
import 'package:humanscoring/view/profileScreen/drawerScreen/edit_profile_sreen.dart';
import 'package:humanscoring/view/profileScreen/drawerScreen/favourite_screen.dart';
import 'package:humanscoring/view/profileScreen/drawerScreen/my_received_feedback_screen.dart';
import 'package:humanscoring/view/profileScreen/drawerScreen/qr_code_screen.dart';
import 'package:humanscoring/view/profileScreen/drawerScreen/user_activity_screen.dart';
import 'package:humanscoring/view/reportScreen/new_tabbar_user_reportscreen.dart';
import 'package:humanscoring/viewmodel/avatar_user_name_controller.dart';
import 'package:octo_image/octo_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../modal/apiModel/res_model/user_wallet_res_model.dart';
import '../../modal/apis/api_response.dart';
import '../../modal/repo/auth_repo.dart';
import '../../utils/enum_utils.dart';
import '../../utils/shared_preference_utils.dart';
import '../../viewmodel/dashboard_viewmodel.dart';
import '../../viewmodel/payment_view_model.dart';
import '../chatScreen/admin_chat_screen.dart';
import '../home/view_dp_rating.dart';
import 'drawerScreen/feature_request_screen.dart';
import 'drawerScreen/posted_feed_back_screen.dart';
import 'drawerScreen/webpage_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthRepo authRepo = AuthRepo();
  PaymentViewModel paymentViewModel = Get.find();

  @override
  void initState() {
    paymentViewModel.getUserWalletViewModel();
    super.initState();
  }

  GetUserProfileResModel response = GetUserProfileResModel();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
            GetBuilder<AvatarUserNameController>(builder: (userNameController) {
          return Stack(
            children: [
              Container(
                height: Get.height,
                width: Get.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/image/profileBg.webp'),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  children: [
                    GetBuilder<PaymentViewModel>(
                      builder: (paymentViewModel) {
                        if (paymentViewModel.userWalletApiResponse.status ==
                            Status.COMPLETE) {
                          response =
                              paymentViewModel.userWalletApiResponse.data;
                        }
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Column(
                            children: [
                              SizeConfig.sH2,
                              Row(
                                children: [
                                  Material(
                                    color: ColorUtils.transparent,
                                    borderRadius: BorderRadius.circular(150),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(150),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconsWidgets.backArrow,
                                      ),
                                      onTap: () {
                                        Get.back();
                                      },
                                    ),
                                  ),
                                  SizeConfig.sW2,
                                  Text(
                                    VariableUtils.profile,
                                    style: FontTextStyle.poppinsWhite11semiB
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 1.w, right: 3.w),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() => const EditProfileScreen());
                                      },
                                      child: SizedBox(
                                          child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: OctoImage(
                                              height: 15.w,
                                              width: 15.w,
                                              image: CachedNetworkImageProvider(
                                                  PreferenceManagerUtils
                                                      .getUserAvatar()),
                                              placeholderBuilder:
                                                  OctoPlaceholder.blurHash(
                                                'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                              ),
                                              errorBuilder:
                                                  (context, obj, stack) =>
                                                      IconsWidgets.userIcon,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0.w,
                                            right: 0,
                                            child: Image.asset(
                                              'assets/icon/settingEdit.webp',
                                              scale: 0.8.w,
                                            ),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizeConfig.sH1,
                                        Row(
                                          children: [
                                            ///USER NAME
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                PreferenceManagerUtils
                                                    .getAvatarUserName(),
                                                style: FontTextStyle
                                                    .poppinsYellow13semiB
                                                    .copyWith(
                                                        color:
                                                            ColorUtils.yellow),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),

                                            ///WALLET BALANCE COINS.....
                                            SizedBox(width: 1.w),
                                            IconsWidgets.walletCoin,
                                            SizedBox(width: 2.w),
                                            paymentViewModel
                                                        .userWalletApiResponse
                                                        .status ==
                                                    Status.LOADING
                                                ? buildShimmer()
                                                : Text(
                                                    response.data!.user!.wallet
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                          ],
                                        ),
                                        SizeConfig.sH05,

                                        /// USER FULL NAME ....
                                        Text(
                                          PreferenceManagerUtils
                                              .getAvatarUserFullName(),
                                          style: FontTextStyle
                                              .poppinsYellow13semiB
                                              .copyWith(
                                                  color: ColorUtils.yellowB7,
                                                  fontSize: 11.sp),
                                          maxLines: 1,
                                        ),
                                        SizeConfig.sH05,

                                        /// TRUST SCORE ....
                                        paymentViewModel.userWalletApiResponse
                                                    .status ==
                                                Status.LOADING
                                            ? buildShimmer()
                                            : RichText(
                                                text: TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: response
                                                            .data!.trustScore,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: ColorUtils
                                                                .yellow97)),
                                                    const TextSpan(text: '/'),
                                                    TextSpan(
                                                        text: response.data!
                                                            .totalTrustScore,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizeConfig.sH2,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() =>
                                          const MyReceivedFeedBackScreen());
                                    },
                                    child: paymentViewModel
                                                .userWalletApiResponse.status ==
                                            Status.LOADING
                                        ? buildShimmer()
                                        : commonIconAndText(
                                            title:
                                                VariableUtils.feedbackReceived,
                                            count: response.data!.receivedCount,
                                          ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => const PostedFeedBacksScreen(
                                          isHeaderShow: true,
                                        ),
                                      );
                                    },
                                    child: paymentViewModel
                                                .userWalletApiResponse.status ==
                                            Status.LOADING
                                        ? buildShimmer()
                                        : commonIconAndText(
                                            title: VariableUtils.feedbackPosted,
                                            count: response.data!.postedCount,
                                          ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await Get.to(
                                          () => const FavouriteScreen());
                                      setState(() {});
                                    },
                                    child: Column(
                                      children: [
                                        paymentViewModel.userWalletApiResponse
                                                    .status ==
                                                Status.LOADING
                                            ? buildShimmer()
                                            : Text(
                                                "${response.data!.favoriteCount}",
                                                style: FontTextStyle
                                                    .poppinsWhiteSp9AMedium
                                                    .copyWith(
                                                        color:
                                                            ColorUtils.yellow97,
                                                        fontSize: 14.sp),
                                              ),
                                        SizeConfig.sW2,
                                        Text(
                                          VariableUtils.subscribedFavourited,
                                          style: FontTextStyle
                                              .poppinsWhiteSp9AMedium
                                              .copyWith(
                                                  color: ColorUtils.grayDD,
                                                  fontSize: 9.sp),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizeConfig.sH4,
                            ],
                          ),
                        );
                      },
                    ),

                    ///LISTING....
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: ColorUtils.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15)),
                        ),
                        padding:
                            EdgeInsets.only(top: 2.5.w, left: 3.w, right: 5.w),
                        child: GetBuilder<AvatarUserNameController>(
                          builder: (userNameController) {
                            return Column(
                              children: [
                                Expanded(
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    child: ListView.builder(
                                      itemCount: ConstUtils.drawerScreen.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            if (ProfileScreenOption
                                                    .shareViaQr.index ==
                                                index) {
                                              Get.to(QrCodeScreen());
                                            }
                                            else if(ProfileScreenOption
                                                .checkDPRating.index ==
                                                index)
                                              {
                                                Get.to(const DpRating());
                                              }
                                            else if(ProfileScreenOption
                                                .chatwithModerator.index ==
                                                index)
                                            {

                                                Get.to(const AdminChatScreen());
                                            }
                                            else if (ProfileScreenOption
                                                    .userActivity.index ==
                                                index) {
                                              await Get.to(
                                                  const UserActivityScreen());
                                              paymentViewModel
                                                  .getUserWalletViewModel();
                                            } else if (ProfileScreenOption
                                                    .leaderBoard.index ==
                                                index) {
                                              Get.to(
                                                  const NewLeaderBoardScreen());
                                            } else if (ProfileScreenOption
                                                    .userReport.index ==
                                                index) {
                                              Get.to(
                                                  const NewTabBarUserReportScreen());
                                            } else if (ProfileScreenOption
                                                    .featureRequest.index ==
                                                index) {
                                              Get.to(
                                                  const FeatureRequestScreen());
                                            } else if (ProfileScreenOption
                                                    .faqS.index ==
                                                index) {
                                              Get.to(const WebViewScreen(
                                                  titleBarText: VariableUtils
                                                      .frequentlyAskQuestion,
                                                  webUrl: ConstUtils.faqUrl));
                                            } else if (ProfileScreenOption
                                                        .logOut.index ==
                                                    index ||
                                                ProfileScreenOption
                                                        .deleteAccount.index ==
                                                    index) {
                                              userNameController.setIsLogout =
                                                  true;
                                              await authRepo
                                                  .loginUserOnlineOfflineRepo(
                                                      {"online": false});
                                              await PreferenceManagerUtils
                                                  .clearLocalData();
                                              userNameController.setIsLogout =
                                                  false;
                                              Get.offAll(
                                                  () => const LoginScreen());
                                              Get.delete<DashBoardViewModel>();
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: ListTile(
                                                  leading: CircleAvatar(
                                                    radius: 4.5.w,
                                                    backgroundColor: ColorUtils
                                                        .lightGrey7A
                                                        .withOpacity(0.2),
                                                    child: ConstUtils
                                                        .drawerScreen[index]
                                                        .icon,
                                                  ),
                                                  title: Text(
                                                    "${ConstUtils.drawerScreen[index].title}",
                                                    style: FontTextStyle
                                                        .poppinsDarkBlue2BMedium,
                                                  ),
                                                  trailing: ConstUtils
                                                                  .drawerScreen[
                                                                      index]
                                                                  .title ==
                                                              VariableUtils
                                                                  .logOut ||
                                                          ConstUtils
                                                                  .drawerScreen[
                                                                      index]
                                                                  .title ==
                                                              VariableUtils
                                                                  .deleteAccount
                                                      ? const SizedBox()
                                                      : IconsWidgets
                                                          .forwardArrow,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizeConfig.sH1,
                                Text(
                                  "${VariableUtils.version}  ${ConstUtils.displayAapVersion}",
                                  textAlign: TextAlign.center,
                                  style: FontTextStyle.poppinsBlue14Sp9Medium
                                      .copyWith(
                                          color: ColorUtils.lightGrey83,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () => Get.to(const WebViewScreen(
                                          titleBarText:
                                              VariableUtils.termsAndConditions,
                                          webUrl:
                                              ConstUtils.termsConditionUrl)),
                                      child: Text(
                                        VariableUtils.termsAndConditions,
                                        textAlign: TextAlign.center,
                                        style: FontTextStyle
                                            .poppinsBlue14Sp9Medium
                                            .copyWith(
                                                color: ColorUtils.lightGrey83,
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w500),
                                        maxLines: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 1.h,
                                    ),
                                    IconsWidgets.greyCircle,
                                    SizedBox(
                                      width: 1.h,
                                    ),
                                    InkWell(
                                      onTap: () => Get.to(const WebViewScreen(
                                        titleBarText:
                                            VariableUtils.privacyPolicy,
                                        webUrl: ConstUtils.privacyPolicyUrl,
                                      )),
                                      child: Text(VariableUtils.privacyPolicy,
                                          textAlign: TextAlign.center,
                                          style: FontTextStyle
                                              .poppinsBlue14Sp9Medium
                                              .copyWith(
                                                  color: ColorUtils.lightGrey83,
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w500),
                                          maxLines: 1),
                                    ),
                                  ],
                                ),
                                SizeConfig.sH2,
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GetBuilder<AvatarUserNameController>(
                  builder: (userNameController) {
                return userNameController.isLogout == true
                    ? const CircularIndicator()
                    : const SizedBox();
              }),
            ],
          );
        }),
      ),
    );
  }

  Shimmer buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.white10,
      highlightColor: Colors.white,
      child: Text(
        "0",
        style: TextStyle(
            color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Column commonIconAndText({String? title, int? count}) {
    return Column(
      children: [
        Text(
          "$count",
          style: FontTextStyle.poppinsWhiteSp9AMedium
              .copyWith(color: ColorUtils.yellow97, fontSize: 14.sp),
        ),
        SizeConfig.sW2,
        Text(
          "$title",
          style: FontTextStyle.poppinsWhiteSp9AMedium
              .copyWith(color: ColorUtils.grayDD, fontSize: 9.sp),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
