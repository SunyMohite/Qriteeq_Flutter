import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
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
import '../../../utils/decoration_utils.dart';
import '../../../utils/enum_utils.dart';
import '../../../utils/font_style_utils.dart';
import '../../../utils/shared_preference_utils.dart';
import '../../../utils/size_config_utils.dart';
import '../../../utils/variable_utils.dart';
import '../../../viewmodel/dashboard_viewmodel.dart';
import '../../../viewmodel/feedback_viewmodel.dart';
import '../../chatScreen/chatpage.dart';
import '../../profileScreen/share_profile_qr.dart';
import '../../profileScreen/viewfullprofile.dart';
import '../../reportScreen/new_user_report_genrate_screen.dart';

class FeedUserProfileHeaderWidget extends StatefulWidget {
  final String? userProfile, toUserId, userName, screenName;
  final bool? userOnlineStatus, userActive, favorite, isBlock, isFlagProfile;
  final TabController? tabController;

  const FeedUserProfileHeaderWidget(
      {Key? key,
      required this.userProfile,
      required this.toUserId,
      required this.userOnlineStatus,
      required this.userActive,
      required this.favorite,
      this.userName,
      this.isBlock,
      this.isFlagProfile,
      this.screenName,
      this.tabController})
      : super(key: key);

  @override
  State<FeedUserProfileHeaderWidget> createState() =>
      _FeedUserProfileHeaderWidgetState();
}

String name = "", userid = "", count2 = "";
double count = 5.0;
bool israted = false;

