import 'dart:developer';

import 'package:get/get.dart';
import 'package:humanscoring/modal/apiModel/res_model/your_interactions_res_model.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/modal/repo/user_activity_repo.dart';

class YourInteractionsController extends GetxController {
  int _selected = 0;

  int get selected => _selected;

  set selected(int value) {
    _selected = value;
    update();
  }

  var data = {
    "data": [
      {
        "date": "April-02-2022 ",
        "listData": [
          {
            "title": "You likes JD’s Feedback",
            "subTitle": "JD is a awesome person , i have never Seen",
          },
          {
            "title": "You likes Ashly’s Feedback",
            "subTitle": "JD is a awesome person , i have never Seen",
          },
        ],
      },
      {
        "date": "April-01-2022 ",
        "listData": [
          {
            "title": "You likes Babhilash’s Feedback",
            "subTitle": "JD is a awesome person , i have never Seen",
          },
        ],
      },
      {
        "date": "April-04-2022 ",
        "listData": [
          {
            "title": "You likes Babhilash’s Feedback",
            "subTitle": "JD is a awesome person , i have never Seen",
          },
          {
            "title": "You likes Babhilash’s Feedback",
            "subTitle": "JD is a awesome person , i have never Seen",
          },
          {
            "title": "You likes Babhilash’s Feedback",
            "subTitle": "JD is a awesome person , i have never Seen",
          },
          {
            "title": "You likes Babhilash’s Feedback",
            "subTitle": "JD is a awesome person , i have never Seen .....",
          },
        ],
      },
    ]
  };

  ApiResponse yourInteractionsApiResponse = ApiResponse.initial('Initial');

  List<YourInteractionsData> yourInteractionsList = [];

  int yourInteractionsPage = 1;
  int yourInteractionsTotalData = 0;
  bool isYourInteractionsFirstLoading = true;
  bool _isYourInteractionsMoreLoading = false;

  bool get isYourInteractionsMoreLoading => _isYourInteractionsMoreLoading;

  Future<void> getYourInteractions({bool? initLoad = true}) async {
    if (yourInteractionsList.length >= yourInteractionsTotalData &&
        yourInteractionsList.isNotEmpty) {
      return;
    }

    yourInteractionsApiResponse = ApiResponse.loading('Loading');
    _isYourInteractionsMoreLoading = true;
    if (initLoad == true) {
      update();
    }

    update();
    try {
      String url =
          "feedback/activity?type=interaction&page=$yourInteractionsPage";
      YourInteractionsResModel response =
          await UserActivityRepo().yourInteractionsRepo(url: url);
      yourInteractionsApiResponse = ApiResponse.complete(response);
      yourInteractionsTotalData = response.data!.totalResults!;

      yourInteractionsPage += 1;
      yourInteractionsList.addAll(response.data!.results!);
      isYourInteractionsFirstLoading = false;
      _isYourInteractionsMoreLoading = false;
    } catch (e) {
      log('yourInteractionsApiResponse.......$e');
      isYourInteractionsFirstLoading = false;
      _isYourInteractionsMoreLoading = false;
      yourInteractionsApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
