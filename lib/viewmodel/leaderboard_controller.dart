import 'dart:developer';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/modal/repo/leader_boared_repo.dart';

import '../modal/apiModel/res_model/get_leaderboard_filter_res_model.dart';

class LeaderBoardController extends GetxController {
  ApiResponse leaderBoardApiResponse = ApiResponse.initial('Initial');
  List<LeaderBoardResults>? leaderBoardResultsList = [];
  int leaderBoardResultTotalData = 0;
  int leaderBoardPage = 1;
  bool _isLeaderBoardMoreLoading = false;
  bool isLeaderBoardScrollLoading = false;

  bool get isLeaderBoardMoreLoading => _isLeaderBoardMoreLoading;

  Future<void> getLeaderBoardPagenationViewModel({
    required String filter,
    required var lat,
    required var long,
    bool? initLoad = true,
  }) async {
    if (leaderBoardResultsList!.length >= leaderBoardResultTotalData &&
        leaderBoardResultsList!.isNotEmpty) {
      return;
    }
    if (leaderBoardApiResponse.status != Status.COMPLETE) {
      leaderBoardApiResponse = ApiResponse.loading('Loading');
    } else {
      _isLeaderBoardMoreLoading = true;
    }
    if (initLoad == true) {
      update();
    }
    String? url =
        "feedback/leaderboard?lat=$lat&lon=$long&filter=$filter&limit=10&page=$leaderBoardPage";
    try {
      GetLeaderBoardResModel response =
          await LeaderBoardRepo().leaderBoardRepo(url: url);
      leaderBoardApiResponse = ApiResponse.complete(response);
      leaderBoardResultTotalData = response.data!.totalResults!;
      leaderBoardPage += 1;
      leaderBoardResultsList!.addAll(response.data!.results!);
      isLeaderBoardScrollLoading = false;
      _isLeaderBoardMoreLoading = false;
    } catch (e) {
      leaderBoardResultsList!.clear();
      isLeaderBoardScrollLoading = false;
      _isLeaderBoardMoreLoading = false;
      log('leaderBoardApiResponse.......$e');
      leaderBoardApiResponse = ApiResponse.error('error');
    }
    update();
  }

  int _isTabSelector = 0;

  int get isTabSelector => _isTabSelector;

  set isTabSelector(int value) {
    _isTabSelector = value;
    update();
  }

  set initIsTabSelector(int value) {
    _isTabSelector = value;
  }

  bool _isLocationPermissionStatus = false;

  bool get isLocationPermissionStatus => _isLocationPermissionStatus;

  set isLocationPermissionStatus(bool value) {
    _isLocationPermissionStatus = value;
    update();
  }
}
