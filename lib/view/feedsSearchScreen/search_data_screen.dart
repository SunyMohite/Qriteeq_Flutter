import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_search_res_model.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/utils/assets/icons_utils.dart';
import 'package:humanscoring/utils/assets/images_utils.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/home/feed_inside_page/search_user_inside_page.dart';
import 'package:humanscoring/viewmodel/search_feed_back_viewmodel.dart';
import 'package:sizer/sizer.dart';

import '../../common/circular_progress_indicator.dart';
import '../../common/commonWidget/octo_image_widget.dart';
import '../../common/commonWidget/unlock_feedback_bottomsheet_widget.dart';
import '../../utils/no_leading_space_formatter.dart';
import '../../utils/shared_preference_utils.dart';
import '../../viewmodel/notification_viewmodel.dart';
import '../profileScreen/profile_screen.dart';

class SearchDataScreen extends StatefulWidget {
  const SearchDataScreen({Key? key, this.itsFirstTime}) : super(key: key);
  final bool? itsFirstTime;
  @override
  State<SearchDataScreen> createState() => _SearchDataScreenState();
}

class _SearchDataScreenState extends State<SearchDataScreen> {
  GetSearchResModel getSearchResModel = GetSearchResModel();
  SearchFeedBackViewModel searchFeedBackViewModel = Get.find();
  NotificationViewModel notificationViewModel =
      Get.find<NotificationViewModel>();
  bool? isFirstTime;
  bool validURL = false;
  bool validEmail = false;
  String? isEmail;
  String? isProfileURL;
  String? isNameMobile;

  @override
  void initState() {
    isFirstTime = widget.itsFirstTime!;
    notificationViewModel.notificationViewModel();
    super.initState();
  }

