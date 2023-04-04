import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/const_utils.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../common/commonWidget/nodatafound_widget.dart';
import '../../../common/commonWidget/octo_image_widget.dart';
import '../../../common/commonWidget/snackbar.dart';
import '../../../modal/apis/api_response.dart';
import '../../../utils/assets/icons_utils.dart';
import '../../../utils/assets/images_utils.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/decoration_utils.dart';
import '../../../utils/enum_utils.dart';
import '../../../utils/font_style_utils.dart';
import '../../../utils/shared_preference_utils.dart';
import '../../../utils/size_config_utils.dart';
import '../../../utils/variable_utils.dart';
import '../../../viewmodel/leaderboard_controller.dart';
import '../../home/feed_inside_page/user_profile_inside_page.dart';

class NewLeaderBoardScreen extends StatefulWidget {
  const NewLeaderBoardScreen({Key? key}) : super(key: key);

  @override
  State<NewLeaderBoardScreen> createState() => _NewLeaderBoardScreenState();
}

class _NewLeaderBoardScreenState extends State<NewLeaderBoardScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  String? leaderBoardScreen = 'LeaderBoardScreen';

  LeaderBoardController leaderBoardController =
      Get.find<LeaderBoardController>();
  bool serviceStatus = false;
  bool hasPermission = false;
  late LocationPermission permission;
  PermissionStatus? permissionStatus;

  late Position position;
  String long = "", lat = "";
  late ScrollController leaderBoardScrollController;

  @override
  void initState() {
    // checkGps();

    leaderBoardController.initIsTabSelector = 0;
    leaderBoardController.isLeaderBoardScrollLoading = true;
    if (leaderBoardController.isLeaderBoardScrollLoading == true) {
      _firstLoad();
    }
    leaderBoardScrollController = ScrollController()..addListener(_loadMore);

    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    leaderBoardScrollController.removeListener(_loadMore);
    super.dispose();
  }

  void _loadMore() async {
    if (leaderBoardController.isLeaderBoardScrollLoading == false &&
        leaderBoardController.isLeaderBoardMoreLoading == false &&
        leaderBoardScrollController.position.extentAfter < 300) {
      try {
        leaderBoardController.getLeaderBoardPagenationViewModel(
            filter: leaderBoardController.isTabSelector ==
                    LeaderBoardTab.nearBy.index
                ? 'nearBy'
                : leaderBoardController.isTabSelector ==
                        LeaderBoardTab.myCountry.index
                    ? 'country'
                    : 'global',
            lat: lat,
            long: long);
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }
    }
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    long = position.longitude.toString();
    lat = position.latitude.toString();
    _firstLoad();
    // setState(() {});
    logs("permissionStatus $permissionStatus LAT =====  $lat LONG ===== $long");
  }

  _firstLoad() async {
    try {
      logs(
          "leaderBoardController.leaderBoardResultsList! =========== ${leaderBoardController.leaderBoardResultsList!.length}");
      permissionStatus = await Permission.location.request();
      if (permissionStatus!.isGranted && lat.isEmpty && long.isEmpty) {
        leaderBoardController.leaderBoardResultsList!.clear();

        await getLocation();
        leaderBoardController.isLocationPermissionStatus = true;
      } else if (permissionStatus!.isGranted &&
          lat.isNotEmpty &&
          long.isNotEmpty) {
        leaderBoardController.leaderBoardPage = 1;
        leaderBoardController.leaderBoardResultsList!.clear();
        leaderBoardController.getLeaderBoardPagenationViewModel(
            filter: leaderBoardController.isTabSelector ==
                    LeaderBoardTab.nearBy.index
                ? 'nearBy'
                : leaderBoardController.isTabSelector ==
                        LeaderBoardTab.myCountry.index
                    ? 'country'
                    : 'global',
            lat: lat,
            long: long);
      }
    } on Exception catch (e) {
      // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              left: 0,
              bottom: 0,
              child: Image.asset(
                leaderboardBackgroundImg,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                SizeConfig.sH2,

                ///HEADER VIEW...
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
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
                        VariableUtils.leaderboard,
                        style: FontTextStyle.poppinsWhite11semiB.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 13.sp),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: GetBuilder<LeaderBoardController>(
                    builder: (leaderBoardController) {
                      if (leaderBoardController.leaderBoardApiResponse.status ==
                          Status.ERROR) {
                        return const NoDataFoundWidget(
                          message: "No user found",
                        );
                      }
                      var countryRes =
                          leaderBoardController.leaderBoardResultsList!;
                      return Column(
                        children: [
                          SizeConfig.sH1,
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Container(
                              height: 12.w,
                              decoration: const BoxDecoration(
                                color: ColorUtils.leaderblur,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: TabBar(
                                onTap: (value) async {
                                  leaderBoardController
                                      .isLeaderBoardScrollLoading = true;

                                  leaderBoardController.leaderBoardPage = 1;
                                  leaderBoardController.leaderBoardResultsList!
                                      .clear();
                                  leaderBoardController.isTabSelector = value;

                                  await leaderBoardController
                                      .getLeaderBoardPagenationViewModel(
                                          filter: leaderBoardController
                                                      .isTabSelector ==
                                                  LeaderBoardTab.nearBy.index
                                              ? 'nearBy'
                                              : leaderBoardController
                                                          .isTabSelector ==
                                                      LeaderBoardTab
                                                          .myCountry.index
                                                  ? 'country'
                                                  : 'global',
                                          lat: lat,
                                          long: long,
                                          initLoad: true);
                                },
                                controller: tabController,
                                indicatorColor: const Color(0xFF699BF7),
                                indicatorWeight: 3,
                                tabs: [
                                  Text(
                                    VariableUtils.nearby,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 11.sp),
                                  ),
                                  Text(
                                    VariableUtils.myCountry,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 11.sp),
                                  ),
                                  Text(
                                    VariableUtils.global,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 11.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizeConfig.sH2,

                          leaderBoardController.isTabSelector ==
                                      LeaderBoardTab.nearBy.index &&
                                  lat.isEmpty &&
                                  long.isEmpty
                              ? InkWell(
                                  onTap: () async {
                                    openAppSettings().then((value) async {
                                      permissionStatus =
                                          await Permission.location.request();

                                      if (value == false) {
                                        showSnackBar(
                                            message: VariableUtils
                                                .betterLocationExperience);
                                      } else {
                                        ///CALL API HERE ...
                                        if (permissionStatus!.isGranted) {
                                          await getLocation();
                                          setState(() {});
                                        }
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 13.w,
                                    margin: EdgeInsets.only(
                                        left: 5.w, right: 5.w, bottom: 5.w),
                                    decoration: DecorationUtils
                                        .allBorderAndColorDecorationBox(
                                            radius: 7,
                                            colors: ColorUtils.white),
                                    child: Center(
                                      child: Text(
                                        VariableUtils.betterLocationExperience,
                                        style: FontTextStyle.poppinsWhite10bold
                                            .copyWith(
                                                color: ColorUtils.primaryColor),
                                      ),
                                    ),
                                  ),
                                )
                              : leaderBoardController.isLeaderBoardScrollLoading
                                  ? Expanded(
                                      child: SizedBox(
                                      height: 35.w,
                                      width: 35.w,
                                      child: Center(
                                        child: Lottie.asset(
                                            'assets/json/loader.json',
                                            height: 35.w,
                                            width: 35.w),
                                      ),
                                    ))
                                  : leaderBoardController
                                          .leaderBoardResultsList!.isEmpty
                                      ? SizedBox(
                                          width: Get.width,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizeConfig.sH5,
                                              Text(
                                                "No users ${leaderBoardController.isTabSelector == LeaderBoardTab.nearBy.index ? "nearby" : leaderBoardController.isTabSelector == LeaderBoardTab.myCountry.index ? "my country" : leaderBoardController.isTabSelector == LeaderBoardTab.global.index ? "global" : ''}. Refer people near \nyour location to earn coins",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizeConfig.sH5,
                                              PreferenceManagerUtils
                                                          .getReferralCode()
                                                      .isEmpty
                                                  ? const SizedBox()
                                                  : Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 3.w,
                                                              vertical: 3.w),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffEEEEEE),
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              PreferenceManagerUtils
                                                                  .getReferralCode(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              if (PreferenceManagerUtils
                                                                      .getReferralCodeDeepLink()
                                                                  .isEmpty) {
                                                                showSnackBar(
                                                                    message:
                                                                        "Something went to wrong");
                                                                return;
                                                              }
                                                              await Share.share(
                                                                  "Hey there! ${PreferenceManagerUtils.getAvatarUserName()} is inviting you to join QriteeQ. Click on this link to Download the App: ${PreferenceManagerUtils.getReferralCodeDeepLink()} to visit his profile.\nRegards,\nTeam QriteeQ");
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5.w,
                                                                      vertical:
                                                                          3.w),
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      ColorUtils
                                                                          .blue14,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Text(
                                                                "SHARE",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                /// SECOND

                                                countryRes.length >= 2 &&
                                                        leaderBoardController
                                                                .isTabSelector ==
                                                            LeaderBoardTab
                                                                .nearBy.index
                                                    ? InkWell(
                                                        onTap: () {
                                                          if (countryRes[1]
                                                                  .blockStatus!
                                                                  .hideUser ==
                                                              true) {
                                                            showSnackBar(
                                                                message: countryRes[
                                                                        1]
                                                                    .blockStatus!
                                                                    .hideUserMessage);
                                                            return;
                                                          }
                                                          secondRankUserProfileNavigate(
                                                              context,
                                                              leaderBoardController,
                                                              countryRes,
                                                              1);
                                                        },
                                                        child:
                                                            secondRankTagUserWidget(
                                                                countryRes),
                                                      )
                                                    : countryRes.length >= 2 &&
                                                            leaderBoardController
                                                                    .isTabSelector ==
                                                                LeaderBoardTab
                                                                    .myCountry
                                                                    .index
                                                        ? InkWell(
                                                            onTap: () {
                                                              if (countryRes[1]
                                                                      .blockStatus!
                                                                      .hideUser ==
                                                                  true) {
                                                                showSnackBar(
                                                                    message: countryRes[
                                                                            1]
                                                                        .blockStatus!
                                                                        .hideUserMessage);
                                                                return;
                                                              }
                                                              secondRankUserProfileNavigate(
                                                                  context,
                                                                  leaderBoardController,
                                                                  countryRes,
                                                                  1);
                                                            },
                                                            child:
                                                                secondRankTagUserWidget(
                                                                    countryRes),
                                                          )
                                                        : countryRes.length >=
                                                                    2 &&
                                                                leaderBoardController
                                                                        .isTabSelector ==
                                                                    LeaderBoardTab
                                                                        .global
                                                                        .index
                                                            ? InkWell(
                                                                onTap: () {
                                                                  if (countryRes[
                                                                              1]
                                                                          .blockStatus!
                                                                          .hideUser ==
                                                                      true) {
                                                                    showSnackBar(
                                                                        message: countryRes[1]
                                                                            .blockStatus!
                                                                            .hideUserMessage);
                                                                    return;
                                                                  }
                                                                  secondRankUserProfileNavigate(
                                                                      context,
                                                                      leaderBoardController,
                                                                      countryRes,
                                                                      1);
                                                                },
                                                                child: secondRankTagUserWidget(
                                                                    countryRes),
                                                              )
                                                            : const SizedBox(),

                                                /// FIRST

                                                countryRes.isNotEmpty &&
                                                        leaderBoardController
                                                                .isTabSelector ==
                                                            LeaderBoardTab
                                                                .nearBy.index
                                                    ? InkWell(
                                                        onTap: () {
                                                          if (countryRes[0]
                                                                  .blockStatus!
                                                                  .hideUser ==
                                                              true) {
                                                            showSnackBar(
                                                                message: countryRes[
                                                                        0]
                                                                    .blockStatus!
                                                                    .hideUserMessage);
                                                            return;
                                                          }
                                                          secondRankUserProfileNavigate(
                                                              context,
                                                              leaderBoardController,
                                                              countryRes,
                                                              0);
                                                        },
                                                        child:
                                                            firstRankTagUserWidget(
                                                                countryRes),
                                                      )
                                                    : countryRes.isNotEmpty &&
                                                            leaderBoardController
                                                                    .isTabSelector ==
                                                                LeaderBoardTab
                                                                    .myCountry
                                                                    .index
                                                        ? InkWell(
                                                            onTap: () {
                                                              if (countryRes[0]
                                                                      .blockStatus!
                                                                      .hideUser ==
                                                                  true) {
                                                                showSnackBar(
                                                                    message: countryRes[
                                                                            0]
                                                                        .blockStatus!
                                                                        .hideUserMessage);
                                                                return;
                                                              }
                                                              secondRankUserProfileNavigate(
                                                                  context,
                                                                  leaderBoardController,
                                                                  countryRes,
                                                                  0);
                                                            },
                                                            child:
                                                                firstRankTagUserWidget(
                                                                    countryRes),
                                                          )
                                                        : countryRes.isNotEmpty &&
                                                                leaderBoardController
                                                                        .isTabSelector ==
                                                                    LeaderBoardTab
                                                                        .global
                                                                        .index
                                                            ? InkWell(
                                                                onTap: () {
                                                                  if (countryRes[
                                                                              0]
                                                                          .blockStatus!
                                                                          .hideUser ==
                                                                      true) {
                                                                    showSnackBar(
                                                                        message: countryRes[0]
                                                                            .blockStatus!
                                                                            .hideUserMessage);
                                                                    return;
                                                                  }
                                                                  secondRankUserProfileNavigate(
                                                                      context,
                                                                      leaderBoardController,
                                                                      countryRes,
                                                                      0);
                                                                },
                                                                child: firstRankTagUserWidget(
                                                                    countryRes),
                                                              )
                                                            : const SizedBox(),

                                                /// THIRD
                                                countryRes.length >= 3 &&
                                                        leaderBoardController
                                                                .isTabSelector ==
                                                            LeaderBoardTab
                                                                .nearBy.index
                                                    ? InkWell(
                                                        onTap: () {
                                                          if (countryRes[2]
                                                                  .blockStatus!
                                                                  .hideUser ==
                                                              true) {
                                                            showSnackBar(
                                                                message: countryRes[
                                                                        2]
                                                                    .blockStatus!
                                                                    .hideUserMessage);
                                                            return;
                                                          }
                                                          secondRankUserProfileNavigate(
                                                              context,
                                                              leaderBoardController,
                                                              countryRes,
                                                              2);
                                                        },
                                                        child:
                                                            thirdRankUserTagWidget(
                                                                countryRes),
                                                      )
                                                    : countryRes.length >= 3 &&
                                                            leaderBoardController
                                                                    .isTabSelector ==
                                                                LeaderBoardTab
                                                                    .myCountry
                                                                    .index
                                                        ? InkWell(
                                                            onTap: () {
                                                              if (countryRes[2]
                                                                      .blockStatus!
                                                                      .hideUser ==
                                                                  true) {
                                                                showSnackBar(
                                                                    message: countryRes[
                                                                            2]
                                                                        .blockStatus!
                                                                        .hideUserMessage);
                                                                return;
                                                              }
                                                              secondRankUserProfileNavigate(
                                                                  context,
                                                                  leaderBoardController,
                                                                  countryRes,
                                                                  2);
                                                            },
                                                            child:
                                                                thirdRankUserTagWidget(
                                                                    countryRes),
                                                          )
                                                        : countryRes.length >=
                                                                    3 &&
                                                                leaderBoardController
                                                                        .isTabSelector ==
                                                                    LeaderBoardTab
                                                                        .global
                                                                        .index
                                                            ? InkWell(
                                                                onTap: () {
                                                                  if (countryRes[
                                                                              2]
                                                                          .blockStatus!
                                                                          .hideUser ==
                                                                      true) {
                                                                    showSnackBar(
                                                                        message: countryRes[2]
                                                                            .blockStatus!
                                                                            .hideUserMessage);
                                                                    return;
                                                                  }
                                                                  secondRankUserProfileNavigate(
                                                                      context,
                                                                      leaderBoardController,
                                                                      countryRes,
                                                                      2);
                                                                },
                                                                child: thirdRankUserTagWidget(
                                                                    countryRes),
                                                              )
                                                            : const SizedBox()
                                              ],
                                            ),
                                          ],
                                        ),
                          SizeConfig.sH3,

                          ///LIST VIEW....
                          countryRes.length >= 3 &&
                                  leaderBoardController.isTabSelector ==
                                      LeaderBoardTab.nearBy.index
                              ? leaderBoardListingUser(
                                  leaderBoardController, countryRes)
                              : countryRes.length >= 3 &&
                                      leaderBoardController.isTabSelector ==
                                          LeaderBoardTab.myCountry.index
                                  ? leaderBoardListingUser(
                                      leaderBoardController, countryRes)
                                  : countryRes.length >= 3 &&
                                          leaderBoardController.isTabSelector ==
                                              LeaderBoardTab.global.index
                                      ? leaderBoardListingUser(
                                          leaderBoardController, countryRes)
                                      : const SizedBox()
                        ],
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget leaderBoardListingUser(LeaderBoardController leaderBoardController,
      List<dynamic> userListingList) {
    return Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: Container(
          padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
          height: 40.89.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: userListingList.length <= 3
                ? Colors.transparent
                : ColorUtils.leaderblur,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ListView.builder(
            controller: leaderBoardScrollController,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: userListingList.length - 3,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  if (userListingList[index + 3].blockStatus!.hideUser ==
                      true) {
                    showSnackBar(
                        message: userListingList[index + 3]
                            .blockStatus!
                            .hideUserMessage);
                    return;
                  }
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserInsidePage(
                        screenName: leaderBoardScreen,
                        userName: userListingList[index + 3].user!.userIdentity,
                        avatar: userListingList[index + 3].user!.avatar!,
                        toId: userListingList[index + 3].user!.id!,
                        phone: userListingList[index + 3].user!.phone,
                        favorite:
                            userListingList[index + 3].defaultStatus == null
                                ? false
                                : userListingList[index + 3]
                                    .defaultStatus!
                                    .favorite,
                        isBlock: userListingList[index + 3].defaultStatus ==
                                null
                            ? false
                            : userListingList[index + 3].defaultStatus!.block,
                        flag: userListingList[index + 3].defaultStatus == null
                            ? false
                            : userListingList[index + 3].defaultStatus!.flag,
                        online: userListingList[index + 3].user!.online,
                        active: userListingList[index + 3].user!.active,
                      ),
                    ),
                  );
                  // leaderBoardController.getLeaderBoardViewModel(
                  //     lat: lat, long: long);
                },
                child: userListingWidget(
                    index, leaderBoardController, userListingList),
              );
            },
          ),
        ),
      ),
    );
  }

  Padding userListingWidget(
      int index,
      LeaderBoardController leaderBoardController,
      List<dynamic> userListingList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Row(
          children: [
            Text(
              '${index + 4}',
              style: TextStyle(
                  color: ColorUtils.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp),
            ),
            SizedBox(
              width: 3.h,
            ),
            Stack(
              children: [
                OctoImageWidget(
                  profileLink: userListingList[index + 3].user!.avatar!,
                ),
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
                          color:
                              userListingList[index + 3].user!.online! == true
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
            SizedBox(
              width: 2.h,
            ),
            Expanded(
              flex: 3,
              child: Text(
                userListingList[index + 3].user!.userIdentity ?? 'N/A',
                style: TextStyle(
                    color: ColorUtils.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            Text(
              "${userListingList[index + 3].postedCount} Post",
              style: TextStyle(
                  color: ColorUtils.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 10.sp),
            ),
          ],
        ),
      ),
    );
  }

  Stack firstRankTagUserWidget(List<dynamic> userFilterList) {
    return Stack(
      children: [
        Container(
          height: 35.w,
          width: 35.w,
          decoration: const BoxDecoration(
            color: ColorUtils.leaderblur,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          margin: EdgeInsets.only(top: 20.w),
          padding: const EdgeInsets.only(bottom: 38),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizeConfig.sH3,
              onlineStatusTextWidget(
                  onlineStatus: userFilterList[0].user!.online!),
              SizeConfig.sH1,
              userIdentityTextWidget(
                  userIdentity: userFilterList[0].user!.userIdentity!),
              SizeConfig.sH1,
              Text(
                "${userFilterList[0].postedCount} Post",
                style: FontTextStyle.poppins12DarkBlack.copyWith(
                    color: ColorUtils.leaderfirstwinner, fontSize: 10.sp),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Column(
            children: [
              Image.asset(
                crownImg,
                height: 10.w,
                width: 10.w,
              ),
              SizeConfig.sH1,
              Container(
                height: 15.w,
                width: 15.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(winnerfirstImg),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 2.w, top: 1.w, right: 2.w, bottom: 4.w),
                  child: OctoImageWidget(
                    profileLink: userFilterList[0].user!.avatar!,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Stack secondRankTagUserWidget(List<dynamic> userFilterList) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            height: 30.w,
            width: 26.w,
            decoration: const BoxDecoration(
              color: ColorUtils.leaderdarkblur,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizeConfig.sH3,
                onlineStatusTextWidget(
                    onlineStatus: userFilterList[1].user!.online!),
                SizeConfig.sH1,
                userIdentityTextWidget(
                    userIdentity: userFilterList[1].user!.userIdentity!),
                SizeConfig.sH1,
                Text(
                  "${userFilterList[1].postedCount} Post",
                  style: FontTextStyle.poppins12DarkBlack.copyWith(
                      color: ColorUtils.leaderseconddwinner, fontSize: 10.sp),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Container(
            height: 15.w,
            width: 15.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(wiinersecondImg),
                fit: BoxFit.contain,
              ),
            ),
            child: Padding(
              padding:
                  EdgeInsets.only(left: 2.w, top: 1.w, right: 2.w, bottom: 4.w),
              child: OctoImageWidget(
                profileLink: userFilterList[1].user!.avatar!,
              ),
            ),
          ),
        )
      ],
    );
  }

  Stack thirdRankUserTagWidget(
    List<dynamic> userFilterList,
  ) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Container(
            height: 30.w,
            width: 26.w,
            decoration: const BoxDecoration(
              color: ColorUtils.leaderdarkblur,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizeConfig.sH2,
                onlineStatusTextWidget(
                    onlineStatus: userFilterList[2].user!.online!),
                SizeConfig.sH1,
                userIdentityTextWidget(
                    userIdentity: userFilterList[2].user!.userIdentity!),
                SizeConfig.sH1,
                Text(
                  "${userFilterList[2].postedCount} Post",
                  style: FontTextStyle.poppins12DarkBlack.copyWith(
                      color: ColorUtils.leaderthirdwinner, fontSize: 10.sp),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Container(
            height: 15.w,
            width: 15.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(winnerthirdImg),
                fit: BoxFit.contain,
              ),
            ),
            child: Padding(
              padding:
                  EdgeInsets.only(left: 2.w, top: 1.w, right: 2.w, bottom: 4.w),
              child: OctoImageWidget(
                profileLink: userFilterList[2].user!.avatar!,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget userIdentityTextWidget({required String userIdentity}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: Text(
        userIdentity,
        style: FontTextStyle.poppins12DarkBlack
            .copyWith(color: ColorUtils.white, fontSize: 9.sp),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Text onlineStatusTextWidget({required bool onlineStatus}) {
    return Text(onlineStatus ? "Online" : "Offline",
        style: FontTextStyle.poppins12DarkBlack.copyWith(
            color: onlineStatus ? ColorUtils.green : ColorUtils.grey,
            fontSize: 9.sp));
  }

  void secondRankUserProfileNavigate(BuildContext context,
      LeaderBoardController leaderBoardController, dataRes, int currentIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserInsidePage(
          screenName: leaderBoardScreen,
          userName: dataRes[currentIndex].user!.userIdentity,
          avatar: dataRes[currentIndex].user!.avatar!,
          toId: dataRes[currentIndex].user!.id!,
          phone: dataRes[currentIndex].user!.phone,
          favorite: dataRes[currentIndex].defaultStatus!.favorite,
          isBlock: dataRes[currentIndex].defaultStatus!.block,
          flag: dataRes[currentIndex].defaultStatus!.flag,
          online: dataRes[currentIndex].user!.online,
          active: dataRes[currentIndex].user!.active,
        ),
      ),
    );
  }
}
