import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../utils/color_utils.dart';
import '../../utils/decoration_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/size_config_utils.dart';

class FeedBackScoreEmoji extends StatelessWidget {
  const FeedBackScoreEmoji({Key? key, required this.score}) : super(key: key);
  final String score;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DecorationUtils.shadowAndColorDecorationBox(),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          score == "fine"
              ? Image.asset(
                  "assets/icon/smileHighlight.webp",
                  scale: 1.5.w,
                )
              : score == "great"
                  ? Image.asset(
                      "assets/icon/happyHighlight.webp",
                      height: 4.w,
                      width: 4.w,
                    )
                  : score == "poor"
                      ? Image.asset(
                          "assets/icon/sadHighlight.webp",
                          height: 4.w,
                          width: 4.w,
                        )
                      : score == "bad"
                          ? Image.asset(
                              "assets/icon/angryHighlight.webp",
                              scale: 1.5.w,
                            )
                          : score == "amazing"
                              ? Image.asset(
                                  "assets/icon/amazingHighlight.webp",
                                  height: 4.w,
                                  width: 4.w,
                                )
                              : const SizedBox(),
          SizeConfig.sW2,
          Text(
            score.toString().capitalizeFirst!,
            style: FontTextStyle.poppinsOrangeF87ASemiB
                .copyWith(color: ColorUtils.blueCD),
          ),
        ],
      ),
    );
  }
}
