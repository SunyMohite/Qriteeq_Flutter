import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:sizer/sizer.dart';

String basePath = 'assets/icon/';
String bottomBasePath = 'assets/icon/bottomIcons/';

String gallaryImg = "assets/icon/Frame.webp";
String purpleCamera = "assets/icon/purpleCamera.webp";
String viedocallImg = "assets/icon/video.webp";
String pdfImg = "assets/icon/document.webp";
String messageImg = "assets/icon/chat.webp";

String earthImg = "assets/icon/earth.svg";
String tickImg = "assets/icon/darkGreySingleTick.webp";
String doubletickImg = "assets/icon/readGreenRight.webp";
String likeImg = "assets/icon/thumbsUp.svg";
String likeBorder = "assets/icon/likeBorder.webp";
String unlikeBorder = "assets/icon/unlike.webp";
String commantBorder = "assets/icon/commant.webp";
String dislikeImg = "assets/icon/thumbDown.svg";
String commentImg = "assets/icon/commentGrey.svg";
String shareImg = "assets/icon/shareGrey.svg";

class IconsWidgets {
  static String likeSvg = "assets/icon/like.svg";
  static String grayLikeSvg = "assets/icon/grayLike.svg";
  static String disLikeSvg = "assets/icon/disLike.svg";
  static String grayDisLikeSvg = "assets/icon/grayDislike.svg";
  static String commentSvg = "assets/icon/comment.svg";
  static String grayCommentSvg = "assets/icon/grayComment.svg";

  static Image walletCoin = Image.asset(
    'assets/icon/walletCoin.webp',
    scale: 1.w,
    fit: BoxFit.fill,
  );

  static Image blackStar = Image.asset(
    'assets/icon/blackStar.webp',
    height: 5.w,
    width: 5.w,
  );
  static Image redStar = Image.asset(
    'assets/icon/redStar.webp',
    height: 5.w,
    width: 5.w,
  );
  static Image blackHeart = Image.asset(
    'assets/icon/blackHeart.webp',
    height: 5.w,
    width: 5.w,
  );
  static Image redHeart = Image.asset(
    'assets/icon/favred.webp',
    height: 5.w,
    width: 5.w,
  );
  static Image appLogoWhite = Image.asset(
    'assets/icon/appLogoWhite.webp',
    scale: 1.w,
  );
  static Image disputeIcon = Image.asset(
    'assets/icon/dispute.webp',
    scale: 1.w,
  );

  static Image bellIcon = Image.asset("${basePath}bellIcon.webp", scale: 1.w);
  static Image notificationIcon =
      Image.asset("${basePath}notificationicon.webp", scale: 1.w);

  static Image userIcon = Image.asset(
    "${basePath}userIcon.webp",
    scale: 1.w,
  );
  static Image correct = Image.asset(
    "${basePath}correct.webp",
    scale: 1.w,
  );

  static Image camera = Image.asset(
    "${basePath}camera.webp",
  );
  static Image video = Image.asset(
    "${basePath}video.webp",
  );
  static Image document = Image.asset(
    "${basePath}document.webp",
  );

  static Image photo = Image.asset(
    "${basePath}photo.webp",
  );

  static Image faceBook = Image.asset(
    "${basePath}facebook.webp",
    scale: 1.w,
  );

  static Image angryHighlight = Image.asset(
    "${basePath}angryHighlight.webp",
    scale: 1.w,
  );

  static Widget mobile = Image.asset(
    "${basePath}mobile.webp",
    scale: 1.w,
  );

  static Widget iosBackArrow = Image.asset(
    "${basePath}circleBackArrow.webp",
    scale: 1.w,
  );
  static Widget iosForwardArrow = Image.asset(
    "${basePath}circleNextArrow.webp",
    scale: 1.w,
  );
  static Widget backArrow = SvgPicture.asset(
    "${basePath}backArrow.svg",
  );
  static Widget backArrowBlack = SvgPicture.asset(
    "${basePath}backArrow.svg",
    color: ColorUtils.black,
  );

  static Widget popupMenu = SvgPicture.asset(
    "${basePath}popupMenu.svg",
  );
  static Widget popupMenuColor = SvgPicture.asset(
    "${basePath}popupMenu.svg",
    color: ColorUtils.gray90,
  );

  static Widget orangeLock = SvgPicture.asset(
    "${basePath}orangeLock.svg",
  );

