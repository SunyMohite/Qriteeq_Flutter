import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

Widget materialButton({
  required String submitText,
  required Color buttonColor,
  required double height,
  double? width,
  required void Function() onTap,
  required double fontSize,
  String? fontFamily,
  FontWeight? fontWeight,
  EdgeInsetsGeometry? padding,
}) =>
    InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 0),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(5),
          child: Container(
            height: height,
            width: width ?? double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
                child: Text(
              submitText,
              style: TextStyle(
                fontWeight: fontWeight ?? FontWeight.w700,
                color: ColorUtils.blue14,
                fontSize: fontSize,
                fontFamily: 'Roboto',
              ),
            )),
          ),
        ),
      ),
    );
