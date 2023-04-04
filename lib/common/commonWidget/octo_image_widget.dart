import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:sizer/sizer.dart';

import '../../utils/assets/icons_utils.dart';

class OctoImageWidget extends StatelessWidget {
  OctoImageWidget({Key? key, required this.profileLink, this.radius})
      : super(key: key);
  String? profileLink;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    profileLink ??= DateTime.now().microsecondsSinceEpoch.toString();
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: radius ?? 6.w,
      child: OctoImage(
        image: CachedNetworkImageProvider(profileLink!),
        progressIndicatorBuilder:
            OctoProgressIndicator.circularProgressIndicator(),
        imageBuilder: OctoImageTransformer.circleAvatar(),
        errorBuilder: (context, ob, st) {
          return IconsWidgets.userIcon;
        },
        fit: BoxFit.cover,
      ),
    );
  }
}