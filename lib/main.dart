import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:humanscoring/service/app_notification.dart';
import 'package:humanscoring/utils/const_utils.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/generalScreen/nointernet_screen.dart';
import 'package:humanscoring/view/loginScreen/login_screen.dart';
import 'package:humanscoring/view/loginScreen/user_register_screen.dart';
import 'package:humanscoring/viewmodel/address_book_viewmodel.dart';
import 'package:humanscoring/viewmodel/auth_viewmodel.dart';
import 'package:humanscoring/viewmodel/avatar_user_name_controller.dart';
import 'package:humanscoring/viewmodel/chat_viewmodel.dart';
import 'package:humanscoring/viewmodel/connectivity_viewmodel.dart';
import 'package:humanscoring/viewmodel/create_campaign_view_model.dart';
import 'package:humanscoring/viewmodel/dispute_view_model.dart';
import 'package:humanscoring/viewmodel/feature_request_view_model.dart';
import 'package:humanscoring/viewmodel/feedback_viewmodel.dart';
import 'package:humanscoring/viewmodel/fileupload_viewmodel.dart';
import 'package:humanscoring/viewmodel/global_feedback_viewmodel.dart';
import 'package:humanscoring/viewmodel/leaderboard_controller.dart';
import 'package:humanscoring/viewmodel/notification_viewmodel.dart';
import 'package:humanscoring/viewmodel/payment_view_model.dart';
import 'package:humanscoring/viewmodel/post_feedback_view_model.dart';
import 'package:humanscoring/viewmodel/referral_virwmodel.dart';
import 'package:humanscoring/viewmodel/search_feed_back_viewmodel.dart';
import 'package:humanscoring/viewmodel/subscribe_list_view_model.dart';
import 'package:humanscoring/viewmodel/user_generate_report_viewmodel.dart';
import 'package:humanscoring/viewmodel/your_interactions_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import 'common/commonWidget/unlock_feedback_bottomsheet_widget.dart';
import 'view/home/home_screen.dart';

///Receive message when app is in background solution for on message
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  /// FIREBASE NOTIFICATION SETUP
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await NotificationMethods.getFcmToken();
  var location = await Permission.location.request();
  var status = await Permission.contacts.request();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  ConstUtils.aapVersion = packageInfo.version.replaceAll('.', '');
  ConstUtils.displayAapVersion = packageInfo.version;
  ConstUtils.aapBuildVersion = int.parse(packageInfo.buildNumber);
  logs("${ConstUtils.aapVersion}BUILD NO ${ConstUtils.aapBuildVersion}");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? isLoginToken, isUserAvatar;

  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    isLoginToken = PreferenceManagerUtils.getLoginToken();
    isUserAvatar = PreferenceManagerUtils.getUserAvatar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: VariableUtils.appName,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: "Roboto",
              useMaterial3: true),
          onGenerateRoute: generateRoute,
          initialRoute: '/',
        );
      },
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    logs("isLoginToken $isLoginToken");
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => GetBuilder<ConnectivityViewModel>(
                  builder: (connectivityViewModel) {
                    if (connectivityViewModel.isOnline != null) {
                      if (connectivityViewModel.isOnline!) {
                        return isLoginToken!.isEmpty
                            ? const LoginScreen()
                            : isUserAvatar!.isEmpty
                                ? const UserRegisterScreen()
                                : const HomeScreen();
                        // : SuggestionScreen();
                      } else {
                        return const NoInterNetConnected();
                      }
                    } else {
                      return const Material();
                    }
                  },
                ));

      default:
        return MaterialPageRoute(
          builder: (_) => GetBuilder<ConnectivityViewModel>(
            builder: (connectivityController) {
              if (connectivityViewModel.isOnline != null) {
                if (connectivityViewModel.isOnline!) {
                  return isLoginToken!.isEmpty
                      ? const LoginScreen()
                      : isUserAvatar!.isEmpty
                          ? const UserRegisterScreen()
                          : const HomeScreen();
                  // : SuggestionScreen();
                } else {
                  return const NoInterNetConnected();
                }
              } else {
                return const Material();
              }
            },
          ),
        );
    }
  }

  /// CONTROLLER INITIALIZE
  ConnectivityViewModel connectivityViewModel =
      Get.put(ConnectivityViewModel());
  AuthViewModel authViewModel = Get.put(AuthViewModel());
  PaymentViewModel paymentViewModel = Get.put(PaymentViewModel());
  NotificationViewModel notificationViewModel =
      Get.put(NotificationViewModel());
  AvatarUserNameController userNameController =
      Get.put(AvatarUserNameController());
  LeaderBoardController leaderBoardController =
      Get.put(LeaderBoardController());
  YourInteractionsController yourInteractionsController =
      Get.put(YourInteractionsController());
  AddressBookViewModel addressBookViewModel = Get.put(AddressBookViewModel());
  SubScribeListViewModel scribeListViewModel =
      Get.put(SubScribeListViewModel());
  PostFeedBackViewModel postFeedBackViewModel =
      Get.put(PostFeedBackViewModel());
  // DashBoardViewModel dashBoardViewModel = Get.put(DashBoardViewModel());
  FeedBackViewModel feedBackViewModel = Get.put(FeedBackViewModel());
  GlobalFeedBackViewModel globalFeedBackViewModel =
      Get.put(GlobalFeedBackViewModel());
  SearchFeedBackViewModel searchFeedBackViewModel =
      Get.put(SearchFeedBackViewModel());
  ChatViewModel chatViewModel = Get.put(ChatViewModel());
  ReferralViewModel referralViewModel = Get.put(ReferralViewModel());

  FeatureRequestViewModel featureRequestViewModel =
      Get.put(FeatureRequestViewModel());

  UserGenerateReportViewModel userGenerateReportViewModel =
      Get.put(UserGenerateReportViewModel());
  InstantViewModel instantViewModel = Get.put(InstantViewModel());
  DisputeViewModel disputeViewModel = Get.put(DisputeViewModel());
  CreateCampaignRequestViewModel createCampaignRequestViewModel =
      Get.put(CreateCampaignRequestViewModel());
  FileUploadViewModel fileUploadViewModel = Get.put(FileUploadViewModel());
}
