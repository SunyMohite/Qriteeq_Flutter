import 'package:flutter/material.dart';

import '../../common/commonWidget/custom_header.dart';
import '../../utils/color_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/variable_utils.dart';
import 'generate_report_list_screen.dart';

class NewTabBarUserReportScreen extends StatefulWidget {
  const NewTabBarUserReportScreen({Key? key}) : super(key: key);

  @override
  State<NewTabBarUserReportScreen> createState() =>
      _NewTabBarUserReportScreenState();
}

class _NewTabBarUserReportScreenState extends State<NewTabBarUserReportScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  // myReport
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            const CustomHeaderWidget(
              headerTitle: VariableUtils.userReport,
            ),
            Container(
              color: const Color(0xff969AFF).withOpacity(0.10),
              child: TabBar(
                labelStyle:
                    FontTextStyle.fontStyle.copyWith(color: ColorUtils.grayA5),
                unselectedLabelStyle:
                    FontTextStyle.fontStyle.copyWith(color: ColorUtils.grayA5),
                unselectedLabelColor: ColorUtils.grayA5,
                labelColor: ColorUtils.blue14,
                padding: EdgeInsets.zero,
                indicatorColor: ColorUtils.blue14,
                tabs: [
                  Tab(
                    text: VariableUtils.myDownloads,
                  ),
                  Tab(
                    text: VariableUtils.downloadsForMe,
                  )
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(color: ColorUtils.blue14, width: 5.0),
                  insets: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  GenerateReportListScreen(
                    myReport: true,
                  ),
                  GenerateReportListScreen(
                    myReport: false,
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
