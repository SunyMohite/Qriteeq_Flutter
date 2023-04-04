import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';
import 'package:humanscoring/view/reportScreen/user_generate_report_list_screen.dart';
import 'package:sizer/sizer.dart';

import '../../common/circular_progress_indicator.dart';
import '../../common/commonWidget/octo_image_widget.dart';
import '../../modal/apis/api_response.dart';
import '../../utils/color_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/size_config_utils.dart';
import '../../utils/variable_utils.dart';
import '../../viewmodel/user_generate_report_viewmodel.dart';
import '../generalScreen/no_searchfound_screen.dart';

class GenerateReportListScreen extends StatefulWidget {
  const GenerateReportListScreen({Key? key, required this.myReport})
      : super(key: key);
  final bool myReport;

  @override
  State<GenerateReportListScreen> createState() =>
      _GenerateReportListScreenState();
}

class _GenerateReportListScreenState extends State<GenerateReportListScreen> {
  UserGenerateReportViewModel viewModel = Get.find();
  late ScrollController userGenerateReportController;

  void _firstLoad() async {
    viewModel.getReportListViewModel(initLoad: true, myReport: widget.myReport);
  }

  void _loadMore() async {
    if (viewModel.isGetReportFirstLoading == false &&
        viewModel.isGetReportMoreLoading == false &&
        userGenerateReportController.position.extentAfter < 300) {
      try {
        viewModel.getReportListViewModel(myReport: widget.myReport);
      } catch (err) {
        log('Something went wrong!');
      }
    }
  }

