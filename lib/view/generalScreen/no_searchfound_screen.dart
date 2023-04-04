import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../utils/color_utils.dart';
import '../../utils/size_config_utils.dart';

class NoFeedBackFound extends StatelessWidget {
  const NoFeedBackFound({Key? key, this.titleMsg, this.subTitleMsg})
      : super(key: key);

  final String? titleMsg, subTitleMsg;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorUtils.white,
      child: SafeArea(
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizeConfig.sH5,
                Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Image.asset(
                    'assets/image/noFeedBackFound.webp',
                    scale: 1,
                  ),
                ),
                Text(
                  titleMsg ?? 'No FeedBacks yet!',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                  textAlign: TextAlign.center,
                ),
                SizeConfig.sH2,
                Text(
                  subTitleMsg ?? 'Be the first to give feedback',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 10.sp,
                      color: ColorUtils.grey85),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NoResultFound extends StatelessWidget {
  const NoResultFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorUtils.white,
      child: SafeArea(
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Image.asset(
                    'assets/image/noResultFound.png',
                    scale: 1,
                  ),
                ),
                Text(
                  'No Results',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                  textAlign: TextAlign.center,
                ),
                SizeConfig.sH2,
                Text(
                  'Sorry, there are no results for this search.\n Please try another phrase',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 10.sp,
                      color: ColorUtils.grey85),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
