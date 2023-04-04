import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/home/your_posted.dart';
import 'package:sizer/sizer.dart';

import '../../../common/commonWidget/octo_image_widget.dart';
import '../../../common/commonWidget/snackbar.dart';
import '../../../common/commonWidget/texwidget.dart';
import '../../../modal/apiModel/req_model/block_req_model.dart';
import '../../../modal/apiModel/req_model/feed_like_request_model.dart';
import '../../../modal/apiModel/res_model/block_res_model.dart';
import '../../../modal/apiModel/res_model/feed_like_pin_response_model.dart';
import '../../../modal/apis/api_response.dart';
import '../../../newwidget/appbar.dart';
import '../../../utils/assets/icons_utils.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/const_utils.dart';
import '../../../utils/enum_utils.dart';
import '../../../utils/shared_preference_utils.dart';
import '../../../viewmodel/dashboard_viewmodel.dart';
import '../../../viewmodel/feedback_viewmodel.dart';
import '../../reportScreen/new_user_report_genrate_screen.dart';
import '../user_all_feedback.dart';
import '../widget/add_post_button_widget.dart';

class NonExistsUserInsidePage extends StatefulWidget {
  final String? mobileNo, displayName;

  const NonExistsUserInsidePage({Key? key, this.mobileNo, this.displayName})
      : super(key: key);

  @override
  State<NonExistsUserInsidePage> createState() => _InsidePageState();
}