  TextEditingController searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                ImagesWidgets.appbarBackground,
                Positioned(
                    child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.5.h),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      SizeConfig.sW4,
                      InkWell(
                        onTap: () {
                          Get.to(const ProfileScreen());
                        },
                        child: OctoImageWidget(
                          profileLink: PreferenceManagerUtils.getUserAvatar(),
                          radius: 4.2.w,
                        ),
                      ),
                      SizeConfig.sW3,
                      IconsWidgets.appLogoWhite,
                    ],
                  ),
                ))
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
              child: SizedBox(
                height: 44,
                child: TextFormField(
                  controller: searchBarController,
                  textCapitalization: TextCapitalization.none,
                  inputFormatters: [NoLeadingSpaceFormatter()],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: ColorUtils.gray,
                      filled: true,
                      hintText: VariableUtils.hintSearch,
                      hintStyle: FontTextStyle.poppins12semiB,
                      contentPadding: const EdgeInsets.only(
                        top: 3,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                          top: 13.5,
                          bottom: 13.5,
                        ),
                        child: SvgPicture.asset(
                          'assets/icon/searchBlack.svg',
                        ),
                      )),
                  onChanged: (searchText) async {
                    isFirstTime = false;
                    log("Please searchText $searchText");

                    if (searchText.isNotEmpty) {
                      log("Please enter valid url********1");
                      // var value = searchText;
                      String pattern =
                          r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
                      String emailPattern =
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

                      RegExp regExp = RegExp(pattern);
                      RegExp emailRegExp = RegExp(emailPattern);

                      /// URL
                      if (searchText.isEmpty) {
                        log("Please enter url =============VALID URL");
                        // return 'Please enter url';
                      } else if (!regExp.hasMatch(searchText)) {
                        log("Please enter valid url=============INVALID URL");
                        validURL = false;
                        setState(() {});

                      } else {
                        log("Please enter url =============VALID URL11111");
                        isProfileURL = searchText;
                        validURL = true;
                        setState(() {});
                      }

                      ///EMAIL

                      if (!emailRegExp.hasMatch(searchText)) {
                        validEmail = false;

                        setState(() {});
                      } else {
                        isEmail = searchText;
                        validEmail = true;
                        setState(() {});
                      }
                      await Future.delayed(const Duration(seconds: 1), () {
                        searchFeedBackViewModel
                            .getSearchFeedBackViewModel(searchText);
                      });

                      // linkedAccountBottomSheet();
                      // return null;
                    } else {
                      validEmail = false;
                      validURL = false;
                      isProfileURL = '';
                      isEmail = '';
                      setState(() {});
                      isFirstTime = true;
                      await Future.delayed(const Duration(seconds: 1), () {
                        searchFeedBackViewModel.getSearchFeedBackViewModel('');
                      });
                      // }
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: GetBuilder<SearchFeedBackViewModel>(
                  builder: (controller) {
                    if (isFirstTime == true) {
                      return const SizedBox();
                    }
                    if (searchFeedBackViewModel
                            .searchFeedBackApiResponse.status ==
                        Status.LOADING) {
                      return Container(
                        color: ColorUtils.white,
                        child: const Center(
                          child: CircularIndicator(),
                        ),
                      );
                    }
                    if (searchFeedBackViewModel
                            .searchFeedBackApiResponse.status ==
                        Status.ERROR) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/image/noSearchResultFound.webp',
                            scale: 2,
                          ),
                        ],
                      );
                    }
                    if (searchFeedBackViewModel
                            .searchFeedBackApiResponse.data !=
                        null) {
                      getSearchResModel = searchFeedBackViewModel
                          .searchFeedBackApiResponse.data;
                    }
                    if (getSearchResModel.data == null) {
                      return const SizedBox();
                    }

                    /// EMAIL  aniket.d@esmagico.in
                    if (validEmail == true &&
                        getSearchResModel.data!.results!.isEmpty) {
                      return notFoundWidget();
                    }

                    /// URL
                    else if (validURL == true &&
                        getSearchResModel.data!.results!.isEmpty) {
                      return notFoundWidget();
                    }

                    /// EMPTY RESPONSE
                    else if ((validEmail == false || validURL == false) &&
                        getSearchResModel.data!.results!.isEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/image/noSearchResultFound.webp',
                            scale: 2,
                          ),
                        ],
                      );
                    }

                    /// EMPTY RESPONSE
                    else if (getSearchResModel.data!.results!.isEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/image/noSearchResultFound.webp',
                            scale: 2,
                          ),
                        ],
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: getSearchResModel.data!.results!.length,
                      itemBuilder: (context, index) {
                        var data = getSearchResModel.data!.results![index];
                        return InkWell(
                          onTap: () async {
                            FocusScope.of(context).unfocus();

                            await Get.to(
                                SearchUserInsidePage(
                                  searchResults:
                                      getSearchResModel.data!.results![index],
                                  avatar: getSearchResModel
                                      .data!.results![index].avatar,
                                ),
                                transition: Transition.cupertino);
                            searchBarController.clear();
                            getSearchResModel.data!.results!.clear();
                            isFirstTime = true;
                            searchFeedBackViewModel.update();
                          },
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                OctoImageWidget(profileLink: data.avatar),
                                SizeConfig.sW5,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${data.userIdentity}",
                                      style: FontTextStyle.poppinsMediumBlue
                                          .copyWith(
                                        color: Colors.black,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeightClass.medium,
                                      ),
                                    ),
                                    data.maskData != null
                                        ? Text(
                                            data.maskData!,
                                            style: FontTextStyle
                                                .poppins14RegularBlackLightColor,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget notFoundWidget() {
    return ListTile(
        horizontalTitleGap: 2.w,
        title: Text(
          'Not found',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
        ),
        trailing: Container(
          decoration: BoxDecoration(
              color: const Color(0xff3E46FF),
              borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 2.5.w),
          child: InkWell(
            onTap: () {
              Get.bottomSheet(
                addUserNameBottomSheet(
                  connect: false,
                  id: '',
                  mobile: '',
                  userName: searchBarController.text,
                  email: isEmail,
                  profileUrl: isProfileURL,
                ),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
              );
            },
            child: Text(
              'Post feedback',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 9.sp,
                  color: Colors.white),
            ),
          ),
        ),
        subtitle: Text(
          searchBarController.text,
          style: const TextStyle(color: Colors.black38),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: Container(
          height: 13.w,
          width: 13.w,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: const DecorationImage(
                  image: AssetImage("assets/image/amico.png"),
                  fit: BoxFit.fill),
              border: Border.all(color: Colors.black45)),
        ));
  }
}
