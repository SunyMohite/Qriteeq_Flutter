import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/commonWidget/snackbar.dart';
import 'package:humanscoring/utils/const_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../common/circular_progress_indicator.dart';
import '../../common/commonWidget/custom_header.dart';
import '../../utils/color_utils.dart';
import '../../utils/decoration_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/shared_preference_utils.dart';
import '../../utils/size_config_utils.dart';
import '../../utils/variable_utils.dart';
import '../../viewmodel/address_book_viewmodel.dart';
import 'feed_inside_page/non_exsistuser_inside_page.dart';

class DeviceContactScreen extends StatefulWidget {
  const DeviceContactScreen({Key? key}) : super(key: key);

  @override
  State<DeviceContactScreen> createState() => _DeviceContactScreenState();
}

class _DeviceContactScreenState extends State<DeviceContactScreen> {
  TextEditingController searchUser = TextEditingController();
  AddressBookViewModel addressBookViewModel = Get.find<AddressBookViewModel>();

  @override
  void initState() {
    super.initState();
    addressBookViewModel.isContactFirstLoading = true;
    addressBookViewModel.initSelectedString = '';
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (addressBookViewModel.isContactFirstLoading == true) {
        _firstLoad();
      }
    });
  }

  PermissionStatus? permissionStatus;
  @override
  void dispose() {
    super.dispose();
  }

  void _firstLoad() async {
    addressBookViewModel.pageNationContactList.clear();
    try {
      permissionStatus = await Permission.contacts.request();
      addressBookViewModel.isContactPermissionStatus =
          permissionStatus!.isGranted;

      if (permissionStatus!.isGranted) {
        addressBookViewModel.pagenationGetContactList(initLoad: false);
      }
    } on Exception catch (e) {
      showSnackBar(message: "Need contact permission for better experience");

      // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Column(
          children: [
            const CustomHeaderWidget(
              headerTitle: VariableUtils.findContact,
            ),
            Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.w),
              child: Text(
                VariableUtils.clickOnTheContactNameToGiveFeedback,
                style: TextStyle(
                    color: ColorUtils.orange,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp),
              ),
              color: ColorUtils.orangeDC,
            ),
            SizeConfig.sH2,
            GetBuilder<AddressBookViewModel>(builder: (addressCon) {
              if (addressCon.isContactPermissionStatus == false) {
                return InkWell(
                  onTap: () async {
                    openAppSettings().then((value) async {
                      logs("PERMISSION ======== $value");
                      permissionStatus = await Permission.contacts.request();
                      logs("PERMISSION ======== ${permissionStatus}");

                      if (value == false) {
                        showSnackBar(
                            message:
                                "Give contact permission for better experiance..");
                      } else {
                        addressBookViewModel.isContactFirstLoading = true;
                        addressBookViewModel.initSelectedString = '';
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) async {
                          if (addressBookViewModel.isContactFirstLoading ==
                              true) {
                            _firstLoad();
                          }
                        });
                      }
                    });
                  },
                  child: Container(
                    height: 13.w,
                    margin: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.w),
                    decoration: DecorationUtils.allBorderAndColorDecorationBox(
                        radius: 7, colors: ColorUtils.primaryColor),
                    child: Center(
                      child: Text(
                        VariableUtils.betterContactExperience,
                        style: FontTextStyle.poppinsWhite10bold,
                      ),
                    ),
                  ),
                );

                return InkWell(
                    onTap: () {
                      openAppSettings().then((value) async {
                        logs("PERMISSION ======== $value");
                        permissionStatus = await Permission.contacts.request();
                        logs("PERMISSION ======== ${permissionStatus}");

                        if (value == false) {
                          showSnackBar(
                              message:
                                  "Give contact permission for better experiance..");
                        } else {
                          addressBookViewModel.isContactFirstLoading = true;
                          addressBookViewModel.initSelectedString = '';
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) async {
                            if (addressBookViewModel.isContactFirstLoading ==
                                true) {
                              _firstLoad();
                            }
                          });
                        }
                      });
                    },
                    child: Text(
                        "No contact Permission available give permission for better performance $permissionStatus "));
              }
              if (jsonDecode(PreferenceManagerUtils.getContactNumber())
                  .isEmpty) {
                if (addressCon.isContactLoading == true) {
                  return const CircularIndicator();
                }
              }

              return Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: SizedBox(
                        height: 15.w,
                        child: TextField(
                          onChanged: (val) {
                            addressCon.selectedString = val;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(2.5.w),
                            hintText: VariableUtils.searchContactNumber,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      ),
                    ),
                    Text("LEN ${addressCon.pageNationContactList.length}"),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          addressBookViewModel.isContactFirstLoading = true;
                          addressBookViewModel.initSelectedString = '';
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) async {
                            if (addressBookViewModel.isContactFirstLoading ==
                                true) {
                              _firstLoad();
                            }
                          });
                        },
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: addressCon.pageNationContactList.length,
                            itemBuilder: (context, index) {
                              final element =
                                  addressCon.pageNationContactList[index];
                              Contact? selectedContact;
                              if (element.displayName != null) {
                                if (element.displayName!.toLowerCase().contains(
                                    addressCon.selectedString.toLowerCase())) {
                                  selectedContact = element;
                                } else if (element.phones != null) {
                                  if (element.phones!.isNotEmpty) {
                                    final index = element.phones!.indexWhere(
                                        (e) => e.value!.contains(
                                            addressCon.selectedString));

                                    if (index > -1) {
                                      selectedContact = element;
                                    }
                                  }
                                }
                              } else if (element.phones != null) {
                                if (element.phones!.isNotEmpty) {
                                  if (element.phones!.first.value!
                                      .toLowerCase()
                                      .contains(addressCon.selectedString
                                          .toLowerCase())) {
                                    selectedContact = element;
                                  }
                                }
                              }
                              if (selectedContact == null) {
                                // return Text("data");
                                return const SizedBox();
                              }
                              logs(
                                  "addressCon.pageNationContactList[index].phones!.isEmpty ${addressCon.pageNationContactList[index].phones!.isEmpty}");
                              return addressCon.pageNationContactList[index]
                                      .phones!.isEmpty
                                  ? SizedBox()
                                  : GestureDetector(
                                      onTap: () async {
                                        Get.to(NonExistsUserInsidePage(
                                          mobileNo: selectedContact!
                                                  .phones!.first.value ??
                                              '',
                                          displayName:
                                              selectedContact.displayName ??
                                                  selectedContact
                                                      .phones!.first.value,
                                        ));
                                      },
                                      child: contactListTile(addressCon, index),
                                    );
                            }),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget contactListTile(AddressBookViewModel addressCon, int i) {
    logs("CALL CONTACTS TILES");
    return ListTile(
      leading: const Padding(
        padding: EdgeInsets.only(top: 0),
        child: CircleAvatar(
          radius: 22.5,
          backgroundColor: ColorUtils.primaryColor,
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        addressCon.pageNationContactList[i].displayName ?? '',
        style: FontTextStyle.poppinsMediumBlue.copyWith(
          color: Colors.black,
          fontSize: 11.sp,
          fontWeight: FontWeightClass.medium,
        ),
      ),
      subtitle: Text(
        addressCon.pageNationContactList[i].phones!.first.value ?? '',
        style: FontTextStyle.poppins14RegularBlackLightColor,
      ),
    );
  }

  InkWell inviteBtn() {
    return InkWell(
      onTap: () async {
        if (PreferenceManagerUtils.getReferralCodeDeepLink().isEmpty) {
          showSnackBar(message: "Something went to wrong");
          return;
        }
        await Share.share(
            "Hey there! ${PreferenceManagerUtils.getAvatarUserName()} is inviting you to join QriteeQ. Click on this link to Download the App: ${PreferenceManagerUtils.getReferralCodeDeepLink()} to visit his profile.\nRegards,\nTeam QriteeQ");
      },
      child: Text(
        VariableUtils.invite,
        style: FontTextStyle.poppinsMediumBlue
            .copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
