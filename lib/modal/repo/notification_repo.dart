import 'package:humanscoring/modal/apiModel/req_model/notification_read_req_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/notification_count_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/notification_read_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/notification_res_model.dart';
import 'package:humanscoring/modal/services/api_service.dart';
import 'package:humanscoring/modal/services/base_service.dart';
import 'package:humanscoring/utils/enum_utils.dart';

class NotificationRepo extends BaseService {
  ///==========================Notification Repo====================
  Future notificationRepo() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: notification,
    );
    NotificationResModel notificationResModel =
        NotificationResModel.fromJson(response);
    return notificationResModel;
  }
  ///==========================Notification Read Repo====================

  Future notificationReadRepo(NotificationReadReqModel model) async {
    Map<String, dynamic> body = model.toJson();

    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: notificationRead,
      body: body,
    );
    NotificationReadResModel notificationReadResModel =
        NotificationReadResModel.fromJson(response);
    return notificationReadResModel;
  }
  ///==========================Notification Read Repo====================

  Future notificationCountRepo() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: userApi,
    );

    NotificationCountResModel notificationCountResModel =
        NotificationCountResModel.fromJson(response);

    return notificationCountResModel;
  }
}
