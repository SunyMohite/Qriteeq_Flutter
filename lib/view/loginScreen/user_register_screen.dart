import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:humanscoring/modal/apiModel/res_model/user_name_availability_res_model.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/viewmodel/auth_viewmodel.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../common/circular_progress_indicator.dart';
import '../../common/commonWidget/custom_text_field.dart';
import '../../common/commonWidget/snackbar.dart';
import '../../modal/apiModel/req_model/avatar_username_req_model.dart';
import '../../modal/apiModel/res_model/avatar_username_res_model.dart';
import '../../modal/apiModel/res_model/get_avatar_username_res_model.dart';
import '../../modal/apiModel/res_model/image_upload_res_model.dart';
import '../../modal/apis/api_response.dart';
import '../../newwidget/buttons.dart';
import '../../utils/assets/icons_utils.dart';
import '../../utils/assets/images_utils.dart';
import '../../utils/country_dialcode.dart';
import '../../utils/decoration_utils.dart';
import '../../utils/enum_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/shared_preference_utils.dart';
import '../../utils/validation_utils.dart';
import '../../utils/variable_utils.dart';
import '../../viewmodel/address_book_viewmodel.dart';
import '../../viewmodel/avatar_user_name_controller.dart';
import '../../viewmodel/fileupload_viewmodel.dart';
import '../home/home_screen.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({Key? key}) : super(key: key);

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  AuthViewModel viewModel = Get.find();

  TextEditingController fullnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  final fromkey = GlobalKey<FormState>();
  AvatarUserNameReqModel avatarUserNameReqModel = AvatarUserNameReqModel();
  GetAvatarUserNameResModel getAvatarUserNameResModel =
      GetAvatarUserNameResModel();
  CarouselController carouselController = CarouselController();
  AvatarUserNameController avatarUserNameController =
      Get.find<AvatarUserNameController>();
  String? userName = "";

  bool serviceStatus = false;
  bool hasPermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  List<Placemark> placeMarks = [];
  String? address = '';
  String? countryName = '';
  String? state = '';
  String? dialCode = '';

  FileUploadViewModel fileUploadViewModel = Get.find<FileUploadViewModel>();
  File? _image;
  AppState? appState;
  String? countryFlagUrl;

  @override
  void initState() {
    checkGps();
    avatarUserNameController.getAvatarUserNameViewModel();
    super.initState();
  }

  List<String> stringList = [
    'The username can only have alphabets in lower case, 0-9 and underscores.',
    'Minimum length is 5 characters.'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            left: 0,
            bottom: 0,
            child: Image.asset(
              profileBackgroundImg,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: fromkey,
              child: ListView(
                children: [
                  SizeConfig.sH3,
                  Text(
                    "Set profile",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 10.w),
                  ),
                  Text(
                    "Set an avatar & username",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 6.w),
                  ),
                  SizeConfig.sH3,
                  GetBuilder<AvatarUserNameController>(
                      builder: (userNameController) {
                    if (userNameController
                            .getAvatarUserNameApiResponse.status ==
                        Status.LOADING) {
                      return const CircularIndicator();
                    }
                    if (userNameController
                            .getAvatarUserNameApiResponse.status ==
                        Status.COMPLETE) {
                      getAvatarUserNameResModel =
                          userNameController.getAvatarUserNameApiResponse.data;
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: IconsWidgets.iosBackArrow,
                              onTap: () {
                                carouselController.previousPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeIn,
                                );
                              },
                            ),
                            getAvatarUserNameResModel.data == null
                                ? const Text("Server error")
                                : Expanded(
                                    child: Container(
                                      height: 19.w,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: CarouselSlider(
                                        carouselController: carouselController,
                                        options: CarouselOptions(
                                          enableInfiniteScroll: false,
                                          enlargeCenterPage: true,
                                          viewportFraction: 0.3,
                                          aspectRatio: 0.1,
                                          initialPage: 0,
                                          onPageChanged: (val, _) {
                                            userNameController.setPageIndex =
                                                val;
                                          },
                                        ),
                                        items: List.generate(
                                          getAvatarUserNameResModel
                                              .data!.url!.length,
                                          (index) {
                                            if (userNameController
                                                    .setPageIndex ==
                                                index) {
                                              userNameController.selectedUrl =
                                                  getAvatarUserNameResModel
                                                      .data!.url![index];
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
                                                          ? Colors.transparent
                                                              .withOpacity(0.5)
                                                          : ColorUtils
                                                              .transparent,
                                                      blurRadius: 4,
                                                      offset:
                                                          const Offset(0, 4))
                                                ],
                                                border: userNameController
                                                            .setPageIndex ==
                                                        index
                                                    ? Border.all(
                                                        color: ColorUtils.white,
                                                        width: 2,
                                                      )
                                                    : const Border(),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                      userNameController
                                                                  .setPageIndex ==
                                                              index
                                                          ? 4
                                                          : 15,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: Image.network(
                                                        getAvatarUserNameResModel
                                                            .data!.url![index],
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                  ),
                                                  userNameController
                                                              .setPageIndex ==
                                                          index
                                                      ? Container()
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: ColorUtils
                                                                  .transparent,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: userNameController.setPageIndex ==
                                                                            index
                                                                        ? Colors
                                                                            .transparent
                                                                            .withOpacity(
                                                                                0.5)
                                                                        : ColorUtils
                                                                            .white
                                                                            .withOpacity(
                                                                                0.5),
                                                                    blurRadius:
                                                                        4,
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            4))
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
                                  ),
                            InkWell(
                              onTap: () {
                                carouselController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: IconsWidgets.iosForwardArrow,
                            ),
                          ],
                        ),
                        SizeConfig.sH1,
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
                                      height: 20.w,
                                      width: 20.w,
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
                                    child: Container(
                                      height: 20.w,
                                      width: 20.w,
                                      decoration: BoxDecoration(
                                          color: ColorUtils.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Icon(
                                        Icons.person_add_alt,
                                        size: 8.w,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        SizeConfig.sH1,
                        CommonTextField(
                          hintText: VariableUtils.fullNameRequired,
                          textCapitalization: TextCapitalization.sentences,
                          textEditController: fullnameController,
                          isValidate: true,
                          validationMessage: VariableUtils.fullNameRequired,
                          textInputType: TextInputType.name,
                          regularExpression:
                              RegularExpression.alphabetDigitsPattern,
                        ),
                        SizeConfig.sH2,
                        CommonTextField(
                          hintText: "Username*",
                          validationMessage: VariableUtils.userNameRequired,
                          textEditController: usernameController,
                          isValidate: true,
                          textInputType: TextInputType.name,
                          regularExpression: RegularExpression
                              .alphabetDigitsWithoutSpacePattern,
                          onChange: (str) async {
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
                        ),
                        SizeConfig.sH1,
                        GetBuilder<AuthViewModel>(
                          builder: (controller) {
                            return Text(
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
                                      ? ColorUtils.white
                                      : controller.userStatus
                                          ? ColorUtils.lightRed
                                          : ColorUtils.lightGreen,
                                  fontSize: 5.w,
                                  fontWeight: FontWeight.w600),
                            );
                          },
                        ),
                        SizedBox(height: 2.w),
                        GetBuilder<AuthViewModel>(
                          builder: (authViewModel) {
                            return authViewModel.getSignInSelected == false ||
                                    serviceStatus == false ||
                                    serviceStatus == null
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "SELECT COUNTRY : ",
                                        style: TextStyle(
                                            color: ColorUtils.greyNew),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            selectCountryCode();
                                          },
                                          child: Text(
                                            countryName!.isEmpty
                                                ? "Select your country"
                                                : countryName!,
                                            style: const TextStyle(
                                                color: ColorUtils.white),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          selectCountryCode();
                                        },
                                        child: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  )
                                : SizedBox();
                          },
                        ),
                        SizedBox(height: 2.w),
                        Container(
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Color(0xEF4A52FC),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: stringList.map((str) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '\u2022',
                                    style: TextStyle(
                                        fontSize: 16,
                                        height: 1.55,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      str,
                                      textAlign: TextAlign.left,
                                      softWrap: true,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        height: 1.55,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        SizeConfig.sH8,
                        GetBuilder<AuthViewModel>(
                          builder: (authViewModel) {
                            return materialButton(
                                submitText: "Continue",
                                buttonColor: Colors.white,
                                height: 7.h,
                                onTap: () async {
                                  if (fromkey.currentState!.validate()) {
                                    if (usernameController.text.isEmpty) {
                                      showSnackBar(
                                        message: VariableUtils.userNameRequired,
                                        snackColor: ColorUtils.primaryColor,
                                      );
                                      return;
                                    } else if (fullnameController
                                        .text.isBlank!) {
                                      showSnackBar(
                                        message:
                                            VariableUtils.userFullNameRequired,
                                        snackColor: ColorUtils.primaryColor,
                                      );
                                      return;
                                    } else if (dialCode == null ||
                                        dialCode!.isEmpty) {
                                      showSnackBar(
                                        message:
                                            VariableUtils.selectYourCountry,
                                        snackColor: ColorUtils.primaryColor,
                                      );
                                      return;
                                    }
                                    avatarUserNameReqModel.avatar =
                                        userNameController.selectedUrl;
                                    avatarUserNameReqModel.username =
                                        usernameController.text;
                                    avatarUserNameReqModel.anonymous = true;
                                    avatarUserNameReqModel.fullName =
                                        fullnameController.text.trimLeft();

                                    avatarUserNameReqModel.flagUrl =
                                        countryFlagUrl ??
                                            VariableUtils.countryFlag;
                                    avatarUserNameReqModel.fcm =
                                        PreferenceManagerUtils.getFcmToken();
                                    avatarUserNameReqModel.referral =
                                        PreferenceManagerUtils
                                            .getReferralCode();
                                    avatarUserNameReqModel.location =
                                        LocationMap(
                                      coordinates: [lat, long],
                                    );
                                    LocationName locationName = LocationName();
                                    locationName.address = address;
                                    locationName.counter = countryName;
                                    locationName.state = state;
                                    locationName.dialCode = dialCode;
                                    avatarUserNameReqModel.locationName =
                                        locationName;
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
                                        AddressBookViewModel
                                            addressBookViewModel = Get.find();

                                        await PreferenceManagerUtils
                                            .setAvatarUserName(
                                                usernameController.text);
                                        await PreferenceManagerUtils
                                            .setAvatarUserFullName(
                                                fullnameController.text
                                                    .trimLeft());
                                        await PreferenceManagerUtils
                                            .setUserAvatar(userNameController
                                                .selectedUrl!);

                                        addressBookViewModel.setUserAvatar =
                                            userNameController.selectedUrl!;
                                        FocusScope.of(context).unfocus();
                                        showSnackBar(
                                          message: response.message,
                                          snackColor: ColorUtils.greenE8,
                                        );
                                        Get.offAll(const HomeScreen());
                                      } else {
                                        Get.defaultDialog(
                                            title: VariableUtils.appName,
                                            titleStyle: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 14.sp,
                                                color: ColorUtils.primaryColor,
                                                fontWeight: FontWeight.bold),
                                            barrierDismissible: true,
                                            onWillPop: () {
                                              return Future.value(true);
                                            },
                                            content: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 2.w,
                                                    right: 2.w,
                                                  ),
                                                  child: Text(
                                                    response.message!,
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 12.sp,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              InkWell(
                                                onTap: () async {
                                                  Get.back();
                                                },
                                                child: Container(
                                                  height: 10.w,
                                                  margin: EdgeInsets.only(
                                                      left: 25.w,
                                                      right: 25.w,
                                                      bottom: 5.w),
                                                  padding: EdgeInsets.only(
                                                    left: 2.w,
                                                    right: 2.w,
                                                  ),
                                                  decoration: DecorationUtils
                                                      .allBorderAndColorDecorationBox(
                                                          radius: 7,
                                                          colors: ColorUtils
                                                              .primaryColor),
                                                  child: Center(
                                                    child: Text(
                                                      "Ok",
                                                      style: FontTextStyle
                                                          .poppinsWhite10bold,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]);
                                      }
                                    }
                                  } else {
                                    return;
                                  }
                                },
                                fontSize: 4.w);
                          },
                        )
                      ],
                    );
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void selectCountryCode() {
    showCountryPicker(
      context: context,
      showPhoneCode:
          false, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        setState(() {
          countryName = country.name;
          dialCode = country.countryCode;
        });
      },
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

    long = position.longitude.toString();
    lat = position.latitude.toString();
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    address = placeMarks.first.subAdministrativeArea;
    countryName = placeMarks.first.country;
    state = placeMarks.first.administrativeArea;
    for (var map in countryPhoneCodes) {
      if (map["code"] == placeMarks.first.isoCountryCode) {
        dialCode = map['dial_code'];
      }
    }
  }
}