  @override
  void initState() {
    viewModel.getReportList.clear();
    viewModel.getReportPage = 1;
    viewModel.isGetReportFirstLoading = true;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (viewModel.isGetReportFirstLoading == true) {
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
    return GetBuilder<UserGenerateReportViewModel>(
      builder: (controller) {
        if (controller.isGetReportFirstLoading) {
          return const Center(
            child: CircularIndicator(),
          );
        } else if (controller.getReportListApiResponse.status == Status.ERROR) {
          return const Center(
            child: Text("Server error"),
          );
        }

        if (controller.getReportList.isEmpty) {
          return const NoFeedBackFound(
            titleMsg: VariableUtils.youAreNotGenerateAnyReport,
            subTitleMsg: '',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            // print("widget.myReport${widget.myReport}");
            controller.getReportList.clear();
            controller.getReportPage = 1;
            controller.isGetReportFirstLoading = true;
            controller.getReportListViewModel(myReport: widget.myReport);

            return Future.value();
          },
          child: SingleChildScrollView(
            controller: userGenerateReportController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Column(
                  children:
                      List.generate(controller.getReportList.length, (index) {
                    var data = controller.getReportList[index];
                    return InkWell(
                      onTap: () {
                        Get.to(UserGenerateReportListScreen(
                          userId: controller.getReportList[index].id!,
                          userName:
                              controller.getReportList[index].userIdentity!,
                          myReport: widget.myReport,
                          screenName: '',
                        ));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 2.w,
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: Get.width,
                              color: ColorUtils.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 0.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        OctoImageWidget(
                                            profileLink: data.avatar),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: CircleAvatar(
                                            radius: 1.5.w,
                                            backgroundColor: ColorUtils.white,
                                            child: Padding(
                                              padding: EdgeInsets.all(0.5.w),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: data.online! == true
                                                      ? ColorUtils.colorGreen
                                                      : ColorUtils.colorGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizeConfig.sW3,
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
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
                                                : data.userIdentity!,
                                            style: FontTextStyle
                                                .poppins12mediumDarkBlack
                                                .copyWith(
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          SizeConfig.sW2,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  data.showText ?? 'N/A',
                                                  // 'N/A',
                                                  style: TextStyle(
                                                      fontSize: 10.sp,
                                                      color: ColorUtils
                                                          .lightGrey83),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              data.reportCount == 0
                                                  ? const SizedBox()
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          border: Border.all(
                                                              color: ColorUtils
                                                                  .grayC8)),
                                                      child: CircleAvatar(
                                                        radius: 3.5.w,
                                                        backgroundColor:
                                                            ColorUtils.white,
                                                        child: Text(
                                                          '${data.reportCount}',
                                                          style: TextStyle(
                                                              fontSize: 10.sp,
                                                              color: ColorUtils
                                                                  .black),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.w, top: 2.w),
                              child: const Divider(
                                height: 5,
                                thickness: 1,
                                color: ColorUtils.whiteEA,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                if (controller.isGetReportMoreLoading)
                  const CircularIndicator(
                    isExpand: false,
                  ),
                SizeConfig.sH1,
              ],
            ),
          ),
        );
      },
    );
  }
}

class GenerateReportListScreenForMe extends StatefulWidget {
  const GenerateReportListScreenForMe({Key? key, required this.myReport})
      : super(key: key);
  final bool myReport;

  @override
  State<GenerateReportListScreenForMe> createState() =>
      _GenerateReportListScreenForMeState();
}

class _GenerateReportListScreenForMeState
    extends State<GenerateReportListScreenForMe> {
  UserGenerateReportViewModel viewModel = Get.find();
  late ScrollController userGenerateReportController;

  void _firstLoad() async {
    viewModel.getReportListViewModel(initLoad: true, myReport: widget.myReport);
  }

  void _loadMore() async {
    if (viewModel.isGetReportFirstLoading == false &&
        viewModel.isGetReportMoreLoading == false &&
        userGenerateReportController.position.extentAfter < 300) {
      try {
        viewModel.getReportListViewModel(myReport: widget.myReport);
      } catch (err) {
        log('Something went wrong!');
      }
    }
  }

  @override
  void initState() {
    viewModel.getReportList.clear();
    viewModel.getReportPage = 1;
    viewModel.isGetReportFirstLoading = true;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (viewModel.isGetReportFirstLoading == true) {
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
    return GetBuilder<UserGenerateReportViewModel>(
      builder: (controller) {
        if (controller.isGetReportFirstLoading) {
          return const Center(
            child: CircularIndicator(),
          );
        } else if (controller.getReportListApiResponse.status == Status.ERROR) {
          return const Center(
            child: Text("Server error"),
          );
        }

        if (controller.getReportList.isEmpty) {
          return const NoFeedBackFound(
            titleMsg: VariableUtils.youAreNotGenerateAnyReport,
            subTitleMsg: '',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            // print("widget.myReport${widget.myReport}");
            controller.getReportList.clear();
            controller.getReportPage = 1;
            controller.isGetReportFirstLoading = true;
            controller.getReportListViewModel(myReport: widget.myReport);

            return Future.value();
          },
          child: SingleChildScrollView(
            controller: userGenerateReportController,
            child: Column(
              children: [
                Column(
                  children:
                      List.generate(controller.getReportList.length, (index) {
                    var data = controller.getReportList[index];
                    return InkWell(
                      onTap: () {
                        Get.to(UserGenerateReportListScreen(
                          userId: controller.getReportList[index].id!,
                          userName:
                              controller.getReportList[index].userIdentity!,
                          myReport: widget.myReport,
                          screenName: '',
                        ));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 2.w,
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: Get.width,
                              color: ColorUtils.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 0.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        OctoImageWidget(
                                            profileLink: data.avatar),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: CircleAvatar(
                                            radius: 1.5.w,
                                            backgroundColor: ColorUtils.white,
                                            child: Padding(
                                              padding: EdgeInsets.all(0.5.w),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: data.online! == true
                                                      ? ColorUtils.colorGreen
                                                      : ColorUtils.colorGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizeConfig.sW3,
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
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
                                                : data.userIdentity!,
                                            style: FontTextStyle
                                                .poppins12mediumDarkBlack
                                                .copyWith(
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          SizeConfig.sW2,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  data.showText ?? 'N/A',
                                                  // 'N/A',
                                                  style: TextStyle(
                                                      fontSize: 10.sp,
                                                      color: ColorUtils
                                                          .lightGrey83),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              data.reportCount == 0
                                                  ? const SizedBox()
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          border: Border.all(
                                                              color: ColorUtils
                                                                  .grayC8)),
                                                      child: CircleAvatar(
                                                        radius: 3.5.w,
                                                        backgroundColor:
                                                            ColorUtils.white,
                                                        child: Text(
                                                          '${data.reportCount}',
                                                          style: TextStyle(
                                                              fontSize: 10.sp,
                                                              color: ColorUtils
                                                                  .black),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.w, top: 2.w),
                              child: const Divider(
                                height: 5,
                                thickness: 1,
                                color: ColorUtils.whiteEA,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                if (controller.isGetReportMoreLoading)
                  const CircularIndicator(
                    isExpand: false,
                  ),
                SizeConfig.sH1,
              ],
            ),
          ),
        );
      },
    );
  }
}
