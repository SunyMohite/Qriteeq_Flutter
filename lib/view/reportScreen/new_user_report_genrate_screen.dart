import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:humanscoring/service/download_file.dart';
import 'package:humanscoring/service/video_player.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/reportScreen/widget/chart_label_view.dart';
import 'package:humanscoring/view/reportScreen/widget/score_rating_view_widget.dart';
import 'package:octo_image/octo_image.dart';
import 'package:sizer/sizer.dart';

import '../../common/circular_progress_indicator.dart';
import '../../common/commonWidget/common_profile_icon.dart';
import '../../common/commonWidget/feedback_score_emoji.dart';
import '../../common/commonWidget/octo_image_widget.dart';
import '../../common/commonWidget/texwidget.dart';
import '../../modal/apiModel/req_model/like_unlike_req_model.dart';
import '../../modal/apiModel/res_model/get_scoring_reting_res_model.dart';
import '../../modal/apiModel/res_model/my_feed_back_response_model.dart';
import '../../modal/apis/api_response.dart';
import '../../utils/assets/icons_utils.dart';
import '../../utils/assets/images_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/shared_preference_utils.dart';
import '../../viewmodel/feedback_viewmodel.dart';
import '../generalScreen/no_searchfound_screen.dart';

class NewGenerateReport extends StatefulWidget {
  const NewGenerateReport(
      {Key? key, this.sId, this.name, this.avatar, this.isActive})
      : super(key: key);

  final String? sId;

  final String? name;
  final String? avatar;
  final bool? isActive;

  @override
  State<NewGenerateReport> createState() => _GenerateReportState();
}

class _GenerateReportState extends State<NewGenerateReport> {
  FeedBackViewModel feedBackViewModel = Get.find<FeedBackViewModel>();

  GetScoreRatingResModel getScoreRatingResModel = GetScoreRatingResModel();
  FeedBackLikeUnLikeReqModel feedBackLikeUnLikeReqModel =
      FeedBackLikeUnLikeReqModel();

  String? userFeedBackId;
  bool? isExistsUser, isDialogLoad = false;

  void _firstLoad() async {
    feedBackViewModel.applicantPage = 1;
    feedBackViewModel.myFeedBackResultList.clear();
    feedBackViewModel.getMyFeed(
        initLoad: false,
        userId: userFeedBackId!,
        queryKey: VariableUtils.userId,
        queryValue: userFeedBackId,
        isExistsUser: isExistsUser == true ? true : false);
  }

  late ScrollController feedBackListController;

  void _loadMore() async {
    if (feedBackViewModel.isFeedScrollLoading == false &&
        feedBackViewModel.isApplicantMoreLoading == false &&
        feedBackListController.position.extentAfter < 300) {
      try {
        feedBackViewModel.getMyFeed(
            userId: userFeedBackId!,
            queryKey: VariableUtils.userId,
            queryValue: userFeedBackId,
            isExistsUser: isExistsUser == true ? true : false);
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }
    }
  }

