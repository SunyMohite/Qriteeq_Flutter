import 'package:flutter/material.dart';
import '../../utils/color_utils.dart';
import '../../utils/font_style_utils.dart';

typedef OnPress = Function();

class CustomButtons extends StatelessWidget {
  const CustomButtons({Key? key, required this.buttonName, this.onTap})
      : super(key: key);

  final String? buttonName;
  final OnPress? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: Material(
        color: ColorUtils.blue14,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15),
              child: Text(
                buttonName!,
                style: FontTextStyle.poppinsWhite20Bold.copyWith(fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
