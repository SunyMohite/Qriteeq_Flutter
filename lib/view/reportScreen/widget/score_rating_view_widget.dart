import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/size_config_utils.dart';

class StoreRatingViewWidget extends StatelessWidget {
  final String? image, title;
  final double? percent;
  const StoreRatingViewWidget(
      {Key? key,
      required this.image,
      required this.title,
      required this.percent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(1.w),
                  child: Image.asset(image!),
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.orange),
                        ),
                        Text(
                          "${(percent! * 100).toInt().toString()}%",
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: ColorUtils.green),
                        )
                      ],
                    ),
                    SizeConfig.sH2,
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      animation: true,
                      lineHeight: 2.w,
                      barRadius: const Radius.circular(5),
                      percent: percent!,
                      // ignore: deprecated_member_use
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.orange,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
