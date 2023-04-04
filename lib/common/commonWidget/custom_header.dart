import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../utils/assets/icons_utils.dart';
import '../../utils/color_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/size_config_utils.dart';
import '../../utils/variable_utils.dart';
import '../../view/home/home_screen.dart';

class CustomHeaderWidget extends StatelessWidget {
  final String? headerTitle, screenName;
  const CustomHeaderWidget(
      {Key? key, required this.headerTitle, this.screenName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18.w,
      width: Get.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorUtils.blue14,
            ColorUtils.blue74,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Row(
          children: [
            VariableUtils.referEndEarn == headerTitle
                ? const SizedBox()
                : Material(
                    color: ColorUtils.transparent,
                    borderRadius: BorderRadius.circular(150),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(150),
                      child: Padding(
                        padding: EdgeInsets.all(1.w),
                        child: IconsWidgets.backArrow,
                      ),
                      onTap: () {
                        // Get.back();
                        if (screenName == 'AppNotification') {
                          Get.offAll(const HomeScreen());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
            SizeConfig.sW3,
            Expanded(
              child: Text(
                headerTitle!,
                style: FontTextStyle.poppinsWhite11semiB,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
