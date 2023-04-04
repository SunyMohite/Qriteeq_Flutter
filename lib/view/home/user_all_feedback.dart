import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/commonWidget/common_profile_icon.dart';
import 'package:humanscoring/service/download_file.dart';
import 'package:humanscoring/service/video_player.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:octo_image/octo_image.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../../common/circular_progress_indicator.dart';
import '../../common/commonWidget/custom_dialog.dart';
import '../../common/commonWidget/feedback_score_emoji.dart';
import '../../common/commonWidget/snackbar.dart';
import '../../common/deeplink_send_widget.dart';
import '../../modal/apiModel/res_model/like_unlike_res_model.dart';
import '../../modal/apiModel/res_model/my_feed_back_response_model.dart';
import '../../modal/apiModel/res_model/payment_coin_res_model.dart';
import '../../modal/apis/api_response.dart';
import '../../utils/assets/icons_utils.dart';
import '../../utils/assets/images_utils.dart';
import '../../utils/assets/lotti_animation_json.dart';
import '../../utils/color_utils.dart';
import '../../utils/shared_preference_utils.dart';
import '../../viewmodel/feedback_viewmodel.dart';
import '../detailsScreen/feed_back_details_screen.dart';
import '../generalScreen/no_searchfound_screen.dart';
import 'feed_inside_page/user_profile_inside_page.dart';

class UserAllFeedBackScreen extends StatefulWidget {
  final String? userFeedBackId;
  final String? isScreenName;
  final String? queryKey;
  final String? queryValue;
  final String? campignId;
  final bool? isExistsUser;
  final bool? isCompletedCamping;

  const UserAllFeedBackScreen(
      {Key? key,
      this.userFeedBackId,
      this.isScreenName,
      this.isExistsUser,
      this.queryKey,
      this.campignId,
      this.isCompletedCamping = false,
      this.queryValue})
      : super(key: key);

  @override
  State<UserAllFeedBackScreen> createState() => _UserAllFeedBackScreenState();
}

class _UserAllFeedBackScreenState extends State<UserAllFeedBackScreen> {
  String? userFeedBackId;
  bool? isExistsUser;
  FeedBackViewModel feedBackViewModel = Get.find<FeedBackViewModel>();

  void _firstLoad() async {
    feedBackViewModel.applicantPage = 1;
    feedBackViewModel.myFeedBackResultList.clear();
    feedBackViewModel.getMyFeed(
        initLoad: false,
        userId: userFeedBackId!,
        campignId: widget.campignId,
        queryKey: widget.queryKey,
        queryValue: widget.queryValue,
        isExistsUser: isExistsUser == true ? true : false);
  }

  void _loadMore() async {
    if (feedBackViewModel.isFeedScrollLoading == false &&
        feedBackViewModel.isApplicantMoreLoading == false &&
        feedBackListController.position.extentAfter < 300) {
      try {
        feedBackViewModel.getMyFeed(
            userId: userFeedBackId!,
            campignId: widget.campignId,
            isExistsUser: isExistsUser == true ? true : false,
            queryKey: widget.queryKey,
            queryValue: widget.queryValue);
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }
    }
  }

  late ScrollController feedBackListController;

