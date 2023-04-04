import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/circular_progress_indicator.dart';
import 'package:humanscoring/common/commonWidget/custom_header.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/home/user_all_feedback.dart';
import 'package:humanscoring/viewmodel/create_campaign_view_model.dart';
import 'package:sizer/sizer.dart';

import '../../../modal/apiModel/res_model/get_campaign_id_res_model.dart';

class CampaignDetailScreen extends StatefulWidget {
  const CampaignDetailScreen(
      {Key? key,
      required this.id,
      required this.title,
      required this.isCompletedCamping})
      : super(key: key);

  final String id;
  final String title;
  final bool isCompletedCamping;

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  CreateCampaignRequestViewModel viewModel = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
    super.initState();
  }

  init() async {
    await viewModel.getCampaignIdViewModel(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.offWhiteE5,
        body: Column(
          children: [
            CustomHeaderWidget(
              headerTitle: '${VariableUtils.campaigns} -${widget.title}',
            ),
            SizedBox(
              height: 20.w,
              child: GetBuilder<CreateCampaignRequestViewModel>(
                builder: (controller) {
                  if (controller.getCampaignIdApiResponse.status ==
                          Status.LOADING ||
                      controller.getCampaignIdApiResponse.data == null) {
                    return const Center(child: CircularIndicator());
                  }
                  GetCampaignIdResModel res =
                      controller.getCampaignIdApiResponse.data;

                  return Container(
                    color: ColorUtils.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.groups_rounded,
                                  color: ColorUtils.purple68,
                                ),
                                SizeConfig.sW2,
                                Text(
                                  res.data!.feedbacksReceivedCount!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: ColorUtils.grayA8A8),
                                ),
                              ],
                            ),
                            SizeConfig.sW10,
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_month_sharp,
                                  color: ColorUtils.purple68,
                                ),
                                SizeConfig.sW1,
                                Text(
                                  res.data!.startDate!,
                                  style: const TextStyle(
                                    color: ColorUtils.grayA8A8,
                                  ),
                                ),
                                SizeConfig.sW2,
                                const Text(
                                  '-',
                                  style: TextStyle(
                                    color: ColorUtils.grayA8A8,
                                  ),
                                ),
                                SizeConfig.sW2,
                                Text(
                                  res.data!.endDate!,
                                  style: const TextStyle(
                                    color: ColorUtils.grayA8A8,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizeConfig.sH1,
                        Text(
                          res.data!.description ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizeConfig.sH1,
            Expanded(
              child: UserAllFeedBackScreen(
                  isExistsUser: true,
                  campignId: widget.id,
                  userFeedBackId: '',
                  isCompletedCamping: widget.isCompletedCamping),
            ),
          ],
        ),
      ),
    );
  }
}
