import 'package:flutter/material.dart';
import 'package:humanscoring/utils/assets/images_utils.dart';
import 'package:sizer/sizer.dart';

Widget profileIconSetWidget({required String profileType}) {
  profileType = profileType.toLowerCase();
  return profileType == 'facebook'
      ? Image.asset(
          "${baseImgPath}facebook.webp",
          scale: 2.2.w,
        )
      : profileType == 'instagram'
          ? Image.asset(
              "${baseImgPath}Instagram.webp",
              scale: 1.w,
            )
          : profileType == 'gmail'
              ? Image.asset(
                  "${baseImgPath}Gmail.webp",
                  scale: 1.w,
                )
              : profileType == 'twitter'
                  ? Image.asset(
                      "${baseImgPath}twitter.webp",
                      scale: 1.w,
                    )
                  : profileType == 'mobile' || profileType == 'hs'
                      ? Image.asset(
                          "${baseImgPath}mobile.webp",
                          scale: 1.w,
                        )
                      : profileType == 'linkedin'
                          ? Image.asset(
                              "${baseImgPath}linkedin.webp",
                              scale: 8.w,
                            )
                          : Image.asset(
                              "${baseImgPath}mobile.webp",
                              scale: 1.w,
                            );
}
