import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/circular_progress_indicator.dart';
import 'package:humanscoring/common/commonWidget/snackbar.dart';
import 'package:humanscoring/modal/apiModel/req_model/avatar_username_req_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/avatar_username_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/get_avatar_username_res_model.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/utils/assets/icons_utils.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/decoration_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/viewmodel/avatar_user_name_controller.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';
import 'package:sizer/sizer.dart';

import '../../../common/commonWidget/custom_header.dart';
import '../../../modal/apiModel/res_model/image_upload_res_model.dart';
import '../../../modal/apiModel/res_model/user_name_availability_res_model.dart';
import '../../../utils/enum_utils.dart';
import '../../../utils/validation_utils.dart';
import '../../../viewmodel/address_book_viewmodel.dart';
import '../../../viewmodel/auth_viewmodel.dart';
import '../../../viewmodel/fileupload_viewmodel.dart';
import '../profile_traits.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  AvatarUserNameController avatarUserNameController =
  Get.find<AvatarUserNameController>();
  AvatarUserNameReqModel avatarUserNameReqModel = AvatarUserNameReqModel();

  GetAvatarUserNameResModel getAvatarUserNameResModel =
  GetAvatarUserNameResModel();
  AuthViewModel viewModel = Get.find();
  AddressBookViewModel addressBookViewModel = Get.find();
  bool serviceStatus = false;
  bool hasPermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;
  List<Placemark> placeMarks = [];
  String? address = '';
  String? country = '';
  String? state = '';
  String? userName = "";

  checkGps() async {
    serviceStatus = await Geolocator.isLocationServiceEnabled();
    if (serviceStatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showSnackBar(
              message: "Location permissions are denied",
              snackColor: ColorUtils.red);
        } else if (permission == LocationPermission.deniedForever) {
          showSnackBar(
              message: "Location permissions are permanently denied",
              snackColor: ColorUtils.red);
        } else {
          hasPermission = true;
        }
      } else {
        hasPermission = true;
      }

      if (hasPermission) {
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      showSnackBar(
          message: "GPS Service is not enabled, turn on GPS location",
          snackColor: ColorUtils.red);
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    debugPrint('location: ${position.latitude}');
    debugPrint('longitude: ${position.longitude}');
    long = position.longitude.toString();
    lat = position.latitude.toString();
    List<Placemark> placeMarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    address = placeMarks.first.subAdministrativeArea;
    country = placeMarks.first.country;
    state = placeMarks.first.administrativeArea;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController ageController =TextEditingController();
  TextEditingController cityController =TextEditingController();
  TextEditingController professionController =TextEditingController();
  TextEditingController schoolController =TextEditingController();
  TextEditingController collegeController =TextEditingController();

  CarouselController carouselController = CarouselController();
  int? selectedImageIndex = 0;
  File? _image;
  final picker = ImagePicker();
  AppState? appState;

  @override
  void initState() {
    avatarUserNameReqModel.avatar = PreferenceManagerUtils.getUserAvatar();

    nameController.text = PreferenceManagerUtils.getAvatarUserName();
    fullnameController.text = PreferenceManagerUtils.getAvatarUserFullName();
    checkGps();
    avatarUserNameController.initSetPageIndex = -1;
    // log("avatarUserNameController.setPageIndex ${avatarUserNameController.setPageIndex}");

    initMethod();
    validateRating();
    super.initState();
  }

  void initMethod() async {
    await avatarUserNameController.getAvatarUserNameViewModel();
  }

  void validateRating()
  {
    final firestore = FirebaseFirestore.instance;
    firestore.collection("ProfileDetails")
        .doc(PreferenceManagerUtils.getLoginId())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        ageController.text=documentSnapshot['age'].toString();
        professionController.text=documentSnapshot['profession'].toString();
        cityController.text=documentSnapshot['city'].toString();
        schoolController.text=documentSnapshot['school_name'].toString();
        collegeController.text=documentSnapshot['college_name'].toString();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const CustomHeaderWidget(
                headerTitle: VariableUtils.editProfile,
              ),
              SizeConfig.sH3,
              GetBuilder<AvatarUserNameController>(
                builder: (userNameController) {
                  if (userNameController.getAvatarUserNameApiResponse.status ==
                      Status.LOADING) {
                    return const CircularIndicator();
                  }
                  if (userNameController.getAvatarUserNameApiResponse.status ==
                      Status.COMPLETE) {
                    getAvatarUserNameResModel =
                        userNameController.getAvatarUserNameApiResponse.data;
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Material(
                            color: ColorUtils.blue14,
                            child: InkWell(
                              onTap: () async {
                                Get.to(()=>ProfileTraits());
                              },
                              child: Container(
                                height: 13.w,
                                decoration: DecorationUtils
                                    .allBorderAndColorDecorationBox(
                                  radius: 7,
                                ),
                                child: Center(
                                  child: Text(
                                    "MANAGE PROFILE TRAITS",
                                    style: FontTextStyle.poppinsWhite10bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizeConfig.sH5,
                        Text(
                          VariableUtils.changeAvatarAndUserName,
                          style: FontTextStyle.poppinsBlack21Bold,
                        ),
                        SizeConfig.sH2,

                        ///CarouselSlider SLIDER SELECT AVATAR....
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            userNameController.setPageIndex == 0
                                ? const SizedBox()
                                : InkWell(
                              child: IconsWidgets.iosBackArrow,
                              onTap: () {
                                carouselController.previousPage(
                                  duration:
                                  const Duration(milliseconds: 400),
                                  curve: Curves.easeIn,
                                );
                                // log('COUNT===============${userNameController.setPageIndex}');
                                userNameController.selectedUrl =
                                getAvatarUserNameResModel.data!.url![
                                userNameController.setPageIndex -
                                    1];
                              },
                            ),
                            Container(
                              height: 19.w,
                              width: 60.w,
                              // color: ColorUtils.whiteF5,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: CarouselSlider(
                                carouselController: carouselController,
                                options: CarouselOptions(
                                  enableInfiniteScroll: false,
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.3,
                                  // scrollPhysics: NeverScrollableScrollPhysics(),
                                  aspectRatio: 0.1,
                                  initialPage: 0,
                                  onPageChanged: (val, _) {
                                    userNameController.setPageIndex = val;
                                  },
                                ),
                                items: List.generate(
                                  getAvatarUserNameResModel.data!.url!.length,
                                      (index) {
                                    if (userNameController.setPageIndex ==
                                        index) {
                                      userNameController.selectedUrl =
                                      getAvatarUserNameResModel.data!.url![
                                      userNameController.setPageIndex];
                                    }
                                    return Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: DecorationUtils
                                          .borderAndCircleDecorationBox(
                                        boxShadow: [
                                          BoxShadow(
                                              color: userNameController
                                                  .setPageIndex ==
                                                  index
                                                  ? Colors.grey.withOpacity(0.5)
                                                  : ColorUtils.transparent,
                                              blurRadius: 4,
                                              offset: const Offset(0, 4))
                                        ],
                                        border:
                                        userNameController.setPageIndex ==
                                            index
                                            ? Border.all(
                                          color: ColorUtils.purple68,
                                          width: 2,
                                        )
                                            : const Border(),
                                      ),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(
                                              userNameController.setPageIndex ==
                                                  index
                                                  ? 4
                                                  : 15,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(100),
                                              child: Image.network(
                                                getAvatarUserNameResModel
                                                    .data!.url![index],
                                              ),
                                            ),
                                          ),
                                          userNameController.setPageIndex ==
                                              index
                                              ? Container()
                                              : ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(
                                                100),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: ColorUtils
                                                    .transparent,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: userNameController
                                                          .setPageIndex ==
                                                          index
                                                          ? Colors
                                                          .transparent
                                                          .withOpacity(
                                                          0.5)
                                                          : ColorUtils
                                                          .white
                                                          .withOpacity(
                                                          0.5),
                                                      blurRadius: 4,
                                                      offset:
                                                      const Offset(
                                                          0, 4))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            userNameController.setPageIndex == 3
                                ? const SizedBox()
                                : InkWell(
                              onTap: () {
                                carouselController.nextPage(
                                  duration:
                                  const Duration(milliseconds: 400),
                                  curve: Curves.easeIn,
                                );
                                userNameController.selectedUrl =
                                getAvatarUserNameResModel.data!.url![
                                userNameController.setPageIndex +
                                    1];
                              },
                              child: IconsWidgets.iosForwardArrow,
                            ),
                          ],
                        ),
                        SizeConfig.sH2,
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                              onTap: () {
                                _showPicker(context);
                              },
                              child: _image != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: Container(
                                  height: 25.w,
                                  width: 25.w,
                                  decoration: BoxDecoration(
                                      color: ColorUtils.grey,
                                      borderRadius:
                                      BorderRadius.circular(10)),
                                  child: Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                                  : ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: OctoImage(
                                  height: 25.w,
                                  width: 25.w,
                                  image: CachedNetworkImageProvider(
                                      PreferenceManagerUtils
                                          .getUserAvatar()),
                                  placeholderBuilder:
                                  OctoPlaceholder.blurHash(
                                    'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                  ),
                                  errorBuilder: (context, obj, stack) =>
                                  IconsWidgets.userIcon,
                                  fit: BoxFit.cover,
                                ),
                              )
                          ),
                        ),
                        SizeConfig.sH1,
                        InkWell(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: const Text(
                              VariableUtils.changeProfilePicture,
                              style: TextStyle(
                                color: ColorUtils.primaryColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            )),
                        SizeConfig.sH3,
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              "Enter full name",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizeConfig.sH1,

                        ///FULL NAME...
                        TextField(
                          controller: fullnameController,
                          keyboardType: TextInputType.text,
                          style: FontTextStyle.poppinsBlack10Medium,
                          textCapitalization: TextCapitalization.sentences,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(RegularExpression.alphabetDigitsPattern))
                          ],
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 4.w),
                            hintText: VariableUtils.fullNameRequired,
                            hintStyle: FontTextStyle.poppinsGrayB3Normal,
                            filled: true,
                            fillColor: ColorUtils.whiteEB,
                            focusedBorder: DecorationUtils.outLineR20,
                            enabledBorder: DecorationUtils.outLineR20,
                            disabledBorder: DecorationUtils.outLineR20,
                            errorBorder: DecorationUtils.outLineR20,
                            focusedErrorBorder: DecorationUtils.outLineR20,
                          ),
                        ),
                        SizeConfig.sH1,

                        ///USER NAME...
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              "User name",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizeConfig.sH1,

                        TextField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          style: FontTextStyle.poppinsBlack10Medium,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(
                                RegularExpression
                                    .alphabetDigitsWithoutSpacePattern))
                          ],
                          onChanged: (str) async {
                            if (str.length >= 5) {
                              setState(() {
                                userName = str;
                              });

                              await viewModel.userNameAvailability(str);

                              if (viewModel
                                  .userNameAvailabilityResponse.status ==
                                  Status.COMPLETE) {
                                UserNameAvailabilityResModel res =
                                    viewModel.userNameAvailabilityResponse.data;

                                viewModel.userStatus = res.data!.usernameTaken!;
                              }
                            } else {
                              setState(() {
                                userName = '';
                              });
                            }
                          },
                          enabled: true,
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 4.w),
                            hintText: VariableUtils.userName,
                            hintStyle: FontTextStyle.poppinsGrayB3Normal,
                            filled: true,
                            fillColor: ColorUtils.whiteEB,
                            focusedBorder: DecorationUtils.outLineR20,
                            enabledBorder: DecorationUtils.outLineR20,
                            disabledBorder: DecorationUtils.outLineR20,
                            errorBorder: DecorationUtils.outLineR20,
                            focusedErrorBorder: DecorationUtils.outLineR20,
                          ),
                        ),
                        //SizeConfig.sH1,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GetBuilder<AuthViewModel>(
                            builder: (controller) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  userName == null ||
                                      userName!.isEmpty ||
                                      userName == ''
                                      ? ''
                                      : !controller.userStatus
                                      ? 'Username is available'
                                      : 'This username is already taken',
                                  style: TextStyle(
                                      color: userName == null ||
                                          userName!.isEmpty ||
                                          userName == ''
                                          ? ColorUtils.black
                                          : controller.userStatus
                                          ? ColorUtils.red
                                          : ColorUtils.green,
                                      fontSize: 4.w,
                                      fontWeight: FontWeight.w300),
                                ),
                              );
                            },
                          ),
                        ),
                        //SizeConfig.sH1,

                        ///Age
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              "Age",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizeConfig.sH1,

                        TextField(
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          style: FontTextStyle.poppinsBlack10Medium,
                          textCapitalization: TextCapitalization.sentences,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(RegularExpression.digitsPattern))
                          ],
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 4.w),
                            hintText: "Enter Age",
                            hintStyle: FontTextStyle.poppinsGrayB3Normal,
                            filled: true,
                            fillColor: ColorUtils.whiteEB,
                            focusedBorder: DecorationUtils.outLineR20,
                            enabledBorder: DecorationUtils.outLineR20,
                            disabledBorder: DecorationUtils.outLineR20,
                            errorBorder: DecorationUtils.outLineR20,
                            focusedErrorBorder: DecorationUtils.outLineR20,
                          ),
                        ),
                        SizeConfig.sH1,

                        ///City
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              "City",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizeConfig.sH1,

                        TextField(
                          controller: cityController,
                          keyboardType: TextInputType.text,
                          style: FontTextStyle.poppinsBlack10Medium,
                          textCapitalization: TextCapitalization.sentences,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(RegularExpression.alphabetPattern))
                          ],
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 4.w),
                            hintText: "Enter City",
                            hintStyle: FontTextStyle.poppinsGrayB3Normal,
                            filled: true,
                            fillColor: ColorUtils.whiteEB,
                            focusedBorder: DecorationUtils.outLineR20,
                            enabledBorder: DecorationUtils.outLineR20,
                            disabledBorder: DecorationUtils.outLineR20,
                            errorBorder: DecorationUtils.outLineR20,
                            focusedErrorBorder: DecorationUtils.outLineR20,
                          ),
                        ),
                        SizeConfig.sH1,

                        ///Profession
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              "Profession",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizeConfig.sH1,

                        TextField(
                          controller: professionController,
                          keyboardType: TextInputType.text,
                          style: FontTextStyle.poppinsBlack10Medium,
                          textCapitalization: TextCapitalization.sentences,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(RegularExpression.alphabetDigitsPattern))
                          ],
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 4.w),
                            hintText: "Enter Profession",
                            hintStyle: FontTextStyle.poppinsGrayB3Normal,
                            filled: true,
                            fillColor: ColorUtils.whiteEB,
                            focusedBorder: DecorationUtils.outLineR20,
                            enabledBorder: DecorationUtils.outLineR20,
                            disabledBorder: DecorationUtils.outLineR20,
                            errorBorder: DecorationUtils.outLineR20,
                            focusedErrorBorder: DecorationUtils.outLineR20,
                          ),
                        ),
                        SizeConfig.sH1,

                        ///School Name
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              "School name",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizeConfig.sH1,
                        TextField(
                          controller: schoolController,
                          keyboardType: TextInputType.text,
                          style: FontTextStyle.poppinsBlack10Medium,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 4.w),
                            hintText: "School name",
                            hintStyle: FontTextStyle.poppinsGrayB3Normal,
                            filled: true,
                            fillColor: ColorUtils.whiteEB,
                            focusedBorder: DecorationUtils.outLineR20,
                            enabledBorder: DecorationUtils.outLineR20,
                            disabledBorder: DecorationUtils.outLineR20,
                            errorBorder: DecorationUtils.outLineR20,
                            focusedErrorBorder: DecorationUtils.outLineR20,
                          ),
                        ),
                        SizeConfig.sH1,

                        ///College Name
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              "College name",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizeConfig.sH1,
                        TextField(
                          controller: collegeController,
                          keyboardType: TextInputType.text,
                          style: FontTextStyle.poppinsBlack10Medium,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 4.w),
                            hintText: "College name",
                            hintStyle: FontTextStyle.poppinsGrayB3Normal,
                            filled: true,
                            fillColor: ColorUtils.whiteEB,
                            focusedBorder: DecorationUtils.outLineR20,
                            enabledBorder: DecorationUtils.outLineR20,
                            disabledBorder: DecorationUtils.outLineR20,
                            errorBorder: DecorationUtils.outLineR20,
                            focusedErrorBorder: DecorationUtils.outLineR20,
                          ),
                        ),
                        SizeConfig.sH3,
                        SizeConfig.sH1,
                        ///Continue Button
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Material(
                            color: ColorUtils.blue14,
                            child: InkWell(
                              onTap: () async {
                                if (nameController.text.isEmpty) {
                                  showSnackBar(
                                    message: VariableUtils.userNameRequired,
                                    snackColor: ColorUtils.primaryColor,
                                  );
                                  return;
                                } else if (fullnameController.text.isBlank!) {
                                  showSnackBar(
                                    message: VariableUtils.userFullNameRequired,
                                    snackColor: ColorUtils.primaryColor,
                                  );
                                  return;
                                }
                                else if (ageController.text.isEmpty!) {
                                  showSnackBar(
                                    message: "Age is required",
                                    snackColor: ColorUtils.primaryColor,
                                  );
                                  return;
                                }
                                else if (cityController.text.isEmpty!) {
                                  showSnackBar(
                                    message: "City is required",
                                    snackColor: ColorUtils.primaryColor,
                                  );
                                  return;
                                }
                                else if (professionController.text.isEmpty!) {
                                  showSnackBar(
                                    message: "Profession is required",
                                    snackColor: ColorUtils.primaryColor,
                                  );
                                  return;
                                }
                                else {

                                  avatarUserNameReqModel
                                      .avatar = userNameController
                                      .selectedUrl ??
                                      PreferenceManagerUtils.getUserAvatar();
                                  avatarUserNameReqModel.username =
                                  // ignore: unrelated_type_equality_checks
                                  avatarUserNameReqModel.username ==
                                      nameController.text.isEmpty
                                      ? PreferenceManagerUtils
                                      .getAvatarUserName()
                                      : nameController.text;
                                  avatarUserNameReqModel.fullName =
                                      fullnameController.text.trimLeft();
                                  avatarUserNameReqModel.anonymous =
                                  userNameController.tabSelector == 0
                                      ? true
                                      : false;
                                  avatarUserNameReqModel.referral =
                                      PreferenceManagerUtils.getReferralCode();
                                  avatarUserNameReqModel.location = LocationMap(
                                    coordinates: [lat, long],
                                  );
                                  LocationName locationName = LocationName();
                                  locationName.address = address;
                                  locationName.counter = country;
                                  locationName.state = state;
                                  avatarUserNameReqModel.locationName =
                                      locationName;

                                  // log('==================>${avatarUserNameReqModel.toJson()}');
                                  await userNameController
                                      .avatarUserNameViewModel(
                                      avatarUserNameReqModel);
                                  if (userNameController
                                      .avatarUserNameApiResponse.status ==
                                      Status.COMPLETE) {
                                    AvatarUserNameResModel response =
                                        userNameController
                                            .avatarUserNameApiResponse.data;

                                    if (response.status == 200) {
                                      addressBookViewModel.setUserAvatar =
                                          avatarUserNameReqModel.avatar;
                                      await PreferenceManagerUtils
                                          .setAvatarUserName(
                                          nameController.text);
                                      await PreferenceManagerUtils
                                          .setAvatarUserFullName(
                                          fullnameController.text
                                              .trimLeft());
                                      if (userNameController.selectedUrl !=
                                          null &&
                                          userNameController
                                              .selectedUrl!.isNotEmpty) {
                                        await PreferenceManagerUtils
                                            .setUserAvatar(userNameController
                                            .selectedUrl!);
                                      }

                                      Map<String, dynamic> data = {
                                        'username':nameController.text,
                                        'fullname':fullnameController.text,
                                        'city':cityController.text,
                                        'age':ageController.text,
                                        'profession':professionController.text,
                                        'school_name':schoolController.text,
                                        'college_name':collegeController.text
                                      };

                                      FirebaseFirestore.instance.collection("ProfileDetails")
                                          .doc(PreferenceManagerUtils.getLoginId()).set(data);
                                      FocusScope.of(context).unfocus();
                                      Get.back();
                                      showSnackBar(
                                        message: response.message,
                                        snackColor: ColorUtils.greenE8,
                                      );
                                    } else {
                                      showSnackBar(
                                        message: response.message,
                                        snackColor: ColorUtils.red,
                                      );
                                    }
                                  }
                                }
                              },
                              child: Container(
                                height: 13.w,
                                decoration: DecorationUtils
                                    .allBorderAndColorDecorationBox(
                                  radius: 7,
                                ),
                                child: Center(
                                  child: Text(
                                    VariableUtils.save,
                                    style: FontTextStyle.poppinsWhite10bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizeConfig.sH3,
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// _showPicker

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  /// get Image from Camera

  _imgFromCamera() async {
    try {
      ImagePicker pickImage = ImagePicker();
      final result = await pickImage.pickImage(
        source: ImageSource.camera,
      );

      if (result != null) {
        // uploadFile = File(result.path);
        setState(() {});
        _image = await _cropImage(File(result.path));

        appState = AppState.picked;
        avatarUserNameController.selectedUrl =
        await uploadProfileImage(image: _image);
      }
    } on Exception catch (e) {
      log('error $e');
    }
  }

  /// get Image from gallery

  _imgFromGallery() async {
    try {
      ImagePicker pickImage = ImagePicker();
      final result = await pickImage.pickImage(
        source: ImageSource.gallery,
      );

      if (result != null) {
        // uploadFile = File(result.path);
        setState(() {});
        _image = await _cropImage(File(result.path));

        appState = AppState.picked;
        avatarUserNameController.selectedUrl =
        await uploadProfileImage(image: _image);
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('error $e');
      }
    }
  }

  /// Cropper
  Future _cropImage(File? pickFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickFile!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
        ]
            : [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: VariableUtils.appName,
            toolbarColor: ColorUtils.primaryColor,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: ColorUtils.primaryColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: const IOSUiSettings(
          title: VariableUtils.appName,
        ));
    if (croppedFile != null) {
      pickFile = croppedFile;
      setState(() {
        appState = AppState.cropped;
      });
      // log("PATH $pickFile");
    }
    return croppedFile!;
  }

  Future<String?> uploadProfileImage({File? image}) async {
    FileUploadViewModel fileUploadViewModel = Get.find<FileUploadViewModel>();

    await fileUploadViewModel.uploadProfile(query: image!);

    if (fileUploadViewModel.uploadProfileApiResponse.status ==
        Status.COMPLETE) {
      ImageUploadResModel uploadProfileResModel =
          fileUploadViewModel.uploadProfileApiResponse.data;

      if (uploadProfileResModel.error == true) {
        showSnackBar(
            message: "${uploadProfileResModel.message}",
            snackColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        return uploadProfileResModel.data;
      }
    } else {
      showSnackBar(
          message: "Something went to wrong...",
          snackColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM);
    }
    return null;
  }
}