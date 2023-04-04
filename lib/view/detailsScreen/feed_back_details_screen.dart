import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/commonWidget/common_profile_icon.dart';
import 'package:humanscoring/common/commonWidget/octo_image_widget.dart';
import 'package:humanscoring/common/commonWidget/snackbar.dart';
import 'package:humanscoring/modal/apiModel/req_model/like_unlike_req_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_comment_res_model.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/service/download_file.dart';
import 'package:humanscoring/utils/assets/icons_utils.dart';
import 'package:humanscoring/utils/assets/images_utils.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/decoration_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/detailsScreen/dispute_screen.dart';
import 'package:humanscoring/viewmodel/feedback_viewmodel.dart';
import 'package:octo_image/octo_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../common/circular_progress_indicator.dart';
import '../../common/commonWidget/custom_dialog.dart';
import '../../common/commonWidget/custom_header.dart';
import '../../common/commonWidget/feedback_score_emoji.dart';
import 'package:flutter_svg/svg.dart';
import '../../modal/apiModel/res_model/get_feedback_details_res_model.dart';
import '../../modal/apiModel/res_model/like_unlike_res_model.dart';
import '../../modal/apiModel/res_model/payment_coin_res_model.dart';
import '../../newwidget/text_and_style.dart';
import '../../service/video_player.dart';
import '../../utils/assets/lotti_animation_json.dart';
import '../flagBottomsheetScreen/comment_flag_bottom_sheet.dart';
import '../flagBottomsheetScreen/flag_bottom_sheet.dart';
import '../home/feed_inside_page/user_profile_inside_page.dart';
import '../home/home_screen.dart';

class FeedBackDetailsScreen extends StatefulWidget {
  final bool? isCommentTap;

  final String? feedBackId, screenName;

  const FeedBackDetailsScreen({
    Key? key,
    this.isCommentTap,
    this.feedBackId,
    this.screenName = '',
  }) : super(key: key);

  @override
  State<FeedBackDetailsScreen> createState() => _NewFeedBackScreenState();
}