  static Widget purpleLock = SvgPicture.asset(
    "${basePath}purpleLock.svg",
  );
  static Widget upArrow = SvgPicture.asset(
    "${basePath}upArrow.svg",
  );
  static Widget uploadProof = SvgPicture.asset(
    "${basePath}uploadProof.svg",
  );
  static Widget send = SvgPicture.asset(
    "${basePath}send.svg",
  );
  static Widget like = SvgPicture.asset(
    "${basePath}like.svg",
  );
  static Widget arrowIcon = SvgPicture.asset(
    "${basePath}arrow.svg",
  );
  static Widget purpleLike = SvgPicture.asset(
    "${basePath}like.svg",
    color: ColorUtils.blue14,
  );
  static Widget disLike = SvgPicture.asset(
    "${basePath}disLike.svg",
  );
  static Widget purpleDisLike = SvgPicture.asset(
    "${basePath}disLike.svg",
    color: ColorUtils.blue14,
  );

  static Widget purpleComment = SvgPicture.asset(
    "${basePath}commentPurple.svg",
  );
  static Widget like1 = SvgPicture.asset(
    "${basePath}like.svg",
    height: 5.w,
    width: 5.w,
  );
  static Widget disLike1 = SvgPicture.asset(
    "${basePath}disLike.svg",
    height: 5.w,
    width: 5.w,
  );

  static Widget star = SvgPicture.asset(
    "${basePath}star.svg",
  );
  static Widget blueStar = SvgPicture.asset(
    "${basePath}star.svg",
    color: ColorUtils.blue14,
    height: 4.w,
    width: 4.w,
  );
  static Widget orangeStar = SvgPicture.asset(
    "${basePath}star.svg",
    color: ColorUtils.orangeF1,
    height: 4.w,
    width: 4.w,
  );
  static Widget pin = SvgPicture.asset(
    "${basePath}pin.svg",
    height: 4.w,
    width: 4.w,
  );

  static Widget grayLike = SvgPicture.asset(
    "${basePath}grayLike.svg",
  );
  static Widget grayDislike = SvgPicture.asset(
    "${basePath}grayDislike.svg",
  );
  static Widget grayComment = SvgPicture.asset(
    "${basePath}grayComment.svg",
  );
  static Widget grayUserActivity = SvgPicture.asset(
    "${basePath}grayUserActivity.svg",
  );

  static Widget lockIcon = Image.asset(
    "${basePath}lockIcon.webp",
    scale: 1.w,
  );

  static final more = SvgPicture.asset(
    '${basePath}more.svg',
    height: 18,
  );
  static final close = SvgPicture.asset(
    '${basePath}close.svg',
    height: 3.5.h,
  );
  static final whiteClose = SvgPicture.asset(
    '${basePath}Whiteclose.svg',
  );

  static Widget linkYourAccount = SvgPicture.asset(
    '${basePath}linkYourAccount.svg',
  );
  static Widget userActivity = SvgPicture.asset(
    '${basePath}userActivity.svg',
    color: ColorUtils.blue14,
  );
  static Widget userActivitylightGrey7A = SvgPicture.asset(
    '${basePath}userActivity.svg',
    color: ColorUtils.lightGrey7A,
  );
  static Widget shareViaQr = SvgPicture.asset(
    '${basePath}shareViaQr.svg',
  );
  static Widget leaderboard = SvgPicture.asset(
    '${basePath}leaderBoard.svg',
  );
  static Widget pdfDownload = SvgPicture.asset(
    '${basePath}pdfDownload.svg',
  );
  static Widget faqs = SvgPicture.asset(
    '${basePath}faq.svg',
  );
  static Widget transaction = SvgPicture.asset(
    '${basePath}transaction.svg',
  );
  static Widget featureReqIcon = SvgPicture.asset(
    '${basePath}featureReqIcon.svg',
  );

  static Widget forwardArrow = SvgPicture.asset(
    '${basePath}forwardArrow.svg',
  );

  static Widget shareGrey = SvgPicture.asset(
    '${basePath}shareGrey.svg',
    height: 5.w,
    width: 5.w,
  );
  static Widget termsAndCondition = SvgPicture.asset(
    '${basePath}tearmsAndCondition.svg',
    color: ColorUtils.lightGrey7A,
  );

  static Widget logOut = SvgPicture.asset(
    '${basePath}logout.svg',
  );
  static Widget deleteSvg = SvgPicture.asset(
    "${basePath}delete.svg",
  );
  static Widget greyCircle = SvgPicture.asset(
    '${basePath}greyCircle.svg',
  );
  static Widget rightIconArrow = SvgPicture.asset(
    '${basePath}rightIconArrow.svg',
    color: Colors.white,
  );

  static Widget checkDPRating = SvgPicture.asset(
    '${basePath}rate.svg',
  );
  static Widget chatwithModerator = SvgPicture.asset(
    '${basePath}chatmoderator.svg',
  );
  static Image chat =
  Image.asset("${basePath}chat2.webp", scale: 1.w);

  static Image chatNotif =
  Image.asset("${basePath}chatnotif.webp", scale: 1.w);

  static Image pollsIcon =
  Image.asset("${basePath}polls.webp", scale: 1.w);

}
