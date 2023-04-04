import 'dart:developer';

import 'package:get/get.dart';
import 'package:humanscoring/modal/apiModel/req_model/notification_read_req_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/notification_res_model.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/modal/repo/notification_repo.dart';

import '../modal/apiModel/res_model/notification_count_res_model.dart';

class NotificationViewModel extends GetxController {
  ApiResponse notificationApiResponse = ApiResponse.initial('Initial');
  ApiResponse notificationCountApiResponse = ApiResponse.initial('Initial');

  ///======================NotificationViewModel Repo=====================

  List<String> notificationId = [];
  NotificationReadReqModel notificationReadReqModel =
      NotificationReadReqModel();

  Future getNotificationViewModel() async {
    notificationApiResponse = ApiResponse.loading('Loading');
    try {
      NotificationResModel response =
          await NotificationRepo().notificationRepo();
      notificationApiResponse = ApiResponse.complete(response);

      List<NotificationData> id = response.data!;
      for (var element in id) {
        notificationId.add(element.sId!);
      }

      notificationReadReqModel.data = notificationId;
      await NotificationRepo().notificationReadRepo(notificationReadReqModel);
      setNotificationCount(0);
    } catch (e) {
      log('notificationApiResponse.......$e');
      notificationApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> notificationViewModel() async {
    notificationCountApiResponse = ApiResponse.loading('Loading');
    try {
      NotificationCountResModel response =
          await NotificationRepo().notificationCountRepo();
      notificationCountApiResponse = ApiResponse.complete(response);

      setNotificationCount(response.data!.notification!);
    } catch (e) {
      log('notificationCountApiResponse.......$e');
      notificationCountApiResponse = ApiResponse.error('error');
    }
    update();
  }

  List<Map<String, dynamic>> bottomIconList = [
    {'icon': 'home.svg', 'title': 'Home'},
    {'icon': 'explore.svg', 'title': 'Explore'},
    {'icon': 'refer_earn.svg', 'title': 'Refer & Earn'}
  ];

  int _notificationCount = 0;

  int get notificationCount => _notificationCount;

  void setNotificationCount(int value) {
    _notificationCount = value;
    update();
  }

  int _indexChange = 0;

  int get indexChange => _indexChange;

  set indexChange(int value) {
    _indexChange = value;
    update();
  }
}
