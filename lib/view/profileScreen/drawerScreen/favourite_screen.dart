import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/commonWidget/octo_image_widget.dart';
import 'package:humanscoring/viewmodel/subscribe_list_view_model.dart';
import 'package:sizer/sizer.dart';

import '../../../common/circular_progress_indicator.dart';
import '../../../common/commonWidget/custom_header.dart';
import '../../../common/commonWidget/snackbar.dart';
import '../../../modal/apiModel/req_model/feed_like_request_model.dart';
import '../../../modal/apiModel/res_model/feed_like_pin_response_model.dart';
import '../../../modal/apiModel/res_model/my_favourite_res_model.dart';
import '../../../modal/apis/api_response.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/decoration_utils.dart';
import '../../../utils/font_style_utils.dart';
import '../../../utils/shared_preference_utils.dart';
import '../../../utils/size_config_utils.dart';
import '../../../utils/variable_utils.dart';
import '../../../viewmodel/dashboard_viewmodel.dart';
import '../../generalScreen/no_searchfound_screen.dart';
import '../../home/feed_inside_page/my_favourite_inside_page.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  SubScribeListViewModel viewModel = Get.find<SubScribeListViewModel>();

  late ScrollController favouriteScribeController;

  void _firstLoad() async {
    viewModel.favouritePage = 1;
    viewModel.favouriteList.clear();
    viewModel.getMyFavoriteViewModel(initLoad: false);
  }

  void _loadMore() async {
    if (viewModel.isFavouriteFirstLoading == false &&
        viewModel.isFavouriteMoreLoading == false &&
        favouriteScribeController.offset >=
            favouriteScribeController.position.maxScrollExtent) {
      try {
        viewModel.getMyFavoriteViewModel();
      } catch (err) {
        log('Something went wrong!');
      }
    }
  }

  @override
  void initState() {
    viewModel.isFavouriteFirstLoading = true;
    if (viewModel.isFavouriteFirstLoading == true) {
      _firstLoad();
    }
    favouriteScribeController = ScrollController()..addListener(_loadMore);
    super.initState();
  }

  @override
  void dispose() {
    favouriteScribeController.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            const CustomHeaderWidget(
              headerTitle:
                  "${VariableUtils.subscribed}/${VariableUtils.favourited}",
            ),
            Expanded(
              child: GetBuilder<SubScribeListViewModel>(
                builder: (controller) {
                  if (controller.isFavouriteFirstLoading) {
                    return const Center(child: CircularIndicator());
                  }
                  // return Center(child: CircularIndicator());

                  if (controller.favouriteList.isEmpty) {
                    return const NoFeedBackFound(
                      titleMsg: 'No any feedback favourite yet!',
                      subTitleMsg: '',
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () {
                      controller.favouriteList.clear();
                      controller.favouritePage = 1;
                      controller.isFavouriteFirstLoading = true;
                      controller.getMyFavoriteViewModel();
                      return Future.value();
                    },
                    child: SingleChildScrollView(
                      controller: favouriteScribeController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            children: List.generate(
                                controller.favouriteList.length, (index) {
                              var data = controller.favouriteList[index];
                              return InkWell(
                                onTap: () async {
                                  MyFavouriteResult? favResultsObj =
                                      controller.favouriteList[index];

                                  await Get.to(MyFavouriteInsidePage(
                                      favResults: favResultsObj));
                                  viewModel.favouriteList.clear();
                                  viewModel.favouritePage = 1;
                                  viewModel.isFavouriteFirstLoading = true;
                                  viewModel.getMyFavoriteViewModel(
                                      initLoad: false);
                                },
                                child: data.to == null
                                    ? const SizedBox()
                                    : ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 2.w, horizontal: 5.w),
                                        title: Row(
                                          children: [
                                            data.to == null
                                                ? const SizedBox()
                                                : Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      "${data.to!.userIdentity}",
                                                      style: FontTextStyle
                                                          .poppinsDarkBlackSp11SemiB,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            GetBuilder<DashBoardViewModel>(
                                              builder: (dashBoardViewModel) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    FeedLikeRequestModel
                                                        feedLikeRequestModel =
                                                        FeedLikeRequestModel();
                                                    String byId =
                                                        PreferenceManagerUtils
                                                            .getLoginId();

                                                    feedLikeRequestModel.by =
                                                        byId;
                                                    feedLikeRequestModel
                                                            .toLike =
                                                        data.to!.id.toString();
                                                    feedLikeRequestModel
                                                        .favorite = false;
                                                    await dashBoardViewModel
                                                        .feedLikeViewModel(
                                                            feedLikeRequestModel);
                                                    if (dashBoardViewModel
                                                            .feedLikeApiResponse
                                                            .status ==
                                                        Status.COMPLETE) {
                                                      FeedLikePinResponseModel
                                                          response =
                                                          dashBoardViewModel
                                                              .feedLikeApiResponse
                                                              .data;
                                                      if (response.status ==
                                                          200) {
                                                        showSnackBar(
                                                          message:
                                                              response.message,
                                                          snackColor: ColorUtils
                                                              .primaryColor,
                                                        );
                                                        viewModel.favouriteList
                                                            .clear();
                                                        viewModel
                                                            .favouritePage = 1;
                                                        viewModel
                                                                .isFavouriteFirstLoading =
                                                            true;
                                                        viewModel
                                                            .getMyFavoriteViewModel(
                                                                initLoad:
                                                                    false);
                                                        dashBoardViewModel
                                                            .allFeedsViewModel();
                                                      } else {
                                                        showSnackBar(
                                                          message:
                                                              response.message,
                                                          snackColor: ColorUtils
                                                              .primaryColor,
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 8.w,
                                                    width: 25.w,
                                                    decoration: DecorationUtils
                                                        .borderDecorationBoxBlueColor(
                                                      radius: 10,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        data.to!.active == true
                                                            ? VariableUtils
                                                                .unFavorite
                                                            : VariableUtils
                                                                .unsubscribe,
                                                        style: FontTextStyle
                                                            .poppinsBlue14Sp9Medium,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                        subtitle: Text(
                                          data.to!.maskData ?? '',
                                          style: FontTextStyle
                                              .poppinsBlackLightNormal,
                                        ),
                                        leading: data.to == null ||
                                                data.to!.avatar == null
                                            ? OctoImageWidget(profileLink: '')
                                            : OctoImageWidget(
                                                profileLink: data.to!.avatar),
                                      ),
                              );
                            }),
                          ),
                          if (controller.isFavouriteMoreLoading)
                            const CircularIndicator(
                                isExpand: false, bgColor: Colors.transparent),
                          SizeConfig.sH1,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
