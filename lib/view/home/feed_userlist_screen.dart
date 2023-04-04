import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/circular_progress_indicator.dart';
import 'package:humanscoring/common/commonWidget/octo_image_widget.dart';
import 'package:humanscoring/common/commonWidget/snackbar.dart';
import 'package:humanscoring/modal/apiModel/req_model/chat_req_model.dart';
import 'package:humanscoring/modal/apiModel/req_model/feed_like_request_model.dart';
import 'package:humanscoring/modal/apiModel/req_model/feed_pin_request_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/feed_like_pin_response_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/feedback_delete_res_model.dart';
import 'package:humanscoring/utils/assets/icons_utils.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/decoration_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/home/feed_inside_page/you_inside_page.dart';
import 'package:sizer/sizer.dart';

import '../../modal/apiModel/res_model/all_feeds_respo_model.dart';
import '../../modal/apis/api_response.dart';
import '../../utils/size_config_utils.dart';
import '../../viewmodel/address_book_viewmodel.dart';
import '../../viewmodel/dashboard_viewmodel.dart';
import '../../viewmodel/notification_viewmodel.dart';
import '../chatScreen/admin_chat_screen.dart';
import '../chatScreen/chat_room.dart';
import '../generalScreen/no_searchfound_screen.dart';
import '../polls/poll_screen.dart';
import 'address_book_screen.dart';
import 'feed_inside_page/all_inside_page.dart';
import 'feed_inside_page/pin_inside_page.dart';
import 'feed_inside_page/unread_inside_page.dart';

Stream<List<ConversationsModel>> getConversionList() {
  return chatConversationsCollection
      .where('reciever', isEqualTo: PreferenceManagerUtils.getLoginId())
      .snapshots()
      .map((event) => event.docs
          .map((e) =>
              ConversationsModel.fromJson((e.data() as Map<String, dynamic>)))
          .toList());
}

class FeedUserListScreen extends StatefulWidget {
  const FeedUserListScreen({Key? key}) : super(key: key);

  @override
  State<FeedUserListScreen> createState() => _FeedUserListScreenState();
}

