import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/circular_progress_indicator.dart';
import 'package:humanscoring/common/commonWidget/snackbar.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/generalScreen/no_searchfound_screen.dart';
import 'package:humanscoring/view/profileScreen/campaign/campaign_details_screen.dart';
import 'package:humanscoring/viewmodel/create_campaign_view_model.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/shared_preference_utils.dart';

class OnGoingCampaignScreen extends StatefulWidget {
  final bool active;

  const OnGoingCampaignScreen({Key? key, required this.active})
      : super(key: key);

  @override
  State<OnGoingCampaignScreen> createState() => _OnGoingCampaignScreenState();
}

class _OnGoingCampaignScreenState extends State<OnGoingCampaignScreen> {
  CreateCampaignRequestViewModel viewModel = Get.find();
  late ScrollController getCampaignScrollController;

  void _firstLoad() async {
    viewModel.getCampaignViewModel(initLoad: true, active: widget.active);
  }

  void _loadMore() async {
    if (viewModel.isGetCampaignFirstLoading == false &&
        viewModel.isGetCampaignMoreLoading == false &&
        getCampaignScrollController.position.extentAfter < 300) {
      try {
        viewModel.getCampaignViewModel(active: widget.active);
      } catch (err) {
        log('Something went wrong!');
      }
    }
  }

  @override
  void initState() {
    viewModel.getCampaignList.clear();
    viewModel.getCampaignPage = 1;
    viewModel.isGetCampaignFirstLoading = true;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (viewModel.isGetCampaignFirstLoading == true) {
        _firstLoad();
      }
    });
    getCampaignScrollController = ScrollController()..addListener(_loadMore);
    super.initState();
  }

  @override
  void dispose() {
    getCampaignScrollController.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateCampaignRequestViewModel>(
      builder: (controller) {
        if (controller.isGetCampaignFirstLoading) {
          return const Center(
            child: CircularIndicator(),
          );
        } else if (controller.getCampaignApiResponse.status == Status.ERROR) {
          return const Center(
            child: Text("Server error"),
          );
        }

        if (controller.getCampaignList.isEmpty) {
          return const NoFeedBackFound(
            titleMsg: VariableUtils.oopsNoCampaignMadeYet,
            subTitleMsg: VariableUtils.makeCampaignKnowWhatTheySay,
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: () {
              controller.getCampaignList.clear();
              controller.getCampaignPage = 1;
              controller.isGetCampaignFirstLoading = true;
              controller.getCampaignViewModel(active: widget.active);

              return Future.value();
            },
            child: SingleChildScrollView(
              controller: getCampaignScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Column(
                    children: List.generate(
                      controller.getCampaignList.length,
                      (index) {
                        var data = controller.getCampaignList[index];
                        return Material(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(1.w),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(9),
                              onTap: () {
                                Get.to(() => CampaignDetailScreen(
                                    id: data.id!,
                                    title: data.title!,
                                    isCompletedCamping: false));
                              },
                              child: Container(
                                padding: EdgeInsets.all(2.w),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFFD3D3D3)),
                                  borderRadius: BorderRadius.circular(9),
                                  // color: ColorUtils.white,
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizeConfig.sH1,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data.title!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF515365),
                                            ),
                                          ),
                                          Material(
                                            child: InkResponse(
                                              radius: 20,
                                              onTap: () async {
                                                if (data
                                                    .campaignLink!.isEmpty) {
                                                  showSnackBar(
                                                      message:
                                                          'Something went to wrong!!!',
                                                      snackColor:
                                                          ColorUtils.red);
                                                  return;
                                                }
                                                await Clipboard.setData(ClipboardData(
                                                    text: "Hey there! ${PreferenceManagerUtils.getAvatarUserName()} is inviting you to post a review for them on QriteeQ. Click on this link:"
                                                        " ${data.campaignLink} to visit his profile.\nRegards,\nTeam QriteeQ"));
                                                showSnackBar(
                                                    message: VariableUtils
                                                        .copyCampaignLink);
                                              },
                                              child: const Icon(
                                                Icons.copy,
                                                color: ColorUtils.grey,
                                                size: 20,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizeConfig.sH1,
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_month_sharp,
                                            color: ColorUtils.purple68,
                                          ),
                                          SizeConfig.sW1,
                                          Text(
                                            data.startDate!,
                                            style: const TextStyle(
                                              color: ColorUtils.purple68,
                                            ),
                                          ),
                                          SizeConfig.sW2,
                                          const Text(
                                            '-',
                                            style: TextStyle(
                                              color: ColorUtils.purple68,
                                            ),
                                          ),
                                          SizeConfig.sW2,
                                          Text(
                                            data.endDate!,
                                            style: const TextStyle(
                                              color: ColorUtils.purple68,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizeConfig.sH1,
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.groups_rounded,
                                            color: ColorUtils.purple68,
                                          ),
                                          SizeConfig.sW2,
                                          Text(
                                            data.feedbacksReceivedCount!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: ColorUtils.greenE8,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (controller.isGetCampaignMoreLoading)
                    const CircularIndicator(
                      isExpand: false,
                    ),
                  SizeConfig.sH1,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
