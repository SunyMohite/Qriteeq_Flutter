import 'package:flutter/material.dart';
import 'package:humanscoring/newwidget/text_and_style.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:sizer/sizer.dart';

import '../utils/typedef_utils.dart';

Widget appBar({
  required String label,
  IconData? icon,
  VoidCallback? onTap,
  String? iconright,
  VoidCallback? onTapright,
  OnPopUpTap? onPopUpTap,
  bool? isHideOption,
  required Widget? favSub,
  List<PopupMenuEntry<int>>? popupMenuItem,
}) =>
    SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(left: 5.w, right: 3.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: onTap,
              child: Icon(
                icon,
                size: 28,
                color: ColorUtils.black,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  label,
                  textAlign: TextAlign.left,
                  style: textStyle(
                    color: ColorUtils.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                    fontFamily: 'workSans',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(
              width: 3.w,
            ),
            favSub ?? const SizedBox(),
            isHideOption == true
                ? const SizedBox()
                : PopupMenuButton(
                    tooltip: '',
                    onSelected: onPopUpTap,
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) {
                      return popupMenuItem!;
                    },
                  ),
          ],
        ),
      ),
    );
