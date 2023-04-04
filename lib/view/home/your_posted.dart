import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/commonWidget/common_profile_icon.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/service/download_file.dart';
import 'package:octo_image/octo_image.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../../common/circular_progress_indicator.dart';
import '../../common/commonWidget/feedback_score_emoji.dart';
import '../../common/deeplink_send_widget.dart';
import '../../modal/apiModel/res_model/like_unlike_res_model.dart';
import '../../modal/apiModel/res_model/you_posted_feedback_res_model.dart';
import '../../service/video_player.dart';
import '../../utils/assets/icons_utils.dart';
import '../../utils/assets/images_utils.dart';
import '../../utils/color_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/shared_preference_utils.dart';
import '../../utils/size_config_utils.dart';
import '../../utils/variable_utils.dart';
import '../../viewmodel/feedback_viewmodel.dart';
import '../detailsScreen/feed_back_details_screen.dart';
import '../generalScreen/no_searchfound_screen.dart';
import 'feed_inside_page/user_profile_inside_page.dart';

class YourPosted extends StatefulWidget {
  final String? feedBackUserId;
  final String? fromScreen;
  final bool? isExistsUser;
  final String? isScreenName;
  final String? queryKey;
  final String? queryValue;
  const YourPosted(
      {Key? key,
      this.feedBackUserId,
      this.fromScreen,
      this.isExistsUser,
      this.isScreenName,
      this.queryKey,
      this.queryValue})
      : super(key: key);

  @override
  State<YourPosted> createState() => _YourPostedState();
}

class _YourPostedState extends State<YourPosted> {
  late ScrollController feedBackListController;
  FeedBackViewModel feedBackViewModel = Get.find();

  void _firstLoad() async {
    feedBackViewModel.applicantPage = 1;
    feedBackViewModel.yoursFeedbackPostedResults.clear();
    feedBackViewModel.getMyPostedFeed(
        initLoad: false,
        userId: widget.feedBackUserId,
        fromScreen: widget.fromScreen,
        isExistsUser: widget.isExistsUser,
        queryKey: widget.queryKey,
        queryValue: widget.queryValue);
  }

  void _loadMore() async {
    if (feedBackViewModel.isFeedScrollLoading == false &&
        feedBackViewModel.isApplicantMoreLoading == false &&
        feedBackListController.position.extentAfter < 300) {
      try {
        feedBackViewModel.getMyPostedFeed(
            userId: widget.feedBackUserId,
            fromScreen: widget.fromScreen,
            isExistsUser: widget.isExistsUser,
            queryKey: widget.queryKey,
            queryValue: widget.queryValue);
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }
    }
  }

  @override
  void initState() {
    clearLocalList();
    feedBackViewModel.isFeedScrollLoading = true;
    if (feedBackViewModel.isFeedScrollLoading == true) {
      _firstLoad();
    }
    feedBackListController = ScrollController()..addListener(_loadMore);
    super.initState();
  }

  ///CLEAR LOCAL LIST....
  void clearLocalList() {
    feedBackViewModel.insideAllLikeMap.clear();
    feedBackViewModel.insideAllDisLikeMap.clear();
  }

