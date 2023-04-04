import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/circular_progress_indicator.dart';
import 'package:humanscoring/modal/apiModel/res_model/dispute_res_model.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/utils/assets/icons_utils.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/decoration_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/home/home_screen.dart';
import 'package:humanscoring/viewmodel/dispute_view_model.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class DisputeScreen extends StatefulWidget {
  const DisputeScreen({Key? key, required this.feedBackId}) : super(key: key);

  final String feedBackId;

  @override
  State<DisputeScreen> createState() => _DisputeScreenState();
}

class _DisputeScreenState extends State<DisputeScreen> {
  final viewModel = Get.find<DisputeViewModel>();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await viewModel.disputeViewModel(
        feedbackId: widget.feedBackId,
        dateTime:
            '${DateFormat('MM/dd/yyyy').format(DateTime.now())} ${DateFormat('hh:mm a').format(DateTime.now())}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// header
            Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: ColorUtils.transparent,
                      borderRadius: BorderRadius.circular(150),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(150),
                        child: Padding(
                          padding: EdgeInsets.all(1.w),
                          child: IconsWidgets.backArrow,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    IconsWidgets.appLogoWhite,
                    Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: const SizedBox(),
                    )
                  ],
                ),
              ),
            ),
            SizeConfig.sH3,
            Expanded(
              child: GetBuilder<DisputeViewModel>(
                builder: (controller) {
                  if (controller.disputeApiResponse.status == Status.LOADING) {
                    return const CircularIndicator();
                  }

                  if (controller.disputeApiResponse.status == Status.ERROR) {
                    return const Center(child: Text("Server error"));
                  }

                  DisputeResModel disputeRes =
                      controller.disputeApiResponse.data;

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 7.w,
                                width: 7.w,
                                child: Image.asset('assets/icon/doneIcon.png')),
                            SizeConfig.sW2,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  disputeRes.data!.title!,
                                  style: FontTextStyle.poppins10NormalDarkBlack
                                      .copyWith(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeightClass.bold),
                                ),
                                SizeConfig.sW2,
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    disputeRes.data!.date!,
                                    style: FontTextStyle.poppins12RegularGray
                                        .copyWith(fontSize: 10.sp),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizeConfig.sH3,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Container(
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3E5FF),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'SR NUMBER: ',
                                style: FontTextStyle.poppins10NormalDarkBlack
                                    .copyWith(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeightClass.bold),
                              ),
                              Text(
                                disputeRes.data!.serialNumber!.toString(),
                                style: FontTextStyle.poppins10NormalDarkBlack
                                    .copyWith(
                                        fontSize: 12.sp,
                                        color: const Color(0xFF5562FF),
                                        fontWeight: FontWeightClass.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizeConfig.sH5,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          disputeRes.data!.showText!,
                          style: FontTextStyle.poppins10NormalDarkBlack
                              .copyWith(
                                  fontSize: 12.sp,
                                  color: const Color(0xFF404040)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: InkWell(
                          onTap: () {
                            Get.offAll(const HomeScreen());
                          },
                          child: Container(
                            height: 13.w,
                            decoration:
                                DecorationUtils.allBorderAndColorDecorationBox(
                              colors: ColorUtils.blue14,
                              radius: 7,
                            ),
                            child: Center(
                              child: Text(
                                VariableUtils.goToHome.toUpperCase(),
                                style: FontTextStyle.poppinsWhite10bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizeConfig.sH3,
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