  @override
  void initState() {
    clearLocalList();
    userFeedBackId = widget.userFeedBackId;
    isExistsUser = widget.isExistsUser;
    feedBackViewModel.isFeedScrollLoading = true;
    if (feedBackViewModel.isFeedScrollLoading == true) {
      _firstLoad();
    }
    feedBackListController = ScrollController()..addListener(_loadMore);
    super.initState();
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
        if (feedBackController.myFeedBackResultList.isEmpty) {
          return NoFeedBackFound(
            titleMsg: VariableUtils.beFirstFeedback,
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            apiCalling(feedBackViewModel: feedBackViewModel);
          },
          child: SingleChildScrollView(
            controller: feedBackListController,
            child: Column(
              children: List.generate(
                  feedBackController.myFeedBackResultList.length, (index) {
                MyFeedBackResults myFeedBackResultsData =
                    feedBackController.myFeedBackResultList[index];

                var senderName = myFeedBackResultsData.sender == null
                    ? ''
                    : ((myFeedBackResultsData.sender!.id ==
                                PreferenceManagerUtils.getLoginId()) &&
                            myFeedBackResultsData.anonymous == false)
                        ? VariableUtils.you
                        : myFeedBackResultsData.anonymous == true
                            ? VariableUtils.anonymous
                            : myFeedBackResultsData.sender!.userIdentity ?? '';

                var time = myFeedBackResultsData.createdAt;
                var review = myFeedBackResultsData.text;
                var score = myFeedBackResultsData.score;
                final likeCount = myFeedBackResultsData.like;
                final unLikeCount = myFeedBackResultsData.unlike;
                final isUnlocked = myFeedBackResultsData.isUnlocked;
                var country = myFeedBackResultsData.sender!.countryName ??
                    VariableUtils.global;
                var flagUrl = myFeedBackResultsData.sender!.flagUrl;
                final profileType = myFeedBackResultsData.sender!.profileType;

                return myFeedBackResultsData.sender == null
                    ? const SizedBox()
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: isUnlocked == true ? 0 : 3,
                              sigmaY: isUnlocked == true ? 0 : 3,
                              tileMode: TileMode.decal,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 6.0, top: 4),
                              child: InkWell(
                                onTap: () async {
                                  if (isUnlocked == true) {
                                    detailsScreenCall(
                                        feedBackController: feedBackController,
                                        isFeedBackCommentTap: false,
                                        feedBackIndex: index);
                                  } else {
                                    await feedBackViewModel
                                        .paymentCoinViewModel(
                                            feedBackId: feedBackController
                                                .myFeedBackResultList[index]
                                                .sId);
                                    if (feedBackViewModel
                                            .paymentCoinApiResponse.status ==
                                        Status.COMPLETE) {
                                      PaymentCoinResModel response =
                                          feedBackViewModel
                                              .paymentCoinApiResponse.data;
                                      if (response.status == 200) {
                                        if (response.data!.open == false) {
                                          showSnackBar(
                                              message: response.data!.showText,
                                              showDuration:
                                                  const Duration(seconds: 3));

                                        } else if (response.data!.open ==
                                            true) {
                                          dialogShow(
                                              response, feedBackController);
                                          return;
                                        }
                                      }
                                    }
                                  }
                                },
                                child: Material(
                                  elevation: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            var userName = myFeedBackResultsData
                                                        .sender!.id ==
                                                    PreferenceManagerUtils
                                                        .getLoginId()
                                                ? VariableUtils.you
                                                : myFeedBackResultsData
                                                    .sender!.userIdentity;
                                            if (myFeedBackResultsData
                                                    .blockStatus!.hideUser ==
                                                true) {
                                              showSnackBar(
                                                  message: myFeedBackResultsData
                                                      .blockStatus!
                                                      .hideUserMessage);
                                              return;
                                            }
                                            if (myFeedBackResultsData
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
                                                                userName:
                                                                    userName,
                                                                avatar:
                                                                    myFeedBackResultsData
                                                                        .sender!
                                                                        .avatar,
                                                                toId:
                                                                    myFeedBackResultsData
                                                                        .sender!
                                                                        .id,
                                                                phone:
                                                                    myFeedBackResultsData
                                                                        .sender!
                                                                        .phone,
                                                                favorite: myFeedBackResultsData
                                                                            .defaultStatus ==
                                                                        null
                                                                    ? false
                                                                    : myFeedBackResultsData
                                                                        .defaultStatus!
                                                                        .sender!
                                                                        .favorite,
                                                                isBlock: myFeedBackResultsData
                                                                            .defaultStatus ==
                                                                        null
                                                                    ? false
                                                                    : myFeedBackResultsData
                                                                        .defaultStatus!
                                                                        .sender!
                                                                        .block,
                                                                flag: myFeedBackResultsData
                                                                            .defaultStatus ==
                                                                        null
                                                                    ? false
                                                                    : myFeedBackResultsData
                                                                        .defaultStatus!
                                                                        .sender!
                                                                        .flag,
                                                                online:
                                                                    myFeedBackResultsData
                                                                        .sender!
                                                                        .online,
                                                                active:
                                                                    myFeedBackResultsData
                                                                        .sender!
                                                                        .active,
                                                              )));
                                            } else {
                                              await Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserInsidePage(
                                                            screenName:
                                                                'UserAllFeedBack',
                                                            userName: userName,
                                                            avatar:
                                                                myFeedBackResultsData
                                                                    .sender!
                                                                    .avatar,
                                                            toId:
                                                                myFeedBackResultsData
                                                                    .sender!.id,
                                                            phone:
                                                                myFeedBackResultsData
                                                                    .sender!
                                                                    .phone,
                                                            favorite: myFeedBackResultsData
                                                                        .defaultStatus ==
                                                                    null
                                                                ? false
                                                                : myFeedBackResultsData
                                                                    .defaultStatus!
                                                                    .sender!
                                                                    .favorite,
                                                            isBlock: myFeedBackResultsData
                                                                        .defaultStatus ==
                                                                    null
                                                                ? false
                                                                : myFeedBackResultsData
                                                                    .defaultStatus!
                                                                    .sender!
                                                                    .block,
                                                            flag: myFeedBackResultsData
                                                                        .defaultStatus ==
                                                                    null
                                                                ? false
                                                                : myFeedBackResultsData
                                                                    .defaultStatus!
                                                                    .sender!
                                                                    .flag,
                                                            online:
                                                                myFeedBackResultsData
                                                                    .sender!
                                                                    .online,
                                                            active:
                                                                myFeedBackResultsData
                                                                    .sender!
                                                                    .active,
                                                          )));
                                            }
                                            apiCalling(
                                                feedBackViewModel:
                                                    feedBackController);
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              flagUrl == '' || flagUrl == null
                                                  ? Image.asset(
                                                      "${baseImgPath}world.webp",
                                                      scale: 9.w,
                                                    )
                                                  : SvgPicture.network(
                                                      flagUrl,
                                                      height: 5.w,
                                                      width: 5.w,
                                                      fit: BoxFit.fill,
                                                    ),
                                              SizeConfig.sW2,
                                              Text(
                                                senderName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10.sp,
                                                ),
                                              ),
                                              SizeConfig.sW1,
                                              profileIconSetWidget(
                                                  profileType: profileType!),
                                            ],
                                          ),
                                        ),
                                        SizeConfig.sH1,
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              child: SvgPicture.asset(
                                                earthImg,
                                                height: 5.w,
                                                width: 5.w,
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
                                            Text(" . $time",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        ColorUtils.blacklight,
                                                    fontSize: 10.sp)),
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
                                        SizedBox(height: 1.h),
                                        myFeedBackResultsData.document ==
                                                    null ||
                                                myFeedBackResultsData
                                                    .document!.isEmpty ||
                                                myFeedBackResultsData
                                                        .document!.first.url ==
                                                    null
                                            ? const SizedBox()
                                            : ImageFiltered(
                                                imageFilter: ImageFilter.blur(
                                                  sigmaX: isUnlocked == true
                                                      ? 0
                                                      : 3,
                                                  sigmaY: isUnlocked == true
                                                      ? 0
                                                      : 3,
                                                  tileMode: TileMode.decal,
                                                ),
                                                child: VariableUtils
                                                        .imageFormatList
                                                        .contains(
                                                            myFeedBackResultsData
                                                                .document!
                                                                .first
                                                                .ext!
                                                                .toUpperCase())
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2.w),
                                                        child: OctoImage(
                                                          image:
                                                              CachedNetworkImageProvider(
                                                            myFeedBackResultsData
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
                                                          width:
                                                              double.infinity,
                                                          errorBuilder:
                                                              OctoError.icon(
                                                                  color: Colors
                                                                      .red),
                                                          fit: BoxFit.fitWidth,
                                                        ),
                                                      )
                                                    : VariableUtils
                                                            .videoFormatList
                                                            .contains(
                                                                myFeedBackResultsData
                                                                    .document!
                                                                    .first
                                                                    .ext
                                                                    .toString()
                                                                    .toUpperCase())
                                                        ? VideoPlayerService(
                                                            key: ValueKey(
                                                                myFeedBackResultsData
                                                                    .document!
                                                                    .first
                                                                    .url!),
                                                            url:
                                                                myFeedBackResultsData
                                                                    .document!
                                                                    .first
                                                                    .url!,
                                                          )
                                                        : VariableUtils
                                                                .documentFormatList
                                                                .contains(myFeedBackResultsData
                                                                    .document!
                                                                    .first
                                                                    .ext
                                                                    .toString()
                                                                    .toUpperCase())
                                                            ? InkWell(
                                                                onTap: () {
                                                                  firebaseDownloadFile(
                                                                          myFeedBackResultsData
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
                                                                child:
                                                                    Container(
                                                                  width:
                                                                      Get.width,
                                                                  height: 15.w,
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
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
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          SizedBox(
                                                                              height: 6.w,
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
                                                                      const Icon(
                                                                          Icons
                                                                              .download),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                              ),
                                        VariableUtils.feedBackStatusList
                                                    .contains(
                                                        myFeedBackResultsData
                                                            .status) &&
                                                (myFeedBackResultsData
                                                        .showText !=
                                                    null)
                                            ? Column(
                                                children: [
                                                  SizedBox(height: 1.h),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 1.h),
                                                    child: Container(
                                                      color: const Color(
                                                          0xffE8E8E8),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 3.w),
                                                      height: 5.h,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                            tickImg,
                                                            color: ColorUtils
                                                                .lightGrey83,
                                                            height: 5.w,
                                                            width: 5.w,
                                                          ),
                                                          SizedBox(width: 2.w),
                                                          Expanded(
                                                            child: Text(
                                                              myFeedBackResultsData
                                                                  .showText!,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: ColorUtils
                                                                      .lightGrey83,
                                                                  fontSize:
                                                                      9.sp),
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 1.h),
                                                ],
                                              )
                                            : const SizedBox(),
                                        SizedBox(height: 1.h),
                                        Divider(
                                          height: 1.h,
                                          color: ColorUtils.black,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkResponse(
                                                  radius: 40,
                                                  onTap:
                                                      widget.isCompletedCamping!
                                                          ? null
                                                          : () async {
                                                              MyFeedBackResults
                                                                  data =
                                                                  feedBackController
                                                                          .myFeedBackResultList[
                                                                      index];
                                                              String?
                                                                  feedBackId =
                                                                  data.sId!;

                                                              ///DATA FROM LOCAL WHEN IS LIKE IS TRUE

                                                              ///DATA FROM LOCAL WHEN IS LIKE IS TRUE

                                                              if (feedBackController
                                                                      .insideAllLikeMap
                                                                      .containsKey(
                                                                          feedBackId) &&
                                                                  feedBackController
                                                                          .insideAllLikeMap[
                                                                              feedBackId]!
                                                                          .interactionStatus ==
                                                                      true) {
                                                                if (kDebugMode) {
                                                                  print(
                                                                      "LIKE 1");
                                                                }

                                                                feedBackController
                                                                    .insideAllLikeMap
                                                                    .addAll({
                                                                  feedBackId: InteractionStatus(
                                                                      interactionStatus:
                                                                          false,
                                                                      count: feedBackController.insideAllLikeMap[feedBackId]!.count! > 0
                                                                          ? feedBackController.insideAllLikeMap[feedBackId]!.count! -
                                                                              1
                                                                          : feedBackController
                                                                              .insideAllLikeMap[
                                                                                  feedBackId]!
                                                                              .count!,
                                                                      interactionId: feedBackController
                                                                          .insideAllLikeMap[
                                                                              feedBackId]!
                                                                          .interactionId)
                                                                });
                                                                await feedBackController.interactionDeleteViewModel(
                                                                    interactionId: feedBackController
                                                                        .insideAllLikeMap[
                                                                            feedBackId]!
                                                                        .interactionId);

                                                                return;
                                                              }

                                                              ///DATA FROM LOCAL WHEN IS LIKE IS FALSE

                                                              else if (feedBackController
                                                                      .insideAllLikeMap
                                                                      .containsKey(
                                                                          feedBackId) &&
                                                                  feedBackController
                                                                          .insideAllLikeMap[
                                                                              feedBackId]!
                                                                          .interactionStatus ==
                                                                      false) {
                                                                if (kDebugMode) {
                                                                  print(
                                                                      "LIKE 2");
                                                                }

                                                                ///unlike from local data
                                                                if (feedBackController
                                                                    .insideAllDisLikeMap
                                                                    .containsKey(
                                                                        feedBackId)) {
                                                                  if (kDebugMode) {
                                                                    print(
                                                                        "LIKE 3");
                                                                  }

                                                                  if (feedBackController
                                                                          .insideAllDisLikeMap[
                                                                              feedBackId]!
                                                                          .interactionStatus ==
                                                                      true) {
                                                                    if (kDebugMode) {
                                                                      print(
                                                                          "LIKE 4");
                                                                    }

                                                                    feedBackController
                                                                        .insideAllDisLikeMap
                                                                        .addAll({
                                                                      feedBackId: InteractionStatus(
                                                                          feedbackId:
                                                                              feedBackId,
                                                                          interactionStatus:
                                                                              false,
                                                                          count: feedBackController.insideAllDisLikeMap[feedBackId]!.count! > 0
                                                                              ? feedBackController.insideAllDisLikeMap[feedBackId]!.count! - 1
                                                                              : feedBackController.insideAllDisLikeMap[feedBackId]!.count!,
                                                                          interactionId: feedBackController.insideAllDisLikeMap[feedBackId]!.interactionId)
                                                                    });
                                                                    await feedBackController.interactionDeleteViewModel(
                                                                        interactionId: feedBackController
                                                                            .insideAllDisLikeMap[feedBackId]!
                                                                            .interactionId);
                                                                  }
                                                                }

                                                                await feedBackController
                                                                    .feedBackLDCViewModel({
                                                                  "user": PreferenceManagerUtils
                                                                      .getLoginId(),
                                                                  "feedback":
                                                                      feedBackId,
                                                                  "ftype":
                                                                      "like"
                                                                });

                                                                if (feedBackController
                                                                        .feedBackLikeApiResponse
                                                                        .status ==
                                                                    Status
                                                                        .COMPLETE) {
                                                                  if (kDebugMode) {
                                                                    print(
                                                                        "LIKE 5");
                                                                  }

                                                                  FeedBackLikeUnLikeResModel
                                                                      response =
                                                                      feedBackController
                                                                          .feedBackLikeApiResponse
                                                                          .data;

                                                                  feedBackController
                                                                      .insideAllLikeMap
                                                                      .addAll({
                                                                    feedBackId: InteractionStatus(
                                                                        feedbackId:
                                                                            feedBackId,
                                                                        interactionStatus:
                                                                            true,
                                                                        count:
                                                                            feedBackController.insideAllLikeMap[feedBackId]!.count! +
                                                                                1,
                                                                        interactionId: response
                                                                            .data!
                                                                            .sId)
                                                                  });
                                                                }

                                                                return;
                                                              }

                                                              ///DATA FROM API WHEN IS LIKE IS TRUE

                                                              else if (data
                                                                      .mylike ==
                                                                  true) {
                                                                if (kDebugMode) {
                                                                  print(
                                                                      "LIKE 6");
                                                                }

                                                                feedBackController
                                                                    .insideAllLikeMap
                                                                    .addAll({
                                                                  feedBackId: InteractionStatus(
                                                                      interactionStatus:
                                                                          false,
                                                                      count: data.like! > 0
                                                                          ? data.like! -
                                                                              1
                                                                          : data
                                                                              .like!)
                                                                });
                                                                await feedBackController
                                                                    .interactionDeleteViewModel(
                                                                        interactionId:
                                                                            data.mylikeid);

                                                                return;
                                                              }

                                                              ///DATA FROM API MY LIKE IS FALSE
                                                              else if (data
                                                                      .mylike ==
                                                                  false) {
                                                                if (kDebugMode) {
                                                                  print(
                                                                      "LIKE 7");
                                                                }

                                                                ///unlike from api data
                                                                if (data.myunlike ==
                                                                    true) {
                                                                  if (kDebugMode) {
                                                                    print(
                                                                        "LIKE 8");
                                                                  }

                                                                  feedBackController
                                                                      .insideAllDisLikeMap
                                                                      .addAll({
                                                                    feedBackId:
                                                                        InteractionStatus(
                                                                      feedbackId:
                                                                          feedBackId,
                                                                      interactionStatus:
                                                                          false,
                                                                      count: data.unlike! > 0
                                                                          ? data.unlike! -
                                                                              1
                                                                          : data
                                                                              .unlike!,
                                                                    )
                                                                  });
                                                                  await feedBackController
                                                                      .interactionDeleteViewModel(
                                                                          interactionId:
                                                                              data.myunlikeid);
                                                                } else {
                                                                  if (feedBackController
                                                                      .insideAllDisLikeMap
                                                                      .containsKey(
                                                                          feedBackId)) {
                                                                    feedBackController
                                                                        .insideAllDisLikeMap
                                                                        .addAll({
                                                                      feedBackId: InteractionStatus(
                                                                          feedbackId:
                                                                              feedBackId,
                                                                          interactionStatus:
                                                                              false,
                                                                          count: feedBackController.insideAllDisLikeMap[feedBackId]!.count! > 0
                                                                              ? feedBackController.insideAllDisLikeMap[feedBackId]!.count! - 1
                                                                              : feedBackController.insideAllDisLikeMap[feedBackId]!.count!,
                                                                          interactionId: feedBackController.insideAllDisLikeMap[feedBackId]!.interactionId)
                                                                    });
                                                                    await feedBackController.interactionDeleteViewModel(
                                                                        interactionId: feedBackController
                                                                            .insideAllDisLikeMap[feedBackId]!
                                                                            .interactionId);
                                                                  }
                                                                }

                                                                await feedBackController
                                                                    .feedBackLDCViewModel({
                                                                  "user": PreferenceManagerUtils
                                                                      .getLoginId(),
                                                                  "feedback":
                                                                      feedBackId,
                                                                  "ftype":
                                                                      "like"
                                                                });

                                                                if (feedBackController
                                                                        .feedBackLikeApiResponse
                                                                        .status ==
                                                                    Status
                                                                        .COMPLETE) {
                                                                  if (kDebugMode) {
                                                                    print(
                                                                        "LIKE 9");
                                                                  }

                                                                  FeedBackLikeUnLikeResModel
                                                                      response =
                                                                      feedBackController
                                                                          .feedBackLikeApiResponse
                                                                          .data;

                                                                  feedBackController
                                                                      .insideAllLikeMap
                                                                      .addAll({
                                                                    feedBackId: InteractionStatus(
                                                                        feedbackId:
                                                                            feedBackId,
                                                                        interactionStatus:
                                                                            true,
                                                                        count:
                                                                            data.like! +
                                                                                1,
                                                                        interactionId: response
                                                                            .data!
                                                                            .sId)
                                                                  });
                                                                }

                                                                return;
                                                              }
                                                              feedBackController
                                                                  .update();
                                                            },
                                                  child: interactionWidget(
                                                    svg: feedBackController
                                                            .insideAllLikeMap
                                                            .containsKey(
                                                                myFeedBackResultsData
                                                                    .sId!)
                                                        ? feedBackController
                                                                    .insideAllLikeMap[
                                                                        myFeedBackResultsData
                                                                            .sId]!
                                                                    .interactionStatus ==
                                                                true
                                                            ? SvgPicture.asset(
                                                                likeImg,
                                                                color: ColorUtils
                                                                    .primaryColor,
                                                              )
                                                            : SvgPicture.asset(
                                                                likeImg,
                                                              )
                                                        : myFeedBackResultsData
                                                                    .mylike ==
                                                                true
                                                            ? SvgPicture.asset(
                                                                likeImg,
                                                                color: ColorUtils
                                                                    .primaryColor,
                                                              )
                                                            : SvgPicture.asset(
                                                                likeImg,
                                                              ),
                                                    value: feedBackController
                                                            .insideAllLikeMap
                                                            .containsKey(
                                                                myFeedBackResultsData
                                                                    .sId!)
                                                        ? feedBackController
                                                            .insideAllLikeMap[
                                                                myFeedBackResultsData
                                                                    .sId]!
                                                            .count
                                                        : likeCount,
                                                  ),
                                                ),
                                                SizeConfig.sW5,

                                                ///dislike
                                                InkResponse(
                                                    radius: 40,
                                                    onTap: widget
                                                            .isCompletedCamping!
                                                        ? null
                                                        : () async {
                                                            MyFeedBackResults
                                                                data =
                                                                feedBackController
                                                                        .myFeedBackResultList[
                                                                    index];
                                                            String? feedBackId =
                                                                data.sId!;

                                                            ///DATA FROM LOCAL

                                                            if (feedBackController
                                                                    .insideAllDisLikeMap
                                                                    .containsKey(
                                                                        feedBackId) &&
                                                                feedBackController
                                                                        .insideAllDisLikeMap[
                                                                            feedBackId]!
                                                                        .interactionStatus ==
                                                                    true) {
                                                              if (kDebugMode) {
                                                                print(
                                                                    "UNLIKE 1");
                                                              }
                                                              feedBackController
                                                                  .insideAllDisLikeMap
                                                                  .addAll({
                                                                feedBackId: InteractionStatus(
                                                                    interactionStatus:
                                                                        false,
                                                                    count: feedBackController.insideAllDisLikeMap[feedBackId]!.count! > 0
                                                                        ? feedBackController.insideAllDisLikeMap[feedBackId]!.count! -
                                                                            1
                                                                        : feedBackController
                                                                            .insideAllDisLikeMap[
                                                                                feedBackId]!
                                                                            .count!,
                                                                    interactionId: feedBackController
                                                                        .insideAllDisLikeMap[
                                                                            feedBackId]!
                                                                        .interactionId)
                                                              });
                                                              await feedBackController.interactionDeleteViewModel(
                                                                  interactionId: feedBackController
                                                                      .insideAllDisLikeMap[
                                                                          feedBackId]!
                                                                      .interactionId);

                                                              return;
                                                            }

                                                            ///DATA FROM LOCAL

                                                            else if (feedBackController
                                                                    .insideAllDisLikeMap
                                                                    .containsKey(
                                                                        feedBackId) &&
                                                                feedBackController
                                                                        .insideAllDisLikeMap[
                                                                            feedBackId]!
                                                                        .interactionStatus ==
                                                                    false) {
                                                              if (kDebugMode) {
                                                                print(
                                                                    "UNLIKE 2");
                                                              }

                                                              ///unlike from local data
                                                              if (feedBackController
                                                                  .insideAllLikeMap
                                                                  .containsKey(
                                                                      feedBackId)) {
                                                                if (kDebugMode) {
                                                                  print(
                                                                      "UNLIKE 3");
                                                                }

                                                                if (feedBackController
                                                                        .insideAllLikeMap[
                                                                            feedBackId]!
                                                                        .interactionStatus ==
                                                                    true) {
                                                                  if (kDebugMode) {
                                                                    print(
                                                                        "UNLIKE 4");
                                                                  }

                                                                  feedBackController
                                                                      .insideAllLikeMap
                                                                      .addAll({
                                                                    feedBackId: InteractionStatus(
                                                                        feedbackId:
                                                                            feedBackId,
                                                                        interactionStatus:
                                                                            false,
                                                                        count: feedBackController.insideAllLikeMap[feedBackId]!.count! > 0
                                                                            ? feedBackController.insideAllLikeMap[feedBackId]!.count! -
                                                                                1
                                                                            : feedBackController
                                                                                .insideAllLikeMap[
                                                                                    feedBackId]!
                                                                                .count!,
                                                                        interactionId: feedBackController
                                                                            .insideAllLikeMap[feedBackId]!
                                                                            .interactionId)
                                                                  });
                                                                  await feedBackController.interactionDeleteViewModel(
                                                                      interactionId: feedBackController
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
                                                                    feedBackId,
                                                                "ftype":
                                                                    "unlike"
                                                              });

                                                              if (feedBackController
                                                                      .feedBackLikeApiResponse
                                                                      .status ==
                                                                  Status
                                                                      .COMPLETE) {
                                                                if (kDebugMode) {
                                                                  print(
                                                                      "UNLIKE 5");
                                                                }

                                                                FeedBackLikeUnLikeResModel
                                                                    response =
                                                                    feedBackController
                                                                        .feedBackLikeApiResponse
                                                                        .data;

                                                                feedBackController
                                                                    .insideAllDisLikeMap
                                                                    .addAll({
                                                                  feedBackId: InteractionStatus(
                                                                      feedbackId:
                                                                          feedBackId,
                                                                      interactionStatus:
                                                                          true,
                                                                      count:
                                                                          feedBackController.insideAllDisLikeMap[feedBackId]!.count! +
                                                                              1,
                                                                      interactionId: response
                                                                          .data!
                                                                          .sId)
                                                                });
                                                              }

                                                              return;
                                                            }

                                                            ///DATA FROM API
                                                            else if (data
                                                                    .myunlike ==
                                                                true) {
                                                              if (kDebugMode) {
                                                                print(
                                                                    "UNLIKE 6");
                                                              }

                                                              feedBackController
                                                                  .insideAllDisLikeMap
                                                                  .addAll({
                                                                feedBackId: InteractionStatus(
                                                                    interactionStatus:
                                                                        false,
                                                                    count: data
                                                                                .unlike! >
                                                                            0
                                                                        ? data.unlike! -
                                                                            1
                                                                        : data
                                                                            .unlike!)
                                                              });
                                                              await feedBackController
                                                                  .interactionDeleteViewModel(
                                                                      interactionId:
                                                                          data.myunlikeid);
                                                              return;
                                                            }

                                                            ///DATA FROM API
                                                            else if (data
                                                                    .myunlike ==
                                                                false) {
                                                              if (kDebugMode) {
                                                                print(
                                                                    "UNLIKE 7");
                                                              }

                                                              ///unlike from local data
                                                              if (data.mylike ==
                                                                  true) {
                                                                if (kDebugMode) {
                                                                  print(
                                                                      "UNLIKE 8");
                                                                }

                                                                await feedBackController
                                                                    .interactionDeleteViewModel(
                                                                        interactionId:
                                                                            data.mylikeid);

                                                                feedBackController
                                                                    .insideAllLikeMap
                                                                    .addAll({
                                                                  feedBackId:
                                                                      InteractionStatus(
                                                                    feedbackId:
                                                                        feedBackId,
                                                                    interactionStatus:
                                                                        false,
                                                                    count: data
                                                                                .like! >
                                                                            0
                                                                        ? data.like! -
                                                                            1
                                                                        : data
                                                                            .like!,
                                                                  )
                                                                });
                                                              } else {
                                                                if (kDebugMode) {
                                                                  print(
                                                                      "UNLIKE 9");
                                                                }

                                                                if (feedBackController
                                                                    .insideAllLikeMap
                                                                    .containsKey(
                                                                        feedBackId)) {
                                                                  if (kDebugMode) {
                                                                    print(
                                                                        "UNLIKE 10");
                                                                  }

                                                                  feedBackController
                                                                      .insideAllLikeMap
                                                                      .addAll({
                                                                    feedBackId: InteractionStatus(
                                                                        feedbackId:
                                                                            feedBackId,
                                                                        interactionStatus:
                                                                            false,
                                                                        count: feedBackController.insideAllLikeMap[feedBackId]!.count! > 0
                                                                            ? feedBackController.insideAllLikeMap[feedBackId]!.count! -
                                                                                1
                                                                            : feedBackController
                                                                                .insideAllLikeMap[
                                                                                    feedBackId]!
                                                                                .count!,
                                                                        interactionId: feedBackController
                                                                            .insideAllLikeMap[feedBackId]!
                                                                            .interactionId)
                                                                  });
                                                                  await feedBackController.interactionDeleteViewModel(
                                                                      interactionId: feedBackController
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
                                                                    data.sId,
                                                                "ftype":
                                                                    "unlike"
                                                              });

                                                              if (feedBackController
                                                                      .feedBackLikeApiResponse
                                                                      .status ==
                                                                  Status
                                                                      .COMPLETE) {
                                                                if (kDebugMode) {
                                                                  print(
                                                                      "UNLIKE 11");
                                                                }

                                                                FeedBackLikeUnLikeResModel
                                                                    response =
                                                                    feedBackController
                                                                        .feedBackLikeApiResponse
                                                                        .data;

                                                                feedBackController
                                                                    .insideAllDisLikeMap
                                                                    .addAll({
                                                                  feedBackId: InteractionStatus(
                                                                      feedbackId:
                                                                          feedBackId,
                                                                      interactionStatus:
                                                                          true,
                                                                      count:
                                                                          data.unlike! +
                                                                              1,
                                                                      interactionId: response
                                                                          .data!
                                                                          .sId)
                                                                });
                                                              }

                                                              return;
                                                            }
                                                            feedBackController
                                                                .update();
                                                          },
                                                    child: interactionWidget(
                                                      svg: feedBackController
                                                              .insideAllDisLikeMap
                                                              .containsKey(
                                                                  myFeedBackResultsData
                                                                      .sId!)
                                                          ? feedBackController
                                                                      .insideAllDisLikeMap[
                                                                          myFeedBackResultsData
                                                                              .sId]!
                                                                      .interactionStatus ==
                                                                  true
                                                              ? SvgPicture
                                                                  .asset(
                                                                  dislikeImg,
                                                                  color: ColorUtils
                                                                      .primaryColor,
                                                                )
                                                              : SvgPicture
                                                                  .asset(
                                                                  dislikeImg,
                                                                )
                                                          : myFeedBackResultsData
                                                                      .myunlike ==
                                                                  true
                                                              ? SvgPicture
                                                                  .asset(
                                                                  dislikeImg,
                                                                  color: ColorUtils
                                                                      .primaryColor,
                                                                )
                                                              : SvgPicture
                                                                  .asset(
                                                                  dislikeImg,
                                                                ),
                                                      value: feedBackController
                                                              .insideAllDisLikeMap
                                                              .containsKey(
                                                                  myFeedBackResultsData
                                                                      .sId!)
                                                          ? feedBackController
                                                              .insideAllDisLikeMap[
                                                                  myFeedBackResultsData
                                                                      .sId]!
                                                              .count
                                                          : unLikeCount,
                                                    )),
                                                SizeConfig.sW5,
                                                InkResponse(
                                                  radius: 40,
                                                  onTap:
                                                      widget.isCompletedCamping!
                                                          ? null
                                                          : () async {
                                                              detailsScreenCall(
                                                                  feedBackController:
                                                                      feedBackController,
                                                                  isFeedBackCommentTap:
                                                                      true,
                                                                  feedBackIndex:
                                                                      index);
                                                            },
                                                  child: interactionWidget(
                                                      svg: SvgPicture.asset(
                                                        commentImg,
                                                      ),
                                                      iconPath: commentImg,
                                                      value:
                                                          myFeedBackResultsData
                                                              .comment),
                                                ),
                                                SizeConfig.sW5,
                                                DeepLinkSendWidget(
                                                    feedBackId: feedBackController
                                                        .myFeedBackResultList[
                                                            index]
                                                        .sId,
                                                    shareLink: feedBackController
                                                        .myFeedBackResultList[
                                                            index]
                                                        .shareLink,
                                                    isCompletedCamping: true),
                                              ],
                                            ),
                                            FeedBackScoreEmoji(
                                              score: score!,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          isUnlocked == false
                              ? InkWell(
                                  onTap: () async {
                                    if (isUnlocked == true) {
                                      detailsScreenCall(
                                          feedBackController:
                                              feedBackController,
                                          isFeedBackCommentTap: false,
                                          feedBackIndex: index);
                                    } else {
                                      await feedBackViewModel
                                          .paymentCoinViewModel(
                                              feedBackId: feedBackController
                                                  .myFeedBackResultList[index]
                                                  .sId);
                                      if (feedBackViewModel
                                              .paymentCoinApiResponse.status ==
                                          Status.COMPLETE) {
                                        PaymentCoinResModel response =
                                            feedBackViewModel
                                                .paymentCoinApiResponse.data;
                                        if (response.status == 200) {
                                          if (response.data!.open == false) {
                                            showSnackBar(
                                                message:
                                                    response.data!.showText,
                                                showDuration:
                                                    const Duration(seconds: 3));

                                          } else if (response.data!.open ==
                                              true) {
                                            dialogShow(
                                                response, feedBackController);
                                            return;
                                          }
                                        }
                                      }
                                    }
                                  },
                                  child: SizedBox(
                                      height: 20.w,
                                      width: 20.w,
                                      child: IconsWidgets.lockIcon),
                                )
                              : const SizedBox(),
                        ],
                      );
              }),
            ),
          ),
        );
      }),
    );
  }

  void dialogShow(
      PaymentCoinResModel response, FeedBackViewModel feedBackController) {
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
    apiCalling(feedBackViewModel: feedBackController);
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

  ///CLEAR LOCAL LIST....
  void clearLocalList() {
    feedBackViewModel.insideAllLikeMap.clear();
    feedBackViewModel.insideAllDisLikeMap.clear();
  }

  ///api calling
  apiCalling({FeedBackViewModel? feedBackViewModel}) {
    feedBackViewModel!.isFeedScrollLoading = true;

    feedBackViewModel.applicantPage = 1;
    feedBackViewModel.myFeedBackResultList.clear();
    feedBackViewModel.getMyFeed(
        userId: userFeedBackId!,
        campignId: widget.campignId,
        isExistsUser: isExistsUser == true ? true : false,
        queryKey: widget.queryKey,
        queryValue: widget.queryValue);
    clearLocalList();
  }

  Future<void> detailsScreenCall(
      {FeedBackViewModel? feedBackController,
      int? feedBackIndex,
      bool? isFeedBackCommentTap}) async {
    if (widget.isCompletedCamping!) {
      return;
    }
    await Get.to(
      FeedBackDetailsScreen(
        feedBackId:
            feedBackController!.myFeedBackResultList[feedBackIndex!].sId,
        isCommentTap: isFeedBackCommentTap ?? false,
      ),
    );
    apiCalling(feedBackViewModel: feedBackController);
  }
}