  @override
  void dispose() {
    feedBackListController.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.offWhiteE5,
      body: GetBuilder<FeedBackViewModel>(builder: (feedBackController) {
        if (feedBackController.isFeedScrollLoading) {
          return const Center(child: CircularIndicator());
        }
        if (feedBackController.getMyPostedFeedBackApiResponse.status ==
                Status.ERROR ||
            feedBackController.yoursFeedbackPostedResults.isEmpty) {
          return NoFeedBackFound(
            titleMsg: VariableUtils.beFirstFeedback,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            apiCalling(feedBackController);
          },
          child: ListView.builder(
            key: const ValueKey('List'),
            controller: feedBackListController,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: feedBackController.yoursFeedbackPostedResults.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              YoursFeedbackPostedResults yoursFeedbackPostedResults =
                  feedBackController.yoursFeedbackPostedResults[index];
              var name = yoursFeedbackPostedResults.anonymous == true
                  ? VariableUtils.anonymous
                  : VariableUtils.you;

              var senderName = yoursFeedbackPostedResults.user == null
                  ? ''
                  : yoursFeedbackPostedResults.user!.userIdentity ?? '';
              var time = yoursFeedbackPostedResults.createdAt;
              var review = yoursFeedbackPostedResults.text;
              var score = yoursFeedbackPostedResults.score;
              var reviewStatus = yoursFeedbackPostedResults.status;
              final likeCount = yoursFeedbackPostedResults.like;
              final unLikeCount = yoursFeedbackPostedResults.unlike;
              var disputeStatus = yoursFeedbackPostedResults.disputeStatus;
              var country = yoursFeedbackPostedResults.user!.countryName ??
                  VariableUtils.global;
              var senderFlagUrl = yoursFeedbackPostedResults.user!.flagUrl;
              var senderProfileType =
                  yoursFeedbackPostedResults.user!.profileType;
              var userFlagUrl = yoursFeedbackPostedResults.sender!.flagUrl;
              var userProfileType =
                  yoursFeedbackPostedResults.sender!.profileType;

              return yoursFeedbackPostedResults.user == null ||
                      yoursFeedbackPostedResults.sender == null
                  ? const SizedBox()
                  : InkWell(
                      onTap: () async {
                        detailScreenCall(
                          feedBackController: feedBackController,
                          index: index,
                          disputeStatus: disputeStatus,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6.0, top: 4),
                        child: Material(
                          elevation: 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizeConfig.sH2,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    userFlagUrl == '' || userFlagUrl == null
                                        ? Image.asset(
                                            "${baseImgPath}world.webp",
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
                                      onTap: () async {
                                        if (yoursFeedbackPostedResults
                                                .anonymous ==
                                            true) {
                                          return;
                                        }
                                        if (widget.isScreenName ==
                                            "UserInsidePage") {
                                          await Navigator.of(context)
                                              .pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserInsidePage(
                                                            screenName: yoursFeedbackPostedResults
                                                                        .sender!
                                                                        .id ==
                                                                    PreferenceManagerUtils
                                                                        .getLoginId()
                                                                ? "YouInside"
                                                                : null,
                                                            userName:
                                                                yoursFeedbackPostedResults
                                                                    .sender!
                                                                    .userIdentity,
                                                            avatar:
                                                                yoursFeedbackPostedResults
                                                                    .sender!
                                                                    .avatar,
                                                            toId: PreferenceManagerUtils
                                                                .getLoginId(),
                                                            phone:
                                                                yoursFeedbackPostedResults
                                                                    .sender!
                                                                    .phone,
                                                            favorite: false,
                                                            isBlock: false,
                                                            flag: false,
                                                            online:
                                                                yoursFeedbackPostedResults
                                                                    .sender!
                                                                    .online,
                                                            active:
                                                                yoursFeedbackPostedResults
                                                                    .sender!
                                                                    .active,
                                                          )));
                                        } else {
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserInsidePage(
                                                        screenName:
                                                            'YourPosted',
                                                        userName:
                                                            yoursFeedbackPostedResults
                                                                .sender!
                                                                .userIdentity,
                                                        avatar:
                                                            yoursFeedbackPostedResults
                                                                .sender!.avatar,
                                                        toId:
                                                            PreferenceManagerUtils
                                                                .getLoginId(),
                                                        phone:
                                                            yoursFeedbackPostedResults
                                                                .sender!.phone,
                                                        favorite: false,
                                                        isBlock: false,
                                                        flag: false,
                                                        online:
                                                            yoursFeedbackPostedResults
                                                                .sender!.online,
                                                        active:
                                                            yoursFeedbackPostedResults
                                                                .sender!.active,
                                                      )));
                                        }
                                      },
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ),
                                    profileIconSetWidget(
                                        profileType: userProfileType!),
                                    SizeConfig.sW1,
                                    widget.fromScreen != 'YouInside' ||
                                            yoursFeedbackPostedResults
                                                    .user!.id ==
                                                PreferenceManagerUtils
                                                    .getLoginId()
                                        ? const SizedBox()
                                        : InkWell(
                                            onTap: () async {
                                              await Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              UserInsidePage(
                                                                userName:
                                                                    yoursFeedbackPostedResults
                                                                        .user!
                                                                        .userIdentity,
                                                                avatar:
                                                                    yoursFeedbackPostedResults
                                                                        .user!
                                                                        .avatar,
                                                                toId:
                                                                    yoursFeedbackPostedResults
                                                                        .user!
                                                                        .id,
                                                                phone:
                                                                    yoursFeedbackPostedResults
                                                                        .user!
                                                                        .phone,
                                                                favorite: yoursFeedbackPostedResults
                                                                            .defaultStatus ==
                                                                        null
                                                                    ? false
                                                                    : yoursFeedbackPostedResults
                                                                        .defaultStatus!
                                                                        .receiver!
                                                                        .favorite,
                                                                isBlock: yoursFeedbackPostedResults
                                                                            .defaultStatus ==
                                                                        null
                                                                    ? false
                                                                    : yoursFeedbackPostedResults
                                                                        .defaultStatus!
                                                                        .receiver!
                                                                        .block,
                                                                flag: yoursFeedbackPostedResults
                                                                            .defaultStatus ==
                                                                        null
                                                                    ? false
                                                                    : yoursFeedbackPostedResults
                                                                        .defaultStatus!
                                                                        .receiver!
                                                                        .flag,
                                                                online:
                                                                    yoursFeedbackPostedResults
                                                                        .user!
                                                                        .online,
                                                                active:
                                                                    yoursFeedbackPostedResults
                                                                        .user!
                                                                        .active,
                                                              )));
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconsWidgets.arrowIcon,
                                                SizeConfig.sW1,

                                                /// ==========SENDER=============
                                                senderFlagUrl == '' ||
                                                        senderFlagUrl == null
                                                    ? Image.asset(
                                                        "${baseImgPath}world.webp",
                                                        scale: 9.w,
                                                      )
                                                    : SvgPicture.network(
                                                        senderFlagUrl,
                                                        height: 5.w,
                                                        width: 5.w,
                                                        fit: BoxFit.fill,
                                                      ),
                                                SizeConfig.sW1,
                                                senderName.toString().length >=
                                                        22
                                                    ? Text(
                                                        senderName
                                                            .toString()
                                                            .substring(0, 20),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 10.sp,
                                                        ),
                                                      )
                                                    : Text(
                                                        senderName,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 10.sp,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                    widget.fromScreen != 'YouInside' ||
                                            yoursFeedbackPostedResults
                                                    .user!.id ==
                                                PreferenceManagerUtils
                                                    .getLoginId()
                                        ? const SizedBox()
                                        : profileIconSetWidget(
                                            profileType: senderProfileType!),
                                  ],
                                ),
                                SizeConfig.sH1,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: SvgPicture.asset(
                                        earthImg,
                                        height: 4.w,
                                        width: 4.w,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Text(
                                      "  $country",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: ColorUtils.blacklight,
                                          fontSize: 10.sp),
                                    ),
                                    Text(
                                      " . $time",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: ColorUtils.blacklight,
                                          fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: ReadMoreText(
                                    review!,
                                    trimLines: 2,
                                    colorClickableText: Colors.pink,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Show more',
                                    trimExpandedText: 'Show less',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: ColorUtils.black,
                                        height: 1.6,
                                        fontSize: 10.sp),
                                    lessStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ColorUtils.grey,
                                        height: 1.6,
                                        fontSize: 10.sp),
                                    moreStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ColorUtils.grey,
                                        height: 1.6,
                                        fontSize: 10.sp),
                                  ),
                                ),

                                SizeConfig.sH1,
                                yoursFeedbackPostedResults.document == null ||
                                        yoursFeedbackPostedResults
                                            .document!.isEmpty ||
                                        yoursFeedbackPostedResults
                                                .document!.first.url ==
                                            null
                                    ? const SizedBox()
                                    : ImageFiltered(
                                        imageFilter: ImageFilter.blur(
                                          sigmaX: index == 0 ? 0 : 0,
                                          sigmaY: index == 0 ? 0 : 0,
                                          tileMode: TileMode.decal,
                                        ),
                                        child: VariableUtils.imageFormatList
                                                .contains(
                                                    yoursFeedbackPostedResults
                                                        .document!.first.ext!
                                                        .toUpperCase())
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(2.w),
                                                child: OctoImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    yoursFeedbackPostedResults
                                                        .document!.first.url!,
                                                  ),
                                                  placeholderBuilder:
                                                      OctoPlaceholder.blurHash(
                                                    'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                  ),
                                                  height: 80.w,
                                                  width: double.infinity,
                                                  errorBuilder: OctoError.icon(
                                                      color: Colors.red),
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              )
                                            : VariableUtils.videoFormatList
                                                    .contains(
                                                        yoursFeedbackPostedResults
                                                            .document!.first.ext
                                                            .toString()
                                                            .toUpperCase())
                                                ? VideoPlayerService(
                                                    // key: UniqueKey(),
                                                    key: ValueKey(
                                                        yoursFeedbackPostedResults
                                                            .document!
                                                            .first
                                                            .url!),

                                                    url:
                                                        yoursFeedbackPostedResults
                                                            .document!
                                                            .first
                                                            .url!,
                                                  )
                                                : VariableUtils
                                                        .documentFormatList
                                                        .contains(
                                                            yoursFeedbackPostedResults
                                                                .document!
                                                                .first
                                                                .ext!
                                                                .toString()
                                                                .toUpperCase())
                                                    ? InkWell(
                                                        onTap: () {
                                                          firebaseDownloadFile(
                                                                  yoursFeedbackPostedResults
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
                                                                  seconds: 2),
                                                            );
                                                            Get.back();
                                                          });
                                                        },
                                                        child: Container(
                                                          width: Get.width,
                                                          height: 15.w,
                                                          alignment: Alignment
                                                              .centerRight,
                                                          padding:
                                                              const EdgeInsets
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
                                                                      width:
                                                                          6.w,
                                                                      child: const Icon(
                                                                          Icons
                                                                              .assignment_outlined)),
                                                                  SizedBox(
                                                                    width: 1.w,
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
                                SizeConfig.sH1,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FeedBackScoreEmoji(
                                      score: score!,
                                    ),
                                    yoursFeedbackPostedResults.status ==
                                            VariableUtils.rejectStatus
                                        ? Row(
                                            children: [
                                              Image.asset(
                                                "${basePath}redAlert.webp",
                                                scale: 1.w,
                                                color: ColorUtils.red,
                                              ),
                                              SizeConfig.sW1,
                                              Text(
                                                yoursFeedbackPostedResults
                                                        .feedText ??
                                                    '',
                                                style: FontTextStyle
                                                    .poppins12regular
                                                    .copyWith(
                                                        fontSize: 11.sp,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: ColorUtils.red),
                                              )
                                            ],
                                          )
                                        : const SizedBox()
                                  ],
                                ),

                                SizeConfig.sH1,
                                VariableUtils.feedBackStatusList
                                            .contains(reviewStatus) &&
                                        yoursFeedbackPostedResults.showText !=
                                            null
                                    ? Column(
                                        children: [
                                          SizeConfig.sH1,
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 1.h),
                                            child: Container(
                                              color: const Color(0xffE8E8E8),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3.w),
                                              height: 5.h,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    tickImg,
                                                    color:
                                                        ColorUtils.lightGrey83,
                                                    height: 5.w,
                                                    width: 5.w,
                                                  ),
                                                  SizedBox(width: 2.5.w),
                                                  Expanded(
                                                    child: Text(
                                                      yoursFeedbackPostedResults
                                                          .showText!,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: ColorUtils
                                                              .lightGrey83,
                                                          fontSize: 10.sp),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                SizeConfig.sH1,
                                Divider(
                                  height: 1.h,
                                  color: ColorUtils.black,
                                ),
                                SizeConfig.sH1,
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ///like
                                    InkResponse(
                                      radius: 40,
                                      onTap: () async {
                                        YoursFeedbackPostedResults
                                            yoursFeedbackPostedResults =
                                            feedBackController
                                                    .yoursFeedbackPostedResults[
                                                index];
                                        String? feedBackId =
                                            yoursFeedbackPostedResults.sId!;

                                        ///DATA FROM LOCAL WHEN IS LIKE IS TRUE

                                        if (feedBackController.insideAllLikeMap
                                                .containsKey(feedBackId) &&
                                            feedBackController
                                                    .insideAllLikeMap[
                                                        feedBackId]!
                                                    .interactionStatus ==
                                                true) {
                                          if (kDebugMode) {
                                            print("LIKE 1");
                                          }

                                          feedBackController.insideAllLikeMap
                                              .addAll({
                                            feedBackId: InteractionStatus(
                                                interactionStatus: false,
                                                count: feedBackController
                                                            .insideAllLikeMap[
                                                                feedBackId]!
                                                            .count! >
                                                        0
                                                    ? feedBackController
                                                            .insideAllLikeMap[
                                                                feedBackId]!
                                                            .count! -
                                                        1
                                                    : feedBackController
                                                        .insideAllLikeMap[
                                                            feedBackId]!
                                                        .count!,
                                                interactionId:
                                                    feedBackController
                                                        .insideAllLikeMap[
                                                            feedBackId]!
                                                        .interactionId)
                                          });
                                          await feedBackController
                                              .interactionDeleteViewModel(
                                                  interactionId:
                                                      feedBackController
                                                          .insideAllLikeMap[
                                                              feedBackId]!
                                                          .interactionId);

                                          return;
                                        }

                                        ///DATA FROM LOCAL WHEN IS LIKE IS FALSE

                                        else if (feedBackController
                                                .insideAllLikeMap
                                                .containsKey(feedBackId) &&
                                            feedBackController
                                                    .insideAllLikeMap[
                                                        feedBackId]!
                                                    .interactionStatus ==
                                                false) {
                                          if (kDebugMode) {
                                            print("LIKE 2");
                                          }

                                          ///unlike from local data
                                          if (feedBackController
                                              .insideAllDisLikeMap
                                              .containsKey(feedBackId)) {
                                            if (kDebugMode) {
                                              print("LIKE 3");
                                            }

                                            if (feedBackController
                                                    .insideAllDisLikeMap[
                                                        feedBackId]!
                                                    .interactionStatus ==
                                                true) {
                                              if (kDebugMode) {
                                                print("LIKE 4");
                                              }

                                              feedBackController
                                                  .insideAllDisLikeMap
                                                  .addAll({
                                                feedBackId: InteractionStatus(
                                                    feedbackId: feedBackId,
                                                    interactionStatus: false,
                                                    count: feedBackController
                                                                .insideAllDisLikeMap[
                                                                    feedBackId]!
                                                                .count! >
                                                            0
                                                        ? feedBackController
                                                                .insideAllDisLikeMap[
                                                                    feedBackId]!
                                                                .count! -
                                                            1
                                                        : feedBackController
                                                            .insideAllDisLikeMap[
                                                                feedBackId]!
                                                            .count!,
                                                    interactionId:
                                                        feedBackController
                                                            .insideAllDisLikeMap[
                                                                feedBackId]!
                                                            .interactionId)
                                              });
                                              await feedBackController
                                                  .interactionDeleteViewModel(
                                                      interactionId:
                                                          feedBackController
                                                              .insideAllDisLikeMap[
                                                                  feedBackId]!
                                                              .interactionId);
                                            }
                                          }
                                          await feedBackController
                                              .feedBackLDCViewModel({
                                            "user": PreferenceManagerUtils
                                                .getLoginId(),
                                            "feedback": feedBackId,
                                            "ftype": "like"
                                          });

                                          if (feedBackController
                                                  .feedBackLikeApiResponse
                                                  .status ==
                                              Status.COMPLETE) {
                                            if (kDebugMode) {
                                              print("LIKE 5");
                                            }

                                            FeedBackLikeUnLikeResModel
                                                response = feedBackController
                                                    .feedBackLikeApiResponse
                                                    .data;

                                            feedBackController.insideAllLikeMap
                                                .addAll({
                                              feedBackId: InteractionStatus(
                                                  feedbackId: feedBackId,
                                                  interactionStatus: true,
                                                  count: feedBackController
                                                          .insideAllLikeMap[
                                                              feedBackId]!
                                                          .count! +
                                                      1,
                                                  interactionId:
                                                      response.data!.sId)
                                            });
                                          }

                                          return;
                                        }

                                        ///DATA FROM API WHEN IS LIKE IS TRUE

                                        else if (yoursFeedbackPostedResults
                                                .mylike ==
                                            true) {
                                          if (kDebugMode) {
                                            print("LIKE 6");
                                          }

                                          feedBackController.insideAllLikeMap
                                              .addAll({
                                            feedBackId: InteractionStatus(
                                                interactionStatus: false,
                                                count:
                                                    yoursFeedbackPostedResults
                                                                .like! >
                                                            0
                                                        ? yoursFeedbackPostedResults
                                                                .like! -
                                                            1
                                                        : yoursFeedbackPostedResults
                                                            .like!)
                                          });
                                          await feedBackController
                                              .interactionDeleteViewModel(
                                                  interactionId:
                                                      yoursFeedbackPostedResults
                                                          .mylikeid);

                                          return;
                                        }

                                        ///DATA FROM API MY LIKE IS FALSE
                                        else if (yoursFeedbackPostedResults
                                                .mylike ==
                                            false) {
                                          if (kDebugMode) {
                                            print("LIKE 7");
                                          }

                                          ///unlike from api data
                                          if (yoursFeedbackPostedResults
                                                  .myunlike ==
                                              true) {
                                            if (kDebugMode) {
                                              print("LIKE 8");
                                            }

                                            feedBackController
                                                .insideAllDisLikeMap
                                                .addAll({
                                              feedBackId: InteractionStatus(
                                                feedbackId: feedBackId,
                                                interactionStatus: false,
                                                count:
                                                    yoursFeedbackPostedResults
                                                                .unlike! >
                                                            0
                                                        ? yoursFeedbackPostedResults
                                                                .unlike! -
                                                            1
                                                        : yoursFeedbackPostedResults
                                                            .unlike!,
                                              )
                                            });
                                            await feedBackController
                                                .interactionDeleteViewModel(
                                                    interactionId:
                                                        yoursFeedbackPostedResults
                                                            .myunlikeid);
                                          } else {
                                            if (feedBackController
                                                .insideAllDisLikeMap
                                                .containsKey(feedBackId)) {
                                              feedBackController
                                                  .insideAllDisLikeMap
                                                  .addAll({
                                                feedBackId: InteractionStatus(
                                                    feedbackId: feedBackId,
                                                    interactionStatus: false,
                                                    count: feedBackController
                                                                .insideAllDisLikeMap[
                                                                    feedBackId]!
                                                                .count! >
                                                            0
                                                        ? feedBackController
                                                                .insideAllDisLikeMap[
                                                                    feedBackId]!
                                                                .count! -
                                                            1
                                                        : feedBackController
                                                            .insideAllDisLikeMap[
                                                                feedBackId]!
                                                            .count!,
                                                    interactionId:
                                                        feedBackController
                                                            .insideAllDisLikeMap[
                                                                feedBackId]!
                                                            .interactionId)
                                              });
                                              await feedBackController
                                                  .interactionDeleteViewModel(
                                                      interactionId:
                                                          feedBackController
                                                              .insideAllDisLikeMap[
                                                                  feedBackId]!
                                                              .interactionId);
                                            }
                                          }
                                          await feedBackController
                                              .feedBackLDCViewModel({
                                            "user": PreferenceManagerUtils
                                                .getLoginId(),
                                            "feedback": feedBackId,
                                            "ftype": "like"
                                          });

                                          if (feedBackController
                                                  .feedBackLikeApiResponse
                                                  .status ==
                                              Status.COMPLETE) {
                                            if (kDebugMode) {
                                              print("LIKE 9");
                                            }

                                            FeedBackLikeUnLikeResModel
                                                response = feedBackController
                                                    .feedBackLikeApiResponse
                                                    .data;

                                            feedBackController.insideAllLikeMap
                                                .addAll({
                                              feedBackId: InteractionStatus(
                                                  feedbackId: feedBackId,
                                                  interactionStatus: true,
                                                  count:
                                                      yoursFeedbackPostedResults
                                                              .like! +
                                                          1,
                                                  interactionId:
                                                      response.data!.sId)
                                            });
                                          }

                                          return;
                                        }
                                        feedBackController.update();
                                      },
                                      child: interactionWidget(
                                        svg: feedBackController.insideAllLikeMap
                                                .containsKey(
                                                    yoursFeedbackPostedResults
                                                        .sId!)
                                            ? feedBackController
                                                        .insideAllLikeMap[
                                                            yoursFeedbackPostedResults
                                                                .sId]!
                                                        .interactionStatus ==
                                                    true
                                                ? SvgPicture.asset(
                                                    likeImg,
                                                    color:
                                                        ColorUtils.primaryColor,
                                                  )
                                                : SvgPicture.asset(
                                                    likeImg,
                                                  )
                                            : yoursFeedbackPostedResults
                                                        .mylike ==
                                                    true
                                                ? SvgPicture.asset(
                                                    likeImg,
                                                    color:
                                                        ColorUtils.primaryColor,
                                                  )
                                                : SvgPicture.asset(
                                                    likeImg,
                                                  ),
                                        value: feedBackController
                                                .insideAllLikeMap
                                                .containsKey(
                                                    yoursFeedbackPostedResults
                                                        .sId!)
                                            ? feedBackController
                                                .insideAllLikeMap[
                                                    yoursFeedbackPostedResults
                                                        .sId]!
                                                .count
                                            : likeCount,
                                      ),
                                    ),
                                    SizeConfig.sW5,

                                    ///dislike
                                    InkResponse(
                                      radius: 40,
                                      onTap: () async {
                                        YoursFeedbackPostedResults
                                            yoursFeedbackPostedResults =
                                            feedBackController
                                                    .yoursFeedbackPostedResults[
                                                index];
                                        String? feedBackId =
                                            yoursFeedbackPostedResults.sId!;

                                        ///DATA FROM LOCAL

                                        if (feedBackController
                                                .insideAllDisLikeMap
                                                .containsKey(feedBackId) &&
                                            feedBackController
                                                    .insideAllDisLikeMap[
                                                        feedBackId]!
                                                    .interactionStatus ==
                                                true) {
                                          if (kDebugMode) {
                                            print("UNLIKE 1");
                                          }
                                          feedBackController.insideAllDisLikeMap
                                              .addAll({
                                            feedBackId: InteractionStatus(
                                                interactionStatus: false,
                                                count: feedBackController
                                                            .insideAllDisLikeMap[
                                                                feedBackId]!
                                                            .count! >
                                                        0
                                                    ? feedBackController
                                                            .insideAllDisLikeMap[
                                                                feedBackId]!
                                                            .count! -
                                                        1
                                                    : feedBackController
                                                        .insideAllDisLikeMap[
                                                            feedBackId]!
                                                        .count!,
                                                interactionId:
                                                    feedBackController
                                                        .insideAllDisLikeMap[
                                                            feedBackId]!
                                                        .interactionId)
                                          });
                                          await feedBackController
                                              .interactionDeleteViewModel(
                                                  interactionId:
                                                      feedBackController
                                                          .insideAllDisLikeMap[
                                                              feedBackId]!
                                                          .interactionId);

                                          return;
                                        }

                                        ///DATA FROM LOCAL

                                        else if (feedBackController
                                                .insideAllDisLikeMap
                                                .containsKey(feedBackId) &&
                                            feedBackController
                                                    .insideAllDisLikeMap[
                                                        feedBackId]!
                                                    .interactionStatus ==
                                                false) {
                                          if (kDebugMode) {
                                            print("UNLIKE 2");
                                          }

                                          ///unlike from local data
                                          if (feedBackController
                                              .insideAllLikeMap
                                              .containsKey(feedBackId)) {
                                            if (kDebugMode) {
                                              print("UNLIKE 3");
                                            }

                                            if (feedBackController
                                                    .insideAllLikeMap[
                                                        feedBackId]!
                                                    .interactionStatus ==
                                                true) {
                                              if (kDebugMode) {
                                                print("UNLIKE 4");
                                              }

                                              feedBackController
                                                  .insideAllLikeMap
                                                  .addAll({
                                                feedBackId: InteractionStatus(
                                                    feedbackId: feedBackId,
                                                    interactionStatus: false,
                                                    count: feedBackController
                                                                .insideAllLikeMap[
                                                                    feedBackId]!
                                                                .count! >
                                                            0
                                                        ? feedBackController
                                                                .insideAllLikeMap[
                                                                    feedBackId]!
                                                                .count! -
                                                            1
                                                        : feedBackController
                                                            .insideAllLikeMap[
                                                                feedBackId]!
                                                            .count!,
                                                    interactionId:
                                                        feedBackController
                                                            .insideAllLikeMap[
                                                                feedBackId]!
                                                            .interactionId)
                                              });
                                              await feedBackController
                                                  .interactionDeleteViewModel(
                                                      interactionId:
                                                          feedBackController
                                                              .insideAllLikeMap[
                                                                  feedBackId]!
                                                              .interactionId);
                                            }
                                          }
                                          await feedBackController
                                              .feedBackLDCViewModel({
                                            "user": PreferenceManagerUtils
                                                .getLoginId(),
                                            "feedback": feedBackId,
                                            "ftype": "unlike"
                                          });

                                          if (feedBackController
                                                  .feedBackLikeApiResponse
                                                  .status ==
                                              Status.COMPLETE) {
                                            if (kDebugMode) {
                                              print("UNLIKE 5");
                                            }

                                            FeedBackLikeUnLikeResModel
                                                response = feedBackController
                                                    .feedBackLikeApiResponse
                                                    .data;

                                            feedBackController
                                                .insideAllDisLikeMap
                                                .addAll({
                                              feedBackId: InteractionStatus(
                                                  feedbackId: feedBackId,
                                                  interactionStatus: true,
                                                  count: feedBackController
                                                          .insideAllDisLikeMap[
                                                              feedBackId]!
                                                          .count! +
                                                      1,
                                                  interactionId:
                                                      response.data!.sId)
                                            });
                                          }

                                          return;
                                        }

                                        ///DATA FROM API
                                        else if (yoursFeedbackPostedResults
                                                .myunlike ==
                                            true) {
                                          if (kDebugMode) {
                                            print("UNLIKE 6");
                                          }

                                          feedBackController.insideAllDisLikeMap
                                              .addAll({
                                            feedBackId: InteractionStatus(
                                                interactionStatus: false,
                                                count:
                                                    yoursFeedbackPostedResults
                                                                .unlike! >
                                                            0
                                                        ? yoursFeedbackPostedResults
                                                                .unlike! -
                                                            1
                                                        : yoursFeedbackPostedResults
                                                            .unlike!)
                                          });
                                          await feedBackController
                                              .interactionDeleteViewModel(
                                                  interactionId:
                                                      yoursFeedbackPostedResults
                                                          .myunlikeid);

                                          return;
                                        }

                                        ///DATA FROM API
                                        else if (yoursFeedbackPostedResults
                                                .myunlike ==
                                            false) {
                                          if (kDebugMode) {
                                            print("UNLIKE 7");
                                          }

                                          ///unlike from local data
                                          if (yoursFeedbackPostedResults
                                                  .mylike ==
                                              true) {
                                            if (kDebugMode) {
                                              print("UNLIKE 8");
                                            }

                                            await feedBackController
                                                .interactionDeleteViewModel(
                                                    interactionId:
                                                        yoursFeedbackPostedResults
                                                            .mylikeid);

                                            feedBackController.insideAllLikeMap
                                                .addAll({
                                              feedBackId: InteractionStatus(
                                                feedbackId: feedBackId,
                                                interactionStatus: false,
                                                count:
                                                    yoursFeedbackPostedResults
                                                                .like! >
                                                            0
                                                        ? yoursFeedbackPostedResults
                                                                .like! -
                                                            1
                                                        : yoursFeedbackPostedResults
                                                            .like!,
                                              )
                                            });
                                          } else {
                                            if (kDebugMode) {
                                              print("UNLIKE 9");
                                            }

                                            if (feedBackController
                                                .insideAllLikeMap
                                                .containsKey(feedBackId)) {
                                              if (kDebugMode) {
                                                print("UNLIKE 10");
                                              }

                                              feedBackController
                                                  .insideAllLikeMap
                                                  .addAll({
                                                feedBackId: InteractionStatus(
                                                    feedbackId: feedBackId,
                                                    interactionStatus: false,
                                                    count: feedBackController
                                                                .insideAllLikeMap[
                                                                    feedBackId]!
                                                                .count! >
                                                            0
                                                        ? feedBackController
                                                                .insideAllLikeMap[
                                                                    feedBackId]!
                                                                .count! -
                                                            1
                                                        : feedBackController
                                                            .insideAllLikeMap[
                                                                feedBackId]!
                                                            .count!,
                                                    interactionId:
                                                        feedBackController
                                                            .insideAllLikeMap[
                                                                feedBackId]!
                                                            .interactionId)
                                              });
                                              await feedBackController
                                                  .interactionDeleteViewModel(
                                                      interactionId:
                                                          feedBackController
                                                              .insideAllLikeMap[
                                                                  feedBackId]!
                                                              .interactionId);
                                            }
                                          }
                                          await feedBackController
                                              .feedBackLDCViewModel({
                                            "user": PreferenceManagerUtils
                                                .getLoginId(),
                                            "feedback":
                                                yoursFeedbackPostedResults.sId,
                                            "ftype": "unlike"
                                          });

                                          if (feedBackController
                                                  .feedBackLikeApiResponse
                                                  .status ==
                                              Status.COMPLETE) {
                                            if (kDebugMode) {
                                              print("UNLIKE 11");
                                            }

                                            FeedBackLikeUnLikeResModel
                                                response = feedBackController
                                                    .feedBackLikeApiResponse
                                                    .data;

                                            feedBackController
                                                .insideAllDisLikeMap
                                                .addAll({
                                              feedBackId: InteractionStatus(
                                                  feedbackId: feedBackId,
                                                  interactionStatus: true,
                                                  count:
                                                      yoursFeedbackPostedResults
                                                              .unlike! +
                                                          1,
                                                  interactionId:
                                                      response.data!.sId)
                                            });
                                          }

                                          return;
                                        }
                                        feedBackController.update();
                                      },
                                      child: interactionWidget(
                                        svg: feedBackController
                                                .insideAllDisLikeMap
                                                .containsKey(
                                                    yoursFeedbackPostedResults
                                                        .sId!)
                                            ? feedBackController
                                                        .insideAllDisLikeMap[
                                                            yoursFeedbackPostedResults
                                                                .sId]!
                                                        .interactionStatus ==
                                                    true
                                                ? SvgPicture.asset(
                                                    dislikeImg,
                                                    color:
                                                        ColorUtils.primaryColor,
                                                  )
                                                : SvgPicture.asset(
                                                    dislikeImg,
                                                  )
                                            : yoursFeedbackPostedResults
                                                        .myunlike ==
                                                    true
                                                ? SvgPicture.asset(
                                                    dislikeImg,
                                                    color:
                                                        ColorUtils.primaryColor,
                                                  )
                                                : SvgPicture.asset(
                                                    dislikeImg,
                                                  ),
                                        value: feedBackController
                                                .insideAllDisLikeMap
                                                .containsKey(
                                                    yoursFeedbackPostedResults
                                                        .sId!)
                                            ? feedBackController
                                                .insideAllDisLikeMap[
                                                    yoursFeedbackPostedResults
                                                        .sId]!
                                                .count
                                            : unLikeCount,
                                      ),
                                    ),
                                    SizeConfig.sW5,
                                    InkResponse(
                                      radius: 40,
                                      onTap: () async {
                                        detailScreenCall(
                                            feedBackController:
                                                feedBackController,
                                            index: index,
                                            isCommentTap: true);
                                      },
                                      child: interactionWidget(
                                          svg: SvgPicture.asset(
                                            commentImg,
                                          ),
                                          iconPath: commentImg,
                                          value: yoursFeedbackPostedResults
                                              .comment),
                                    ),
                                    SizeConfig.sW5,
                                    DeepLinkSendWidget(
                                      feedBackId: feedBackController
                                          .yoursFeedbackPostedResults[index]
                                          .sId,
                                      shareLink: feedBackController
                                          .yoursFeedbackPostedResults[index]
                                          .shareLink,
                                    ),
                                  ],
                                ),
                                SizeConfig.sH1,
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
            },
          ),
        );
      }),
    );
  }

  Row interactionWidget({String? iconPath, int? value, SvgPicture? svg}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        svg!,
        const SizedBox(
          width: 5,
        ),
        value == null
            ? const SizedBox()
            : Text(
                value.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColorUtils.grey,
                    fontSize: 10.sp),
              ),
      ],
    );
  }

  Future<void> detailScreenCall(
      {FeedBackViewModel? feedBackController,
      int? index,
      bool? disputeStatus,
      bool? isCommentTap}) async {
    await Get.to(
      FeedBackDetailsScreen(
        feedBackId: feedBackController!.yoursFeedbackPostedResults[index!].sId,
        isCommentTap: isCommentTap ?? false,
      ),
    );
    apiCalling(feedBackController);
  }

  apiCalling(FeedBackViewModel feedBackController) async {
    feedBackController.isFeedScrollLoading = true;
    feedBackController.applicantPage = 1;
    feedBackController.yoursFeedbackPostedResults.clear();

    await feedBackController.getMyPostedFeed(
        userId: widget.feedBackUserId,
        fromScreen: widget.fromScreen,
        isExistsUser: widget.isExistsUser);
    clearLocalList();
  }
}
