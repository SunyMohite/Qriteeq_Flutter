import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/commonWidget/octo_image_widget.dart';
import 'package:humanscoring/modal/apiModel/res_model/notification_res_model.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/utils/assets/images_utils.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/home/home_screen.dart';
import 'package:humanscoring/viewmodel/notification_viewmodel.dart';
import 'package:sizer/sizer.dart';

import '../../common/circular_progress_indicator.dart';
import '../../common/commonWidget/custom_header.dart';
import '../../common/commonWidget/nodatafound_widget.dart';
import '../detailsScreen/feed_back_details_screen.dart';
import '../profileScreen/drawerScreen/user_transactions_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationViewModel notificationViewModel =
      Get.find<NotificationViewModel>();

  @override
  void initState() {
    notificationViewModel.getNotificationViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const CustomHeaderWidget(
              headerTitle: VariableUtils.notification,
            ),
            Expanded(
              child: GetBuilder<NotificationViewModel>(
                builder: (notificationViewModel) {
                  if (notificationViewModel.notificationApiResponse.status ==
                      Status.LOADING) {
                    return const CircularIndicator();
                  }

                  if (notificationViewModel.notificationApiResponse.status ==
                      Status.ERROR) {
                    return const NoDataFoundWidget(message: "No Data Found");
                  }

                  NotificationResModel notificationRes =
                      notificationViewModel.notificationApiResponse.data;

                  return notificationRes.data!.isEmpty
                      ? Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.w),
                                child: ImagesWidgets.svgNotification,
                              ),
                            ),
                            Text(
                              "You have no notifications yet",
                              style: FontTextStyle.poppinsBlackLightNormal
                                  .copyWith(
                                color: ColorUtils.blue41.withOpacity(0.6),
                              ),
                            ),
                          ],
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            notificationViewModel.getNotificationViewModel();
                          },
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: notificationRes.data!.length,
                            itemBuilder: (context, index) {
                              var data = notificationRes.data![index];
                              return InkWell(
                                onTap: () {
                                  if (data.redirect != null) {
                                    if (data.redirect!.tag == 'transaction') {
                                      Get.to(const UserTransactionScreen());
                                    } else if (data.redirect!.tag ==
                                            'feedback' ||
                                        data.redirect!.tag == 'comment') {
                                      Get.to(FeedBackDetailsScreen(
                                        feedBackId: data.redirect!.id,
                                        isCommentTap:
                                            data.redirect!.tag == 'comment'
                                                ? true
                                                : false,
                                      ));
                                    } else if (data.redirect!.tag == 'home') {
                                      Get.offAll(const HomeScreen());
                                    } else {
                                      ///error or tag is un-define at that time......
                                      Get.offAll(const HomeScreen());
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.w),
                                  child: Container(
                                    width: Get.width,
                                    color: ColorUtils.white,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.w, vertical: 1.h),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          OctoImageWidget(
                                              profileLink: data.sender!.avatar),
                                          SizeConfig.sW5,
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: "${data.title}\n",
                                                        style: FontTextStyle
                                                            .poppinsDarkBlackSp11SemiB
                                                            .copyWith(
                                                          color:
                                                              ColorUtils.blue2B,
                                                          fontWeight:
                                                              FontWeightClass
                                                                  .bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: data.body ?? '',
                                                        style: FontTextStyle
                                                            .poppinsDarkBlack9Regular
                                                            .copyWith(
                                                          height: 0,
                                                          fontSize: 10.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                data.body != null
                                                    ? SizeConfig.sH05
                                                    : const SizedBox(),
                                                Text(
                                                  data.createdAt!,
                                                  style: FontTextStyle
                                                      .poppinsSp8regular
                                                      .copyWith(
                                                          color: ColorUtils
                                                              .blue2B
                                                              .withOpacity(
                                                                  0.6)),
                                                ),
                                                SizeConfig.sH1,
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
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
}
