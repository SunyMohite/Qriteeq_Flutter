import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/const_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/home/your_posted.dart';

import '../../../common/commonWidget/snackbar.dart';
import '../../../modal/apiModel/req_model/block_req_model.dart';
import '../../../modal/apiModel/req_model/feed_like_request_model.dart';
import '../../../modal/apiModel/res_model/block_res_model.dart';
import '../../../modal/apiModel/res_model/feed_like_pin_response_model.dart';
import '../../../modal/apis/api_response.dart';
import '../../../newwidget/appbar.dart';
import '../../../utils/assets/icons_utils.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/enum_utils.dart';
import '../../../utils/shared_preference_utils.dart';
import '../../../viewmodel/dashboard_viewmodel.dart';
import '../../../viewmodel/feedback_viewmodel.dart';
import '../../profileScreen/share_profile_qr.dart';
import '../../profileScreen/viewfullprofile.dart';
import '../../reportScreen/new_user_report_genrate_screen.dart';
import '../home_screen.dart';
import '../user_all_feedback.dart';
import '../widget/add_post_button_widget.dart';
import '../widget/common_feeduser_header_widget.dart';

class UserInsidePage extends StatefulWidget {
  final String? avatar, userName, toId, phone, screenName;
  final bool? isBlock, favorite, online, active, flag;

  const UserInsidePage(
      {Key? key,
      this.avatar,
      this.userName,
      this.toId,
      this.isBlock,
      this.flag,
      this.favorite,
      this.phone,
      this.active,
      this.online,
      this.screenName})
      : super(key: key);

  @override
  State<UserInsidePage> createState() => _UserInsidePageState();
}

