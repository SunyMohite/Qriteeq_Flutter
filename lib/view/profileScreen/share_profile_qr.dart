import 'dart:typed_data';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:humanscoring/common/commonWidget/octo_image_widget.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/decoration_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../common/commonWidget/custom_header.dart';
import 'dart:io';

class ShareProfileQR extends StatefulWidget {
  final String id;
  final String name;
  final String imageurl;
  final String profileLink;
  ShareProfileQR(
      {Key? key, required this.id, required this.name, required this.imageurl,required this.profileLink})
      : super(key: key);
  final dynamicLinks = FirebaseDynamicLinks.instance;
  @override
  State<ShareProfileQR> createState() => _ShareProfileQRState();
}

class _ShareProfileQRState extends State<ShareProfileQR> {
  final controller = ScreenshotController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.whiteE5,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const CustomHeaderWidget(
                headerTitle: "Share Profile",
              ),
              SizeConfig.sH2,
              Screenshot(child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      width: 80.w,
                      decoration: BoxDecoration(
                          color: ColorUtils.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: ColorUtils.gray,
                              blurRadius: 15,
                              offset: Offset(1, 3),
                            )
                          ]),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizeConfig.sH6,
                            Text(
                              widget.name,
                              style: FontTextStyle.poppinsBlue14SemiB.copyWith(
                                  fontSize: 14.sp, color: ColorUtils.black),
                            ),
                            SizeConfig.sH2,
                            Container(
                              color: Colors.white,
                              child: QrImage(
                                data: widget.profileLink,
                                version: QrVersions.auto,
                                size: 150.0,
                              ),
                            ),
                            SizeConfig.sH5,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: OctoImageWidget(
                      profileLink: widget.imageurl,
                    ),
                  ),
                ],
              ),
                  controller: controller),
              SizeConfig.sH2,
              InkWell(
                onTap: () async {
                  final image = await controller.capture();
                  if (image == null) return;

                  saveAndShare(image);
                },
                child: Container(
                  height: 10.w,
                  width: 30.w,
                  decoration: DecorationUtils.allBorderAndColorDecorationBox(
                    radius: 5,
                    colors: ColorUtils.orangeF87A,
                  ),
                  child: Center(
                    child: Text(
                      VariableUtils.share,
                      style: FontTextStyle.poppinsWhite10bold,
                    ),
                  ),
                ),
              ),
              SizeConfig.sH2,
            ],
          ),
        ),
      ),
    );
  }
  Future saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.webp');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path],text:"Give this profile a feedback on QriteeQ ${widget.profileLink}");
  }
}