class _FeedUserProfileHeaderWidgetState
    extends State<FeedUserProfileHeaderWidget>
    with SingleTickerProviderStateMixin {
  FeedBackViewModel feedBackViewModel = Get.find();
  DashBoardViewModel dashBoardViewModel = Get.find();
  FlagProfileReqModel flagProfileReqModel = FlagProfileReqModel();
  BlockReqModel blockReqModel = BlockReqModel();
  String? byId;
  @override
  void initState() {
    dashBoardViewModel.initIsUserFavourite = widget.favorite!;
    byId = PreferenceManagerUtils.getLoginId();

    feedBackViewModel.initPostedCount = 0;
    feedBackViewModel.initReceivedCount = 0;
    validateRating();

    super.initState();
  }

  void validateRating() {
    final firestore = FirebaseFirestore.instance;
    firestore
        .collection("Ratings")
        .doc(widget.toUserId)
        .collection(PreferenceManagerUtils.getLoginId())
        .doc("data")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        logs("Data Found: " + documentSnapshot.data().toString());
        count2 = documentSnapshot['rating'].toString();
        israted = true;
      } else {
        logs("Data not Found");
        israted = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedBackViewModel>(
      builder: (feedBackController) {
        return Column(
          children: [
            (widget.screenName != null && widget.screenName == 'UserInsidePage')
                ? const SizedBox()
                : GetBuilder<DashBoardViewModel>(
                    builder: (dashController) {
                      return appBar(
                          label: widget.toUserId ==
                                  PreferenceManagerUtils.getLoginId()
                              ? VariableUtils.you
                              : "${widget.userName}",
                          icon: Icons.arrow_back,
                          onTap: () {
                            Get.back();
                          },
                          favSub:

                              ///favourite...
                              PreferenceManagerUtils.getLoginId() ==
                                      widget.toUserId
                                  ? const SizedBox()
                                  : GestureDetector(
                                      onTap: () async {
                                        if (feedBackController.isUserBlock ==
                                                true ||
                                            feedBackController.hideOptions ==
                                                true) {
                                          showSnackBar(
                                              message:
                                                  VariableUtils.blockByYouUser);
                                          return;
                                        }

                                        if (dashController.getIsUserFavourite ==
                                            false) {
                                          dashController.setIsUserFavourite =
                                              true;
                                        } else {
                                          dashController.setIsUserFavourite =
                                              false;
                                        }
                                        FeedLikeRequestModel
                                            feedLikeRequestModel =
                                            FeedLikeRequestModel();

                                        /// Favorite
                                        feedLikeRequestModel.by =
                                            PreferenceManagerUtils.getLoginId();
                                        feedLikeRequestModel.toLike =
                                            widget.toUserId;
                                        feedLikeRequestModel.favorite =
                                            dashController.getIsUserFavourite ==
                                                    true
                                                ? true
                                                : false;
                                        await dashController.feedLikeViewModel(
                                            feedLikeRequestModel);

                                        if (dashController
                                                .feedLikeApiResponse.status ==
                                            Status.COMPLETE) {
                                          FeedLikePinResponseModel response =
                                              dashController
                                                  .feedLikeApiResponse.data;

                                          if (response.status != 200) {
                                            showSnackBar(
                                              message: response.message,
                                              snackColor:
                                                  ColorUtils.primaryColor,
                                            );
                                          }
                                        }
                                      },
                                      child: widget.userActive == false
                                          ? dashController.getIsUserFavourite ==
                                                  true
                                              ? IconsWidgets.redStar
                                              : IconsWidgets.blackStar
                                          : dashController.getIsUserFavourite ==
                                                  true
                                              ? IconsWidgets.redHeart
                                              : IconsWidgets.blackHeart,
                                    ),
                          onPopUpTap: (val) async {
                            if (val == ProfileStatus.flagProfile.index) {
                              /// Flag
                              flagProfileReqModel.to = widget.toUserId;
                              flagProfileReqModel.by = byId;
                              flagProfileReqModel.profileFlag =
                                  widget.isFlagProfile == true ? false : true;
                              await dashController
                                  .flagProfileViewModel(flagProfileReqModel);
                              if (dashController
                                      .flagProfileApiResponse.status ==
                                  Status.COMPLETE) {
                                BlockResModel response =
                                    dashController.flagProfileApiResponse.data;
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
                              FeedBackViewModel feedBackController = Get.find();
                              if (feedBackController.isUserBlock == true) {
                                showSnackBar(
                                    message: VariableUtils.blockByYouUser,
                                    showDuration: const Duration(seconds: 3));
                                return;
                              }
                              Get.to(
                                  NewGenerateReport(
                                    sId: widget.toUserId,
                                    avatar: widget.userProfile,
                                    name: widget.userName,
                                    isActive: true,
                                  ),
                                  transition: Transition.cupertino);
                            } else if (val == ProfileStatus.block.index ||
                                val == ProfileStatus.unBlock.index) {
                              /// Block...
                              blockReqModel.to = widget.toUserId;
                              blockReqModel.by = byId;
                              blockReqModel.block =
                                  widget.isBlock == true ? false : true;
                              await dashController
                                  .userBlockUnblockViewModel(blockReqModel);
                              if (dashController.blockFeedApiResponse.status ==
                                  Status.COMPLETE) {
                                BlockResModel response =
                                    dashController.blockFeedApiResponse.data;
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
                            }else if (val ==
                                ProfileStatus.viewfullprofile.index) {
                              Get.to(ViewFullProfile(
                                  id: widget.toUserId.toString(),
                                  name: widget.userName.toString(),
                                  imageurl: widget.userProfile.toString()));
                            } else if (val ==
                                ProfileStatus.shareProfile.index) {
                              Get.to(ShareProfileQR(
                                id: widget.toUserId.toString(),
                                name: widget.userName.toString(),
                                imageurl: widget.userProfile.toString(),
                                profileLink: feedBackViewModel.profileShareLink,
                              ));
                            }
                          },
                          popupMenuItem: widget.toUserId ==
                                  PreferenceManagerUtils.getLoginId()
                              ? [
                                  PopupMenuItem(
                                    child: const Text(
                                        VariableUtils.generateReport),
                                    value: ProfileStatus.generateReport.index,
                                  ),
                                ]
                              : widget.isBlock == true
                                  ? [
                                      PopupMenuItem(
                                        child:
                                            const Text(VariableUtils.unBlock),
                                        value: ProfileStatus.unBlock.index,
                                      ),
                                    ]
                                  : feedBackController
                                              .userObje.generateReportOption ==
                                          true
                                      ? [
                                          PopupMenuItem(
                                            child: Text(widget.isFlagProfile ==
                                                    true
                                                ? VariableUtils.unFlagProfile
                                                : VariableUtils.flagProfile),
                                            value:
                                                ProfileStatus.flagProfile.index,
                                          ),
                                          PopupMenuItem(
                                            child: const Text(
                                                VariableUtils.generateReport),
                                            value: ProfileStatus
                                                .generateReport.index,
                                          ),
                                          PopupMenuItem(
                                            child:
                                                const Text(VariableUtils.block),
                                            value: ProfileStatus.block.index,
                                          ),
                                          PopupMenuItem(
                                            child: const Text("Share Profile"),
                                            value: ProfileStatus
                                                .shareProfile.index,
                                          ),
                                          PopupMenuItem(
                                            child:
                                                const Text("View Full Profile"),
                                            value: ProfileStatus
                                                .viewfullprofile.index,
                                          ),
                                        ]
                                      : [
                                          PopupMenuItem(
                                            child: Text(widget.isFlagProfile ==
                                                    true
                                                ? VariableUtils.unFlagProfile
                                                : VariableUtils.flagProfile),
                                            value:
                                                ProfileStatus.flagProfile.index,
                                          ),
                                          PopupMenuItem(
                                            child:
                                                const Text(VariableUtils.block),
                                            value: ProfileStatus.block.index,
                                          ),
                                          PopupMenuItem(
                                            child: const Text("Share Profile"),
                                            value: ProfileStatus
                                                .shareProfile.index,
                                          ),
                                          PopupMenuItem(
                                            child:
                                                const Text("View Full Profile"),
                                            value: ProfileStatus
                                                .viewfullprofile.index,
                                          ),
                                        ]);
                    },
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
                        profileLink: widget.userProfile,
                      ),
                      PreferenceManagerUtils.getLoginId() == widget.toUserId
                          ? const SizedBox()
                          : Positioned(
                              bottom: 0.5.w,
                              right: 0,
                              child: Container(
                                height: 3.w,
                                width: 3.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: widget.userOnlineStatus == true
                                        ? ColorUtils.colorGreen
                                        : ColorUtils.colorGrey),
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// TRUST SCORE ....
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: feedBackController.trustScore,
                              style: FontTextStyle.roboto10W5Black1E
                                  .copyWith(color: ColorUtils.purple68),
                            ),
                            TextSpan(
                                text: '/',
                                style: FontTextStyle.roboto10W5Black1E),
                            TextSpan(
                                text: feedBackController.totalTrustScore,
                                style: FontTextStyle.roboto10W5Black1E),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, top:10, right: 5, bottom:10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Material(
                      color: ColorUtils.primaryColor,
                      child: InkWell(
                        onTap: () async {
                          if (!israted) {
                            name = widget.userName.toString();
                            userid = widget.toUserId.toString();
                            showAlertDialog(context);
                          } else {
                            showSnackBar(
                                message: "You have already rated " +
                                    widget.userName.toString() +
                                    " " +
                                    count2.substring(0, 1) +
                                    "⭐");
                          }
                        },
                        child: Container(
                          height: 8.w,
                          width:160,
                          decoration:
                          DecorationUtils.allBorderAndColorDecorationBox(
                            radius: 7,
                          ),
                          child: Center(
                            child: Text(
                              israted ? "You rated DP "+count2.substring(0,1)+"⭐": "Rate DP",
                              style: FontTextStyle.poppinsWhite10bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, top:10, right: 10, bottom:10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Material(
                      color: ColorUtils.primaryColor,
                      child: InkWell(
                        onTap: () async {
                          logs("Button Click");
                          final firestore = FirebaseFirestore.instance;
                          firestore
                              .collection("Users")
                              .doc(widget.toUserId.toString())
                              .get()
                              .then((value) {
                            if (!value.exists) {
                              Map<String, dynamic> data = {
                                'date_time': DateTime.now(),
                                'email': "demo@gmail.com",
                                'name': widget.userName.toString(),
                                'imagepath': widget.userProfile,
                              };
                              firestore
                                  .collection('Users')
                                  .doc(widget.toUserId.toString())
                                  .set(data)
                                  .then((value) => Get.to(ChatPage(
                                  id: widget.toUserId.toString(),
                                  name: widget.userName.toString(),
                                  imagepath: widget.userProfile.toString())));
                            } else {
                              Get.to(ChatPage(
                                  id: widget.toUserId.toString(),
                                  name: widget.userName.toString(),
                                  imagepath: widget.userProfile.toString()));
                            }
                          });
                        },
                        child: Container(
                          height: 8.w,
                          width:160,
                          decoration:
                          DecorationUtils.allBorderAndColorDecorationBox(
                            radius: 7,
                          ),
                          child: Center(
                            child: Text(
                              "Message",
                              style: FontTextStyle.poppinsWhite10bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
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
              controller: widget.tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.black, width: 5.0),
                insets: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
              ),
            ),
          ],
        );
      },
    );
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = TextButton(
    child: Text("RATE DP"),
    onPressed: () {
      final firestore = FirebaseFirestore.instance;
      Map<String, dynamic> data = {
        'name': PreferenceManagerUtils.getAvatarUserFullName(),
        'rating': count,
        'imagepath': PreferenceManagerUtils.getUserAvatar()
      };
      firestore
          .collection('Ratings')
          .doc(userid)
          .collection(PreferenceManagerUtils.getLoginId())
          .doc("data")
          .set(data)
          .then((value) => Navigator.of(context).pop());
      ProfileScreen();
      showSnackBar(message: "Thanks user for Rating");
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    content: Container(
        child: RatingBar.builder(
      initialRating: 5,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        print(rating);
        count = rating;
      },
    )),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
