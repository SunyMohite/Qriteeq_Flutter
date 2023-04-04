import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/assets/icons_utils.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/const_utils.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/home/address_book_screen.dart';
import 'package:humanscoring/view/home/feed_userlist_screen.dart';
import 'package:humanscoring/view/polls/poll_screen.dart';
import 'package:humanscoring/view/referalAndEarnScreen/referal_and_earn_screen.dart';
import 'package:humanscoring/viewmodel/address_book_viewmodel.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../common/commonWidget/custom_dialog.dart';
import '../../common/commonWidget/octo_image_widget.dart';
import '../../modal/apiModel/res_model/app_version_res_model.dart';
import '../../modal/repo/app_version_repo.dart';
import '../../modal/repo/auth_repo.dart';
import '../../service/app_notification.dart';
import '../../service/deeplink_listner.dart';
import '../../utils/font_style_utils.dart';
import '../../viewmodel/connectivity_viewmodel.dart';
import '../../viewmodel/feedback_viewmodel.dart';
import '../../viewmodel/notification_viewmodel.dart';
import '../chatScreen/chathomepage.dart';
import '../detailsScreen/feed_back_details_screen.dart';
import '../feedsSearchScreen/explore_screen.dart';
import '../loginScreen/login_screen.dart';
import '../notificationScreen/notification_screen.dart';
import '../profileScreen/profile_screen.dart';
import 'feed_inside_page/deeplink_user_profile_screen.dart';
import 'feed_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  TabController? tabController;

  NotificationViewModel notificationViewModel =
      Get.find<NotificationViewModel>();
  FeedBackViewModel feedBackViewModel = Get.find<FeedBackViewModel>();

  int? appVersion = 0;
  AuthRepo authRepo = AuthRepo();
  final NotificationMethods _notification = NotificationMethods();
  String? isLoginVia;
  @override
  void initState() {
    forceUpdate();
    notificationInitialization(context);
    logs("DashBoardViewModel INIT CALL");
    Future.delayed(Duration.zero, () {
      logs("INIT DEEPLINK CALL 1");
      initDynamicLinks();
    });

    notificationViewModel.notificationViewModel();
    authRepo.loginUserOnlineOfflineRepo({"online": true});
    isLoginVia = PreferenceManagerUtils.getIsLoginVia();
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addObserver(this);

    validateUser();

    logs("Country Code: "+PreferenceManagerUtils.getUserMobileNumber());

    super.initState();
  }
  late bool isSeen=false,isPollVisible=false;
  void validateUser()
  {
    final firestore = FirebaseFirestore.instance;
    Map<String, dynamic> data = {
      'imagepath':PreferenceManagerUtils.getUserAvatar(),
      'date_time': DateTime.now(),
      'email':"demo@gmail.com",
      'name': PreferenceManagerUtils.getAvatarUserFullName(),
    };
    firestore
        .collection('Users')
        .doc(PreferenceManagerUtils.getLoginId())
        .set(data);

    firestore.collection("MessageNotif")
        .doc(PreferenceManagerUtils.getLoginId())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        isSeen=documentSnapshot['message_seen'];
      }
      else
        {
          isSeen=false;
        }
    });

    FirebaseFirestore.instance
        .collection('poll_bank')
        .get()
        .then((QuerySnapshot querySnapshot2) {
      querySnapshot2.docs.forEach((doc) async {
        isPollVisible = doc["isActive"];
        if(isPollVisible)
          {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            int? lastDay = prefs.getInt('lastDay');
            int today = DateTime.now().day;
            if (lastDay == null || lastDay != today) {
              Alert(
                context: context,
                title: "POLL IS LIVE",
                desc: "Please give your valuable opinion and comment on Poll",
                image: IconsWidgets
                    .pollsIcon,
                buttons: [
                  DialogButton(
                    child: Text(
                      "OPEN POLL",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Get.to(()=>PollScreen()),
                    color: ColorUtils.primaryColor,
                    radius: BorderRadius.circular(0.0),
                  ),
                ],
              ).show();
              prefs.setInt("lastDay", today);
            }
          }
      });
    });
  }

  notificationInitialization(BuildContext context) async {
    _notification.notificationPermission();
    _notification.inItNotification(context);
    _notification.onNotification(context);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      ///foreground online mode
      await authRepo.loginUserOnlineOfflineRepo({"online": true});
    } else if (state == AppLifecycleState.paused) {
      ///background offline mode
      await authRepo.loginUserOnlineOfflineRepo({"online": false});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void initDynamicLinks() async {
    PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      // logs("data?.link ${data?.link}");
      final strName = data?.link.toString();
      deepLinkData.clear();
      isEqualStatus = false;
      String str = '';

      for (int i = 0; i < strName!.length + 1; i++) {
        if (strName.length == i) {
          deepLinkData.add(str);
          break;
        }
        if (isEqualStatus) {
          if (strName[i] != '&') {
            str += strName[i];
          } else {
            deepLinkData.add(str.trim());
            str = '';
            isEqualStatus = false;
          }
        } else if (strName[i] == '=') {
          isEqualStatus = true;
        }
      }
      if (PreferenceManagerUtils.getLoginId().isNotEmpty) {
        if (deepLinkData[0] == 'QrCodeScreen') {
          Get.to(FeedPostScreen(
            connect: true,
            id: deepLinkData[1],
            userName: deepLinkData[2],
          ));
        } else if (deepLinkData[0] == 'CampaignScreen') {
          Get.to(FeedPostScreen(
            connect: true,
            id: deepLinkData[1],
            userName: deepLinkData[2],
            campaignId: deepLinkData[3],
          ));
        } else if (deepLinkData[0] == 'FeedBackDetails') {
          Get.to(FeedBackDetailsScreen(
            feedBackId: deepLinkData[1],
            isCommentTap: false,
          ));
        } else if (deepLinkData[0] == 'ViewUserProfile') {
          Get.to(DeeplinkUserProfileScreen(
            userId: deepLinkData[1],
            key: ValueKey(deepLinkData[1]),
          ));
        }
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    }
  }

  ConnectivityViewModel connectivityViewModel = Get.find();

  forceUpdate() async {
    AppVersionResModel response = await AppVersionRepo().getAppVersionRepo();

    ///1
    if (Platform.isAndroid) {
      appVersion =
          int.parse(response.data!.androidVersion!.replaceAll('.', ''));
      // logs("ANDROID VERSION ${appVersion}");
    } else if (Platform.isIOS) {
      appVersion = int.parse(response.data!.iosVersion!.replaceAll('.', ''));
      // logs("IOS VERSION ${appVersion}");
    }
    if (appVersion! > int.parse(ConstUtils.aapVersion)) {
      forceUpdateDialog();
    }
  }

  List<String> deepLinkData = [];
  bool isEqualStatus = false, isAndStatus = false;
  @override
  Widget build(BuildContext context) {
    DynamicLink.listenDynamicLinks(context);
    return SafeArea(
      child: Material(
        child: GetBuilder<NotificationViewModel>(
          builder: (controller) {
            return Scaffold(
              extendBody: false,

              ///BOTTOM NAVIGATION BAR SCREEN....
              body: controller.indexChange == 0
                  ? SafeArea(
                      child: GetBuilder<AddressBookViewModel>(
                          builder: (addressCon) {
                        return Column(
                          children: [
                            PreferredSize(
                              preferredSize: const Size.fromHeight(80.0),
                              child: Container(
                                width: Get.width,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: AssetImage(
                                      'assets/image/appbarbg.webp',
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    ///HEADER WIDGET VIEW....
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          SizeConfig.sH1,
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.w),
                                                  child: Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          await Get.to(
                                                              const ProfileScreen());
                                                        },
                                                        child: OctoImageWidget(
                                                          profileLink: addressCon
                                                              .setUserAvatar,
                                                          radius: 4.2.w,
                                                        ),
                                                      ),
                                                      SizeConfig.sW3,
                                                      IconsWidgets.appLogoWhite,
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizeConfig.sW5,
                                              // SizeConfig.sW5,
                                              Material(
                                                color: ColorUtils.transparent,
                                                borderRadius:
                                                BorderRadius.circular(150),
                                                child: InkWell(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      150),
                                                  onTap: () async {
                                                    await Get.to(
                                                        const PollScreen());
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 5.w, top: 1.w),
                                                    child:isPollVisible ?
                                                        IconsWidgets
                                                        .pollsIcon : null,
                                                  ),
                                                ),
                                              ),
                                              SizeConfig.sW2,
                                              Material(
                                                color: ColorUtils.transparent,
                                                borderRadius:
                                                BorderRadius.circular(150),
                                                child: InkWell(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      150),
                                                  onTap: () async {
                                                    await Get.to(
                                                        const MyHomePage());
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 5.w, top: 1.w),
                                                    child: isSeen
                                                        ? IconsWidgets
                                                        .chat
                                                        : IconsWidgets.chatNotif,
                                                  ),
                                                ),
                                              ),
                                              SizeConfig.sW2,
                                              Material(
                                                color: ColorUtils.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(150),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          150),
                                                  onTap: () async {
                                                    await Get.to(
                                                        const NotificationScreen());
                                                    controller.update();
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 5.w, top: 1.w),
                                                    child: controller
                                                                .notificationCount ==
                                                            0
                                                        ? IconsWidgets
                                                            .notificationIcon
                                                        : IconsWidgets.bellIcon,
                                                  ),
                                                ),
                                              ),
                                              SizeConfig.sW2,
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    ///TAB BAR WIDGET VIEW....
                                    tabBarViewWidget(),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                child: TabBarView(
                              controller: tabController,
                              children: const [
                                FeedUserListScreen(),
                                AddressBookScreen(),
                              ],
                            )),
                          ],
                        );
                      }),
                    )
                  : controller.indexChange == 1
                      ? const ExploreScreen()
                      : controller.indexChange == 2
                          ? const ReferAndEarnScreen()
                          : const SizedBox(),

              ///BOTTOM NAVIGATION BAR BUTTON VIEW....

              bottomNavigationBar: Container(
                height: 20.w,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: ColorUtils.grey85.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, -10))
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    controller.bottomIconList.length,
                    (index) => InkWell(
                      onTap: () {
                        controller.indexChange = index;
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 2.w,
                            width: 18.w,
                            decoration: BoxDecoration(
                              color: controller.indexChange == index
                                  ? ColorUtils.primaryColor
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(10),
                              ),
                            ),
                          ),
                          SizeConfig.sH1,
                          SvgPicture.asset(
                            "$bottomBasePath${controller.bottomIconList[index]['icon']}",
                            color: controller.indexChange == index
                                ? ColorUtils.primaryColor
                                : Colors.grey,
                          ),
                          SizeConfig.sH1,
                          Text(
                            controller.bottomIconList[index]['title'],
                            style: FontTextStyle.poppins11RegularBlue.copyWith(
                                fontWeight: FontWeightClass.bold,
                                color: controller.indexChange == index
                                    ? ColorUtils.primaryColor
                                    : Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  TabBar tabBarViewWidget() {
    return TabBar(
      controller: tabController,
      onTap: (index) {
        logs("INDEX $index");
        setState(() {});
      },
      indicatorColor: Colors.white,
      automaticIndicatorColorAdjustment: true,
      unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w700, fontSize: 10.sp, fontFamily: 'Poppins'),
      labelStyle: TextStyle(
          fontWeight: FontWeight.w700, fontSize: 10.sp, fontFamily: 'Poppins'),
      indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(
            width: 5.0,
            color: Colors.white,
          ),
          insets: EdgeInsets.symmetric(horizontal: 5.w)),
      tabs: [
        Tab(
          icon: tabWidget(
              imagePath: "${basePath}allFeeds.webp",
              title: VariableUtils.allFeeds,
              tabIndex: 0),
        ),
        Tab(
          icon: tabWidget(
              imagePath: "${basePath}addressBook.webp",
              title: VariableUtils.reviewContacts,
              tabIndex: 1),
        ),
      ],
    );
  }

  Widget tabWidget(
      {required String imagePath,
      required String title,
      required int tabIndex}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Image.asset(
              imagePath,
              scale: 1.0.w,
              color: tabController!.index == tabIndex
                  ? Colors.white
                  : const Color(0xffB6B6B6),
            ),
          ),
          SizeConfig.sW1,
          Center(
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                  color: tabController!.index == tabIndex
                      ? Colors.white
                      : const Color(0xffB6B6B6),
                  fontSize: 10.sp),
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
