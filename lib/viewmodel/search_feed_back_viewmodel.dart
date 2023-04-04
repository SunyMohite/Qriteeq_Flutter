import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_search_res_model.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/modal/repo/search_feedback_repo.dart';

import '../utils/shared_preference_utils.dart';

class RecentSearchModel {
  String? fullName;
  String? avatar;

  RecentSearchModel({this.fullName, this.avatar});

  RecentSearchModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    avatar = json['avatar'] ?? '';
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'avatar': avatar,
      };
}

class SearchFeedBackViewModel extends GetxController {
  List<RecentSearchModel> _recentSearchList = [];

  List<RecentSearchModel> get recentSearchList => _recentSearchList;

  setRecentList(RecentSearchModel val) {
    final index = _recentSearchList
        .indexWhere((element) => element.fullName == val.fullName);
    if (index == -1) {
      _recentSearchList.add(val);
      final data = _recentSearchList.map((e) => e.toJson()).toList();
      PreferenceManagerUtils.setRecentLocalSearchList(jsonEncode(data));
      update();
    }
  }

  void initRecentList() {
    final data = PreferenceManagerUtils.getRecentLocalSearchList();
    log('DATA=============$data');
    if (data.isNotEmpty) {
      _recentSearchList = (jsonDecode(data) as List<dynamic>)
          .map((e) => RecentSearchModel.fromJson(e))
          .toList();
      update();
    }
  }

  ///======================SearchViewModel=======================

  ApiResponse searchFeedBackApiResponse = ApiResponse.initial('Initial');

  Future<void> getSearchFeedBackViewModel(String? title) async {
    log("getSearchFeedBackViewModel");
    searchFeedBackApiResponse = ApiResponse.loading('Loading');
    try {
      GetSearchResModel response =
          await SearchFeedBackRepo().searchFeedBackRepo(title);
      searchFeedBackApiResponse = ApiResponse.complete(response);
    } catch (e) {
      log('Search.......$e');
      searchFeedBackApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
