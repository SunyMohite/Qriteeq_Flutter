import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/circular_progress_indicator.dart';
import 'package:humanscoring/common/commonWidget/octo_image_widget.dart';
import 'package:humanscoring/modal/apiModel/res_model/your_interactions_res_model.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/const_utils.dart';
import 'package:humanscoring/utils/decoration_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/viewmodel/your_interactions_controller.dart';
import 'package:sizer/sizer.dart';

import '../../../common/commonWidget/snackbar.dart';
import '../../detailsScreen/feed_back_details_screen.dart';
import '../../home/feed_inside_page/user_profile_inside_page.dart';

class YourInteractionScreen extends StatefulWidget {
  const YourInteractionScreen({Key? key}) : super(key: key);

  @override
  State<YourInteractionScreen> createState() => _YourInteractionScreenState();
}

class _YourInteractionScreenState extends State<YourInteractionScreen> {
  YourInteractionsController viewModel = Get.find<YourInteractionsController>();

  late ScrollController yourInteractionsScrollController;

  void _firstLoad() async {
    viewModel.getYourInteractions(initLoad: true);
  }

  void _loadMore() async {
    if (viewModel.isYourInteractionsFirstLoading == false &&
        viewModel.isYourInteractionsMoreLoading == false &&
        yourInteractionsScrollController.position.extentAfter < 300) {
      try {
        viewModel.getYourInteractions();
      } catch (err) {
        log('Something went wrong!');
      }
    }
  }

  @override
  void initState() {
    viewModel.yourInteractionsList.clear();
    viewModel.yourInteractionsPage = 1;
    viewModel.isYourInteractionsFirstLoading = true;
    if (viewModel.isYourInteractionsFirstLoading == true) {
      _firstLoad();
    }

    yourInteractionsScrollController = ScrollController()
      ..addListener(_loadMore);

    super.initState();
  }

  @override
  void dispose() {
    yourInteractionsScrollController.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YourInteractionsController>(
      builder: (controller) {

        return Column(
          children: [
            SizeConfig.sH2,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  ConstUtils.userActivity.length,
                  (index) => InkWell(
                    onTap: () async {
                      controller.selected = index;
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorUtils.lightPurple.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                          border: controller.selected == index
                              ? Border.all(
                                  color: ColorUtils.blue14,
                                  width: 2,
                                )
                              : const Border(),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.w, horizontal: 3.w),
                          child: Row(
                            children: [
                              Container(
                                height: 8.w,
                                width: 8.w,
                                decoration: DecorationUtils
                                    .allBorderAndColorDecorationBox(
                                  colors: ColorUtils.lightPurple,
                                  radius: 10,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: controller.selected == index
                                      ? ConstUtils
                                          .userActivity[index].selectedIcon
                                      : ConstUtils
                                          .userActivity[index].unSelectedIcon,
                                ),
                              ),
                              SizeConfig.sW3,
                              Text(
                                "${ConstUtils.userActivity[index].title}",
                                style: FontTextStyle.poppinsBlackLightNormal
                                    .copyWith(
                                  color: controller.selected == index
                                      ? ColorUtils.blue14
                                      : ColorUtils.gray90,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ).toList(),
              ),
            ),
            SizeConfig.sH2,
            Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  controller.yourInteractionsList.clear();
                  controller.yourInteractionsPage = 1;
                  controller.isYourInteractionsFirstLoading = true;
                  controller.getYourInteractions();
                  return Future.value();
                },
                child: SingleChildScrollView(
                  controller: yourInteractionsScrollController,
                  child: Column(
                    children: [
                      Column(
                        children: List.generate(
                            controller.yourInteractionsList.length, (i) {
                          var data = [];
                          String sId = '';
                          if (controller.selected == 0) {
                            data = controller.yourInteractionsList[i].data!;
                            sId = controller.yourInteractionsList[i].sId!;
                          } else if (controller.selected == 1) {
                            data = controller.yourInteractionsList[i].data!
                                .where((e) => e.ftype == 'agree')
                                .toList();
                            sId = controller.yourInteractionsList[i].sId!;
                          } else if (controller.selected == 2) {
                            data = controller.yourInteractionsList[i].data!
                                .where((e) => e.ftype == 'disagree')
                                .toList();
                            sId = controller.yourInteractionsList[i].sId!;
                          } else if (controller.selected == 3) {
                            data = controller.yourInteractionsList[i].data!
                                .where((e) => e.ftype == 'comment')
                                .toList();
                            sId = controller.yourInteractionsList[i].sId!;
                          }

                          if (data.isEmpty) {
                            return const SizedBox();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Text(
                                  sId,
                                  style: FontTextStyle.poppinsDarkBlackSemiB
                                      .copyWith(color: ColorUtils.black),
                                ),
                              ),
                              ListView.builder(
                                itemCount: data.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  YourInteractionsDataCount listData =
                                      (data)[index];
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: InkWell(
                                          onTap: () async {
                                            if (listData
                                                    .blockStatus!.hideUser ==
                                                true) {
                                              showSnackBar(
                                                  message: listData.blockStatus!
                                                      .hideUserMessage);
                                              return;
                                            }
                                            await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserInsidePage(
                                                          screenName:
                                                              "YourInteractionScreen",
                                                          userName: listData
                                                              .feedbackUser!
                                                              .userIdentity,
                                                          avatar: listData
                                                              .feedbackUser!
                                                              .avatar!,
                                                          toId: listData
                                                              .feedbackUser!
                                                              .sId,
                                                          phone: listData
                                                              .feedbackUser!
                                                              .phone,
                                                          favorite: listData
                                                                  .defaultStatus!
                                                                  .favorite ??
                                                              false,
                                                          isBlock: listData
                                                                  .defaultStatus!
                                                                  .block ??
                                                              false,
                                                          flag: listData
                                                                  .defaultStatus!
                                                                  .flag ??
                                                              false,
                                                          online: listData
                                                              .feedbackUser!
                                                              .online,
                                                          active: listData
                                                              .feedbackUser!
                                                              .active,
                                                        )));
                                            controller.getYourInteractions();
                                          },
                                          child: OctoImageWidget(
                                              profileLink: listData
                                                  .feedbackUser!.avatar!),
                                        ),
                                        title: Html(
                                          data: listData.showText,
                                        ),
                                        subtitle: Padding(
                                          padding: EdgeInsets.only(left: 2.w),
                                          child: Text(
                                            "${listData.feedback!.text}",
                                            style: FontTextStyle
                                                .poppinsBlackLightNormal
                                                .copyWith(
                                                    fontSize: 10.sp,
                                                    color:
                                                        const Color(0xff686868),
                                                    fontWeight:
                                                        FontWeight.w400),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        onTap: () async {
                                          YourInteractionsDataCount listData =
                                              (data)[index];
                                          await Get.to(
                                            FeedBackDetailsScreen(
                                              feedBackId:
                                                  listData.feedback!.sId,
                                              isCommentTap: false,
                                            ),
                                          );

                                          controller.getYourInteractions();
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 22.w, right: 5.w),
                                        child: const Divider(
                                          height: 1,
                                          color: ColorUtils.grayD9,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              SizeConfig.sH1,
                            ],
                          );
                        }),
                      ),
                      if (controller.isYourInteractionsMoreLoading)
                        const CircularIndicator(
                          isExpand: false,
                        ),
                      SizeConfig.sH1,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
