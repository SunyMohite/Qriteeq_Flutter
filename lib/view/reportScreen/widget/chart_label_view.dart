import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChatLabelView extends StatelessWidget {
  const ChatLabelView({Key? key, this.title, this.colorName}) : super(key: key);
  final String? title;
  final Color? colorName;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.w,
      child: Row(
        children: [
          CircleAvatar(
            radius: 2.w,
            backgroundColor: colorName,
          ),
          SizedBox(
            width: 2.h,
          ),
          Expanded(
            child: Text(
              title!,
              style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              overflow: TextOverflow.visible,
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }
}
