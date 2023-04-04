import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/commonWidget/octo_image_widget.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_favorite_res_model.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/utils/assets/icons_utils.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/viewmodel/address_book_viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../common/circular_progress_indicator.dart';
import '../../common/commonWidget/snackbar.dart';
import '../../modal/apiModel/res_model/get_contact_users_res_model.dart';
import '../../utils/const_utils.dart';
import '../../utils/decoration_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/size_config_utils.dart';
import '../../utils/variable_utils.dart';
import '../profileScreen/drawerScreen/favourite_screen.dart';
import 'device_contact_screen.dart';
import 'feed_inside_page/exsistuser_inside_page.dart';
import 'feed_inside_page/favourite_inside_page.dart';

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({Key? key}) : super(key: key);

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  AddressBookViewModel addressBookViewModel = Get.find<AddressBookViewModel>();
  late ScrollController contactUsersScrollController;
  PermissionStatus? permissionStatus;

  @override
  void initState() {
    addressBookViewModel.getFavQriteeQUserList();
    contactUsersScrollController = ScrollController()..addListener(_loadMore);
    _firstLoad();
    super.initState();
  }

  @override
  void dispose() {
    contactUsersScrollController.removeListener(_loadMore);
    super.dispose();
  }

  _firstLoad() async {
    try {
      permissionStatus = await Permission.contacts.request();
      logs("permissionStatus ==== $permissionStatus");
      addressBookViewModel.isContactPermissionStatus =
          permissionStatus!.isGranted;
      if (permissionStatus!.isGranted) {
        addressBookViewModel.contactUsersPage = 1;
        addressBookViewModel.getContactUsersResults!.clear();
        addressBookViewModel.getExistingContactList(initLoad: false);
      }
    } on Exception catch (e) {
      // TODO
    }
  }

  void _loadMore() async {
    if (addressBookViewModel.isContactUsersScrollLoading == false &&
        addressBookViewModel.isContactUsersMoreLoading == false &&
        contactUsersScrollController.position.extentAfter < 300) {
      try {
        addressBookViewModel.getExistingContactList();
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GetBuilder<AddressBookViewModel>(
          builder: (con) {
            if (con.favoriteApiResponse.status == Status.LOADING) {
              return const CircularIndicator();
            }
            if (con.favoriteApiResponse.status == Status.ERROR) {
              return const Center(
                child: Text("Server Error trying after sometimes...."),
              );
            }

            GetFavoriteResModel getFavoriteViewModel =
                con.favoriteApiResponse.data;

            return RefreshIndicator(
              onRefresh: () async {
                con.getFavQriteeQUserList();
                con.isContactUsersScrollLoading = true;
                con.contactUsersPage = 1;
                con.getContactUsersResults!.clear();
                con.getExistingContactList();
              },
              child: SingleChildScrollView(
                controller: contactUsersScrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getFavoriteViewModel.data!.fav!.results!.isEmpty
                        ? const SizedBox()
                        : Column(
                            children: [
                              SizeConfig.sH2,
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconsWidgets.star,
                                    Text(
                                      VariableUtils.favorite,
                                      style: FontTextStyle
                                          .poppinsDarkBlack9SemiB
                                          .copyWith(
                                              color: const Color(0xff5E5E5E),
                                              fontSize: 11.sp),
                                    ),
                                    SizeConfig.sw55,
                                    InkWell(
                                      onTap: () async {
                                        await Get.to(const FavouriteScreen());
                                        addressBookViewModel
                                            .getFavQriteeQUserList();
                                      },
                                      child: Text(
                                        VariableUtils.viewAll,
                                        style: FontTextStyle
                                            .poppinsBlue14Sp9Medium
                                            .copyWith(fontSize: 10.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizeConfig.sH1,

                              ///Favorite Data
                              ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: getFavoriteViewModel
                                      .data!.fav!.results!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var data = getFavoriteViewModel
                                        .data!.fav!.results![index].to;
                                    var emailPhone = getFavoriteViewModel.data!
                                            .fav!.results![index].maskData ??
                                        '';
                                    return index < 5
                                        ? InkWell(
                                            onTap: () async {
                                              FavResults favResults =
                                                  getFavoriteViewModel.data!
                                                      .fav!.results![index];
                                              await Get.to(FavouriteInsidePage(
                                                  favResults: favResults));
                                              await addressBookViewModel
                                                  .getFavQriteeQUserList();

                                              con.favoriteApiResponse.status =
                                                  Status.LOADING;
                                              con.allUserApiResponse.status =
                                                  Status.LOADING;

                                              setState(() {});
                                            },
                                            child: data == null
                                                ? const SizedBox()
                                                : ListTile(
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        OctoImageWidget(
                                                          profileLink:
                                                              data.avatar,
                                                          radius: 20,
                                                        ),
                                                        SizeConfig.sW5,
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                data.userIdentity ??
                                                                    "",
                                                                style: FontTextStyle
                                                                    .poppinsMediumBlue
                                                                    .copyWith(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      11.sp,
                                                                  fontWeight:
                                                                      FontWeightClass
                                                                          .medium,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              emailPhone
                                                                      .isNotEmpty
                                                                  ? Text(
                                                                      emailPhone,
                                                                      style: FontTextStyle
                                                                          .poppins14RegularBlackLightColor,
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    )
                                                                  : const SizedBox(),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          )
                                        : const SizedBox();
                                  }),
                              SizeConfig.sH1,

                              const Divider(
                                height: 1,
                                color: ColorUtils.grayD9,
                              ),
                            ],
                          ),
                    SizeConfig.sH1,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        VariableUtils.contactsOnApp,
                        style: FontTextStyle.poppinsDarkBlack9SemiB.copyWith(
                            color: const Color(0xff5E5E5E), fontSize: 11.sp),
                      ),
                    ),

                    if (con.isContactPermissionStatus == false)
                      InkWell(
                        onTap: () async {
                          openAppSettings().then((value) async {
                            logs("PERMISSION ======== $value");
                            permissionStatus =
                                await Permission.contacts.request();
                            logs("PERMISSION ======== ${permissionStatus}");

                            if (value == false) {
                              showSnackBar(
                                  message:
                                      "Give contact permission for better experiance..");
                            } else {
                              _firstLoad();
                            }
                          });
                        },
                        child: Container(
                          height: 13.w,
                          margin: EdgeInsets.only(
                              left: 5.w, right: 5.w, bottom: 5.w),
                          decoration:
                              DecorationUtils.allBorderAndColorDecorationBox(
                                  radius: 7, colors: ColorUtils.primaryColor),
                          child: Center(
                            child: Text(
                              VariableUtils.betterContactExperience,
                              style: FontTextStyle.poppinsWhite10bold,
                            ),
                          ),
                        ),
                      ),

                    /// Api Data...
                    con.isContactUsersScrollLoading
                        ? const CircularIndicator()
                        : con.getContactUsersResults!.isEmpty &&
                                con.isContactUsersScrollLoading
                            ? const Center(
                                child: Padding(
                                padding: EdgeInsets.all(25),
                                child: Text("No user found for you"),
                              ))
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: con.getContactUsersResults!.length,
                                // itemCount: existingUserFromContactResModel.data!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  GetContactUsersResults data =
                                      con.getContactUsersResults![index];
                                  return InkWell(
                                    onTap: () async {
                                      GetContactUsersResults data =
                                          con.getContactUsersResults![index];
                                      await Get.to(ExistsUserInsidePage(
                                        allUserData: data,
                                      ));
                                      await addressBookViewModel
                                          .getFavQriteeQUserList();

                                      con.favoriteApiResponse.status =
                                          Status.LOADING;
                                      con.allUserApiResponse.status =
                                          Status.LOADING;

                                      con.isContactUsersScrollLoading = true;
                                      con.contactUsersPage = 1;
                                      con.getContactUsersResults!.clear();
                                      con.getExistingContactList();

                                      setState(() {});
                                    },
                                    child: ListTile(
                                      leading: OctoImageWidget(
                                        profileLink: data.avatar,
                                        radius: 20,
                                      ),
                                      subtitle: Text(
                                        data.phone ?? '',
                                        style: FontTextStyle
                                            .poppins14RegularBlackLightColor,
                                      ),
                                      title: Text(
                                        data.userIdentity ?? "",
                                        style: FontTextStyle.poppinsMediumBlue
                                            .copyWith(
                                          color: Colors.black,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeightClass.medium,
                                        ),
                                      ),
                                      trailing: const SizedBox(),
                                    ),
                                  );
                                },
                              ),
                    if (con.isContactUsersMoreLoading)
                      const Center(
                        child: CircularIndicator(
                          isExpand: false,
                          bgColor: Colors.transparent,
                        ),
                      ),
                    SizedBox(
                      height: 7.5.h,
                    )
                  ],
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            color: Colors.white,
            child: InkWell(
              onTap: () async {
                ///GET CONTACT PERMISSION...
                Get.to(const DeviceContactScreen());
              },
              child: Container(
                height: 13.w,
                margin: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.w),
                decoration: DecorationUtils.allBorderAndColorDecorationBox(
                    radius: 7, colors: ColorUtils.primaryColor),
                child: Center(
                  child: Text(
                    VariableUtils.reviewOtherContacts,
                    style: FontTextStyle.poppinsWhite10bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
