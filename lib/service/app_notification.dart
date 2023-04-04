import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../utils/const_utils.dart';
import '../utils/shared_preference_utils.dart';
import '../view/detailsScreen/feed_back_details_screen.dart';
import '../view/loginScreen/login_screen.dart';
import '../view/profileScreen/drawerScreen/user_transactions_screen.dart';
import '../view/reportScreen/user_generate_report_list_screen.dart';
import '../viewmodel/bottom_viewmodel.dart';

class NotificationMethods {
  ///notification
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static AndroidNotificationDetails androidPlatformChannelSpecifics =
      const AndroidNotificationDetails(
    'QriteeQ',
    'Song Request Status Notifications',
    channelDescription: 'Song Request Status Notifications',
    playSound: true,
    importance: Importance.high,
    priority: Priority.max,
    icon: '@drawable/notification_icon',
  );

  static const IOSNotificationDetails iOSPlatformChannelSpecifics =
      IOSNotificationDetails();
  static NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  /// initialization of notification
  inItNotification(BuildContext context) async {
    /// set for foreground notification
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    /// On notification click when app is open (local notification click)
    flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
            android:
                AndroidInitializationSettings('@drawable/notification_icon'),
            iOS: IOSInitializationSettings()),
        onSelectNotification: (String? payload) async {
      logs("payload $payload");
      if (payload != null) {
        Map<String, dynamic> messageData = jsonDecode(payload);

        redirectScreen(messageData, context);
      }
    });
  }

  //

  onNotification(BuildContext context) {
    /// on notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      Map<String, dynamic> messageData = message.data;

      if (notification != null && android != null) {
        await flutterLocalNotificationsPlugin.show(notification.hashCode,
            notification.title, notification.body, platformChannelSpecifics,
            payload: json.encode(messageData));
      }
    });

    /// when app is in background and user tap on it.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
      if (message != null) {
        Map<String, dynamic> messageData = message.data;
        redirectScreen(messageData, context);
      }
    });

    /// when app is in terminated and user tap on it.
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message != null) {
        Map<String, dynamic> messageData = message.data;

        redirectScreen(messageData, context);
        // logs('============TERMINATED===============$messageData');
      }
    });
  }

  ///====================get fcm token==========================
  static Future<void> getFcmToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    // firebaseMessaging.deleteToken();
    try {
      String? token = await firebaseMessaging.getToken().catchError((e) {
      });

      await PreferenceManagerUtils.setFcmToken(token!);
      logs(
          "=========FCM-TOKEN AFTER ======${PreferenceManagerUtils.getFcmToken()}");
    } catch (e) {
      return;
    }
  }

  /// notification permission
  notificationPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        sound: true);
  }

  void redirectScreen(Map<String, dynamic> messageData, BuildContext context) {
    String id = messageData['id'];
    String? tag = messageData['tag'];

    if (PreferenceManagerUtils.getLoginId().isNotEmpty) {
      BottomViewModel bottomViewModel = Get.put(BottomViewModel());
      bottomViewModel.selectedBottomIndex = 0;
      if (tag == 'comment' || tag == 'feedback') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => FeedBackDetailsScreen(
                      feedBackId: id,
                      isCommentTap: tag == 'comment' ? true : false,
                      screenName: 'AppNotification',
                    )));
      } else if (tag == 'transaction') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const UserTransactionScreen()));
      } else if (tag == 'report') {
        String? userName = messageData['userName'] ?? '';

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => UserGenerateReportListScreen(
                      userId: id,
                      userName: userName!,
                      myReport: false,
                      screenName: 'AppNotification',
                    )));
      }
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }
}