class _FeedUserListScreenState extends State<FeedUserListScreen> {
  FeedLikeRequestModel feedLikeRequestModel = FeedLikeRequestModel();
  FeedPinRequestModel feedPinRequestModel = FeedPinRequestModel();
  DashBoardViewModel dashBoardViewModel = Get.put(DashBoardViewModel());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<DashBoardViewModel>(builder: (dashBoardController) {
        if (dashBoardController.allFeedsApiResponse.status == Status.LOADING) {
          return const Center(child: CircularIndicator());
        }

        if (dashBoardController.allFeedsApiResponse.status == Status.ERROR) {
          return const Center(child: Text("Server Error"));
        }

        AllFeedsRespoModel allFeedsRespoModel =
            dashBoardController.allFeedsApiResponse.data;

        return allFeedsRespoModel.data == null
            ? const NoFeedBackFound()
            : Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      dashBoardViewModel.allFeedsViewModel();
                      AddressBookViewModel().getContactAddToAPIList();
                    },
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        ///YOU PROFILE VIEW....
                        youProfileView(allFeedsRespoModel),
                        if (allFeedsRespoModel.data!.pin!.isEmpty &&
                            allFeedsRespoModel.data!.unread!.isEmpty &&
                            allFeedsRespoModel.data!.all!.isEmpty)
                          GetBuilder<NotificationViewModel>(
                            builder: (controller) {
                              return InkWell(
                                onTap: () {
                                  controller.indexChange = 1;
                                },
                                child: Container(
                                  height: 13.w,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 10.w),
                                  decoration: BoxDecoration(
                                    color: ColorUtils.primaryColor,
                                    border: Border.all(
                                        color: ColorUtils.blue14, width: 1.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      VariableUtils.letsQriteeQYourFriend,
                                      style: FontTextStyle.poppinsWhite10bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                        /// Need backend support then after work admin panel
                        ///Admin panel
                        modratorChatView(),

                        ///PIN FEED VIEW
                        allFeedsRespoModel.data!.pin!.isEmpty
                            ? const SizedBox()
                            : pinListView(
                                allFeedsRespoModel, dashBoardController),

                        ///UNREAD FEED VIEW...
                        allFeedsRespoModel.data!.unread!.isEmpty
                            ? const SizedBox()
                            : unReadFeedListView(
                                allFeedsRespoModel, dashBoardController),

                        ///ALL FEED VIEW...
                        allFeedsRespoModel.data!.all!.isEmpty
                            ? const SizedBox()
                            : allFeedListView(
                                allFeedsRespoModel, dashBoardController),
                      ],
                    ),
                  ),
                  if (dashBoardViewModel.deleteFeedApiResponse.status ==
                          Status.LOADING ||
                      dashBoardViewModel.feedPinApiResponse.status ==
                          Status.LOADING ||
                      dashBoardViewModel.feedLikeApiResponse.status ==
                          Status.LOADING)
                    const CircularIndicator(),
                ],
              );
      }),
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

          return InkWell(
            onTap: () {
              Get.to(const AdminChatScreen());
            },
            child: Container(
              height: 8.5.h,
              width: Get.width,
              margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 3.w),
              decoration: BoxDecoration(
                color: ColorUtils.orange.withOpacity(0.5),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 10,
                      offset: const Offset(3, 12))
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.w),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(3.2.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/icon/appIconBG.webp',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Admin',
                                style: FontTextStyle.poppins12mediumDarkBlack
                                    .copyWith(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizeConfig.sH1,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'You have new message from admin',
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
        });
  }

  /// YOUR PROFILE FEED VIEW
  youProfileView(AllFeedsRespoModel allFeedsRespoModel) {
    FeedYou? feedYou = allFeedsRespoModel.data!.you;

    return InkWell(
      onTap: () async {
        await Get.to(
            YouInsidePage(
              userType: VariableUtils.you,
              avatar: feedYou!.avatar,
              youFeedData: allFeedsRespoModel.data!.you,
            ),
            transition: Transition.cupertino);
        dashBoardViewModel.allFeedsApiResponse.status = Status.LOADING;
        dashBoardViewModel.allFeedsViewModel();
        setState(() {});
      },
      child: Container(
        height: 8.5.h,
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        decoration: DecorationUtils.myProfileDecoration,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Row(
            children: [
              Stack(
                children: [
                  GetBuilder<AddressBookViewModel>(
                    builder: (controller) {
                      return OctoImageWidget(
                          profileLink: controller.setUserAvatar);
                    },
                  ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Feedbacks',
                          style: FontTextStyle.poppins12mediumDarkBlack
                              .copyWith(
                                  fontSize: 12.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${feedYou!.receiveDate}',
                          style: TextStyle(fontSize: 9.sp),
                        ),
                      ],
                    ),
                    SizeConfig.sH05,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${feedYou.feedText}',
                          style: FontTextStyle.poppins12regular.copyWith(
                              fontSize: 11.sp,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                              color: ColorUtils.darGrey63),
                        ),
                        feedYou.unread == 0 || feedYou.unread == null
                            ? const SizedBox()
                            : Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      blurRadius: 11,
                                      offset: const Offset(0, 4),
                                      spreadRadius: 0.1)
                                ]),
                                child: CircleAvatar(
                                  radius: 3.5.w,
                                  backgroundColor: ColorUtils.orangeF1,
                                  child: Text(
                                    '${feedYou.unread ?? 0}',
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        color: ColorUtils.white),
                                  ),
                                ),
                              )
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
  }

  ///FEEDBACK REVIEW ICON...
  Widget feedBackReviewIcon(feedStatus, feedDescription) {
    return Row(
      children: [
        feedStatus == VariableUtils.flaggedStatus
            ? Image.asset(
                "${basePath}flagedCoffe.webp",
                scale: 1.w,
              )
            : feedStatus == VariableUtils.pendingStatus
                ? Image.asset(
                    "${basePath}unreadRight.webp",
                    scale: 1.w,
                  )
                : feedStatus == VariableUtils.approvedStatus
                    ? Image.asset(
                        "${basePath}readGreenRight.webp",
                        scale: 1.w,
                      )
                    : feedStatus == VariableUtils.rejectStatus
                        ? Image.asset(
                            "${basePath}redAlert.webp",
                            scale: 1.w,
                            color: ColorUtils.red,
                          )
                        : const SizedBox(),
        SizeConfig.sW1,
        Expanded(
          child: Text(
            feedStatus == VariableUtils.rejectStatus
                ? feedDescription
                : '$feedDescription',
            style: FontTextStyle.poppins12regular.copyWith(
                fontSize: 11.sp,
                overflow: TextOverflow.ellipsis,
                color: feedStatus == VariableUtils.rejectStatus
                    ? ColorUtils.red
                    : ColorUtils.lightGrey83),
            maxLines: 10,
          ),
        ),
      ],
    );
  }

  ///UNREAD FEEDS VIEW
  ListView unReadFeedListView(AllFeedsRespoModel allFeedsRespoModel,
      DashBoardViewModel dashBoardController) {
    String userName = '';

    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: allFeedsRespoModel.data!.unread!.length,
        itemBuilder: (context, index) {
          Unread unreadFeed = allFeedsRespoModel.data!.unread![index];
          userName = unreadFeed.user!.userIdentity!;
          return dashBoardController.visibleData.contains(unreadFeed.iId!.sId)
              ? const SizedBox()
              : InkWell(
                  onTap: () async {
                    Unread unreadFeed = allFeedsRespoModel.data!.unread![index];
                    await Get.to(
                        UnreadInsidePage(
                          userType: VariableUtils.notYou,
                          avatar: unreadFeed.iId!.avatar,
                          unreadFeed: unreadFeed,
                        ),
                        transition: Transition.cupertino);
                    dashBoardViewModel.allFeedsApiResponse.status =
                        Status.LOADING;
                    dashBoardViewModel.allFeedsViewModel();
                    setState(() {});
                  },
                  onLongPress: () {
                    Unread unreadFeed = allFeedsRespoModel.data!.unread![index];
                    userInterationBottomSheet(
                        toId: unreadFeed.iId!.sId,
                        toUserName: unreadFeed.user!.userIdentity,
                        toUserActiveStatus: unreadFeed.user!.active,
                        toLikeStatus: unreadFeed.status!.favorite,
                        toPinStatus: unreadFeed.status!.pin,
                        positionIndex: index);
                  },
                  child: Container(
                    height: 8.5.h,
                    width: Get.width,
                    margin:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: ColorUtils.blueED.withOpacity(0.2),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                                  profileLink: unreadFeed.iId!.avatar),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 1.5.w,
                                  backgroundColor: ColorUtils.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(0.5.w),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: unreadFeed.iId!.online == true
                                            ? ColorUtils.colorGreen
                                            : ColorUtils.colorGrey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              )
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
                                        userName,
                                        style: FontTextStyle
                                            .poppins12mediumDarkBlack
                                            .copyWith(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // const Spacer(),
                                    SizeConfig.sW2,
                                    Text(
                                      '${unreadFeed.receiveDate}',
                                      style: TextStyle(fontSize: 9.sp),
                                    ),
                                  ],
                                ),
                                SizeConfig.sH1,
                                feedBackReviewIcon(
                                    unreadFeed.feedStatus, unreadFeed.feedText),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        });
  }

  ///PIN FEEDS VIEW
  ListView pinListView(AllFeedsRespoModel allFeedsRespoModel,
      DashBoardViewModel dashBoardController) {
    String userName = '';

    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: allFeedsRespoModel.data!.pin!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          All pinFeed = allFeedsRespoModel.data!.pin![index];
          userName = pinFeed.user!.userIdentity!;
          return dashBoardController.visibleData.contains(pinFeed.user!.sId)
              ? const SizedBox()
              : InkWell(
                  onTap: () async {
                    All pinFeed = allFeedsRespoModel.data!.pin![index];
                    await Get.to(
                        PinInsidePage(
                          userType: VariableUtils.notYou,
                          avatar: pinFeed.user!.avatar,
                          pinData: pinFeed,
                        ),
                        transition: Transition.cupertino);

                    dashBoardViewModel.allFeedsApiResponse.status =
                        Status.LOADING;
                    dashBoardViewModel.allFeedsViewModel();
                    setState(() {});
                  },
                  onLongPress: () {
                    All pinFeed = allFeedsRespoModel.data!.pin![index];
                    userInterationBottomSheet(
                        toId: pinFeed.user!.sId,
                        toUserActiveStatus: pinFeed.user!.active,
                        toUserName: pinFeed.user!.userIdentity,
                        toLikeStatus: pinFeed.status!.favorite,
                        toPinStatus: pinFeed.status!.pin,
                        positionIndex: index);
                  },
                  child: Container(
                    // height: 8.5.h,
                    width: Get.width,
                    margin:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                    decoration: const BoxDecoration(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              OctoImageWidget(
                                  profileLink: pinFeed.user!.avatar),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 1.5.w,
                                  backgroundColor: ColorUtils.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(0.5.w),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: pinFeed.user!.online == true
                                            ? ColorUtils.colorGreen
                                            : ColorUtils.colorGrey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              )
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
                                        userName,
                                        style: FontTextStyle
                                            .poppins12mediumDarkBlack
                                            .copyWith(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Spacer(),
                                    SizeConfig.sW2,

                                    IconsWidgets.pin,
                                    SizeConfig.sW2,
                                    Text(
                                      '${pinFeed.receiveDate}',
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
                                      child: feedBackReviewIcon(
                                          pinFeed.feedStatus, pinFeed.feedText),
                                    ),
                                    pinFeed.unread == 0 ||
                                            pinFeed.unread == null
                                        ? const SizedBox()
                                        : Container(
                                            decoration:
                                                BoxDecoration(boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.8),
                                                  blurRadius: 11,
                                                  offset: const Offset(0, 4),
                                                  spreadRadius: 0.1)
                                            ]),
                                            child: CircleAvatar(
                                              radius: 3.5.w,
                                              backgroundColor: ColorUtils.white,
                                              child: Text(
                                                '${pinFeed.unread}',
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: ColorUtils.black),
                                              ),
                                            ),
                                          )
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
        });
  }

  ///ALL FEEDS VIEW
  ListView allFeedListView(AllFeedsRespoModel allFeedsRespoModel,
      DashBoardViewModel dashBoardController) {
    String userName = '';

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: allFeedsRespoModel.data!.all!.length,
      itemBuilder: (context, index) {
        All allFeed = allFeedsRespoModel.data!.all![index];

        userName = allFeed.user!.userIdentity!;
        return dashBoardController.visibleData.contains(allFeed.iId!.sId)
            ? const SizedBox()
            : Material(
                color: ColorUtils.transparent,
                child: InkWell(
                  onTap: () async {
                    All allFeed = allFeedsRespoModel.data!.all![index];

                    await Get.to(
                        AllInsidePage(
                          userType: VariableUtils.notYou,
                          avatar: allFeed.user!.avatar,
                          allData: allFeed,
                        ),
                        transition: Transition.cupertino);
                    dashBoardViewModel.allFeedsApiResponse.status =
                        Status.LOADING;
                    dashBoardViewModel.allFeedsViewModel();
                    setState(() {});
                  },
                  onLongPress: () {
                    All allFeed = allFeedsRespoModel.data!.all![index];

                    userInterationBottomSheet(
                        toId: allFeed.iId!.sId,
                        toUserName: allFeed.user!.userIdentity,
                        toUserActiveStatus: allFeed.user!.active,
                        toLikeStatus: allFeed.status!.favorite,
                        toPinStatus: allFeed.status!.pin,
                        positionIndex: index);
                  },
                  child: Container(
                    // height: 8.5.h,
                    width: Get.width,
                    margin:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                    decoration: const BoxDecoration(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              OctoImageWidget(profileLink: allFeed.iId!.avatar),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 1.5.w,
                                  backgroundColor: ColorUtils.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(0.5.w),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: allFeed.iId!.online == true
                                            ? ColorUtils.colorGreen
                                            : ColorUtils.colorGrey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              )
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
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        userName,
                                        style: FontTextStyle
                                            .poppins12mediumDarkBlack
                                            .copyWith(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizeConfig.sW2,
                                    Text(
                                      '${allFeed.receiveDate}',
                                      style: TextStyle(fontSize: 9.sp),
                                    ),
                                  ],
                                ),
                                SizeConfig.sH1,
                                feedBackReviewIcon(
                                    allFeed.feedStatus, allFeed.feedText),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  void userInterationBottomSheet({
    String? toId,
    String? toUserName,
    bool? toUserActiveStatus,
    int? positionIndex,
    bool? toLikeStatus,
    bool? toPinStatus,
  }) {
    String byId = PreferenceManagerUtils.getLoginId();

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return GetBuilder<DashBoardViewModel>(
            builder: (dashBoardViewModel) {
              return Container(
                decoration: DecorationUtils.verticalBorderAndColorDecorationBox(
                  colors: ColorUtils.white,
                  radius: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizeConfig.sH2,
                    Center(
                      child: Container(
                        height: 3,
                        width: 14.w,
                        color: ColorUtils.grayD9,
                      ),
                    ),
                    SizeConfig.sH3,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        "$toUserName",
                        style: FontTextStyle.poppins12DarkBlack,
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: ColorUtils.whiteF1,
                    ),
                    SizeConfig.sH2,

                    ///Pin Api
                    InkWell(
                      onTap: () async {
                        feedPinRequestModel.by = byId;
                        feedPinRequestModel.toPin = toId.toString();

                        feedPinRequestModel.pin =
                            toPinStatus == true ? false : true;
                        feedPinRequestModel.position = positionIndex;
                        await dashBoardViewModel
                            .feedPinViewModel(feedPinRequestModel);
                        if (dashBoardViewModel.feedPinApiResponse.status ==
                            Status.COMPLETE) {
                          FeedLikePinResponseModel response =
                              dashBoardViewModel.feedPinApiResponse.data;
                          if (response.status == 200) {
                            showSnackBar(
                              message: response.message,
                              snackColor: ColorUtils.primaryColor,
                            );
                            dashBoardViewModel.pinList(
                                toId, toPinStatus == true ? false : true);
                            Navigator.pop(context);
                            dashBoardViewModel.allFeedsViewModel();
                          } else {
                            showSnackBar(
                              message: response.message,
                              snackColor: ColorUtils.primaryColor,
                            );
                          }
                        }
                      },
                      child: commonIconAndText(
                        icon: IconsWidgets.pin,
                        text: toPinStatus == true
                            ? VariableUtils.unPin
                            : VariableUtils.pin,
                      ),
                    ),
                    SizeConfig.sH3,

                    ///Favorite Api
                    InkWell(
                      onTap: () async {
                        feedLikeRequestModel.by = byId;
                        feedLikeRequestModel.toLike = toId.toString();
                        feedLikeRequestModel.favorite =
                            toLikeStatus == true ? false : true;
                        await dashBoardViewModel
                            .feedLikeViewModel(feedLikeRequestModel);
                        if (dashBoardViewModel.feedLikeApiResponse.status ==
                            Status.COMPLETE) {
                          FeedLikePinResponseModel response =
                              dashBoardViewModel.feedLikeApiResponse.data;
                          if (response.status == 200) {
                            showSnackBar(
                              message: response.message,
                              snackColor: ColorUtils.primaryColor,
                            );
                            dashBoardViewModel.allFeedsViewModel();

                            Navigator.pop(context);
                          } else {
                            showSnackBar(
                              message: response.message,
                              snackColor: ColorUtils.primaryColor,
                            );
                          }
                        }
                      },
                      child: commonIconAndText(
                        icon: SvgPicture.asset(
                          "${basePath}star.svg",
                          height: 15,
                          width: 15,
                        ),
                        text: toUserActiveStatus == true
                            ? toLikeStatus == true
                                ? VariableUtils.unFavorite
                                : VariableUtils.favorite
                            : toLikeStatus == true
                                ? VariableUtils.unsubscribe
                                : VariableUtils.subscribe,
                      ),
                    ),
                    SizeConfig.sH3,

                    ///Delete Api
                    InkWell(
                      onTap: () async {
                        await dashBoardViewModel.feedDeleteViewModel(
                            body: {"by": byId, "to": toId, "hide": true});
                        if (dashBoardViewModel.deleteFeedApiResponse.status ==
                            Status.COMPLETE) {
                          FeedbackDeleteResModel response =
                              dashBoardViewModel.deleteFeedApiResponse.data;
                          if (response.status == 200) {
                            showSnackBar(
                              message: response.message,
                              snackColor: ColorUtils.primaryColor,
                            );
                            dashBoardViewModel.dataList(toId);
                            Navigator.pop(context);
                          } else {
                            showSnackBar(
                              message: response.message,
                              snackColor: ColorUtils.primaryColor,
                            );
                          }
                        }
                      },
                      child: commonIconAndText(
                        icon: SvgPicture.asset(
                          "${basePath}delete.svg",
                          height: 17.5,
                          width: 17.5,
                        ),
                        text: VariableUtils.delete,
                      ),
                    ),
                    SizeConfig.sH2,
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  commonIconAndText({Widget? icon, String? text}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.w),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon!,
          SizeConfig.sW5,
          Padding(
            padding: text == VariableUtils.delete
                ? const EdgeInsets.only(left: 3)
                : EdgeInsets.zero,
            child: Text(
              text!,
              style: FontTextStyle.poppinsBlack10Regular,
            ),
          ),
        ],
      ),
    );
  }
}