class _UserInsidePageState extends State<UserInsidePage>
    with SingleTickerProviderStateMixin {
  FeedBackViewModel feedBackViewModel = Get.find();
  TabController? _tabController;
  String? userName, byId, toId, phone;
  BlockReqModel blockReqModel = BlockReqModel();
  FlagProfileReqModel flagProfileReqModel = FlagProfileReqModel();
  bool? isFlagProfile;
  String? queryKey, queryValue;

  @override
  void initState() {

    feedBackViewModel.initPostedCount = 0;
    feedBackViewModel.initReceivedCount = 0;

    userName = widget.userName;
    phone = widget.phone.toString().replaceAll("+", "%2B").replaceAll(" ", "");

    logs("Data: " + widget.userName.toString());

    if (widget.toId!.isNotEmpty) {
      queryKey = VariableUtils.userId;
      queryValue = widget.toId!;
      log("USER PROFILE widget.toId! ${widget.toId!}");
    } else if (widget.phone!.isNotEmpty) {
      queryKey = VariableUtils.phone;
      queryValue = widget.phone!;
      log("USER PROFILE widget.phone!");
    }

    isFlagProfile = widget.flag ?? false;
    toId = widget.toId;
    byId = PreferenceManagerUtils.getLoginId();
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.screenName == 'LeaderBoardScreen' ||
            widget.screenName == 'YourInteractionScreen' ||
            widget.screenName == 'UserAllFeedBack' ||
            widget.screenName == 'FeedBackDetailsScreen' ||
            widget.screenName == 'YourPosted' ||
            widget.screenName == 'PostedFeedBacksScreen' ||
            widget.screenName == 'ExploreScreen') {
          Get.back();
        } else {
          Get.offAll(const HomeScreen());
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              GetBuilder<DashBoardViewModel>(builder: (dashController) {
                return Column(
                  children: [
                    SizeConfig.sH1,
                    GetBuilder<FeedBackViewModel>(
                      builder: (feedBackController) {
                        return feedBackController.hideOptions == true
                            ? const SizedBox()
                            : appBar(
                                label:
                                    toId == PreferenceManagerUtils.getLoginId()
                                        ? VariableUtils.you
                                        : "$userName",
                                icon: Icons.arrow_back,
                                favSub:

                                    ///favourite...
                                    PreferenceManagerUtils.getLoginId() == toId
                                        ? const SizedBox()
                                        : GestureDetector(
                                            onTap: () async {
                                              if (feedBackController
                                                          .isUserBlock ==
                                                      true ||
                                                  feedBackController
                                                          .hideOptions ==
                                                      true) {
                                                showSnackBar(
                                                    message: VariableUtils
                                                        .blockByYouUser);
                                                return;
                                              }

                                              if (dashController
                                                      .getIsUserFavourite ==
                                                  false) {
                                                dashController
                                                    .setIsUserFavourite = true;
                                              } else {
                                                dashController
                                                    .setIsUserFavourite = false;
                                              }
                                              FeedLikeRequestModel
                                                  feedLikeRequestModel =
                                                  FeedLikeRequestModel();

                                              /// Favorite
                                              feedLikeRequestModel.by =
                                                  PreferenceManagerUtils
                                                      .getLoginId();
                                              feedLikeRequestModel.toLike =
                                                  toId;
                                              feedLikeRequestModel
                                                  .favorite = dashController
                                                          .getIsUserFavourite ==
                                                      true
                                                  ? true
                                                  : false;
                                              await dashController
                                                  .feedLikeViewModel(
                                                      feedLikeRequestModel);

                                              if (dashController
                                                      .feedLikeApiResponse
                                                      .status ==
                                                  Status.COMPLETE) {
                                                FeedLikePinResponseModel
                                                    response = dashController
                                                        .feedLikeApiResponse
                                                        .data;

                                                if (response.status != 200) {
                                                  showSnackBar(
                                                    message: response.message,
                                                    snackColor:
                                                        ColorUtils.primaryColor,
                                                  );
                                                }
                                              }
                                            },
                                            child: widget.active == false
                                                ? dashController
                                                            .getIsUserFavourite ==
                                                        true
                                                    ? IconsWidgets.redStar
                                                    : IconsWidgets.blackStar
                                                : dashController
                                                            .getIsUserFavourite ==
                                                        true
                                                    ? IconsWidgets.redHeart
                                                    : IconsWidgets.blackHeart,
                                          ),
                                onTap: () {
                                  if (widget.screenName ==
                                          'LeaderBoardScreen' ||
                                      widget.screenName ==
                                          'YourInteractionScreen' ||
                                      widget.screenName == 'UserAllFeedBack' ||
                                      widget.screenName ==
                                          'FeedBackDetailsScreen' ||
                                      widget.screenName == 'YourPosted' ||
                                      widget.screenName ==
                                          'PostedFeedBacksScreen' ||
                                      widget.screenName == 'ExploreScreen') {
                                    Navigator.pop(context);
                                  } else {
                                    Get.offAll(const HomeScreen());
                                  }
                                },
                                onPopUpTap: (val) async {
                                  if (PreferenceManagerUtils.getLoginId() ==
                                      toId) {
                                    Get.to(
                                        NewGenerateReport(
                                          sId: toId,
                                          avatar: widget.avatar,
                                          name: widget.userName,
                                          isActive: true,
                                        ),
                                        transition: Transition.cupertino);
                                  } else {
                                    if (val ==
                                        ProfileStatus.flagProfile.index) {
                                      /// Flag
                                      flagProfileReqModel.to = toId;
                                      flagProfileReqModel.by = byId;
                                      flagProfileReqModel.profileFlag =
                                          feedBackController
                                                      .isUserFlagProfile ==
                                                  true
                                              ? false
                                              : true;
                                      await dashController.flagProfileViewModel(
                                          flagProfileReqModel);
                                      if (dashController
                                              .flagProfileApiResponse.status ==
                                          Status.COMPLETE) {
                                        BlockResModel response = dashController
                                            .flagProfileApiResponse.data;
                                        if (response.status == 200) {
                                          showSnackBar(
                                            message: response.message,
                                            snackColor: ColorUtils.primaryColor,
                                          );
                                          await Future.delayed(
                                              const Duration(seconds: 2));
                                          Navigator.pop(context);
                                        } else {
                                          showSnackBar(
                                            message: response.message,
                                            snackColor: ColorUtils.primaryColor,
                                          );
                                        }
                                      }
                                      dashController.allFeedsViewModel();
                                    } else if (val ==
                                            ProfileStatus.block.index ||
                                        val == ProfileStatus.unBlock.index) {
                                      /// Block

                                      blockReqModel.to = toId;
                                      blockReqModel.by = byId;
                                      blockReqModel.block =
                                          feedBackController.isUserBlock == true
                                              ? false
                                              : true;

                                      await dashController
                                          .userBlockUnblockViewModel(
                                              blockReqModel);
                                      if (dashController
                                              .blockFeedApiResponse.status ==
                                          Status.COMPLETE) {
                                        BlockResModel response = dashController
                                            .blockFeedApiResponse.data;
                                        if (response.status == 200) {
                                          showSnackBar(
                                            message:
                                                response.data!.blockMessage ??
                                                    'Something went to wrong',
                                            snackColor: ColorUtils.primaryColor,
                                          );
                                          await Future.delayed(
                                              const Duration(seconds: 2));
                                          Navigator.pop(context);
                                        } else {
                                          showSnackBar(
                                            message:
                                                response.data!.blockMessage ??
                                                    'Something went to wrong',
                                            snackColor: ColorUtils.primaryColor,
                                          );
                                        }
                                      }
                                      dashController.allFeedsViewModel();
                                      // Navigator.pop(context);
                                    } else if (val ==
                                        ProfileStatus.generateReport.index) {
                                      /// Generate Report
                                      if (feedBackController.isUserBlock ==
                                          true) {
                                        showSnackBar(
                                            message:
                                                VariableUtils.blockByYouUser,
                                            showDuration:
                                                const Duration(seconds: 3));
                                        return;
                                      }
                                      Get.to(
                                          NewGenerateReport(
                                            sId: toId,
                                            avatar: widget.avatar,
                                            name: widget.userName,
                                            isActive: true,
                                          ),
                                          transition: Transition.cupertino);
                                    }
                                    else if (val ==
                                        ProfileStatus.viewfullprofile.index) {
                                      Get.to(ViewFullProfile(
                                          id: widget.toId.toString(),
                                          name: widget.userName.toString(),
                                          imageurl: widget.avatar.toString()));
                                    } else if (val ==
                                        ProfileStatus.shareProfile.index) {
                                      Get.to(ShareProfileQR(
                                        id: widget.toId.toString(),
                                        name: widget.userName.toString(),
                                        imageurl: widget.avatar.toString(),
                                        profileLink: feedBackViewModel.profileShareLink,
                                      ));
                                    }
                                  }
                                },
                                popupMenuItem: feedBackController.isUserBlock ==
                                        true
                                    ? [
                                        PopupMenuItem(
                                          child:
                                              const Text(VariableUtils.unBlock),
                                          value: ProfileStatus.unBlock.index,
                                        ),
                                      ]
                                    : PreferenceManagerUtils.getLoginId() ==
                                            toId
                                        ? [
                                            PopupMenuItem(
                                              child: const Text(
                                                  VariableUtils.generateReport),
                                              value: ProfileStatus
                                                  .generateReport.index,
                                            )
                                          ]
                                        : feedBackController.userObje
                                                    .generateReportOption ==
                                                true
                                            ? [
                                                PopupMenuItem(
                                                  child: Text(feedBackController
                                                              .isUserFlagProfile ==
                                                          true
                                                      ? VariableUtils
                                                          .unFlagProfile
                                                      : VariableUtils
                                                          .flagProfile),
                                                  value: ProfileStatus
                                                      .flagProfile.index,
                                                ),
                                                PopupMenuItem(
                                                  child: const Text(
                                                      VariableUtils
                                                          .generateReport),
                                                  value: ProfileStatus
                                                      .generateReport.index,
                                                ),
                                                PopupMenuItem(
                                                  child: const Text(
                                                      VariableUtils.block),
                                                  value:
                                                      ProfileStatus.block.index,
                                                ),
                                                PopupMenuItem(
                                                  child: const Text(
                                                      "Share Profile"),
                                                  value: ProfileStatus
                                                      .shareProfile.index,
                                                ),
                                                PopupMenuItem(
                                                  child: const Text(
                                                      "View Full Profile"),
                                                  value: ProfileStatus
                                                      .viewfullprofile.index,
                                                ),
                                              ]
                                            : [
                                                PopupMenuItem(
                                                  child: Text(feedBackController
                                                              .isUserFlagProfile ==
                                                          true
                                                      ? VariableUtils
                                                          .unFlagProfile
                                                      : VariableUtils
                                                          .flagProfile),
                                                  value: ProfileStatus
                                                      .flagProfile.index,
                                                ),
                                                PopupMenuItem(
                                                  child: const Text(
                                                      VariableUtils.block),
                                                  value:
                                                      ProfileStatus.block.index,
                                                ),
                                                PopupMenuItem(
                                                  child: const Text(
                                                      "Share Profile"),
                                                  value: ProfileStatus
                                                      .shareProfile.index,
                                                ),
                                                PopupMenuItem(
                                                  child: const Text(
                                                      "View Full Profile"),
                                                  value: ProfileStatus
                                                      .viewfullprofile.index,
                                                ),
                                              ],
                              );
                      },
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          ///FEED USER common HEADER VIEW
                          FeedUserProfileHeaderWidget(
                            userOnlineStatus: widget.online,
                            userActive: widget.active,
                            toUserId: toId,
                            userProfile: widget.avatar,
                            favorite: widget.favorite,
                            screenName: "UserInsidePage",
                            tabController: _tabController,
                            userName: widget.userName,
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                UserAllFeedBackScreen(
                                  userFeedBackId: widget.active == true
                                      ? widget.toId
                                      : phone ?? widget.toId,
                                  isExistsUser: widget.active,
                                  queryKey: queryKey,
                                  queryValue: queryValue,
                                  isScreenName: "UserInsidePage",
                                ),
                                YourPosted(
                                  feedBackUserId: widget.active == true
                                      ? widget.toId
                                      : phone ?? widget.toId,
                                  isExistsUser: widget.active,
                                  isScreenName: "UserInsidePage",
                                  fromScreen: queryValue ==
                                          PreferenceManagerUtils.getLoginId()
                                      ? "YouInside"
                                      : '',
                                  queryKey: queryKey,
                                  queryValue: queryValue,
                                )
                              ],
                              controller: _tabController,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
              PreferenceManagerUtils.getLoginId() == toId
                  ? const SizedBox()
                  : AddPostButtonWidget(
                      sId: widget.toId!,
                      userName: userName!,
                      mobileNumber: widget.phone == null ? '' : widget.phone!,
                      isConnect: widget.active!,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
