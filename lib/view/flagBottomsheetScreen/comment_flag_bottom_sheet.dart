import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../common/circular_progress_indicator.dart';
import '../../common/commonWidget/snackbar.dart';
import '../../common/my_clip_path.dart';
import '../../modal/apiModel/req_model/like_unlike_req_model.dart';
import '../../modal/apis/api_response.dart';
import '../../utils/assets/icons_utils.dart';
import '../../utils/assets/images_utils.dart';
import '../../utils/color_utils.dart';
import '../../utils/decoration_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/shared_preference_utils.dart';
import '../../utils/size_config_utils.dart';
import '../../utils/variable_utils.dart';
import '../../viewmodel/feedback_viewmodel.dart';
import '../flagReportScreen/flag_report_screen.dart';

class CommentFlagBottomSheet extends StatefulWidget {
  final String? sId;
  final String? commentId;

  const CommentFlagBottomSheet({Key? key, this.sId, this.commentId})
      : super(key: key);

  @override
  State<CommentFlagBottomSheet> createState() => _CommentFlagBottomSheetState();
}

class _CommentFlagBottomSheetState extends State<CommentFlagBottomSheet> {
  FeedBackLikeUnLikeReqModel feedBackLikeUnLikeReqModel =
      FeedBackLikeUnLikeReqModel();
  FeedBackViewModel feedBackController = Get.find();

  @override
  void initState() {
    feedBackController.selected = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return GetBuilder<FeedBackViewModel>(
          builder: (feedBackController) {
            return Container(
              height: 140.w,
              decoration: DecorationUtils.verticalBorderAndColorDecorationBox(
                colors: ColorUtils.white,
                radius: 20,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipPath(
                                clipper: MyClipPath(),
                                child: Container(
                                  height: 45.w,
                                  width: MediaQuery.of(context).size.width,
                                  color: ColorUtils.pinkFF,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 3.w, vertical: 5.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(),
                                        ImagesWidgets.unDrawFlagged,
                                        InkWell(
                                          child: IconsWidgets.close,
                                          onTap: () {
                                            Get.back();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Text(
                                  VariableUtils.flag,
                                  style: FontTextStyle.poppins15darkBluesemiB,
                                ),
                              )
                            ],
                          ),
                          SizeConfig.sH3,
                          Center(
                            child: Text(
                              VariableUtils.areYouFeedBack,
                              style: FontTextStyle.poppinsDarkBlackNormal,
                            ),
                          ),
                          SizeConfig.sH2,
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                            ),
                            child: Text(
                              VariableUtils.reasonReporting,
                              style: FontTextStyle.poppinsGrayA1Sp11,
                            ),
                          ),
                          SizeConfig.sH2,
                          const Divider(
                            height: 2,
                            color: ColorUtils.gray,
                          ),
                          Column(
                              children: VariableUtils.reporting
                                  .map((e) => Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 3.w,
                                          vertical: 3.w,
                                        ),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  feedBackController.selected =
                                                      e;
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 5.w,
                                                    width: 5.w,
                                                    decoration: DecorationUtils
                                                        .allBorderAndColorDecorationBox(
                                                      colors: ColorUtils.white,
                                                      radius: 10,
                                                    ).copyWith(
                                                      border: Border.all(
                                                        color: ColorUtils.black,
                                                      ),
                                                    ),
                                                    child: feedBackController
                                                                .selected ==
                                                            e
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            child: CircleAvatar(
                                                              radius: 2.w,
                                                              backgroundColor:
                                                                  ColorUtils
                                                                      .purple,
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ),
                                                  SizeConfig.sW2,
                                                  Text(
                                                    e,
                                                    style: FontTextStyle
                                                        .poppinsBlackLightNormal
                                                        .copyWith(
                                                            color: feedBackController
                                                                        .selected ==
                                                                    e
                                                                ? ColorUtils
                                                                    .purple
                                                                : null),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizeConfig.sH1,
                                            const Divider(
                                              height: 2,
                                              color: ColorUtils.gray,
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList()),
                          SizeConfig.sH2,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                      height: 10.w,
                                      decoration: DecorationUtils
                                          .allBorderAndColorDecorationBox(
                                        radius: 5,
                                      ).copyWith(
                                          border: Border.all(
                                        color: ColorUtils.blue14,
                                      )),
                                      child: Center(
                                        child: Text(
                                          VariableUtils.cancel,
                                          style:
                                              FontTextStyle.poppinsBlue14bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizeConfig.sW5,
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      // log("REPORT TAP..... ${widget.commentId}");
                                      feedBackLikeUnLikeReqModel.user =
                                          PreferenceManagerUtils.getLoginId();
                                      feedBackLikeUnLikeReqModel.feedback =
                                          widget.sId;
                                      feedBackLikeUnLikeReqModel.ftype = "flag";
                                      feedBackLikeUnLikeReqModel.flagged =
                                          widget.commentId;
                                      feedBackLikeUnLikeReqModel.reason =
                                          feedBackController.selected
                                              .toString();
                                      try {
                                        await feedBackController
                                            .feedBackCommentFlagViewModel(
                                                feedBackLikeUnLikeReqModel
                                                    .toJsonCommentFlag());
                                        if (feedBackController
                                                .feedBackCommentFlagApiResponse
                                                .status ==
                                            Status.ERROR) {
                                          showSnackBar(
                                              message: 'Something went wrong');
                                          Get.back();
                                          return;
                                        }
                                        if (feedBackController
                                                .feedBackCommentFlagApiResponse
                                                .status ==
                                            Status.COMPLETE) {
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            Get.back();
                                            Get.to(const FlagReportScreen());
                                          });
                                        }
                                      } on Exception catch (e) {
                                        if (kDebugMode) {
                                          print(e);
                                        }
                                        showSnackBar(
                                            message: 'Something went wrong');
                                        Get.back();
                                        // TODO
                                      }
                                    },
                                    child: Container(
                                      height: 10.w,
                                      decoration: DecorationUtils
                                          .allBorderAndColorDecorationBox(
                                        colors: ColorUtils.blue14,
                                        radius: 5,
                                      ),
                                      child: Center(
                                        child: Text(
                                          VariableUtils.report,
                                          style:
                                              FontTextStyle.poppinsWhite10bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizeConfig.sH2,
                        ],
                      ),
                    ),
                    if (feedBackController.feedBackLikeApiResponse.status ==
                        Status.LOADING)
                      const CircularIndicator(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