class _NewFeedBackScreenState extends State<FeedBackDetailsScreen>
    with SingleTickerProviderStateMixin {
  FeedBackViewModel feedBackViewModel = Get.find<FeedBackViewModel>();
  FeedBackLikeUnLikeReqModel feedBackLikeUnLikeReqModel =
      FeedBackLikeUnLikeReqModel();
  late ScrollController feedBackListController;
  int? likeCount = 0, unLikeCount = 0;

  String? senderId, feedBackId, score, shareLink, name, userName, avatar;

  bool myComment = false, isFirstLoad = false;
  GetFeedBackDetailsResModel responseDetails = GetFeedBackDetailsResModel();
  FocusNode inputNode = FocusNode();

  void _loadMore() async {
    if (feedBackListController.position.maxScrollExtent ==
            feedBackListController.offset &&
        !feedBackViewModel.commentIsLoading) {
      feedBackViewModel.getCommentViewModel(
        userId: feedBackId!,
      );
    }
  }

  @override
  void dispose() {
    feedBackListController.removeListener(_loadMore);
    feedBackListController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    apiCalling();
    super.initState();
  }

  final controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.screenName == 'AppNotification') {
          Get.offAll(const HomeScreen());
        } else {
          Navigator.pop(context);
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              CustomHeaderWidget(
                headerTitle: VariableUtils.feedback,
                screenName: widget.screenName,
              ),
              GetBuilder<FeedBackViewModel>(
                builder: (feedBackController) {
                  if (feedBackController
                          .userFeedBackDetailsApiResponse.status ==
                      Status.LOADING) {
                    return const Expanded(
                      child: CircularIndicator(),
                    );
                  }
                  if (feedBackController
                          .userFeedBackDetailsApiResponse.status ==
                      Status.ERROR) {
                    return const Center(child: Text("Server error"));
                  }
                  responseDetails =
                      feedBackController.userFeedBackDetailsApiResponse.data;
                  if (responseDetails.status != 200) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: Text(responseDetails.message!)),
                        ],
                      ),
                    );
                  }
                  avatar = responseDetails.data!.user!.avatar;
                  score = responseDetails.data!.score;
                  var senderFlagUrl = responseDetails.data!.sender!.flagUrl;
                  var senderProfile = responseDetails.data!.sender!.profileType;
                  var userFlagUrl = responseDetails.data!.user!.flagUrl;
                  final userProfileType =
                      responseDetails.data!.user!.profileType;

                  if (isFirstLoad == false) {
                    name = ((responseDetails.data!.sender!.id ==
                                PreferenceManagerUtils.getLoginId()) &&
                            responseDetails.data!.anonymous == false)
                        ? VariableUtils.you
                        : responseDetails.data!.anonymous == true
                            ? VariableUtils.anonymous
                            : responseDetails.data!.sender!.userIdentity ?? '';
                    userName = responseDetails.data!.user!.id ==
                            PreferenceManagerUtils.getLoginId()
                        ? VariableUtils.you
                        : responseDetails.data!.user!.userIdentity ?? '';
                    likeCount = responseDetails.data!.metaData!.likeCount;
                    unLikeCount = responseDetails.data!.metaData!.unlikeCount;
                    feedBackController.initPostCommentCount =
                        responseDetails.data!.metaData!.commentCount!;
                    shareLink = responseDetails.data!.shareLink ?? '';
                    senderId = responseDetails.data!.sender!.id;
                    if (responseDetails.data!.mylikeid!.isNotEmpty) {
                      feedBackViewModel.initInteractionId =
                          responseDetails.data!.mylikeid!;
                    } else if (responseDetails.data!.myunlikeid!.isNotEmpty) {
                      feedBackViewModel.initInteractionId =
                          responseDetails.data!.myunlikeid!;
                    } else {
                      feedBackViewModel.initInteractionId = '';
                    }
                    if (widget.isCommentTap != true) {
                      myComment = responseDetails.data!.mycomment!;
                    } else {
                      myComment = true;
                    }
                    isFirstLoad = true;
                  }
                  return responseDetails.data!.isUnlocked == false
                      ? Dialog(
                          backgroundColor: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 3.5.w),
                                child: const Text(
                                  VariableUtils.thisFeedBackIsLocked,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizeConfig.sH1,
                              Material(
                                color: ColorUtils.primaryColor,
                                borderRadius: BorderRadius.circular(5),
                                child: InkWell(
                                  splashColor: ColorUtils.grey,
                                  onTap: () async {
                                    await feedBackViewModel
                                        .paymentCoinViewModel(
                                            feedBackId:
                                                responseDetails.data!.id);
                                    if (feedBackViewModel
                                            .paymentCoinApiResponse.status ==
                                        Status.COMPLETE) {
                                      PaymentCoinResModel response =
                                          feedBackViewModel
                                              .paymentCoinApiResponse.data;
                                      if (response.status == 200) {
                                        if (response.data!.open == false) {
                                          showSnackBar(
                                              message: response.data!.showText!,
                                              showDuration:
                                                  const Duration(seconds: 3));
                                        } else if (response.data!.open ==
                                            true) {
                                          dialogShow(response);
                                          return;
                                        }
                                      }
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                      decoration: DecorationUtils
                                          .allBorderAndColorDecorationBox(
                                        colors: ColorUtils.blue14,
                                        radius: 5,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      child: Text(
                                        VariableUtils.unlock,
                                        style: FontTextStyle.poppinsWhite10bold,
                                      )),
                                ),
                              ),
                              SizeConfig.sH2,
                            ],
                          ))
                      : Expanded(
                          child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: SingleChildScrollView(
                            controller: feedBackListController,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizeConfig.sH1,
                                Screenshot(
                                  controller: controller,
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                senderFlagUrl == '' ||
                                                        senderFlagUrl == null
                                                    ? Image.asset(
                                                        "${baseImgPath}world.png",
                                                        scale: 9.w,
                                                      )
                                                    : SvgPicture.network(
                                                        senderFlagUrl,
                                                        height: 5.w,
                                                        width: 5.w,
                                                        fit: BoxFit.fill,
                                                      ),
                                                SizeConfig.sW1,
                                                InkWell(
                                                  onTap: () {
                                                    if (responseDetails
                                                            .data!
                                                            .senderReceiverBlockStatus!
                                                            .hideUserSender ==
                                                        true) {
                                                      showSnackBar(
                                                          message: responseDetails
                                                              .data!
                                                              .senderReceiverBlockStatus!
                                                              .hideUserMessageSender);
                                                      return;
                                                    }
                                                    if (responseDetails
                                                            .data!.anonymous ==
                                                        true) {
                                                      return;
                                                    }
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                UserInsidePage(
                                                                  screenName:
                                                                      'FeedBackDetailsScreen',
                                                                  userName:
                                                                      name,
                                                                  avatar: responseDetails
                                                                      .data!
                                                                      .sender!
                                                                      .avatar,
                                                                  toId: responseDetails
                                                                      .data!
                                                                      .sender!
                                                                      .id,
                                                                  phone: responseDetails
                                                                      .data!
                                                                      .sender!
                                                                      .phone,
                                                                  favorite: responseDetails
                                                                              .data!
                                                                              .defaultStatus ==
                                                                          null
                                                                      ? false
                                                                      : responseDetails
                                                                          .data!
                                                                          .defaultStatus!
                                                                          .sender!
                                                                          .favorite,
                                                                  isBlock: responseDetails
                                                                              .data!
                                                                              .defaultStatus ==
                                                                          null
                                                                      ? false
                                                                      : responseDetails
                                                                          .data!
                                                                          .defaultStatus!
                                                                          .sender!
                                                                          .block,
                                                                  flag: responseDetails
                                                                              .data!
                                                                              .defaultStatus ==
                                                                          null
                                                                      ? false
                                                                      : responseDetails
                                                                          .data!
                                                                          .defaultStatus!
                                                                          .sender!
                                                                          .flag,
                                                                  online: responseDetails
                                                                      .data!
                                                                      .sender!
                                                                      .online,
                                                                  active: responseDetails
                                                                      .data!
                                                                      .sender!
                                                                      .active,
                                                                )));
                                                  },
                                                  child: Text(
                                                    "$name",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ),
                                                SizeConfig.sW1,
                                                profileIconSetWidget(
                                                    profileType:
                                                        senderProfile!),

                                                /// ========>>>>>>>>>
                                                const Icon(
                                                  Icons.arrow_right,
                                                  color: Colors.grey,
                                                ),
                                                userFlagUrl == '' ||
                                                        userFlagUrl == null
                                                    ? Image.asset(
                                                        "${baseImgPath}world.png",
                                                        scale: 9.w,
                                                      )
                                                    : SvgPicture.network(
                                                        userFlagUrl,
                                                        height: 5.w,
                                                        width: 5.w,
                                                        fit: BoxFit.fill,
                                                      ),
                                                SizeConfig.sW1,
                                                InkWell(
                                                  onTap: () {
                                                    if (responseDetails
                                                            .data!
                                                            .senderReceiverBlockStatus!
                                                            .hideUserReceiver ==
                                                        true) {
                                                      showSnackBar(
                                                          message: responseDetails
                                                              .data!
                                                              .senderReceiverBlockStatus!
                                                              .hideUserMessageReceiver);
                                                      return;
                                                    }
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                UserInsidePage(
                                                                  screenName:
                                                                      'FeedBackDetailsScreen',
                                                                  userName:
                                                                      userName,
                                                                  avatar:
                                                                      responseDetails
                                                                          .data!
                                                                          .user!
                                                                          .avatar,
                                                                  toId:
                                                                      responseDetails
                                                                          .data!
                                                                          .user!
                                                                          .id,
                                                                  phone:
                                                                      responseDetails
                                                                          .data!
                                                                          .user!
                                                                          .phone,
                                                                  favorite: responseDetails
                                                                              .data!
                                                                              .defaultStatus ==
                                                                          null
                                                                      ? false
                                                                      : responseDetails
                                                                          .data!
                                                                          .defaultStatus!
                                                                          .receiver!
                                                                          .favorite,
                                                                  isBlock: responseDetails
                                                                              .data!
                                                                              .defaultStatus ==
                                                                          null
                                                                      ? false
                                                                      : responseDetails
                                                                          .data!
                                                                          .defaultStatus!
                                                                          .receiver!
                                                                          .block,
                                                                  flag: responseDetails
                                                                              .data!
                                                                              .defaultStatus ==
                                                                          null
                                                                      ? false
                                                                      : responseDetails
                                                                          .data!
                                                                          .defaultStatus!
                                                                          .receiver!
                                                                          .flag,
                                                                  online:
                                                                      responseDetails
                                                                          .data!
                                                                          .user!
                                                                          .online,
                                                                  active:
                                                                      responseDetails
                                                                          .data!
                                                                          .user!
                                                                          .active,
                                                                )));
                                                  },
                                                  child: userName
                                                              .toString()
                                                              .length >=
                                                          22
                                                      ? Text(
                                                          userName
                                                              .toString()
                                                              .substring(0, 20),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 10.sp,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )
                                                      : Text(
                                                          userName!,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 10.sp,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                ),
                                                SizeConfig.sW1,
                                                profileIconSetWidget(
                                                    profileType:
                                                        userProfileType!),
                                              ],
                                            ),
                                          ),
                                          responseDetails.data!.disputeStatus ==
                                                      false &&
                                                  responseDetails
                                                          .data!.status ==
                                                      VariableUtils.rejectStatus
                                              ? InkWell(
                                                  onTap: () {
                                                    Get.to(() => DisputeScreen(
                                                        feedBackId:
                                                            responseDetails
                                                                .data!.id!));
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Dispute',
                                                        style: FontTextStyle
                                                            .poppins12regular
                                                            .copyWith(
                                                                fontSize: 10.sp,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                color:
                                                                    ColorUtils
                                                                        .red),
                                                      ),
                                                      SizeConfig.sW1,
                                                      Image.asset(
                                                        'assets/icon/dispute.png',
                                                        scale: 1.w,
                                                      )
                                                    ],
                                                  ))
                                              : const SizedBox(),
                                          senderId ==
                                                  PreferenceManagerUtils
                                                      .getLoginId()
                                              ? const SizedBox()
                                              : Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            150),
                                                    onTap: () async {
                                                      await Get.bottomSheet(
                                                        FlagBottomSheet(
                                                            sId: responseDetails
                                                                .data!.id),
                                                        isScrollControlled:
                                                            true,
                                                      );
                                                      apiCalling();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SvgPicture.asset(
                                                        "${basePath}flag.svg",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                      SizeConfig.sH1,
                                      Row(
                                        children: [
                                          Text(
                                            '${responseDetails.data!.reviewType.toString().capitalizeFirst}',
                                            style: FontTextStyle
                                                .poppinsBlue14Sp9Medium,
                                          ),
                                          SizeConfig.sW2,
                                          Container(
                                            decoration: DecorationUtils
                                                .shadowAndColorDecorationBox(),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.w, vertical: 1.w),
                                            child: Text(
                                              responseDetails.data!.relation!
                                                  .toString()
                                                  .capitalizeFirst!,
                                              style: FontTextStyle
                                                  .poppinsOrangeF87ASemiB
                                                  .copyWith(
                                                      color: ColorUtils.blueCD),
                                            ),
                                          ),
                                          SizeConfig.sW2,
                                          FeedBackScoreEmoji(
                                            score: score!,
                                          ),
                                        ],
                                      ),
                                      SizeConfig.sH1,
                                      Text(
                                        "${responseDetails.data!.text}",
                                        style: FontTextStyle
                                            .poppinsBlackLightRegular,
                                      ),
                                      SizeConfig.sH1,
                                      responseDetails.data!.document == null ||
                                              responseDetails
                                                  .data!.document!.isEmpty ||
                                              responseDetails.data!.document!
                                                      .first.url ==
                                                  null
                                          ? const SizedBox()
                                          : ImageFiltered(
                                              imageFilter: ImageFilter.blur(
                                                sigmaX: 0,
                                                sigmaY: 0,
                                                tileMode: TileMode.decal,
                                              ),
                                              child: VariableUtils
                                                      .imageFormatList
                                                      .contains(responseDetails
                                                          .data!
                                                          .document!
                                                          .first
                                                          .ext!
                                                          .toUpperCase())
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.w),
                                                      child: OctoImage(
                                                        image:
                                                            CachedNetworkImageProvider(
                                                          responseDetails
                                                              .data!
                                                              .document!
                                                              .first
                                                              .url!,
                                                        ),
                                                        placeholderBuilder:
                                                            OctoPlaceholder
                                                                .blurHash(
                                                          'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                        ),
                                                        height: 80.w,
                                                        width: double.infinity,
                                                        errorBuilder:
                                                            OctoError.icon(
                                                                color:
                                                                    Colors.red),
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    )
                                                  : VariableUtils
                                                          .videoFormatList
                                                          .contains(
                                                              responseDetails
                                                                  .data!
                                                                  .document!
                                                                  .first
                                                                  .ext
                                                                  .toString()
                                                                  .toUpperCase())
                                                      ? VideoPlayerService(
                                                          // key: UniqueKey(),
                                                          url: responseDetails
                                                              .data!
                                                              .document!
                                                              .first
                                                              .url!,
                                                        )
                                                      : VariableUtils
                                                              .documentFormatList
                                                              .contains(
                                                                  responseDetails
                                                                      .data!
                                                                      .document!
                                                                      .first
                                                                      .ext
                                                                      .toString()
                                                                      .toUpperCase())
                                                          ? InkWell(
                                                              onTap: () {
                                                                firebaseDownloadFile(
                                                                        responseDetails
                                                                            .data!
                                                                            .document!
                                                                            .first
                                                                            .url!,
                                                                        DateTime.now()
                                                                            .microsecondsSinceEpoch)
                                                                    .then(
                                                                        (value) async {
                                                                  await Future
                                                                      .delayed(
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                                  );
                                                                  Get.back();
                                                                });
                                                              },
                                                              child: Container(
                                                                width:
                                                                    Get.width,
                                                                height: 15.w,
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  color: ColorUtils
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.2),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        SizedBox(
                                                                            height:
                                                                                6.w,
                                                                            width: 6.w,
                                                                            child: const Icon(Icons.assignment_outlined)),
                                                                        SizedBox(
                                                                          width:
                                                                              1.w,
                                                                        ),
                                                                        const Text(
                                                                            'Click to download file'),
                                                                      ],
                                                                    ),
                                                                    const Icon(Icons
                                                                        .download),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                            ),
                                      responseDetails.data!.status ==
                                              VariableUtils.rejectStatus
                                          ? Row(
                                              children: [
                                                Image.asset(
                                                  "${basePath}redAlert.png",
                                                  scale: 1.w,
                                                  color: ColorUtils.red,
                                                ),
                                                SizeConfig.sW1,
                                                Text(
                                                  responseDetails
                                                      .data!.feedText!,
                                                  style: FontTextStyle
                                                      .poppins12regular
                                                      .copyWith(
                                                          fontSize: 11.sp,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              ColorUtils.red),
                                                )
                                              ],
                                            )
                                          : const SizedBox(),
                                      responseDetails.data!.flagReason == null
                                          ? const SizedBox()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizeConfig.sH2,
                                                Text(
                                                  "Flag Reason",
                                                  style: TextStyle(
                                                      color: ColorUtils.black,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizeConfig.sH05,
                                                Text(
                                                  responseDetails
                                                          .data!.flagReason ??
                                                      '',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12.sp),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                                SizeConfig.sH1,
                                divider(),
                                SizeConfig.sH1,

                                ///INTERACTION......
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkResponse(
                                      radius: 20,
                                      onTap: () async {
                                        responseDetails.data!.mylike =
                                            !responseDetails.data!.mylike!;
                                        if (responseDetails.data!.mylike ==
                                            true) {
                                          likeCount = likeCount! + 1;
                                          if (responseDetails.data!.myunlike ==
                                              true) {
                                            unLikeCount = unLikeCount == 0
                                                ? unLikeCount
                                                : unLikeCount! - 1;
                                            responseDetails.data!.myunlike =
                                                !responseDetails
                                                    .data!.myunlike!;

                                            await feedBackController
                                                .interactionDeleteViewModel(
                                                    interactionId:
                                                        feedBackController
                                                            .interactionId);
                                          }

                                          feedBackLikeUnLikeReqModel.ftype =
                                              "like";
                                          feedBackLikeUnLikeReqModel.user =
                                              PreferenceManagerUtils
                                                  .getLoginId();
                                          feedBackLikeUnLikeReqModel.feedback =
                                              feedBackId;

                                          await feedBackController
                                              .feedBackLDCViewModel(
                                                  feedBackLikeUnLikeReqModel
                                                      .toJson());
                                        } else {
                                          if (responseDetails.data!.mylike ==
                                              false) {
                                            likeCount = likeCount == 0
                                                ? likeCount!
                                                : likeCount! - 1;
                                            if (responseDetails
                                                    .data!.myunlike ==
                                                true) {
                                              unLikeCount = unLikeCount == 0
                                                  ? unLikeCount
                                                  : unLikeCount! - 1;
                                              responseDetails.data!.myunlike =
                                                  !responseDetails
                                                      .data!.myunlike!;
                                            }
                                            if (feedBackViewModel
                                                .interactionId.isEmpty) {
                                              showSnackBar(
                                                  message:
                                                      'Something went wrong');
                                              responseDetails.data!.mylike =
                                                  !responseDetails
                                                      .data!.mylike!;
                                              return;
                                            }

                                            await feedBackController
                                                .interactionDeleteViewModel(
                                                    interactionId:
                                                        feedBackController
                                                            .interactionId);
                                          }
                                        }
                                      },
                                      child: commonIconAndText(
                                        title: likeCount.toString(),
                                        icon: SvgPicture.asset(
                                          responseDetails.data!.mylike == true
                                              ? IconsWidgets.likeSvg
                                              : IconsWidgets.grayLikeSvg,
                                          height: 5.w,
                                          width: 5.w,
                                        ),
                                      ),
                                    ),
                                    InkResponse(
                                      radius: 20,
                                      onTap: () async {
                                        responseDetails.data!.myunlike =
                                            !responseDetails.data!.myunlike!;

                                        if (responseDetails.data!.myunlike ==
                                            true) {
                                          unLikeCount = unLikeCount! + 1;
                                          if (responseDetails.data!.mylike ==
                                              true) {
                                            await feedBackController
                                                .interactionDeleteViewModel(
                                                    interactionId:
                                                        feedBackController
                                                            .interactionId);
                                            likeCount = likeCount == 0
                                                ? likeCount
                                                : likeCount! - 1;
                                            responseDetails.data!.mylike =
                                                !responseDetails.data!.mylike!;
                                          }
                                          feedBackLikeUnLikeReqModel.user =
                                              PreferenceManagerUtils
                                                  .getLoginId();
                                          feedBackLikeUnLikeReqModel.feedback =
                                              feedBackId;
                                          feedBackLikeUnLikeReqModel.ftype =
                                              "unlike";

                                          await feedBackController
                                              .feedBackLDCViewModel(
                                                  feedBackLikeUnLikeReqModel
                                                      .toJson());
                                        } else {
                                          if (responseDetails.data!.myunlike ==
                                              false) {
                                            unLikeCount = unLikeCount == 0
                                                ? unLikeCount!
                                                : unLikeCount! - 1;
                                            if (responseDetails.data!.mylike ==
                                                true) {
                                              likeCount = likeCount == 0
                                                  ? likeCount!
                                                  : likeCount! - 1;
                                              responseDetails.data!.mylike =
                                                  !responseDetails
                                                      .data!.mylike!;
                                            }
                                          }
                                          if (feedBackViewModel
                                              .interactionId.isEmpty) {
                                            showSnackBar(
                                                message:
                                                    'Something went wrong');
                                            responseDetails.data!.myunlike =
                                                !responseDetails
                                                    .data!.myunlike!;
                                            return;
                                          }
                                          await feedBackController
                                              .interactionDeleteViewModel(
                                                  interactionId:
                                                      feedBackController
                                                          .interactionId);
                                        }
                                      },
                                      child: commonIconAndText(
                                        title: unLikeCount.toString(),
                                        icon: SvgPicture.asset(
                                          responseDetails.data!.myunlike == true
                                              ? IconsWidgets.disLikeSvg
                                              : IconsWidgets.grayDisLikeSvg,
                                          height: 5.w,
                                          width: 5.w,
                                        ),
                                      ),
                                    ),
                                    InkResponse(
                                      radius: 20,
                                      onTap: () {
                                        // FocusScope.of(context)
                                        //     .requestFocus(inputNode);
                                        setState(() {
                                          if (myComment == false) {
                                            myComment = true;
                                          } else {
                                            myComment = false;
                                          }
                                        });
                                      },
                                      child: commonIconAndText(
                                        title:
                                            "${feedBackController.postCommentCount}",
                                        icon: SvgPicture.asset(
                                          myComment == true
                                              ? IconsWidgets.commentSvg
                                              : IconsWidgets.grayCommentSvg,
                                          height: 5.w,
                                          width: 5.w,
                                        ),
                                      ),
                                    ),
                                    // DeepLinkSendWidget(
                                    //   feedBackId: feedBackId,
                                    //   isScreenFrom: 'DetailsScreen',
                                    //   shareLink: shareLink,
                                    // ),
                                    InkResponse(
                                      radius: 40,
                                      child: IconsWidgets.shareGrey,
                                      onTap: () async {
                                        final image =
                                            await controller.capture();
                                        if (image == null) return;

                                        saveAndShare(image);
                                      },
                                    ),
                                  ],
                                ),
                                myComment == true
                                    ? SizeConfig.sH3
                                    : const SizedBox(),

                                myComment == true
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: 13.w,
                                              width: 80.w,
                                              child: TextField(
                                                focusNode: inputNode,
                                                autofocus: true,
                                                scrollPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 2.w),
                                                controller: feedBackViewModel
                                                    .commentController,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 3.w),
                                                  focusedBorder: DecorationUtils
                                                      .outLineBorderR20,
                                                  border: DecorationUtils
                                                      .outLineBorderR20,
                                                  enabledBorder: DecorationUtils
                                                      .outLineBorderR20,
                                                  disabledBorder:
                                                      DecorationUtils
                                                          .outLineBorderR20,
                                                  hintText:
                                                      'Write your Comment..',
                                                  hintStyle: FontTextStyle
                                                      .poppins12RegularGray,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizeConfig.sW2,
                                          InkWell(
                                            onTap: () async {
                                              if (feedBackViewModel
                                                  .commentController
                                                  .text
                                                  .isEmpty) {
                                                showSnackBar(
                                                    message:
                                                        "Enter your comment....");
                                                return;
                                              }
                                              FocusScope.of(context).unfocus();
                                              feedBackLikeUnLikeReqModel.user =
                                                  PreferenceManagerUtils
                                                      .getLoginId();
                                              feedBackLikeUnLikeReqModel.ftype =
                                                  "comment";
                                              feedBackLikeUnLikeReqModel
                                                  .feedback = feedBackId;
                                              feedBackLikeUnLikeReqModel.text =
                                                  feedBackViewModel
                                                      .commentController.text;

                                              await feedBackController
                                                  .feedBackLDCViewModel(
                                                      feedBackLikeUnLikeReqModel
                                                          .toJsonComment());
                                              if (feedBackController
                                                      .feedBackLikeApiResponse
                                                      .status ==
                                                  Status.COMPLETE) {
                                                feedBackController
                                                    .postCommentCount += 1;
                                                FeedBackLikeUnLikeResModel
                                                    response =
                                                    feedBackController
                                                        .feedBackLikeApiResponse
                                                        .data;

                                                openDialog(
                                                    animation:
                                                        successfulPaperPlaneAnimation,
                                                    title: VariableUtils
                                                        .commentSent,
                                                    message:
                                                        '${response.data!.transaction!.message ?? ''} ');
                                                Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                  Get.back();
                                                });

                                                feedBackViewModel.myCommentList
                                                    .insert(
                                                  0,
                                                  GetCommentResults(
                                                    text: feedBackViewModel
                                                        .commentController.text,
                                                    status: "pending",
                                                    id: response.data!.sId,
                                                    createdAt: response
                                                        .data!.createdAt,
                                                    updatedAt: response
                                                        .data!.updatedAt,
                                                    feedback: CommentFeedback(
                                                        id: response
                                                            .data!.feedback,
                                                        text: "",
                                                        score: "",
                                                        relation: "",
                                                        reviewType: "",
                                                        sender: "",
                                                        shared: ""),
                                                    ftype: "",
                                                    user: CommentUser(
                                                        posted: 0,
                                                        avatar: PreferenceManagerUtils
                                                            .getUserAvatar(),
                                                        online: false,
                                                        id: PreferenceManagerUtils
                                                            .getLoginId(),
                                                        anonymous: false,
                                                        currentlogin: "",
                                                        fcm: "",
                                                        flagUrl:
                                                            PreferenceManagerUtils
                                                                .getFlagUrl(),
                                                        countryName:
                                                            PreferenceManagerUtils
                                                                .getCountryName(),
                                                        lastlogin: "",
                                                        location:
                                                            CommentLocation(),
                                                        locationName:
                                                            CommentLocationName(),
                                                        phone: '',
                                                        received: 1,
                                                        referral: "",
                                                        role: "",
                                                        fullName: '',
                                                        userIdentity:
                                                            PreferenceManagerUtils
                                                                .getAvatarUserFullName()),
                                                  ),
                                                );
                                              }
                                              feedBackViewModel
                                                  .commentController
                                                  .clear();
                                              responseDetails.data!.mycomment =
                                                  false;
                                            },
                                            child: CircleAvatar(
                                              radius: 6.w,
                                              backgroundColor:
                                                  ColorUtils.blue14,
                                              child: Center(
                                                child: IconsWidgets.send,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                SizeConfig.sH2,
                                Text(
                                  VariableUtils.comments,
                                  style: TextStyle(
                                      color: ColorUtils.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizeConfig.sH1,

                                GetBuilder<FeedBackViewModel>(
                                    builder: (feedBackController) {
                                  if (feedBackController.commentInitLoading) {
                                    return const Center(
                                        child: CircularIndicator(
                                      isExpand: false,
                                    ));
                                  }

                                  if (feedBackController
                                      .myCommentList.isEmpty) {
                                    return Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ImagesWidgets.pngEmptyComments,
                                          Text(
                                            "Be the first to comment",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff121212)
                                                    .withOpacity(0.60),
                                                fontSize: 12.sp),
                                          ),
                                          SizedBox(
                                            height: 4.w,
                                          ),
                                          myComment == true
                                              ? const SizedBox()
                                              : InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (myComment == false) {
                                                        myComment = true;
                                                      } else {
                                                        myComment = false;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 8.w,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 30.w),
                                                    decoration: DecorationUtils
                                                        .allBorderAndColorDecorationBox(
                                                      radius: 5,
                                                    ).copyWith(
                                                        border: Border.all(
                                                      color: ColorUtils.blue14,
                                                    )),
                                                    child: Center(
                                                      child: Text(
                                                        VariableUtils.comment,
                                                        style: FontTextStyle
                                                            .poppinsBlue14bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    );
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // divider(),
                                      SizeConfig.sH1,
                                      Column(
                                        children: List.generate(
                                            feedBackController
                                                .myCommentList.length, (index) {
                                          GetCommentResults data =
                                              feedBackController
                                                  .myCommentList[index];

                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.w),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                OctoImageWidget(
                                                  profileLink:
                                                      data.user!.avatar ?? '',
                                                  radius: 5.w,
                                                ),
                                                SizeConfig.sW3,
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: Get.width,
                                                        decoration: BoxDecoration(
                                                            color: ColorUtils
                                                                .lightGreyE9,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      3.w),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizeConfig.sH1,
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  data.user!.flagUrl ==
                                                                              '' ||
                                                                          data.user!.flagUrl ==
                                                                              null
                                                                      ? Image
                                                                          .asset(
                                                                          "${baseImgPath}world.png",
                                                                          scale:
                                                                              9.w,
                                                                        )
                                                                      : SvgPicture
                                                                          .network(
                                                                          data.user!
                                                                              .flagUrl!,
                                                                          height:
                                                                              5.w,
                                                                          width:
                                                                              5.w,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                  SizeConfig
                                                                      .sW1,
                                                                  Expanded(
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        if (feedBackController.myCommentList[index].blockStatus!.hideUser ==
                                                                            true) {
                                                                          showSnackBar(
                                                                              message: feedBackController.myCommentList[index].blockStatus!.hideUserMessage);
                                                                          return;
                                                                        }

                                                                        await Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                                            builder: (context) => UserInsidePage(
                                                                                  screenName: 'FeedBackDetailsScreen',
                                                                                  userName: feedBackController.myCommentList[index].user!.id == PreferenceManagerUtils.getLoginId() ? VariableUtils.you : feedBackController.myCommentList[index].user!.userIdentity,
                                                                                  avatar: feedBackController.myCommentList[index].user!.avatar,
                                                                                  toId: feedBackController.myCommentList[index].user!.id,
                                                                                  phone: feedBackController.myCommentList[index].user!.phone,
                                                                                  favorite: feedBackController.myCommentList[index].user!.id == PreferenceManagerUtils.getLoginId()
                                                                                      ? false
                                                                                      : feedBackController.myCommentList[index].defaultStatus == null
                                                                                          ? false
                                                                                          : feedBackController.myCommentList[index].defaultStatus!.favorite,
                                                                                  isBlock: feedBackController.myCommentList[index].user!.id == PreferenceManagerUtils.getLoginId()
                                                                                      ? false
                                                                                      : feedBackController.myCommentList[index].defaultStatus == null
                                                                                          ? false
                                                                                          : feedBackController.myCommentList[index].defaultStatus!.block,
                                                                                  flag: feedBackController.myCommentList[index].user!.id == PreferenceManagerUtils.getLoginId()
                                                                                      ? false
                                                                                      : feedBackController.myCommentList[index].defaultStatus == null
                                                                                          ? false
                                                                                          : feedBackController.myCommentList[index].defaultStatus!.flag,
                                                                                  online: feedBackController.myCommentList[index].user!.online,
                                                                                  active: feedBackController.myCommentList[index].user!.active,
                                                                                )));
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        feedBackController.myCommentList[index].user!.id ==
                                                                                PreferenceManagerUtils.getLoginId()
                                                                            ? VariableUtils.you
                                                                            : "${data.user!.userIdentity}",
                                                                        style: FontTextStyle
                                                                            .poppins11SemiB,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  data.user!.id ==
                                                                          PreferenceManagerUtils
                                                                              .getLoginId()
                                                                      ? const SizedBox()
                                                                      : SizedBox(
                                                                          height:
                                                                              10.w,
                                                                          width:
                                                                              10.w,
                                                                          child:
                                                                              PopupMenuButton(
                                                                            tooltip:
                                                                                '',
                                                                            shape:
                                                                                const RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10.0),
                                                                              ),
                                                                            ),
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.more_vert_rounded,
                                                                              color: Colors.black,
                                                                            ),
                                                                            onSelected:
                                                                                (val) async {
                                                                              if (val == 0) {
                                                                                GetCommentResults data = feedBackController.myCommentList[index];
                                                                                Get.bottomSheet(
                                                                                  CommentFlagBottomSheet(
                                                                                    sId: data.feedback!.id,
                                                                                    commentId: data.id,
                                                                                  ),
                                                                                  isScrollControlled: true,
                                                                                );
                                                                              }
                                                                            },
                                                                            itemBuilder: (context) =>
                                                                                [
                                                                              PopupMenuItem(
                                                                                value: 0,
                                                                                child: Row(
                                                                                  children: [
                                                                                    SvgPicture.asset(
                                                                                      "${basePath}flag.svg",
                                                                                      color: ColorUtils.lightGrey83,
                                                                                    ),
                                                                                    SizeConfig.sW1,
                                                                                    Text(
                                                                                      VariableUtils.reportComment,
                                                                                      style: FontTextStyle.poppinsBlackRegular,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      earthImg,
                                                                      height:
                                                                          5.w,
                                                                      width:
                                                                          5.w,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ),
                                                                  SizeConfig
                                                                      .sW1,
                                                                  textBox(
                                                                      text: data
                                                                              .user!
                                                                              .countryName ??
                                                                          VariableUtils
                                                                              .global,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: ColorUtils
                                                                          .blacklight,
                                                                      fontSize:
                                                                          10.sp),
                                                                  textBox(
                                                                      text:
                                                                          " .${data.createdAt}",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: ColorUtils
                                                                          .blacklight,
                                                                      fontSize:
                                                                          10.sp),
                                                                ],
                                                              ),
                                                              SizeConfig.sH1,
                                                              Text(
                                                                "${data.text}",
                                                                style: FontTextStyle
                                                                    .poppinsBlackLightTextFieldRegular,
                                                              ),
                                                              SizeConfig.sH1,
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                      SizeConfig.sH1,
                                      if (feedBackController.commentIsLoading)
                                        const Center(
                                            child: CircularIndicator(
                                          isExpand: false,
                                        )),
                                      SizeConfig.sH1,
                                    ],
                                  );
                                })
                              ],
                            ),
                          ),
                        ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dialogShow(PaymentCoinResModel response) {
    if (response.data!.transaction == null) {
      return;
    }
    openDialog(
        animation: successfulPaperPlaneAnimation,
        title: VariableUtils.unlock,
        message: '${response.data!.transaction!.message}');
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
    });
    apiCalling();
  }

  Row commonIconAndText({Widget? icon, String? title}) {
    return Row(
      children: [
        icon!,
        SizeConfig.sW1,
        Text(
          title!,
          style: FontTextStyle.poppinsBlack12Sp9SemiB,
        ),
      ],
    );
  }

  Divider divider() {
    return const Divider(
      height: 2,
      color: ColorUtils.grayDE,
    );
  }

  void apiCalling() {
    feedBackId = widget.feedBackId;

    feedBackViewModel.commentClear();

    feedBackViewModel.getCommentViewModel(userId: feedBackId!, fromInit: true);

    feedBackListController = ScrollController();
    feedBackViewModel.userFeedBackDetailsViewModel(feedBackId!);

    feedBackListController.addListener(() {
      _loadMore();
    });
  }

  Future saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path],
        text: "Hey there! ${PreferenceManagerUtils.getAvatarUserName()}"
            " sent you a feedback... Check here."
            " $shareLink to visit his feedback.\nRegards,\nTeam QriteeQ");
  }
}