class _InsidePageState extends State<NonExistsUserInsidePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  FeedBackViewModel feedBackViewModel = Get.find();
  DashBoardViewModel dashBoardViewModel = Get.find();
  bool isFavSubStatus = false;
  FlagProfileReqModel flagProfileReqModel = FlagProfileReqModel();
  String? mobileNo;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    feedBackViewModel.initPostedCount = 0;
    feedBackViewModel.initReceivedCount = 0;
    mobileNo = widget.mobileNo!
        .toString()
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    super.initState();
  }

  BlockReqModel blockReqModel = BlockReqModel();
  DashBoardViewModel dashController = Get.find();

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<FeedBackViewModel>(
          builder: (feedBackController) {
            return Stack(
              children: [
                Column(
                  children: [
                    ///contact list....
                    Expanded(
                      child: Column(
                        children: [
                          appBar(
                            label: "${widget.displayName ?? widget.mobileNo}",
                            icon: Icons.arrow_back,
                            isHideOption: feedBackController.hideOptions,
                            onTap: () {
                              Get.back();
                            },
                            favSub:

                                ///favourite...
                                PreferenceManagerUtils.getLoginId() ==
                                        feedBackController.userObje.id
                                    ? const SizedBox()
                                    : GetBuilder<DashBoardViewModel>(
                                        builder: (dashController) {
                                          return feedBackViewModel
                                                      .nonExistsUserActive ==
                                                  false
                                              ?

                                              ///user is in active subscribe...
                                              GestureDetector(
                                                  onTap: () async {
                                                    if (feedBackController
                                                            .hideOptions ||
                                                        feedBackController
                                                            .isUserBlock) {
                                                      showSnackBar(
                                                          message: VariableUtils
                                                              .blockByYouUser);
                                                      return;
                                                    }
                                                    if (feedBackController
                                                            .nonExistsUserFav ==
                                                        false) {
                                                      feedBackController
                                                              .nonExistsUserFav =
                                                          true;
                                                    } else {
                                                      feedBackController
                                                              .nonExistsUserFav =
                                                          false;
                                                    }
                                                    FeedLikeRequestModel
                                                        feedLikeRequestModel =
                                                        FeedLikeRequestModel();

                                                    /// Favorite
                                                    feedLikeRequestModel.by =
                                                        PreferenceManagerUtils
                                                            .getLoginId();

                                                    feedLikeRequestModel.toLike =
                                                        feedBackController
                                                                .userObje.id ??
                                                            widget.mobileNo!
                                                                .replaceAll(
                                                                    ' ', '')
                                                                .replaceAll(
                                                                    '+', '');

                                                    feedLikeRequestModel
                                                            .favorite =
                                                        feedBackController
                                                                    .nonExistsUserFav ==
                                                                true
                                                            ? true
                                                            : false;

                                                    await dashController
                                                        .feedLikeViewModel(
                                                            feedLikeRequestModel,
                                                            connectionUrl:
                                                                'connection?fullName=${widget.displayName}&phone=${widget.mobileNo!.replaceAll(' ', '').replaceAll('+', '%2B')}');

                                                    if (dashController
                                                            .feedLikeApiResponse
                                                            .status ==
                                                        Status.COMPLETE) {
                                                      FeedLikePinResponseModel
                                                          response =
                                                          dashController
                                                              .feedLikeApiResponse
                                                              .data;

                                                      if (response.status !=
                                                          200) {
                                                        showSnackBar(
                                                          message:
                                                              response.message,
                                                          snackColor: ColorUtils
                                                              .primaryColor,
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: feedBackController
                                                              .nonExistsUserFav ==
                                                          false
                                                      ? feedBackController
                                                                  .nonExistsUserFav ==
                                                              true
                                                          ? IconsWidgets.redStar
                                                          : IconsWidgets
                                                              .blackStar
                                                      : feedBackController
                                                                  .nonExistsUserFav ==
                                                              true
                                                          ? IconsWidgets.redStar
                                                          : IconsWidgets
                                                              .blackStar,
                                                )
                                              :

                                              ///is user is active then favourite........
                                              GestureDetector(
                                                  onTap: () async {
                                                    if (feedBackController
                                                            .nonExistsUserFav ==
                                                        false) {
                                                      if (feedBackController
                                                              .hideOptions ||
                                                          feedBackController
                                                              .isUserBlock) {
                                                        showSnackBar(
                                                            message: VariableUtils
                                                                .blockByYouUser);
                                                        return;
                                                      }
                                                      feedBackController
                                                              .nonExistsUserFav =
                                                          true;
                                                    } else {
                                                      feedBackController
                                                              .nonExistsUserFav =
                                                          false;
                                                    }
                                                    FeedLikeRequestModel
                                                        feedLikeRequestModel =
                                                        FeedLikeRequestModel();

                                                    /// Favorite
                                                    feedLikeRequestModel.by =
                                                        PreferenceManagerUtils
                                                            .getLoginId();

                                                    feedLikeRequestModel.toLike =
                                                        feedBackController
                                                                .userObje.id ??
                                                            widget.mobileNo!
                                                                .replaceAll(
                                                                    ' ', '')
                                                                .replaceAll(
                                                                    '+', '');

                                                    feedLikeRequestModel
                                                            .favorite =
                                                        feedBackController
                                                                    .nonExistsUserFav ==
                                                                true
                                                            ? true
                                                            : false;

                                                    await dashController
                                                        .feedLikeViewModel(
                                                      feedLikeRequestModel,
                                                    );

                                                    if (dashController
                                                            .feedLikeApiResponse
                                                            .status ==
                                                        Status.COMPLETE) {
                                                      FeedLikePinResponseModel
                                                          response =
                                                          dashController
                                                              .feedLikeApiResponse
                                                              .data;

                                                      if (response.status !=
                                                          200) {
                                                        showSnackBar(
                                                          message:
                                                              response.message,
                                                          snackColor: ColorUtils
                                                              .primaryColor,
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: feedBackController
                                                              .nonExistsUserFav ==
                                                          false
                                                      ? feedBackController
                                                                  .nonExistsUserFav ==
                                                              true
                                                          ? IconsWidgets
                                                              .redHeart
                                                          : IconsWidgets
                                                              .blackHeart
                                                      : feedBackController
                                                                  .nonExistsUserFav ==
                                                              true
                                                          ? IconsWidgets
                                                              .redHeart
                                                          : IconsWidgets
                                                              .blackHeart,
                                                );
                                        },
                                      ),
                            onPopUpTap: (val) async {
                              /// report
                              if (feedBackController.userObje.id == null) {
                                Get.showSnackbar(
                                  const GetSnackBar(
                                    message:
                                        'You are not able to create report yet',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: ColorUtils.primaryColor,
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                                return;
                              } else {
                                if (feedBackController.userObje.active ==
                                        false ||
                                    feedBackController.userObje.active ==
                                        null) {
                                  if (val == ProfileStatus.flagProfile.index) {
                                    if (feedBackViewModel.nonExistsUserActive ==
                                        true) {
                                      showSnackBar(
                                          message: VariableUtils.blockByYouUser,
                                          showDuration:
                                              const Duration(seconds: 3));
                                      return;
                                    }
                                  }
                                  Get.to(
                                      NewGenerateReport(
                                        sId: feedBackController.userObje.id,
                                        avatar:
                                            feedBackController.userObje.avatar,
                                        name: feedBackController
                                            .userObje.userIdentity,
                                        isActive: true,
                                      ),
                                      transition: Transition.cupertino);
                                } else if (feedBackController.userObje.active ==
                                    true) {
                                  if (val == ProfileStatus.flagProfile.index) {
                                    /// Flag

                                    flagProfileReqModel.to =
                                        feedBackController.userObje.id;
                                    flagProfileReqModel.by =
                                        PreferenceManagerUtils.getLoginId();
                                    flagProfileReqModel.profileFlag =
                                        feedBackController.userObje
                                                    .defaultStatus!.flag ==
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
                                      ProfileStatus.generateReport.index) {
                                    if (feedBackViewModel.nonExistsUserActive ==
                                        true) {
                                      showSnackBar(
                                          message: VariableUtils.blockByYouUser,
                                          showDuration:
                                              const Duration(seconds: 3));
                                      return;
                                    }
                                    Get.to(
                                        NewGenerateReport(
                                          sId: feedBackController.userObje.id,
                                          avatar: feedBackController
                                              .userObje.avatar,
                                          name: feedBackController
                                              .userObje.userIdentity,
                                          isActive: true,
                                        ),
                                        transition: Transition.cupertino);
                                  } else if (val == ProfileStatus.block.index ||
                                      val == ProfileStatus.unBlock.index) {
                                    /// Block

                                    blockReqModel.to =
                                        feedBackController.userObje.id;
                                    blockReqModel.by =
                                        PreferenceManagerUtils.getLoginId();
                                    blockReqModel.block = feedBackController
                                                .userObje
                                                .defaultStatus!
                                                .block ==
                                            true
                                        ? false
                                        : true;
                                    await dashController
                                        .userBlockUnblockViewModel(
                                            blockReqModel);
                                    if (dashBoardViewModel
                                            .blockFeedApiResponse.status ==
                                        Status.COMPLETE) {
                                      BlockResModel response =
                                          dashBoardViewModel
                                              .blockFeedApiResponse.data;
                                      if (response.status == 200) {
                                        showSnackBar(
                                          message: response.data!.blockMessage,
                                          snackColor: ColorUtils.primaryColor,
                                        );
                                        await Future.delayed(
                                            const Duration(seconds: 2));

                                        Navigator.pop(context);
                                      } else {
                                        showSnackBar(
                                          message: response.data!.blockMessage,
                                          snackColor: ColorUtils.primaryColor,
                                        );
                                      }
                                    }
                                    dashController.allFeedsViewModel();
                                  }
                                } else {
                                  Get.back();
                                }
                              }
                            },
                            popupMenuItem: feedBackController
                                            .userObje.defaultStatus !=
                                        null &&
                                    feedBackController
                                            .userObje.defaultStatus!.block ==
                                        true
                                ? [
                                    PopupMenuItem(
                                      child: const Text(VariableUtils.unBlock),
                                      value: ProfileStatus.unBlock.index,
                                    ),
                                  ]
                                : PreferenceManagerUtils.getLoginId() ==
                                        feedBackController.userObje.id
                                    ? [
                                        PopupMenuItem(
                                          child: const Text(
                                              VariableUtils.generateReport),
                                          value: ProfileStatus
                                              .generateReport.index,
                                        )
                                      ]
                                    : feedBackController.userObje.active ==
                                                false ||
                                            feedBackController
                                                    .userObje.active ==
                                                null
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
                                                              .userObje
                                                              .defaultStatus!
                                                              .flag ==
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
                                              ]
                                            : [
                                                PopupMenuItem(
                                                  child: Text(feedBackController
                                                              .userObje
                                                              .defaultStatus!
                                                              .flag ==
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
                                              ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: SizedBox(
                                    child: Stack(
                                  children: [
                                    OctoImageWidget(
                                      profileLink:
                                          feedBackController.userObje.avatar,
                                    ),
                                    PreferenceManagerUtils.getLoginId() ==
                                            feedBackController.userObje.id
                                        ? const SizedBox()
                                        : Positioned(
                                            bottom: 0.5.w,
                                            right: 0,
                                            child: Container(
                                              height: 3.w,
                                              width: 3.w,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: feedBackController
                                                                  .userObje
                                                                  .online ==
                                                              null ||
                                                          feedBackController
                                                                  .userObje
                                                                  .online ==
                                                              false
                                                      ? ColorUtils.colorGrey
                                                      : ColorUtils.colorGreen),
                                            ),
                                          ),
                                  ],
                                )),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${feedBackController.receivedCount}",
                                      style: FontTextStyle.roboto10W5Black1E,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizeConfig.sH05,
                                    feedBackReceivedText(),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${feedBackController.postedCount}",
                                      style: FontTextStyle.roboto10W5Black1E,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizeConfig.sH05,
                                    feedBackPostedText(),
                                  ],
                                ),
                              ),

                              /// TRUST SCORE ....

                              feedBackController.userObje.active == false ||
                                      feedBackController.userObje.active == null
                                  ? const SizedBox()
                                  : Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: feedBackController
                                                      .trustScore,
                                                  style: FontTextStyle
                                                      .roboto10W5Black1E
                                                      .copyWith(
                                                          color: ColorUtils
                                                              .purple68),
                                                ),

                                                TextSpan(
                                                    text: '/',
                                                    style: FontTextStyle
                                                        .roboto10W5Black1E),
                                                TextSpan(
                                                    text: feedBackController
                                                        .totalTrustScore,
                                                    style: FontTextStyle
                                                        .roboto10W5Black1E),
                                              ],
                                            ),
                                          ),
                                          SizeConfig.sH05,
                                          trustScoreText(),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                          TabBar(
                            labelStyle: FontTextStyle.fontStyle,
                            unselectedLabelStyle: FontTextStyle.fontStyle,
                            unselectedLabelColor: ColorUtils.gray83,
                            labelColor: ColorUtils.black1E,
                            padding: EdgeInsets.zero,
                            indicatorColor: ColorUtils.black1E,
                            tabs: [
                              Tab(
                                text: VariableUtils.userAllFeedBackScreen,
                              ),
                              Tab(
                                text: VariableUtils.youPosted,
                              )
                            ],
                            controller: _tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: const UnderlineTabIndicator(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 5.0),
                              insets:
                                  EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                UserAllFeedBackScreen(
                                  userFeedBackId: widget.mobileNo!,
                                  queryKey: 'phone',
                                  queryValue: widget.mobileNo!,
                                ),
                                YourPosted(
                                  feedBackUserId: widget.mobileNo,
                                  isExistsUser: false,
                                  queryKey: 'phone',
                                  queryValue: widget.mobileNo!,
                                )
                              ],
                              controller: _tabController,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                feedBackController.userObje.phone ==
                        PreferenceManagerUtils.getUserMobileNumber()
                    ? const SizedBox()
                    : AddPostButtonWidget(
                        sId: '',
                        userName: widget.displayName!,
                        mobileNumber:
                            widget.mobileNo == null ? '' : widget.mobileNo!,
                        isConnect: false,
                      )
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> init() async {
    if (feedBackViewModel.userObje.id == null) {
      isFavSubStatus = false;
      feedBackViewModel.initNonExistsUserFav = false;
    } else {
      isFavSubStatus = feedBackViewModel.nonExistsUserFav;
      feedBackViewModel.initNonExistsUserFav =
          feedBackViewModel.nonExistsUserFav;
    }
  }
}
