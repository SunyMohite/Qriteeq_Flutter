import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

Widget textBox({
  required String text,
  Color? color,
  required FontWeight fontWeight,
  double? height,
  required double fontSize,
  int? maxLine,
  String? fontFamily,
  TextAlign? align,
  EdgeInsetsGeometry? padding,
}) =>
    Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: Text(
        text,
        maxLines: maxLine,
        textAlign: align ?? TextAlign.center,
        style: textStyle(
          color: color ?? ColorUtils.black,
          fontWeight: fontWeight,
          fontSize: fontSize,
          fontFamily: fontFamily,
        ),
      ),
    );

TextStyle textStyle({
  Color color = ColorUtils.white,
  required FontWeight fontWeight,
  required double fontSize,
  String? fontFamily,
}) =>
    TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily ?? 'workSans');
