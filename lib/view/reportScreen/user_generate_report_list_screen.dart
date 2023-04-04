import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';
import 'package:sizer/sizer.dart';

import '../../common/circular_progress_indicator.dart';
import '../../common/commonWidget/custom_header.dart';
import '../../common/commonWidget/octo_image_widget.dart';
import '../../modal/apis/api_response.dart';
import '../../utils/color_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/size_config_utils.dart';
import '../../utils/variable_utils.dart';
import '../../viewmodel/user_generate_report_viewmodel.dart';
import '../generalScreen/no_searchfound_screen.dart';
import '../home/home_screen.dart';
import 'user_report_generated_screen.dart';

class UserGenerateReportListScreen extends StatefulWidget {
  const UserGenerateReportListScreen(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.myReport,
      required this.screenName})
      : super(key: key);
  final String userId, userName, screenName;
  final bool myReport;

  @override
  State<UserGenerateReportListScreen> createState() =>
      _GenerateReportListScreenState();
}

class _GenerateReportListScreenState
    extends State<UserGenerateReportListScreen> {
  UserGenerateReportViewModel userGenerateReportViewModel = Get.find();
  late ScrollController userGenerateReportController;

  void _firstLoad() async {
    userGenerateReportViewModel.getUserReportListViewModel(
        initLoad: true, userId: widget.userId, myReport: widget.myReport);
  }

  void _loadMore() async {
    if (userGenerateReportViewModel.isGetUserReportFirstLoading == false &&
        userGenerateReportViewModel.isGetUserReportMoreLoading == false &&
        userGenerateReportController.position.extentAfter < 300) {
      try {
        userGenerateReportViewModel.getUserReportListViewModel(
            userId: widget.userId, myReport: widget.myReport);
      } catch (err) {
        log('Something went wrong!');
      }
    }
  }

  ///one min.....
  @override
  void initState() {
    userGenerateReportViewModel.getUserReportList.clear();
    userGenerateReportViewModel.getUserReportPage = 1;
    userGenerateReportViewModel.isGetUserReportFirstLoading = true;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (userGenerateReportViewModel.isGetUserReportFirstLoading == true) {
        _firstLoad();
      }
    });

    userGenerateReportController = ScrollController()..addListener(_loadMore);

    super.initState();
  }

  @override
  void dispose() {
    userGenerateReportController.removeListener(_loadMore);
    super.dispose();
  }

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
                  headerTitle: "${widget.userName} Report",
                  screenName: 'AppNotification'),
              Expanded(
                child: GetBuilder<UserGenerateReportViewModel>(
                  builder: (userGenerateReportViewModel) {
                    if (userGenerateReportViewModel
                        .isGetUserReportFirstLoading) {
                      return const Center(
                        child: CircularIndicator(),
                      );
                    } else if (userGenerateReportViewModel
                            .getUserReportListApiResponse.status ==
                        Status.ERROR) {
                      return const Center(
                        child: Text("Server error"),
                      );
                    }

                    if (userGenerateReportViewModel.getUserReportList.isEmpty) {
                      return const NoFeedBackFound(
                        titleMsg: VariableUtils.youAreNotGenerateAnyReport,
                        subTitleMsg: '',
                      );
                    }

                    return userGenerateReportViewModel.getUserReportList.isEmpty
                        ? Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10.w),
                                child: Image.asset(
                                  'assets/image/noFeedBackFound.webp',
                                  scale: 1,
                                ),
                              ),
                              Text(
                                "You have no any report yet",
                                style: FontTextStyle.poppinsBlackLightNormal
                                    .copyWith(
                                  color: ColorUtils.blue41.withOpacity(0.6),
                                ),
                              ),
                            ],
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              userGenerateReportViewModel.getUserReportList
                                  .clear();
                              userGenerateReportViewModel.getUserReportPage = 1;
                              userGenerateReportViewModel
                                  .isGetUserReportFirstLoading = true;
                              userGenerateReportViewModel
                                  .getUserReportListViewModel(
                                      userId: widget.userId,
                                      myReport: widget.myReport);
                              return Future.value();
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                    userGenerateReportViewModel
                                        .getUserReportList.length, (index) {
                                  var data = userGenerateReportViewModel
                                      .getUserReportList[index];

                                  if (data.reportOf == null) {
                                    return const SizedBox();
                                  }
                                  return InkWell(
                                    onTap: () {
                                      var data = userGenerateReportViewModel
                                          .getUserReportList[index];

                                      Get.to(
                                          UserReportGeneratedScreen(
                                            userGenerateReportData: data,
                                          ),
                                          transition: Transition.cupertino);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 2.w,
                                      ),
                                      child: Container(
                                        width: Get.width,
                                        color: ColorUtils.white,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.w, vertical: 1.h),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              OctoImageWidget(
                                                  profileLink:
                                                      data.reportOf!.avatar),
                                              SizeConfig.sW3,
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      PreferenceManagerUtils
                                                                  .getLoginId() ==
                                                              data.id
                                                          ? VariableUtils.you
                                                          : data.reportOf!
                                                              .userIdentity!,
                                                      style: FontTextStyle
                                                          .poppins12mediumDarkBlack
                                                          .copyWith(
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    SizeConfig.sH1,
                                                    Text(
                                                      '${data.showText}',
                                                      maxLines: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizeConfig.sW3,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
