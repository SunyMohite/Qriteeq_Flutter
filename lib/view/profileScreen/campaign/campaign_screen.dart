import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/commonWidget/custom_header.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/profileScreen/campaign/compeleted_campaign_screen.dart';
import 'package:humanscoring/view/profileScreen/campaign/create_campaign_screen.dart';
import 'package:humanscoring/view/profileScreen/campaign/ongoing_campaign_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/font_style_utils.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({Key? key}) : super(key: key);

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int? tabSelector = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.whiteE5,
        body: Column(
          children: [
            const CustomHeaderWidget(
              headerTitle: VariableUtils.campaigns,
            ),
            Container(
              height: 12.w,
              width: Get.width,
              color: const Color(0xff969AFF).withOpacity(0.10),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: TabBar(
                  labelStyle: FontTextStyle.fontStyle,
                  unselectedLabelStyle: FontTextStyle.fontStyle,
                  unselectedLabelColor: ColorUtils.grayA5,
                  labelColor: ColorUtils.blue14,
                  indicatorColor: ColorUtils.blue14,
                  indicatorWeight: 4,
                  controller: _tabController,
                  onTap: (val) {
                    setState(() {
                      tabSelector = val;
                    });
                  },
                  tabs: [
                    Tab(
                      child: Text(
                        VariableUtils.ongoing.toUpperCase(),
                      ),
                    ),
                    Tab(
                      child: Text(
                        VariableUtils.completed.toUpperCase(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  OnGoingCampaignScreen(
                    active: true,
                  ),
                  CompletedCampaignScreen(
                    active: false,
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.to(() => CreateCampaignScreen(
                  active: tabSelector == 0 ? true : false,
                ));
          },
          backgroundColor: ColorUtils.blue14,
          label: const Text('Create a Campaign'),
        ),
      ),
    );
  }
}
