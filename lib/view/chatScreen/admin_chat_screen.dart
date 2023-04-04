import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../common/commonWidget/octo_image_widget.dart';
import '../../modal/apiModel/req_model/chat_req_model.dart';
import '../../utils/assets/icons_utils.dart';
import '../../utils/color_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/size_config_utils.dart';
import '../../utils/variable_utils.dart';
import '../home/feed_userlist_screen.dart';
import 'chat_room.dart';

class AdminChatScreen extends StatelessWidget {
  const AdminChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Column(
          children: [
            Container(
              height: 8.h,
              width: double.infinity,
              color: ColorUtils.blue1,
              padding: EdgeInsets.only(top: 0.h, left: 3.w),
              child: Row(
                children: [
                  Material(
                    color: ColorUtils.transparent,
                    borderRadius: BorderRadius.circular(150),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(150),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconsWidgets.backArrow,
                      ),
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ),
                  SizeConfig.sW2,
                  Text(
                    VariableUtils.moderateList,
                    style: FontTextStyle.poppinsWhite11semiB
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 13.sp),
                  ),
                ],
              ),
            ),
            Expanded(child: modratorChatView()),
          ],
        ),
      ),
    );
  }

  StreamBuilder<List<ConversationsModel>> modratorChatView() {
    return StreamBuilder<List<ConversationsModel>>(
        stream: getConversionList(),
        builder: (context, snapShot) {
          if (!snapShot.hasData) {
            return const SizedBox();
          }

          if (snapShot.hasError) {
            return const SizedBox();
          }

          if (snapShot.data!.isEmpty) {
            return const SizedBox();
          }

          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: snapShot.data!.map((conversationData) {
              return InkWell(
                onTap: () {
                  Get.to(
                      ChatRoom(
                        conversationsModel: conversationData,
                      ),
                      transition: Transition.cupertino);
                },
                child: Container(
                  height: 8.5.h,
                  width: Get.width,
                  margin:
                      EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: ColorUtils.orange.withOpacity(0.5),
                    borderRadius: const BorderRadius.all( Radius.circular(5)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 10,
                          offset: const Offset(3, 12))
                    ],
                  ),
                  // decoration: DecorationUtils.myProfileDecoration,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            OctoImageWidget(
                                profileLink: conversationData.recieverAvatar),
                          ],
                        ),
                        SizeConfig.sW3,
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'RE: ${conversationData.recieverusername!.isEmpty ? 'User' : conversationData.recieverusername} Feedback',
                                      style: FontTextStyle
                                          .poppins12mediumDarkBlack
                                          .copyWith(fontSize: 10.sp),
                                      maxLines: 1,
                                    ),
                                  ),
                                  // Spacer(),
                                  SizeConfig.sW2,
                                  Text(
                                    '${dateFormat(conversationData.created.toString())}',
                                    style: TextStyle(fontSize: 9.sp),
                                  ),
                                ],
                              ),
                              SizeConfig.sH1,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      conversationData.lastmessage!.isNotEmpty
                                          ? conversationData.lastmessage!
                                          : '',
                                      style: FontTextStyle.poppins12regular,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        });
  }

  String? dateFormat(String? date) {
    if (date != null) {
      var newDateFormat = DateFormat("yyyy-MM-dd");
      var newDate = newDateFormat.parse(date.toString());
      var d = DateFormat.d().format(newDate);
      var m = DateFormat('MM').format(newDate);
      var y = DateFormat.y().format(newDate);
      date = "$m/$d/$y";
    }
    return date ?? '';
  }
}