  @override
  void initState() {
    feedBackViewModel.getScoreRatingViewModel(
        sId: widget.sId, isActive: widget.isActive);
    userFeedBackId = widget.sId;
    isExistsUser = widget.isActive;
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.whiteE5,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 8.h,
              width: double.infinity,
              color: ColorUtils.blue1,
              padding: EdgeInsets.only(top: 0.h, left: 3.w),
              child: Row(
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
                    VariableUtils.generateReport,
                    style: FontTextStyle.poppinsWhite11semiB
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 13.sp),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GetBuilder<FeedBackViewModel>(
                builder: (controller) {
                  if (controller.scoreRatingApiResponse.status ==
                      Status.LOADING) {
                    return const Center(child: CircularIndicator());
                  }

                  if (controller.scoreRatingApiResponse.status ==
                      Status.ERROR) {
                    return const Center(
                      child: Text("user with given phone does not exist"),
                    );
                  }

                  getScoreRatingResModel =
                      controller.scoreRatingApiResponse.data;
                  if (getScoreRatingResModel.status == 400) {
                    return Dialog(
                      backgroundColor: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 3.5.w),
                            child: Text(
                              "${controller.scoreRatingApiResponse.data.message}",
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizeConfig.sH1,
                          SizeConfig.sH2,
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    controller: feedBackListController,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: ColorUtils.white,
                              boxShadow: [
                                BoxShadow(
                                  color: ColorUtils.grey.withOpacity(0.2),
                                  blurRadius: 5,
                                  offset: const Offset(0, 1),
                                )
                              ]),
                          // height: 15.w,
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 5.w),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        widget.sId ==
                                                PreferenceManagerUtils
                                                    .getLoginId()
                                            ? VariableUtils.you
                                            : widget.name!,
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizeConfig.sH2,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    OctoImageWidget(
                                      profileLink: widget.avatar,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${controller.receivedCount}',
                                            style:
                                                FontTextStyle.roboto10W5Black1E,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizeConfig.sH05,
                                          feedBackReceivedText(),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${controller.postedCount}',
                                            style:
                                                FontTextStyle.roboto10W5Black1E,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizeConfig.sH05,
                                          feedBackPostedText(),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizeConfig.sH1,
                        getScoreRatingResModel.data!.score == null
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          VariableUtils.overallView,
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    SizeConfig.sH1,
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Material(
                                        elevation: 5,
                                        shadowColor:
                                            Colors.grey.withOpacity(0.4),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 40.w,
                                              width: 50.w,
                                              child: DChartPie(
                                                labelColor: ColorUtils.black,
                                                pieLabel: (pieData, index) {
                                                  return "${pieData['measure']}%";
                                                },
                                                data: [
                                                  {
                                                    'domain':
                                                        'Feedback Received',
                                                    'measure':
                                                        getScoreRatingResModel
                                                            .data!
                                                            .feedbacksReceivedPercentage
                                                  },
                                                  {
                                                    'domain': 'Feedback Posted',
                                                    'measure':
                                                        getScoreRatingResModel
                                                            .data!
                                                            .feedbacksPostedPercentage
                                                  },
                                                ],
                                                fillColor: (pieData, index) =>
                                                    index == 0
                                                        ? ColorUtils.chartPosted
                                                        : ColorUtils
                                                            .chartReview,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const ChatLabelView(
                                                      title: VariableUtils
                                                          .postedFeedback,
                                                      colorName: ColorUtils
                                                          .chartReview),
                                                  SizeConfig.sH1,
                                                  const ChatLabelView(
                                                      title: VariableUtils
                                                          .receivedFeedback,
                                                      colorName: ColorUtils
                                                          .chartPosted),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizeConfig.sH1,
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              VariableUtils.scoreRatingOverview,
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        StoreRatingViewWidget(
                                          title: 'Amazing',
                                          image: amazingImg,
                                          percent: getScoreRatingResModel
                                                  .data!.score!.amazing! /
                                              100,
                                        ),
                                        StoreRatingViewWidget(
                                          title: 'Great',
                                          image: greatImg,
                                          percent: getScoreRatingResModel
                                                  .data!.score!.great! /
                                              100,
                                        ),
                                        StoreRatingViewWidget(
                                          title: 'Fine',
                                          image: fineImg,
                                          percent: getScoreRatingResModel
                                                  .data!.score!.fine! /
                                              100,
                                        ),
                                        StoreRatingViewWidget(
                                          title: 'Poor',
                                          image: poorImg,
                                          percent: getScoreRatingResModel
                                                  .data!.score!.poor! /
                                              100,
                                        ),
                                        StoreRatingViewWidget(
                                          title: 'Bad',
                                          image: badImg,
                                          percent: getScoreRatingResModel
                                                  .data!.score!.bad! /
                                              100,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                        SizeConfig.sH1,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              VariableUtils.allFeedbacks,
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        SizeConfig.sH2,
                        generateReportMethod(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget generateReportMethod() {
    return GetBuilder<FeedBackViewModel>(builder: (feedBackController) {
      if (feedBackController.isFeedScrollLoading) {
        return const Center(
          child: CircularIndicator(),
        );
      }
      if (feedBackController.myFeedBackResultList.isEmpty) {
        return const NoFeedBackFound();
      }
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: feedBackController.myFeedBackResultList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          MyFeedBackResults myFeedBackResultsData =
              feedBackController.myFeedBackResultList[index];

          var name = myFeedBackResultsData.sender == null
              ? ''
              : ((myFeedBackResultsData.sender!.id ==
                          PreferenceManagerUtils.getLoginId()) &&
                      myFeedBackResultsData.anonymous == false)
                  ? VariableUtils.you
                  : myFeedBackResultsData.anonymous == true
                      ? VariableUtils.anonymous
                      : myFeedBackResultsData.sender!.userIdentity ?? '';
          var country =
              myFeedBackResultsData.sender!.countryName ?? VariableUtils.global;
          var flagUrl = myFeedBackResultsData.sender!.flagUrl;
          var profileType = myFeedBackResultsData.user!.profileType;
          var time = myFeedBackResultsData.createdAt;
          var review = myFeedBackResultsData.text;
          var score = myFeedBackResultsData.score;
          var relation = myFeedBackResultsData.relation;
          var reviewType = myFeedBackResultsData.reviewType;

          return Padding(
            padding: const EdgeInsets.only(bottom: 6.0, top: 4),
            child: Container(
              decoration: BoxDecoration(
                color: ColorUtils.white,
                boxShadow: [
                  BoxShadow(
                    color: ColorUtils.grey.withOpacity(0.3),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        SizedBox(width: 1.w),
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp,
                          ),
                        ),
                        SizeConfig.sW1,
                        profileIconSetWidget(profileType: profileType!),
                      ],
                    ),
                    SizeConfig.sH1,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                color: ColorUtils.blacklight,
                                fontSize: 10.sp)),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Text(
                          "${reviewType.toString().capitalizeFirst}",
                          style: FontTextStyle.poppinsBlue14SemiB.copyWith(
                              color: ColorUtils.blue14, fontSize: 10.sp),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizeConfig.sW4,
                        Material(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(200)),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 1.w),
                            child: Text(
                              "${relation.toString().capitalizeFirst}",
                              style: FontTextStyle.poppinsBlue14SemiB
                                  .copyWith(color: ColorUtils.blueCD),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizeConfig.sW4,
                        FeedBackScoreEmoji(
                          score: score!,
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            review!,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: ColorUtils.black,
                                height: 1.6,
                                fontSize: 10.sp),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 1.h),
                    myFeedBackResultsData.document == null ||
                            myFeedBackResultsData.document!.isEmpty ||
                            myFeedBackResultsData.document!.first.url == null
                        ? const SizedBox()
                        : ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: index == 0 ? 0 : 0,
                              sigmaY: index == 0 ? 0 : 0,
                              tileMode: TileMode.decal,
                            ),
                            child: VariableUtils.imageFormatList.contains(
                                    myFeedBackResultsData.document!.first.ext!
                                        .toUpperCase())
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(2.w),
                                    child: OctoImage(
                                      image: CachedNetworkImageProvider(
                                        myFeedBackResultsData
                                            .document!.first.url!,
                                      ),
                                      placeholderBuilder:
                                          OctoPlaceholder.blurHash(
                                        'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                      ),
                                      height: 80.w,
                                      width: double.infinity,
                                      errorBuilder:
                                          OctoError.icon(color: Colors.red),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  )
                                : VariableUtils.videoFormatList.contains(
                                        myFeedBackResultsData
                                            .document!.first.ext
                                            .toString()
                                            .toUpperCase())
                                    ? VideoPlayerService(
                                        key: ValueKey(myFeedBackResultsData
                                            .document!.first.url!),
                                        url: myFeedBackResultsData
                                            .document!.first.url!,
                                      )
                                    : VariableUtils.videoFormatList.contains(
                                            myFeedBackResultsData
                                                .document!.first.ext
                                                .toString()
                                                .toUpperCase())
                                        ? InkWell(
                                            onTap: () {
                                              firebaseDownloadFile(
                                                      myFeedBackResultsData
                                                          .document!.first.url!,
                                                      DateTime.now()
                                                          .microsecondsSinceEpoch)
                                                  .then((value) async {
                                                await Future.delayed(
                                                  const Duration(seconds: 2),
                                                );
                                                Get.back();
                                              });
                                            },
                                            child: Container(
                                              width: Get.width,
                                              height: 15.w,
                                              alignment: Alignment.centerRight,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: ColorUtils.grey
                                                    .withOpacity(0.2),
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
                                                          child: const Icon(Icons
                                                              .assignment_outlined)),
                                                      SizedBox(
                                                        width: 1.w,
                                                      ),
                                                      const Text(
                                                          'Click to download file'),
                                                    ],
                                                  ),
                                                  const Icon(Icons.download),
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                          ),
                    SizedBox(height: 1.h),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
