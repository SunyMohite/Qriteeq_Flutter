import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/profileScreen/drawerScreen/posted_feed_back_screen.dart';
import 'package:humanscoring/view/profileScreen/drawerScreen/your_interaction_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../common/commonWidget/custom_header.dart';

class UserActivityScreen extends StatefulWidget {
  const UserActivityScreen({Key? key}) : super(key: key);

  @override
  State<UserActivityScreen> createState() => _UserActivityScreenState();
}

class _UserActivityScreenState extends State<UserActivityScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const CustomHeaderWidget(
              headerTitle: VariableUtils.userActivity,
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
                  tabs: const [
                    Tab(
                      child: Text(
                        VariableUtils.postedFeedbacks,
                      ),
                    ),
                    Tab(
                      child: Text(
                        VariableUtils.yourInteractions,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  PostedFeedBacksScreen(
                    isHeaderShow: false,
                  ),
                  YourInteractionScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
