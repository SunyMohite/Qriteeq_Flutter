import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/commonWidget/common_profile_icon.dart';
import 'package:humanscoring/common/commonWidget/custom_button.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/feedsSearchScreen/search_data_screen.dart';
import 'package:octo_image/octo_image.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../../common/circular_progress_indicator.dart';
import '../../common/commonWidget/feedback_score_emoji.dart';
import '../../common/commonWidget/octo_image_widget.dart';
import '../../common/commonWidget/snackbar.dart';
import '../../common/deeplink_send_widget.dart';
import '../../modal/apiModel/res_model/global_feedback_res_model.dart';
import '../../modal/apiModel/res_model/like_unlike_res_model.dart';
import '../../modal/apis/api_response.dart';
import '../../service/download_file.dart';
import '../../service/video_player.dart';
import '../../utils/assets/icons_utils.dart';
import '../../utils/assets/images_utils.dart';
import '../../utils/const_utils.dart';
import '../../utils/no_leading_space_formatter.dart';
import '../../utils/shared_preference_utils.dart';
import '../../viewmodel/address_book_viewmodel.dart';
import '../../viewmodel/feedback_viewmodel.dart';
import '../../viewmodel/global_feedback_viewmodel.dart';
import '../../viewmodel/notification_viewmodel.dart';
import '../detailsScreen/feed_back_details_screen.dart';
import '../generalScreen/no_searchfound_screen.dart';
import '../home/feed_inside_page/user_profile_inside_page.dart';
import '../notificationScreen/notification_screen.dart';
import '../profileScreen/profile_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController searchBarController = TextEditingController();
  NotificationViewModel notificationViewModel =
      Get.find<NotificationViewModel>();
  GlobalFeedBackViewModel globalFeedBackViewModel =
      Get.find<GlobalFeedBackViewModel>();
  late ScrollController globalFeedBackPostedController;
  FeedBackViewModel feedBackController = Get.find();

  @override
  void initState() {
    clearLocalList();
    notificationViewModel.notificationViewModel();
    globalFeedBackViewModel.globalFeedBackDataResults.clear();
    globalFeedBackViewModel.globalFeedBackPostedPage = 1;
    globalFeedBackViewModel.isGlobalFeedBackPostedFirstLoading = true;

    if (globalFeedBackViewModel.isGlobalFeedBackPostedFirstLoading == true) {
      _firstLoad();
    }
    globalFeedBackPostedController = ScrollController()..addListener(_loadMore);

    super.initState();
  }

  void _firstLoad() {
    globalFeedBackViewModel.getGlobalFeedBackPosted(initLoad: false);
  }

  void _loadMore() {
    if (globalFeedBackViewModel.isGlobalFeedBackPostedFirstLoading == false &&
        globalFeedBackViewModel.isFeedBackPostedMoreLoading == false &&
        globalFeedBackPostedController.position.extentAfter < 300) {
      try {
        globalFeedBackViewModel.getGlobalFeedBackPosted(initLoad: false);
      } catch (error) {
        log("Something went to wrong");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
          color: ColorUtils.offWhiteE5,
          child: GetBuilder<NotificationViewModel>(
            builder: (controller) {
              return Column(
                children: [
                  Stack(
                    children: [
                      ImagesWidgets.appbarBackground,
                      Positioned(
                          child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 2.h),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(const ProfileScreen());
                              },
                              child: GetBuilder<AddressBookViewModel>(
                                  builder: (addressCon) {
                                return OctoImageWidget(
                                  profileLink: addressCon.setUserAvatar,
                                  radius: 4.2.w,
                                );
                              }),
                            ),
                            SizeConfig.sW3,
                            IconsWidgets.appLogoWhite,
                            const Spacer(),
                            GetBuilder<NotificationViewModel>(
                                builder: (controller) {
                              if (controller
                                      .notificationCountApiResponse.status ==
                                  Status.LOADING) {
                                return const SizedBox();
                              }
                              return Padding(
                                padding: EdgeInsets.only(right: 2.w, top: 1.w),
                                child: InkWell(
                                  onTap: () async {
                                    await Get.to(const NotificationScreen());
                                    controller.update();
                                  },
                                  child: controller.notificationCount == 0
                                      ? IconsWidgets.notificationIcon
                                      : IconsWidgets.bellIcon,
                                ),
                              );
                            })
                          ],
                        ),
                      ))
                    ],
                  ),
                  Expanded(
                    child: GetBuilder<GlobalFeedBackViewModel>(
                      builder: (controller) {
                        if (controller.isGlobalFeedBackPostedFirstLoading) {
                          return const Center(
                            child: CircularIndicator(),
                          );
                        }

                        if (controller.globalFeedBackDataResults.isEmpty) {
                          return const NoFeedBackFound(
                            titleMsg: 'No Posted Feedback yet!',
                            subTitleMsg: 'Be the first to give feedback',
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () {
                            apiCalling(globalFeedController: controller);
                            return Future.value();
                          },
                          child: SingleChildScrollView(
                            controller: globalFeedBackPostedController,
                            child: Column(
                              children: [
                                Container(
                                  color: ColorUtils.white,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 3.h),
                                  child: Column(
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: TextStyle(
                                              color: ColorUtils.blue14,
                                              fontSize: 12.sp),
                                          text: 'Find people via their ',
                                          children: const [
                                            TextSpan(
                                              text:
                                                  'LinkedIn, Instagram, Twitter, Facebook ',
                                              style: TextStyle(
                                                  color: ColorUtils.orangeF87A,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            TextSpan(
                                              text:
                                                  'profiles. Simply copy & paste their profile links!',
                                              style: TextStyle(
                                                  color: ColorUtils.blue14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizeConfig.sH1,
                                      Image.asset(
                                          'assets/image/explore_bg.webp'),
                                      SizeConfig.sH1,
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Material(
                                          color: ColorUtils.blue14,
                                          child: InkWell(
                                            onTap: () async {
                                              await Get.to(
                                                  const SearchDataScreen(
                                                      itsFirstTime: true));
                                              apiCalling(
                                                  globalFeedController:
                                                      globalFeedBackViewModel);
                                            },
                                            child: Container(
                                              width: Get.width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 10),
                                                child: Text(
                                                  VariableUtils.search,
                                                  style: FontTextStyle
                                                      .poppinsWhite20Bold
                                                      .copyWith(fontSize: 14),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
                                //   child: SizedBox(
                                //     height: 50,
                                //     child: TextFormField(
                                //       controller: searchBarController,
                                //       textCapitalization: TextCapitalization.none,
                                //       inputFormatters: [NoLeadingSpaceFormatter()],
                                //       decoration: InputDecoration(
                                //           border: OutlineInputBorder(
                                //               borderSide: BorderSide.none,
                                //               borderRadius: BorderRadius.circular(20)),
                                //           fillColor: ColorUtils.white,
                                //           filled: true,
                                //           hintText: "Search feedback",
                                //           hintStyle: FontTextStyle.poppins12semiB,
                                //           contentPadding: const EdgeInsets.only(
                                //             top: 3,
                                //           ),
                                //           prefixIcon: Padding(
                                //             padding: const EdgeInsets.only(
                                //               top: 13.5,
                                //               bottom: 13.5,
                                //             ),
                                //             child: SvgPicture.asset(
                                //               'assets/icon/searchBlack.svg',
                                //             ),
                                //           )),
                                //       onChanged: (searchText) async {
                                //         log("Please searchText $searchText");
                                //         if (searchText.isNotEmpty) {
                                //           globalFeedBackViewModel.getGlobalFeedBackPosted(initLoad: false);
                                //           for(int i=0;i<controller.globalFeedBackDataResults.length;i++)
                                //             {
                                //               if(globalFeedBackViewModel.globalFeedBackDataResults[i].text.toString().contains(searchText))
                                //                 {
                                //                   logs("Data Found: "+globalFeedBackViewModel.globalFeedBackDataResults[i].text.toString());
                                //                 }
                                //             }
                                //         }
                                //       },
                                //     ),
                                //   ),
                                // ),
                                Column(
                                  children: List.generate(
                                      controller.globalFeedBackDataResults
                                          .length, (index) {
                                    GlobalFeedBackDataResults data = controller
                                        .globalFeedBackDataResults[index];
                                    // logs("Data Found: "+data.text.toString());
                                    if (data.sender == null ||
                                        data.user == null) {
                                      return const SizedBox();
                                    }
                                    var name = data.sender == null
                                        ? ''
                                        : data.sender!.id ==
                                                    PreferenceManagerUtils
                                                        .getLoginId() &&
                                                data.anonymous == false
                                            ? VariableUtils.you
                                            : data.anonymous == true
                                                ? VariableUtils.anonymous
                                                : data.sender == null
                                                    ? ''
                                                    : data.sender!.userIdentity;
                                    var userName = data.user == null
                                        ? ''
                                        : data.user!.id ==
                                                PreferenceManagerUtils
                                                    .getLoginId()
                                            ? VariableUtils.you
                                            : data.user == null
                                                ? ''
                                                : data.user!.userIdentity;

                                    var time = data.createdAt;
                                    var review = data.text;
                                    var score = data.score;
                                    var country = data.sender!.countryName ??
                                        VariableUtils.global;
                                    var senderFlagUrl = data.user!.flagUrl;
                                    var senderProfileType =
                                        data.user!.profileType;
                                    var userFlagUrl = data.sender!.flagUrl;
                                    var userProfileType =
                                        data.sender!.profileType;
                                    return InkWell(
                                      onTap: () async {
                                        detailsScreenCall(
                                            feedBackIndex: index,
                                            isFeedBackCommentTap: false,
                                            globalFeedBackViewModel:
                                                controller);
                                      },
                                      child:
                                          data.user == null ||
                                                  data.sender == null
                                              ? const SizedBox()
                                              : Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 1.h, top: 0),
                                                  child: Material(
                                                    elevation: 1,
                                                    color: ColorUtils.white,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 15.0,
                                                          vertical: 10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Wrap(
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .center,
                                                            children: [
                                                              /// ==========USER=============
                                                              userFlagUrl ==
                                                                          '' ||
                                                                      userFlagUrl ==
                                                                          null
                                                                  ? Image.asset(
                                                                      "${baseImgPath}world.webp",
                                                                      scale:
                                                                          9.w,
                                                                    )
                                                                  : SvgPicture
                                                                      .network(
                                                                      userFlagUrl,
                                                                      height:
                                                                          5.w,
                                                                      width:
                                                                          5.w,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                              SizeConfig.sW1,
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  GlobalFeedBackDataResults
                                                                      data =
                                                                      controller
                                                                              .globalFeedBackDataResults[
                                                                          index];
                                                                  if (data.senderReceiverBlockStatus!
                                                                          .hideUserSender ==
                                                                      true) {
                                                                    showSnackBar(
                                                                        message: data
                                                                            .senderReceiverBlockStatus!
                                                                            .hideUserMessageSender);
                                                                    return;
                                                                  }
                                                                  if (data.anonymous ==
                                                                      true) {
                                                                    return;
                                                                  }
                                                                  await Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (context) => UserInsidePage(
                                                                                screenName: 'ExploreScreen',
                                                                                userName: userName,
                                                                                avatar: data.sender!.avatar,
                                                                                toId: data.sender!.id,
                                                                                phone: data.sender!.phone,
                                                                                favorite: data.defaultStatus == null ? false : data.defaultStatus!.sender!.favorite,
                                                                                isBlock: data.defaultStatus == null ? false : data.defaultStatus!.sender!.block,
                                                                                flag: data.defaultStatus == null ? false : data.defaultStatus!.sender!.flag,
                                                                                online: data.sender!.online,
                                                                                active: data.sender!.active,
                                                                              )));
                                                                },
                                                                child: Text(
                                                                  name!,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        10.sp,
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              profileIconSetWidget(
                                                                  profileType:
                                                                      userProfileType!),
                                                              SizeConfig.sW1,
                                                              IconsWidgets
                                                                  .arrowIcon,
                                                              SizeConfig.sW1,

                                                              /// ==========SENDER=============
                                                              senderFlagUrl ==
                                                                          '' ||
                                                                      senderFlagUrl ==
                                                                          null
                                                                  ? Image.asset(
                                                                      "${baseImgPath}world.webp",
                                                                      scale:
                                                                          9.w,
                                                                    )
                                                                  : SvgPicture
                                                                      .network(
                                                                      senderFlagUrl,
                                                                      height:
                                                                          5.w,
                                                                      width:
                                                                          5.w,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                              SizeConfig.sW1,
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  GlobalFeedBackDataResults
                                                                      data =
                                                                      controller
                                                                              .globalFeedBackDataResults[
                                                                          index];
                                                                  if (data.senderReceiverBlockStatus!
                                                                          .hideUserReceiver ==
                                                                      true) {
                                                                    showSnackBar(
                                                                        message: data
                                                                            .senderReceiverBlockStatus!
                                                                            .hideUserMessageReceiver);
                                                                    return;
                                                                  }
                                                                  await Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (context) => UserInsidePage(
                                                                                screenName: 'ExploreScreen',
                                                                                userName: userName,
                                                                                avatar: data.user!.avatar,
                                                                                toId: data.user!.id,
                                                                                phone: data.user!.phone,
                                                                                favorite: data.defaultStatus == null ? false : data.defaultStatus!.receiver!.favorite,
                                                                                isBlock: data.defaultStatus == null ? false : data.defaultStatus!.receiver!.block,
                                                                                flag: data.defaultStatus == null ? false : data.defaultStatus!.receiver!.flag,
                                                                                online: data.user!.online,
                                                                                active: data.user!.active,
                                                                              )));
                                                                },
                                                                child: userName
                                                                            .toString()
                                                                            .length >=
                                                                        22
                                                                    ? Text(
                                                                        userName
                                                                            .toString()
                                                                            .substring(0,
                                                                                20),
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              10.sp,
                                                                        ),
                                                                      )
                                                                    : Text(
                                                                        userName!,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              10.sp,
                                                                        ),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                              ),
                                                              SizeConfig.sW1,
                                                              profileIconSetWidget(
                                                                  profileType:
                                                                      senderProfileType!),
                                                            ],
                                                          ),
                                                          SizeConfig.sH1,
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  earthImg,
                                                                  height: 4.w,
                                                                  width: 4.w,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                              Text(
                                                                "  $country",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: ColorUtils
                                                                        .blacklight,
                                                                    fontSize:
                                                                        10.sp),
                                                              ),
                                                              Text(" . $time",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: ColorUtils
                                                                          .blacklight,
                                                                      fontSize:
                                                                          10.sp)),
                                                            ],
                                                          ),
                                                          SizedBox(height: 1.h),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: ReadMoreText(
                                                              review!,
                                                              trimLines: 2,
                                                              colorClickableText:
                                                                  Colors.pink,
                                                              trimMode:
                                                                  TrimMode.Line,
                                                              trimCollapsedText:
                                                                  ' Show more',
                                                              trimExpandedText:
                                                                  ' Show less',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      ColorUtils
                                                                          .black,
                                                                  height: 1.6,
                                                                  fontSize:
                                                                      10.sp),
                                                              lessStyle: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      ColorUtils
                                                                          .grey,
                                                                  height: 1.6,
                                                                  fontSize:
                                                                      10.sp),
                                                              moreStyle: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      ColorUtils
                                                                          .grey,
                                                                  height: 1.6,
                                                                  fontSize:
                                                                      10.sp),
                                                            ),
                                                          ),
                                                          SizedBox(height: 1.h),
                                                          data.document ==
                                                                      null ||
                                                                  data.document!
                                                                      .isEmpty ||
                                                                  data
                                                                          .document!
                                                                          .first
                                                                          .url ==
                                                                      null
                                                              ? const SizedBox()
                                                              : ImageFiltered(
                                                                  imageFilter:
                                                                      ImageFilter
                                                                          .blur(
                                                                    sigmaX:
                                                                        index ==
                                                                                0
                                                                            ? 0
                                                                            : 0,
                                                                    sigmaY:
                                                                        index ==
                                                                                0
                                                                            ? 0
                                                                            : 0,
                                                                    tileMode:
                                                                        TileMode
                                                                            .decal,
                                                                  ),
                                                                  child: VariableUtils.imageFormatList.contains(data
                                                                          .document!
                                                                          .first
                                                                          .ext!
                                                                          .toUpperCase())
                                                                      ? ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(2.w),
                                                                          child:
                                                                              OctoImage(
                                                                            image:
                                                                                CachedNetworkImageProvider(
                                                                              data.document!.first.url!,
                                                                            ),
                                                                            placeholderBuilder:
                                                                                OctoPlaceholder.blurHash(
                                                                              'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                                            ),
                                                                            height:
                                                                                80.w,
                                                                            width:
                                                                                double.infinity,
                                                                            errorBuilder:
                                                                                OctoError.icon(color: Colors.red),
                                                                            fit:
                                                                                BoxFit.fitWidth,
                                                                          ),
                                                                        )
                                                                      : VariableUtils.videoFormatList.contains(data
                                                                              .document!
                                                                              .first
                                                                              .ext
                                                                              .toString()
                                                                              .toUpperCase())
                                                                          ? VideoPlayerService(
                                                                              key: ValueKey(data.document!.first.url!),
                                                                              url: data.document!.first.url!,
                                                                            )
                                                                          : VariableUtils.documentFormatList.contains(data.document!.first.ext.toString().toUpperCase())
                                                                              ? InkWell(
                                                                                  onTap: () {
                                                                                    firebaseDownloadFile(data.document!.first.url!, DateTime.now().microsecondsSinceEpoch).then((value) async {
                                                                                      await Future.delayed(
                                                                                        const Duration(seconds: 2),
                                                                                      );
                                                                                      Get.back();
                                                                                    });
                                                                                  },
                                                                                  child: Container(
                                                                                    width: Get.width,
                                                                                    height: 15.w,
                                                                                    alignment: Alignment.centerRight,
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(8),
                                                                                      color: ColorUtils.grey.withOpacity(0.2),
                                                                                    ),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: [
                                                                                            SizedBox(height: 6.w, width: 6.w, child: const Icon(Icons.assignment_outlined)),
                                                                                            SizedBox(
                                                                                              width: 1.w,
                                                                                            ),
                                                                                            const Text('Click to download file'),
                                                                                          ],
                                                                                        ),
                                                                                        const Icon(Icons.download),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : const SizedBox(),
                                                                ),
                                                          SizedBox(height: 1.h),
                                                          FeedBackScoreEmoji(
                                                            score: score!,
                                                          ),
                                                          SizedBox(height: 1.h),
                                                          VariableUtils
                                                                      .feedBackStatusList
                                                                      .contains(data
                                                                          .status) &&
                                                                  (data.showText !=
                                                                      null)
                                                              ? Column(
                                                                  children: [
                                                                    const SizedBox(),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              1.h),
                                                                      child:
                                                                          Container(
                                                                        color: const Color(
                                                                            0xffE8E8E8),
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 3.w),
                                                                        height:
                                                                            5.h,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Image.asset(
                                                                              tickImg,
                                                                              color: ColorUtils.lightGrey83,
                                                                              height: 5.w,
                                                                              width: 5.w,
                                                                            ),
                                                                            SizedBox(width: 5.w),
                                                                            Expanded(
                                                                              child: Text(
                                                                                data.showText!,
                                                                                style: TextStyle(fontWeight: FontWeight.w600, color: ColorUtils.lightGrey83, fontSize: 10.sp),
                                                                                maxLines: 1,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : const SizedBox(),
                                                          Divider(
                                                            height: 1.h,
                                                            color: ColorUtils
                                                                .black,
                                                          ),
                                                          SizeConfig.sH1,
                                                          GetBuilder<
                                                              FeedBackViewModel>(
                                                            builder:
                                                                (feedBackController) {
                                                              return Row(
                                                                children: [
                                                                  InkResponse(
                                                                    radius: 40,
                                                                    onTap:
                                                                        () async {
                                                                      GlobalFeedBackDataResults
                                                                          data =
                                                                          controller
                                                                              .globalFeedBackDataResults[index];
                                                                      String?
                                                                          feedBackId =
                                                                          data.sId!;

                                                                      if (feedBackController.insideAllLikeMap.containsKey(
                                                                              feedBackId) &&
                                                                          feedBackController.insideAllLikeMap[feedBackId]!.interactionStatus ==
                                                                              true) {
                                                                        feedBackController
                                                                            .insideAllLikeMap
                                                                            .addAll({
                                                                          feedBackId: InteractionStatus(
                                                                              interactionStatus: false,
                                                                              count: feedBackController.insideAllLikeMap[feedBackId]!.count! > 0 ? feedBackController.insideAllLikeMap[feedBackId]!.count! - 1 : feedBackController.insideAllLikeMap[feedBackId]!.count!,
                                                                              interactionId: feedBackController.insideAllLikeMap[feedBackId]!.interactionId)
                                                                        });
                                                                        await feedBackController.interactionDeleteViewModel(
                                                                            interactionId:
                                                                                feedBackController.insideAllLikeMap[feedBackId]!.interactionId);

                                                                        return;
                                                                      } else if (feedBackController.insideAllLikeMap.containsKey(
                                                                              feedBackId) &&
                                                                          feedBackController.insideAllLikeMap[feedBackId]!.interactionStatus ==
                                                                              false) {
                                                                        ///unlike from local data
                                                                        if (feedBackController
                                                                            .insideAllDisLikeMap
                                                                            .containsKey(feedBackId)) {
                                                                          if (feedBackController.insideAllDisLikeMap[feedBackId]!.interactionStatus ==
                                                                              true) {
                                                                            feedBackController.insideAllDisLikeMap.addAll({
                                                                              feedBackId: InteractionStatus(feedbackId: feedBackId, interactionStatus: false, count: feedBackController.insideAllDisLikeMap[feedBackId]!.count! > 0 ? feedBackController.insideAllDisLikeMap[feedBackId]!.count! - 1 : feedBackController.insideAllDisLikeMap[feedBackId]!.count!, interactionId: feedBackController.insideAllDisLikeMap[feedBackId]!.interactionId)
                                                                            });
                                                                            await feedBackController.interactionDeleteViewModel(interactionId: feedBackController.insideAllDisLikeMap[feedBackId]!.interactionId);
                                                                          }
                                                                        }

                                                                        await feedBackController
                                                                            .feedBackLDCViewModel({
                                                                          "user":
                                                                              PreferenceManagerUtils.getLoginId(),
                                                                          "feedback":
                                                                              feedBackId,
                                                                          "ftype":
                                                                              "like"
                                                                        });

                                                                        if (feedBackController.feedBackLikeApiResponse.status ==
                                                                            Status.COMPLETE) {
                                                                          if (kDebugMode) {
                                                                            print("LIKE 5");
                                                                          }

                                                                          FeedBackLikeUnLikeResModel
                                                                              response =
                                                                              feedBackController.feedBackLikeApiResponse.data;

                                                                          feedBackController
                                                                              .insideAllLikeMap
                                                                              .addAll({
                                                                            feedBackId: InteractionStatus(
                                                                                feedbackId: feedBackId,
                                                                                interactionStatus: true,
                                                                                count: feedBackController.insideAllLikeMap[feedBackId]!.count! + 1,
                                                                                interactionId: response.data!.sId)
                                                                          });
                                                                        }

                                                                        return;
                                                                      } else if (data
                                                                              .mylike ==
                                                                          true) {
                                                                        if (kDebugMode) {
                                                                          print(
                                                                              "LIKE 6");
                                                                        }

                                                                        feedBackController
                                                                            .insideAllLikeMap
                                                                            .addAll({
                                                                          feedBackId: InteractionStatus(
                                                                              interactionStatus: false,
                                                                              count: data.like! > 0 ? data.like! - 1 : data.like!)
                                                                        });
                                                                        await feedBackController.interactionDeleteViewModel(
                                                                            interactionId:
                                                                                data.mylikeid);

                                                                        return;
                                                                      }

                                                                      ///DATA FROM API MY LIKE IS FALSE
                                                                      else if (data
                                                                              .mylike ==
                                                                          false) {
                                                                        if (kDebugMode) {
                                                                          print(
                                                                              "LIKE 7");
                                                                        }

                                                                        ///unlike from api data
                                                                        if (data.myunlike ==
                                                                            true) {
                                                                          if (kDebugMode) {
                                                                            print("LIKE 8");
                                                                          }

                                                                          feedBackController
                                                                              .insideAllDisLikeMap
                                                                              .addAll({
                                                                            feedBackId:
                                                                                InteractionStatus(
                                                                              feedbackId: feedBackId,
                                                                              interactionStatus: false,
                                                                              count: data.unlike! > 0 ? data.unlike! - 1 : data.unlike!,
                                                                            )
                                                                          });
                                                                          await feedBackController.interactionDeleteViewModel(
                                                                              interactionId: data.myunlikeid);
                                                                        } else {
                                                                          if (feedBackController
                                                                              .insideAllDisLikeMap
                                                                              .containsKey(feedBackId)) {
                                                                            feedBackController.insideAllDisLikeMap.addAll({
                                                                              feedBackId: InteractionStatus(feedbackId: feedBackId, interactionStatus: false, count: feedBackController.insideAllDisLikeMap[feedBackId]!.count! > 0 ? feedBackController.insideAllDisLikeMap[feedBackId]!.count! - 1 : feedBackController.insideAllDisLikeMap[feedBackId]!.count!, interactionId: feedBackController.insideAllDisLikeMap[feedBackId]!.interactionId)
                                                                            });
                                                                            await feedBackController.interactionDeleteViewModel(interactionId: feedBackController.insideAllDisLikeMap[feedBackId]!.interactionId);
                                                                          }
                                                                        }

                                                                        await feedBackController
                                                                            .feedBackLDCViewModel({
                                                                          "user":
                                                                              PreferenceManagerUtils.getLoginId(),
                                                                          "feedback":
                                                                              feedBackId,
                                                                          "ftype":
                                                                              "like"
                                                                        });

                                                                        if (feedBackController.feedBackLikeApiResponse.status ==
                                                                            Status.COMPLETE) {
                                                                          if (kDebugMode) {
                                                                            print("LIKE 9");
                                                                          }

                                                                          FeedBackLikeUnLikeResModel
                                                                              response =
                                                                              feedBackController.feedBackLikeApiResponse.data;

                                                                          feedBackController
                                                                              .insideAllLikeMap
                                                                              .addAll({
                                                                            feedBackId: InteractionStatus(
                                                                                feedbackId: feedBackId,
                                                                                interactionStatus: true,
                                                                                count: data.like! + 1,
                                                                                interactionId: response.data!.sId)
                                                                          });
                                                                        }

                                                                        return;
                                                                      }
                                                                      feedBackController
                                                                          .update();
                                                                    },
                                                                    child:
                                                                        interactionWidgetSvg(
                                                                      svg: feedBackController
                                                                              .insideAllLikeMap
                                                                              .containsKey(data.sId!)
                                                                          ? feedBackController.insideAllLikeMap[data.sId]!.interactionStatus == true
                                                                              ? SvgPicture.asset(
                                                                                  likeImg,
                                                                                  color: ColorUtils.primaryColor,
                                                                                )
                                                                              : SvgPicture.asset(
                                                                                  likeImg,
                                                                                )
                                                                          : data.mylike == true
                                                                              ? SvgPicture.asset(
                                                                                  likeImg,
                                                                                  color: ColorUtils.primaryColor,
                                                                                )
                                                                              : SvgPicture.asset(
                                                                                  likeImg,
                                                                                ),
                                                                      value: feedBackController.insideAllLikeMap.containsKey(data
                                                                              .sId!)
                                                                          ? feedBackController
                                                                              .insideAllLikeMap[data.sId]!
                                                                              .count
                                                                          : data.like,
                                                                    ),
                                                                  ),
                                                                  SizeConfig
                                                                      .sW5,

                                                                  ///dislike
                                                                  InkResponse(
                                                                      radius:
                                                                          40,
                                                                      onTap:
                                                                          () async {
                                                                        GlobalFeedBackDataResults
                                                                            data =
                                                                            controller.globalFeedBackDataResults[index];
                                                                        String?
                                                                            feedBackId =
                                                                            data.sId!;

                                                                        ///DATA FROM LOCAL

                                                                        if (feedBackController.insideAllDisLikeMap.containsKey(feedBackId) &&
                                                                            feedBackController.insideAllDisLikeMap[feedBackId]!.interactionStatus ==
                                                                                true) {
                                                                          if (kDebugMode) {
                                                                            print("UNLIKE 1");
                                                                          }
                                                                          feedBackController
                                                                              .insideAllDisLikeMap
                                                                              .addAll({
                                                                            feedBackId: InteractionStatus(
                                                                                interactionStatus: false,
                                                                                count: feedBackController.insideAllDisLikeMap[feedBackId]!.count! > 0 ? feedBackController.insideAllDisLikeMap[feedBackId]!.count! - 1 : feedBackController.insideAllDisLikeMap[feedBackId]!.count!,
                                                                                interactionId: feedBackController.insideAllDisLikeMap[feedBackId]!.interactionId)
                                                                          });
                                                                          await feedBackController.interactionDeleteViewModel(
                                                                              interactionId: feedBackController.insideAllDisLikeMap[feedBackId]!.interactionId);

                                                                          return;
                                                                        }

                                                                        ///DATA FROM LOCAL

                                                                        else if (feedBackController.insideAllDisLikeMap.containsKey(feedBackId) &&
                                                                            feedBackController.insideAllDisLikeMap[feedBackId]!.interactionStatus ==
                                                                                false) {
                                                                          if (kDebugMode) {
                                                                            print("UNLIKE 2");
                                                                          }

                                                                          ///unlike from local data
                                                                          if (feedBackController
                                                                              .insideAllLikeMap
                                                                              .containsKey(feedBackId)) {
                                                                            if (kDebugMode) {
                                                                              if (kDebugMode) {
                                                                                print("UNLIKE 3");
                                                                              }
                                                                            }

                                                                            if (feedBackController.insideAllLikeMap[feedBackId]!.interactionStatus ==
                                                                                true) {
                                                                              if (kDebugMode) {
                                                                                print("UNLIKE 4");
                                                                              }

                                                                              feedBackController.insideAllLikeMap.addAll({
                                                                                feedBackId: InteractionStatus(feedbackId: feedBackId, interactionStatus: false, count: feedBackController.insideAllLikeMap[feedBackId]!.count! > 0 ? feedBackController.insideAllLikeMap[feedBackId]!.count! - 1 : feedBackController.insideAllLikeMap[feedBackId]!.count!, interactionId: feedBackController.insideAllLikeMap[feedBackId]!.interactionId)
                                                                              });
                                                                              await feedBackController.interactionDeleteViewModel(interactionId: feedBackController.insideAllLikeMap[feedBackId]!.interactionId);
                                                                            }
                                                                          }

                                                                          await feedBackController
                                                                              .feedBackLDCViewModel({
                                                                            "user":
                                                                                PreferenceManagerUtils.getLoginId(),
                                                                            "feedback":
                                                                                feedBackId,
                                                                            "ftype":
                                                                                "unlike"
                                                                          });

                                                                          if (feedBackController.feedBackLikeApiResponse.status ==
                                                                              Status.COMPLETE) {
                                                                            if (kDebugMode) {
                                                                              print("UNLIKE 5");
                                                                            }

                                                                            FeedBackLikeUnLikeResModel
                                                                                response =
                                                                                feedBackController.feedBackLikeApiResponse.data;

                                                                            feedBackController.insideAllDisLikeMap.addAll({
                                                                              feedBackId: InteractionStatus(feedbackId: feedBackId, interactionStatus: true, count: feedBackController.insideAllDisLikeMap[feedBackId]!.count! + 1, interactionId: response.data!.sId)
                                                                            });
                                                                          }

                                                                          return;
                                                                        }

                                                                        ///DATA FROM API
                                                                        else if (data.myunlike ==
                                                                            true) {
                                                                          if (kDebugMode) {
                                                                            print("UNLIKE 6");
                                                                          }

                                                                          feedBackController
                                                                              .insideAllDisLikeMap
                                                                              .addAll({
                                                                            feedBackId:
                                                                                InteractionStatus(interactionStatus: false, count: data.unlike! > 0 ? data.unlike! - 1 : data.unlike!)
                                                                          });
                                                                          await feedBackController.interactionDeleteViewModel(
                                                                              interactionId: data.myunlikeid);
                                                                          return;
                                                                        }

                                                                        ///DATA FROM API
                                                                        else if (data.myunlike ==
                                                                            false) {
                                                                          if (kDebugMode) {
                                                                            print("UNLIKE 7");
                                                                          }

                                                                          ///unlike from local data
                                                                          if (data.mylike ==
                                                                              true) {
                                                                            if (kDebugMode) {
                                                                              print("UNLIKE 8");
                                                                            }

                                                                            await feedBackController.interactionDeleteViewModel(interactionId: data.mylikeid);

                                                                            feedBackController.insideAllLikeMap.addAll({
                                                                              feedBackId: InteractionStatus(
                                                                                feedbackId: feedBackId,
                                                                                interactionStatus: false,
                                                                                count: data.like! > 0 ? data.like! - 1 : data.like!,
                                                                              )
                                                                            });
                                                                          } else {
                                                                            if (kDebugMode) {
                                                                              print("UNLIKE 9");
                                                                            }

                                                                            if (feedBackController.insideAllLikeMap.containsKey(feedBackId)) {
                                                                              if (kDebugMode) {
                                                                                print("UNLIKE 10");
                                                                              }

                                                                              feedBackController.insideAllLikeMap.addAll({
                                                                                feedBackId: InteractionStatus(feedbackId: feedBackId, interactionStatus: false, count: feedBackController.insideAllLikeMap[feedBackId]!.count! > 0 ? feedBackController.insideAllLikeMap[feedBackId]!.count! - 1 : feedBackController.insideAllLikeMap[feedBackId]!.count!, interactionId: feedBackController.insideAllLikeMap[feedBackId]!.interactionId)
                                                                              });
                                                                              await feedBackController.interactionDeleteViewModel(interactionId: feedBackController.insideAllLikeMap[feedBackId]!.interactionId);
                                                                            }
                                                                          }

                                                                          await feedBackController
                                                                              .feedBackLDCViewModel({
                                                                            "user":
                                                                                PreferenceManagerUtils.getLoginId(),
                                                                            "feedback":
                                                                                data.sId,
                                                                            "ftype":
                                                                                "unlike"
                                                                          });

                                                                          if (feedBackController.feedBackLikeApiResponse.status ==
                                                                              Status.COMPLETE) {
                                                                            if (kDebugMode) {
                                                                              print("UNLIKE 11");
                                                                            }

                                                                            FeedBackLikeUnLikeResModel
                                                                                response =
                                                                                feedBackController.feedBackLikeApiResponse.data;

                                                                            feedBackController.insideAllDisLikeMap.addAll({
                                                                              feedBackId: InteractionStatus(feedbackId: feedBackId, interactionStatus: true, count: data.unlike! + 1, interactionId: response.data!.sId)
                                                                            });
                                                                          }

                                                                          return;
                                                                        }
                                                                        feedBackController
                                                                            .update();
                                                                      },
                                                                      child:
                                                                          interactionWidgetSvg(
                                                                        svg: feedBackController.insideAllDisLikeMap.containsKey(data.sId!)
                                                                            ? feedBackController.insideAllDisLikeMap[data.sId]!.interactionStatus == true
                                                                                ? SvgPicture.asset(
                                                                                    dislikeImg,
                                                                                    color: ColorUtils.primaryColor,
                                                                                  )
                                                                                : SvgPicture.asset(
                                                                                    dislikeImg,
                                                                                  )
                                                                            : data.myunlike == true
                                                                                ? SvgPicture.asset(
                                                                                    dislikeImg,
                                                                                    color: ColorUtils.primaryColor,
                                                                                  )
                                                                                : SvgPicture.asset(
                                                                                    dislikeImg,
                                                                                  ),
                                                                        value: feedBackController.insideAllDisLikeMap.containsKey(data.sId!)
                                                                            ? feedBackController.insideAllDisLikeMap[data.sId]!.count
                                                                            : data.unlike,
                                                                      )),
                                                                  SizeConfig
                                                                      .sW5,
                                                                  InkResponse(
                                                                    radius: 40,
                                                                    onTap:
                                                                        () async {
                                                                      detailsScreenCall(
                                                                          feedBackIndex:
                                                                              index,
                                                                          isFeedBackCommentTap:
                                                                              true,
                                                                          globalFeedBackViewModel:
                                                                              controller);
                                                                    },
                                                                    child: interactionWidgetSvg(
                                                                        svg: SvgPicture.asset(
                                                                          commentImg,
                                                                        ),
                                                                        iconPath: commentImg,
                                                                        value: data.comment),
                                                                  ),
                                                                  SizeConfig
                                                                      .sW5,
                                                                  controller
                                                                          .globalFeedBackDataResults
                                                                          .isNotEmpty
                                                                      ?
                                                                      InkResponse(
                                                                          radius:
                                                                              40,
                                                                          child: IconsWidgets
                                                                              .shareGrey,
                                                                          onTap:
                                                                              () async {
                                                                            detailsScreenCall(
                                                                                feedBackIndex: index,
                                                                                isFeedBackCommentTap: false,
                                                                                globalFeedBackViewModel: controller);
                                                                          })
                                                                      : const SizedBox(),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                    );
                                  }),
                                ),
                                if (controller.isFeedBackPostedMoreLoading)
                                  const Center(
                                    child: CircularIndicator(
                                      isExpand: false,
                                    ),
                                  ),
                                SizeConfig.sH1,
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }

  Future<void> detailsScreenCall(
      {GlobalFeedBackViewModel? globalFeedBackViewModel,
      int? feedBackIndex,
      bool? isFeedBackCommentTap}) async {
    await Get.to(
      FeedBackDetailsScreen(
        feedBackId: globalFeedBackViewModel!
            .globalFeedBackDataResults[feedBackIndex!].sId,
        isCommentTap: isFeedBackCommentTap ?? false,
      ),
    );
    apiCalling(globalFeedController: globalFeedBackViewModel);
  }

  ///api calling
  apiCalling({GlobalFeedBackViewModel? globalFeedController}) {
    globalFeedController!.globalFeedBackDataResults.clear();
    globalFeedController.globalFeedBackPostedPage = 1;
    globalFeedController.isGlobalFeedBackPostedFirstLoading = true;
    globalFeedController.getGlobalFeedBackPosted(initLoad: false);
    clearLocalList();
  }

  ///CLEAR LOCAL LIST....
  void clearLocalList() {
    feedBackController.insideAllLikeMap.clear();
    feedBackController.insideAllDisLikeMap.clear();
  }

  Row interactionWidgetSvg({String? iconPath, int? value, SvgPicture? svg}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        svg!,
        const SizedBox(
          width: 5,
        ),
        value == null
            ? const SizedBox()
            : Text(
                value.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColorUtils.grey,
                    fontSize: 10.sp),
              ),
      ],
    );
  }

  void linkedAccountBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          height: 50.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.cancel))),
                Image.asset(
                  'assets/image/socialLoginImage.webp',
                  scale: 1.w,
                ),
                SizeConfig.sH3,
                Text(
                  'To enable reviews via LinkedIn profiles,\nyou must log in to your account first.',
                  style: TextStyle(fontSize: 12.sp),
                ),
                SizeConfig.sH3,
                CustomButtons(
                  buttonName: VariableUtils.linkYourAccount,
                  onTap: () {
                    Get.back();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
