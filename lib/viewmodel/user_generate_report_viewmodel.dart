import 'dart:developer';

import 'package:get/get.dart';

import '../modal/apiModel/res_model/generate_report_res_model.dart';
import '../modal/apiModel/res_model/user_generate_report_res_model.dart';
import '../modal/apis/api_response.dart';
import '../modal/repo/generate_report_repo.dart';

class UserGenerateReportViewModel extends GetxController {
  ApiResponse getReportListApiResponse = ApiResponse.initial('Initial');
  ApiResponse getUserReportListApiResponse = ApiResponse.initial('Initial');

  /// ==================getReportListViewModel===================

  List<GenerateReportData> getReportList = [];
  int getReportPage = 1;
  int getReportTotalData = 0;
  bool isGetReportFirstLoading = true;
  bool _isGetReportMoreLoading = false;

  bool get isGetReportMoreLoading => _isGetReportMoreLoading;

  Future<void> getReportListViewModel(
      {bool? initLoad = true, bool? myReport}) async {
    if (getReportList.length >= getReportTotalData &&
        getReportList.isNotEmpty) {
      return;
    }

    getReportListApiResponse = ApiResponse.loading('Loading');
    _isGetReportMoreLoading = true;
    if (initLoad == true) {
      update();
    }
    try {
      String url = "user/getReports?page=$getReportPage&myReport=$myReport";
      GenerateReportResModel response =
          await GenerateReportRepo().generateReportRepo(url: url);
      getReportListApiResponse = ApiResponse.complete(response);
      getReportTotalData = response.data!.totalResults!;

      getReportPage += 1;
      getReportList.addAll(response.data!.results!);
      isGetReportFirstLoading = false;
      _isGetReportMoreLoading = false;
    } catch (e) {
      isGetReportFirstLoading = false;
      _isGetReportMoreLoading = false;
      log('getReportListApiResponse.......$e');
      getReportListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// ==================getUserReportListViewModel===================

  List<UserGenerateReportResults> getUserReportList = [];

  int getUserReportPage = 1;
  int getUserReportTotalData = 0;
  bool isGetUserReportFirstLoading = true;
  bool _isGetUserReportMoreLoading = false;

  bool get isGetUserReportMoreLoading => _isGetUserReportMoreLoading;

  Future<void> getUserReportListViewModel(
      {bool? initLoad = true,
      required String userId,
      required bool myReport}) async {
    if (getUserReportList.length >= getReportTotalData &&
        getUserReportList.isNotEmpty) {
      return;
    }
    getUserReportListApiResponse = ApiResponse.loading('Loading');
    _isGetUserReportMoreLoading = true;
    if (initLoad == true) {
      update();
    }
    // update();
    try {
      String url =
          "user/getReports?page=$getUserReportPage&id=$userId&myReport=$myReport";

      UserGenerateReportResModel response =
          await GenerateReportRepo().userGenerateReportListRepo(url: url);

      getUserReportListApiResponse = ApiResponse.complete(response);
      getUserReportTotalData = response.data!.totalResults!;

      getUserReportPage += 1;
      getUserReportList.addAll(response.data!.results!);
      isGetUserReportFirstLoading = false;
      _isGetUserReportMoreLoading = false;
    } catch (e) {
      log('getUserReportListApiResponse.......$e');
      isGetUserReportFirstLoading = false;
      _isGetUserReportMoreLoading = false;
      getUserReportListApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
