import 'dart:developer';

import 'package:get/get.dart';
import 'package:humanscoring/modal/apiModel/res_model/subscribe_list_res_model.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/modal/repo/subscribe_list_repo.dart';

import '../modal/apiModel/res_model/my_favourite_res_model.dart';
import 'feedback_viewmodel.dart';

class SubScribeListViewModel extends GetxController {
  FeedBackViewModel feedBackViewModel = Get.put(FeedBackViewModel());
  ApiResponse subScribeListApiResponse = ApiResponse.initial('Initial');
  ApiResponse favouriteListApiResponse = ApiResponse.initial('Initial');

  ///====================== SubScribeListViewModel =====================
  List<SubScribeResults> getSubScribeList = [];
  int subScribePage = 1;
  int subScribeTotalData = 0;
  bool isSubScribeFirstLoading = true;
  bool _isSubScribeMoreLoading = false;
  bool get isSubScribeMoreLoading => _isSubScribeMoreLoading;

  Future<void> getSubScribe({bool? initLoad = true}) async {
    if (getSubScribeList.length >= subScribeTotalData &&
        getSubScribeList.isNotEmpty) {
      return;
    }
    subScribeListApiResponse = ApiResponse.loading('Loading');
    _isSubScribeMoreLoading = true;
    if (initLoad == true) {
      update();
    }
    try {
      String url = "connection?type=subscribe&page=$subScribePage";

      final resModel = await SubScribeListRepo().subScribeListRepo(url: url);
      subScribeListApiResponse = ApiResponse.complete(resModel);
      subScribeTotalData = resModel.data!.data!.totalResults!;

      subScribePage += 1;
      getSubScribeList.addAll(resModel.data!.data!.results!);
      isSubScribeFirstLoading = false;
      _isSubScribeMoreLoading = false;
    } catch (e) {
      log('SubScribeResApiResponse ERROR=>$e');
      subScribeListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///FAVOURITE LIST....
  List<MyFavouriteResult> favouriteList = [];
  int favouritePage = 1;
  int favouriteTotalData = 0;
  bool isFavouriteFirstLoading = true;
  bool isFavouriteMoreLoading = false;

  ///===================getMyFavoriteViewModel()=======================

  Future<void> getMyFavoriteViewModel({bool? initLoad = true}) async {
    if (favouriteList.length >= favouriteTotalData &&
        favouriteList.isNotEmpty) {
      return;
    }
    favouriteListApiResponse = ApiResponse.loading('Loading');
    isFavouriteMoreLoading = true;
    if (initLoad == true) {
      update();
    }
    try {
      String url = "user/getFavouriteUsers?limit=10&page=$favouritePage";
      log("URL******** $url");
      MyFavouriteResModel response =
          await SubScribeListRepo().getMyFavoriteBookRepo(url: url);
      favouriteListApiResponse = ApiResponse.complete(response);
      favouritePage += 1;
      favouriteList.addAll(response.data!.results!);
      feedBackViewModel.myFavoriteCount = response.data!.totalResults!;
      favouriteTotalData = response.data!.totalResults!;
      isFavouriteFirstLoading = false;
      isFavouriteMoreLoading = false;
    } catch (e) {
      isFavouriteFirstLoading = false;
      isFavouriteMoreLoading = false;
      log('GetFavoriteResModelsubscrib list.......$e');
      favouriteListApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
