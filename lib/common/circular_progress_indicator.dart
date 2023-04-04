import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class CircularIndicator extends StatelessWidget {
  const CircularIndicator({Key? key, this.isExpand, this.bgColor})
      : super(key: key);
  final bool? isExpand;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isExpand == false ? 35.w : Get.height,
      width: isExpand == false ? 35.w : Get.width,
      color: bgColor ?? Colors.white.withOpacity(0.5),
      child: Center(
        child:
            Lottie.asset('assets/json/loader.json', height: 35.w, width: 35.w),
      ),
    );
  }
}
