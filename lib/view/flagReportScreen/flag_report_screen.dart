import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/assets/images_utils.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/decoration_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:sizer/sizer.dart';

import '../../common/commonWidget/custom_header.dart';

class FlagReportScreen extends StatelessWidget {
  const FlagReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const CustomHeaderWidget(
              headerTitle: VariableUtils.reportReceived,
            ),
            SizeConfig.sH2,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      ImagesWidgets.blueCircle,
                      Container(
                        height: 20.w,
                        width: 1.w,
                        color: ColorUtils.gray.withOpacity(0.8),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            VariableUtils.reportReceived,
                            style: FontTextStyle.poppinsDarkBlack12bold,
                          ),
                          SizeConfig.sH1,
                          Text(
                            VariableUtils.reportMessage,
                            style: FontTextStyle.poppinsDarkBlack9Regular,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      ImagesWidgets.blueCircle,
                      Container(
                        height: 20.w,
                        width: 1.w,
                        color: ColorUtils.gray.withOpacity(0.8),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            VariableUtils.inReview,
                            style: FontTextStyle.poppinsDarkBlack12bold,
                          ),
                          SizeConfig.sH1,
                          Text(
                            VariableUtils.reviewMessage,
                            style: FontTextStyle.poppinsDarkBlack9Regular,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 5.5.w,
                    width: 5.5.w,
                    decoration: DecorationUtils.allBorderAndColorDecorationBox(
                      colors: ColorUtils.grayF5,
                      radius: 10,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: CircleAvatar(
                        backgroundColor: ColorUtils.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            VariableUtils.decisionMade,
                            style: FontTextStyle.poppinsDarkBlack12bold,
                          ),
                          SizeConfig.sH1,
                          Text(
                            VariableUtils.decisionMessage,
                            style: FontTextStyle.poppinsDarkBlack9Regular,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 20.w,
                width: 100.w,
                color: ColorUtils.white,
                child: Center(
                  child: Text(
                    VariableUtils.done,
                    style: FontTextStyle.poppinsBlue14bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
