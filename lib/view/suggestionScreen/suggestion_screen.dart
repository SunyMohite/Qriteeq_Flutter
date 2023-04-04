import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/view/home/home_screen.dart';
import 'package:sizer/sizer.dart';
import '../../utils/const_utils.dart';
import '../../utils/decoration_utils.dart';
import '../../utils/font_style_utils.dart';
import '../loginScreen/user_register_screen.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  PageController pageController = PageController(initialPage: 0);

  int pageChange = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/suggest/suggest_bg.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 60.h,
              child: PageView(
                controller: pageController,
                onPageChanged: (val) {
                  setState(() {
                    pageChange = val;
                  });
                },
                children: [
                  Image.asset(
                    'assets/suggest/1.webp',
                    scale: 1.2.w,
                  ),
                  Image.asset(
                    'assets/suggest/2.webp',
                    scale: 1.2.w,
                  ),
                  Image.asset(
                    'assets/suggest/3.webp',
                    scale: 1.2.w,
                  ),
                  Image.asset(
                    'assets/suggest/4.webp',
                    scale: 1.2.w,
                  ),
                  Image.asset(
                    'assets/suggest/5.webp',
                    scale: 1.2.w,
                  ),
                  Image.asset(
                    'assets/suggest/6.webp',
                    scale: 1.2.w,
                  ),
                ],
              ),
            ),
            SizeConfig.sH3,
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Material(
                color: ColorUtils.blue14,
                child: InkWell(
                  onTap: () {
                    ConstUtils.isNewUser == true
                        ? Get.offAll(const UserRegisterScreen())
                        : Get.offAll(const HomeScreen());
                  },
                  child: Container(
                    height: 11.w,
                    width: 40.w,
                    decoration: DecorationUtils.allBorderAndColorDecorationBox(
                      // colors: ColorUtils.blue14,
                      radius: 7,
                    ),
                    child: Center(
                      child: Text(
                        pageChange == 5 ? 'Get Started' : 'Skip',
                        style: FontTextStyle.poppinsWhite10bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizeConfig.sH3,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (index) => Container(
                  height: 3.w,
                  width: 3.w,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pageChange == index
                          ? ColorUtils.purple68
                          : ColorUtils.grayD9),
                ),
              ),
            ),
            SizeConfig.sH3,
          ],
        ),
      ),
    );
  }
}
