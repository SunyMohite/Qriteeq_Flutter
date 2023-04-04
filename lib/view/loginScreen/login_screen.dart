import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:humanscoring/common/circular_progress_indicator.dart';
import 'package:humanscoring/modal/apiModel/req_model/fcm_req_model.dart';
import 'package:humanscoring/modal/apiModel/req_model/otp_verification_req_model.dart';
import 'package:humanscoring/modal/apiModel/req_model/register_req_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/otp_verification_res_model.dart';
import 'package:humanscoring/modal/apiModel/res_model/register_res_model.dart';
import 'package:humanscoring/modal/apis/api_response.dart';
import 'package:humanscoring/utils/assets/images_utils.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/decoration_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:humanscoring/utils/variable_utils.dart';
import 'package:humanscoring/view/profileScreen/drawerScreen/webpage_screen.dart';
import 'package:humanscoring/viewmodel/auth_viewmodel.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

import '../../common/commonWidget/snackbar.dart';
import '../../utils/const_utils.dart';
import '../../utils/validation_utils.dart';
import '../../viewmodel/address_book_viewmodel.dart';
import '../home/home_screen.dart';
import '../suggestionScreen/suggestion_screen.dart';
import 'user_register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  RegisterReqModel registerReqModel = RegisterReqModel();
  AuthViewModel authViewModel = Get.find();
  FcmReqModel fcmReqModel = FcmReqModel();
  OtpVerificationReqModel otpVerificationReqModel = OtpVerificationReqModel();

  String maskEmail = '';
  String maskMobile = '';

  @override
  void dispose() {
    super.dispose();
  }

  List<String> onBoardingText = [
    'Review & rate people',
    'Share your opinions with the world',
    'Give Score & review for a person by easy steps',
    'Search people via their social media profiles',
  ];
  List<Widget> onBoardingWidget = [
    ImagesWidgets.onBoard1Image,
    ImagesWidgets.onBoard2Image,
    ImagesWidgets.onBoard3Image,
    ImagesWidgets.onBoard4Image,
  ];

  final _scaffold = GlobalKey<ScaffoldState>();
  final TextEditingController mobileNumber = TextEditingController();
  List<String> deepLinkData = [];
  bool isEqualStatus = false, isAndStatus = false, isTerms = false;
  String? isSuggest;
  bool serviceStatus = false;
  bool hasPermission = false;
  late LocationPermission permission;
  late Position position;
  List<Placemark> placeMarks = [];
  String? long = "",
      lat = "",
      address = '',
      isoCountryCode = '',
      country = '',
      state = '';

  @override
  void initState() {
    checkGps();
    authViewModel.pageController = PageController(initialPage: 0);

    Future.delayed(Duration.zero, () {
      initDynamicLinks();
    });

    isSuggest = PreferenceManagerUtils.getIsSuggest();
    super.initState();
  }

  void initDynamicLinks() async {
    PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      final strName = data?.link.toString();
      deepLinkData.clear();
      isEqualStatus = false;
      String str = '';

      for (int i = 0; i < strName!.length + 1; i++) {
        if (strName.length == i) {
          deepLinkData.add(str);
          break;
        }
        if (isEqualStatus) {
          if (strName[i] != '&') {
            str += strName[i];
          } else {
            deepLinkData.add(str.trim());
            str = '';
            isEqualStatus = false;
          }
        } else if (strName[i] == '=') {
          isEqualStatus = true;
        }
      }
      if (deepLinkData[0] == 'ReferralCode') {
        await PreferenceManagerUtils.setDeepLinkReferral(deepLinkData[1]);
      }
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  AddressBookViewModel addressBookViewModel = Get.find();

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
    country = placeMarks.first.country;
    state = placeMarks.first.administrativeArea;
    isoCountryCode = placeMarks.first.isoCountryCode;
  }

  /// maskingEmailMobile

  String maskingEmailMobile({String? type, String? data, int? dataLen = 3}) {
    if (data!.isEmpty || data == '') {
      return '';
    } else {
      if (type == VariableUtils.email) {
        var emailPrefix = data.split("@")[0];
        var emailSuffix = data.split("@")[1];
        if (emailPrefix.length < 4) {
          dataLen = 2;
        }
        var emailList = [];
        String result = emailPrefix.substring(
            emailPrefix.length - dataLen!, emailPrefix.length);
        String emailFirst =
            emailPrefix.substring(0, emailPrefix.length - dataLen);

        for (int i = 0; i < emailFirst.length; i++) {
          emailList.add(emailFirst.replaceRange(0, emailFirst.length, '*'));
        }

        final finalString = emailList.join('') + result + '@' + emailSuffix;
        log('===============$finalString');
        return finalString;
      } else {
        var mobileList = [];

        String mobileFirst = data.substring(0, data.length - dataLen!);
        String mobileLast = data.substring(data.length - dataLen, data.length);

        for (int i = 0; i < mobileFirst.length; i++) {
          mobileList.add(mobileFirst.replaceRange(0, mobileFirst.length, '*'));
        }

        final finalString = mobileList.join('') + mobileLast;
        log('===============$finalString');
        return finalString;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffold,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: GetBuilder<AuthViewModel>(
            builder: (authViewModel) {
              return Container(
                decoration: DecorationUtils.imageDecorationBox(),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      children: [
                        const Spacer(),
                        SizeConfig.sH1,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            onBoardingText[authViewModel.carouselSliderIndex],
                            style: FontTextStyle.poppinsWhite11semiB
                                .copyWith(fontSize: 16.sp),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizeConfig.sH1,
                        Visibility(
                          visible: !authViewModel.focused,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                List.generate(onBoardingWidget.length, (index) {
                              return Container(
                                height: 10,
                                width: 10,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    color: authViewModel.carouselSliderIndex ==
                                            index
                                        ? ColorUtils.white
                                        : ColorUtils.black.withOpacity(0.35),
                                    shape: BoxShape.circle),
                              );
                            }),
                          ),
                        ),
                        SizeConfig.sH1,
                        Container(
                          height: 85.w,
                          decoration: DecorationUtils
                              .verticalBorderAndColorDecorationBox(
                            colors: ColorUtils.white,
                            radius: 20,
                          ),
                          child: PageView(
                            controller: authViewModel.pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            onPageChanged: (value) {
                              authViewModel.pageSelector = value;
                            },
                            children: [
                              getStartWithWidget(authViewModel),
                              signWithPhoneEmailWidget(authViewModel, context),
                              otpWidget(context, authViewModel),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: !authViewModel.focused,
                      child: CarouselSlider(
                        options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio:
                                authViewModel.focused == false ? 1.2 : 2.5,
                            enlargeCenterPage: true,
                            viewportFraction: 2,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            onPageChanged: (index, reason) {
                              authViewModel.setSliderIndex(index);
                            }),
                        items: onBoardingWidget,
                      ),
                    ),
                    if (authViewModel.registerApiResponse.status ==
                            Status.LOADING ||
                        authViewModel.otpVerificationApiResponse.status ==
                            Status.LOADING)
                      const CircularIndicator(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// GetStartWithWidget
  Widget getStartWithWidget(AuthViewModel authViewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizeConfig.sH2,
          Text(
            VariableUtils.getStart,
            style: FontTextStyle.poppinsBlack12bold.copyWith(
                color: const Color(0xff414141),
                fontWeight: FontWeightClass.semiB),
          ),
          SizeConfig.sH1,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 0.w),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: Checkbox(
                      activeColor: ColorUtils.primaryColor,
                      value: isTerms,
                      onChanged: (value) {
                        setState(() {
                          isTerms = !isTerms;
                        });
                      }),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: VariableUtils.iAcceptThe,
                        style: FontTextStyle.poppinsBlack12bold.copyWith(
                            color: const Color(0xff414141),
                            fontSize: 11.sp,
                            fontWeight: FontWeightClass.regular),
                      ),
                      TextSpan(
                        text: VariableUtils.termsAndConditions,
                        style: FontTextStyle.poppinsBlack12bold.copyWith(
                            color: ColorUtils.primaryColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeightClass.regular),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(
                              const WebViewScreen(
                                webUrl: ConstUtils.termsConditionUrl,
                                titleBarText: VariableUtils.termsAndConditions,
                              ),
                            );
                          },
                      ),
                      TextSpan(
                        text: ' of QriteeQ.',
                        style: FontTextStyle.poppinsBlack12bold.copyWith(
                            color: const Color(0xff414141),
                            fontSize: 11.sp,
                            fontWeight: FontWeightClass.regular),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizeConfig.sH1,
          IgnorePointer(
            ignoring: isTerms ? false : true,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Material(
                color: isTerms
                    ? ColorUtils.blue14
                    : ColorUtils.blue14.withOpacity(0.5),
                child: InkWell(
                  onTap: () async {
                    /// - Widget Button - GetStartWithWidget

                    await PreferenceManagerUtils.setIsLoginVia(
                        VariableUtils.loginViaPHNumber);
                    authViewModel.setSignSelected(true);
                    authViewModel.pageController.nextPage(
                      duration: const Duration(microseconds: 1200),
                      curve: Curves.bounceInOut,
                    );
                    await PreferenceManagerUtils.setIsSuggest('isSuggest');
                  },
                  child: Container(
                    height: 13.w,
                    // width: 80.w,
                    decoration: DecorationUtils.allBorderAndColorDecorationBox(
                      // colors: ColorUtils.blue14,
                      radius: 7,
                    ),
                    child: Center(
                      child: Text(
                        VariableUtils.signInWithPhoneNumber.toUpperCase(),
                        style: FontTextStyle.poppinsWhite10bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizeConfig.sH1,
          Text(
            VariableUtils.oR.toUpperCase(),
            style: FontTextStyle.poppinsBlack12bold,
          ),
          SizeConfig.sH1,
          IgnorePointer(
            ignoring: isTerms ? false : true,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Material(
                color: isTerms
                    ? ColorUtils.black2D
                    : ColorUtils.black2D.withOpacity(0.5),
                child: InkWell(
                  onTap: () async {
                    /// - Widget Button - GetStartWithWidget

                    await checkGps();
                    authViewModel.setSignSelected(false);
                    await PreferenceManagerUtils.setIsLoginVia(
                        VariableUtils.loginViaEmail);

                    authViewModel.pageController.nextPage(
                      duration: const Duration(microseconds: 1200),
                      curve: Curves.bounceInOut,
                    );
                    await PreferenceManagerUtils.setIsSuggest('isSuggest');
                  },
                  child: Container(
                    height: 13.w,
                    // width: 80.w,
                    decoration: DecorationUtils.allBorderAndColorDecorationBox(
                      // colors: ColorUtils.black2D,
                      radius: 7,
                    ),
                    child: Center(
                      child: Text(
                        VariableUtils.signInWithEmail.toUpperCase(),
                        style: FontTextStyle.poppinsWhite10bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizeConfig.sH5,
        ],
      ),
    );
  }

  /// SignWithPhoneEmailWidget
  Widget signWithPhoneEmailWidget(
      AuthViewModel authViewModel, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizeConfig.sH2,
          Text(
            authViewModel.getSignInSelected == true
                ? VariableUtils.signInWithPhoneNumber
                : VariableUtils.signInWithEmail,
            style: FontTextStyle.poppinsBlack12bold.copyWith(
                color: const Color(0xff414141),
                fontWeight: FontWeightClass.semiB),
          ),
          SizeConfig.sH1,
          SizedBox(
            child: Focus(
              onFocusChange: (value) {
                authViewModel.focused = value;
              },
              child: authViewModel.getSignInSelected == true
                  ? Form(
                      key: _formKey,
                      child: IntlPhoneField(
                        controller: mobileNumber,
                        decoration: InputDecoration(
                          hintText: 'Mobile number'.tr,
                          counterText: '',
                          contentPadding: const EdgeInsets.all(10),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: ColorUtils.blue14,
                              width: 10,
                            ),
                          ),
                          focusedBorder: DecorationUtils.outLineSonicBlue14R20,
                          enabledBorder: DecorationUtils.outLineSonicBlue14R20,
                          disabledBorder: DecorationUtils.outLineSonicBlue14R20,
                          errorBorder: DecorationUtils.outLineSonicBlue14R20,
                        ),
                        flagsButtonPadding: EdgeInsets.only(left: 2.5.w),
                        showDropdownIcon: false,
                        disableLengthCheck: false,
                        initialCountryCode: VariableUtils.countryCode,
                        onChanged: (phone) {
                          // if (phone.number.length == 10) {
                          //   FocusScope.of(context).unfocus();
                          // }
                          ConstUtils.mobileEditingController =
                              phone.completeNumber;
                        },
                        onCountryChanged: (country) async {
                          VariableUtils.countryCode = country.code;
                          VariableUtils.countryCodeNumber =
                              '+${country.dialCode}';
                          setState(() {});
                        },
                      ),
                    )
                  : TextFormField(
                      onChanged: (value) {
                        ConstUtils.emailEditingController = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1000),
                        FilteringTextInputFormatter.allow(
                          RegExp(RegularExpression.emailPattern),
                        )
                      ],
                      style: FontTextStyle.poppinsBlack10Medium,
                      decoration: InputDecoration(
                        // contentPadding: const EdgeInsets.all(10),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 13.5, horizontal: 10.0),

                        isDense: true,
                        hintText: VariableUtils.enterEmail,
                        hintStyle: FontTextStyle.poppinsGrayA8A89Normal
                            .copyWith(fontSize: 11.sp),
                        focusedBorder: DecorationUtils.outLineSonicBlue14R20,
                        enabledBorder: DecorationUtils.outLineSonicBlue14R20,
                        disabledBorder: DecorationUtils.outLineSonicBlue14R20,
                        errorBorder: DecorationUtils.outLineSonicBlue14R20,
                        focusedErrorBorder:
                            DecorationUtils.outLineSonicBlue14R20,
                      ),
                    ),
            ),
          ),
          SizeConfig.sH1,
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Material(
              color: ColorUtils.blue14,
              child: InkWell(
                onTap: () async {
                  ///FOR MOBILE NUMBER CALL
                  if (authViewModel.getSignInSelected == true) {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      registerReqModel.verificationId =
                          ConstUtils.mobileEditingController;
                      maskMobile = ConstUtils.mobileEditingController!;

                      registerReqModel.countryCode =
                          VariableUtils.countryCodeNumber;

                      if (PreferenceManagerUtils.getDeepLinkReferral()
                          .isEmpty) {
                        await authViewModel.registerViewModel(
                            registerReqModel.toMobileNumberJson());
                      } else {
                        registerReqModel.referral =
                            PreferenceManagerUtils.getDeepLinkReferral();
                        await authViewModel.registerViewModel(
                            registerReqModel.toWithMobileNumberReferralJson());
                      }

                      if (authViewModel.registerApiResponse.status ==
                          Status.COMPLETE) {
                        RegisterResModel response =
                            authViewModel.registerApiResponse.data;
                        if (response.status == 200) {
                          await PreferenceManagerUtils.setUserCountryCode(
                              VariableUtils.countryCode);
                          await PreferenceManagerUtils.setUserCountryCodeNumber(
                              VariableUtils.countryCodeNumber);

                          showSnackBar(
                            message: response.message,
                            snackColor: ColorUtils.greenE8,
                          );
                          Future.delayed(
                            const Duration(seconds: 1),
                            () {
                              authViewModel.pageController.nextPage(
                                duration: const Duration(microseconds: 1200),
                                curve: Curves.bounceInOut,
                              );
                              // emailEditingController.clear();
                            },
                          );
                        } else {
                          showSnackBar(
                            message: response.message,
                            snackColor: ColorUtils.red,
                          );
                        }
                      }
                    }
                  } else {
                    ///FOR EMAIL CALL
                    await checkGps();

                    if (authViewModel.getSignInSelected == false) {
                      if (ConstUtils.emailEditingController!.isEmpty ||
                          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(ConstUtils.emailEditingController!)) {
                        showSnackBar(
                          message: VariableUtils.emailFormat,
                          snackColor: ColorUtils.red,
                        );
                      } else {
                        FocusScope.of(context).unfocus();
                        registerReqModel.verificationId =
                            ConstUtils.emailEditingController;
                        maskEmail = ConstUtils.emailEditingController!;
                        registerReqModel.countryCode = isoCountryCode;

                        if (PreferenceManagerUtils.getDeepLinkReferral()
                            .isEmpty) {
                          if (isoCountryCode!.isEmpty ||
                              isoCountryCode == null) {
                            await authViewModel.registerViewModel(
                                registerReqModel.toEmailRequestOnlyJson());
                          } else {
                            await authViewModel.registerViewModel(
                                registerReqModel.toEmailRequestJson());
                          }
                        } else {
                          registerReqModel.referral =
                              PreferenceManagerUtils.getDeepLinkReferral();
                          registerReqModel.countryCode = isoCountryCode;
                          if (isoCountryCode!.isEmpty) {
                            await authViewModel.registerViewModel(
                                registerReqModel.toWithEmailReferralOnlyJson());
                          } else {
                            await authViewModel.registerViewModel(
                                registerReqModel.toWithEmailReferralJson());
                          }
                        }

                        if (authViewModel.registerApiResponse.status ==
                            Status.COMPLETE) {
                          RegisterResModel response =
                              authViewModel.registerApiResponse.data;
                          if (response.status == 200) {
                            showSnackBar(
                              message: response.message,
                              snackColor: ColorUtils.primaryColor,
                            );
                            await PreferenceManagerUtils.setUserCountryCode(
                                isoCountryCode!);
                            Future.delayed(
                              const Duration(seconds: 1),
                              () {
                                authViewModel.pageController.nextPage(
                                  duration: const Duration(microseconds: 1200),
                                  curve: Curves.bounceInOut,
                                );
                              },
                            );
                          } else {
                            showSnackBar(
                              message: response.message,
                              snackColor: ColorUtils.red,
                            );
                          }
                        }
                      }
                    }
                  }
                },
                child: Container(
                  height: 13.w,
                  decoration: DecorationUtils.allBorderAndColorDecorationBox(
                    colors: ColorUtils.blue14,
                    radius: 7,
                  ),
                  child: Center(
                    child: Text(
                      VariableUtils.getOtp.toUpperCase(),
                      style: FontTextStyle.poppinsWhite10bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // SizeConfig.sH1,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                VariableUtils.note,
                style: FontTextStyle.poppinsWhite10bold
                    .copyWith(color: ColorUtils.black65),
              ),
              Expanded(
                child: Text(
                  "${authViewModel.getSignInSelected == true ? VariableUtils.otpWillBeSentToWhatsApp : 'The OTP will be sent to your email address'} ",
                  style: FontTextStyle.poppinsWhite10bold.copyWith(
                      color: ColorUtils.black95, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          Text(
            VariableUtils.oR.toUpperCase(),
            style: FontTextStyle.poppinsBlack12bold,
          ),
          authViewModel.getSignInSelected == true
              ? InkWell(
                  onTap: () async {
                    await checkGps();

                    FocusScope.of(context).unfocus();
                    authViewModel.setSignSelected(false);
                    await PreferenceManagerUtils.setIsLoginVia(
                        VariableUtils.loginViaEmail);
                  },
                  child: Text(
                    VariableUtils.signInWithEmail.toUpperCase(),
                    style: FontTextStyle.poppinsBlue14NormalNone,
                  ),
                )
              : InkWell(
                  onTap: () async {
                    // TODO: SignWithPhoneEmailWidget

                    FocusScope.of(context).unfocus();
                    await PreferenceManagerUtils.setIsLoginVia(
                        VariableUtils.loginViaPHNumber);

                    authViewModel.setSignSelected(true);
                  },
                  child: Text(
                    VariableUtils.signInWithPhoneNumber.toUpperCase(),
                    style: FontTextStyle.poppinsBlue14NormalNone,
                  ),
                ),
          SizeConfig.sH3,
        ],
      ),
    );
  }

  /// OTP WIDGET
  Widget otpWidget(BuildContext context, AuthViewModel authViewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizeConfig.sH2,
          Text(
            "${VariableUtils.otpEnterMsg}${authViewModel.getSignInSelected == true ? 'number ${maskingEmailMobile(
                type: VariableUtils.phone,
                data: maskMobile,
              )}' : 'Email id ${maskingEmailMobile(
                type: VariableUtils.email,
                data: maskEmail,
              )}'} ",
            style: FontTextStyle.poppinsBlack12bold.copyWith(
                color: const Color(0xff414141),
                fontWeight: FontWeight.w400,
                fontSize: 11.sp),
          ),
          SizeConfig.sH1,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Focus(
              onFocusChange: (value) {
                authViewModel.focused = value;
              },
              child: PinCodeTextField(
                textInputAction: TextInputAction.done,
                showCursor: false,
                pinTheme: PinTheme(
                  borderRadius: BorderRadius.circular(5),
                  shape: PinCodeFieldShape.box,
                  fieldHeight: 12.w,
                  fieldWidth: 12.w,
                  activeColor: ColorUtils.blue14,
                  borderWidth: 1,
                  inactiveColor: ColorUtils.blue14,
                ),
                keyboardType: TextInputType.number,
                appContext: context,
                length: 4,
                pastedTextStyle: FontTextStyle.poppins12DarkBlack,

                enablePinAutofill: true,
                dialogConfig: DialogConfig(
                    dialogContent: 'Do you want to paste this code '),
                onChanged: (String value) {
                  ConstUtils.otpController = value;
                },
                // controller: otpController,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Didn’t get OTP?",
                style: TextStyle(color: ColorUtils.black26),
              ),
              InkWell(
                onTap: () async {
                  ///FOR MOBILE NUMBER VERIFICATION.......

                  if (authViewModel.getSignInSelected == true) {
                    if (ConstUtils.mobileEditingController!.isEmpty ||
                        ConstUtils.mobileEditingController!.length < 10) {
                      showSnackBar(
                        message: VariableUtils.mobileNumberRequired,
                        snackColor: ColorUtils.red,
                      );
                    } else {
                      FocusScope.of(context).unfocus();
                      registerReqModel.verificationId =
                          ConstUtils.mobileEditingController;
                      registerReqModel.countryCode =
                          VariableUtils.countryCodeNumber;

                      if (PreferenceManagerUtils.getDeepLinkReferral()
                          .isEmpty) {
                        await authViewModel.registerViewModel(
                            registerReqModel.toMobileNumberJson());
                      } else {
                        registerReqModel.referral =
                            PreferenceManagerUtils.getDeepLinkReferral();
                        await authViewModel.registerViewModel(
                            registerReqModel.toWithMobileNumberReferralJson());
                      }
                      if (authViewModel.registerApiResponse.status ==
                          Status.COMPLETE) {
                        RegisterResModel response =
                            authViewModel.registerApiResponse.data;
                        if (response.status == 200) {
                          showSnackBar(
                            message: response.message,
                            snackColor: ColorUtils.greenE8,
                          );

                          Future.delayed(
                            const Duration(seconds: 1),
                            () {
                              authViewModel.pageController.nextPage(
                                duration: const Duration(microseconds: 1200),
                                curve: Curves.bounceInOut,
                              );
                              // emailEditingController.clear();
                            },
                          );
                        } else {
                          showSnackBar(
                            message: response.message,
                            snackColor: ColorUtils.red,
                          );
                        }
                      }
                    }
                  }

                  ///FOR EMAIL VERIFICATION.......

                  else if (authViewModel.getSignInSelected == false) {
                    if (ConstUtils.emailEditingController!.isEmpty ||
                        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(ConstUtils.emailEditingController!)) {
                      showSnackBar(
                        message: VariableUtils.emailFormat,
                        snackColor: ColorUtils.red,
                      );
                    } else {
                      FocusScope.of(context).unfocus();
                      registerReqModel.verificationId =
                          ConstUtils.emailEditingController;
                      registerReqModel.countryCode = isoCountryCode;
                      if (PreferenceManagerUtils.getDeepLinkReferral()
                          .isEmpty) {
                        if (isoCountryCode!.isEmpty || isoCountryCode == null) {
                          await authViewModel.registerViewModel(
                              registerReqModel.toEmailRequestOnlyJson());
                        } else {
                          await authViewModel.registerViewModel(
                              registerReqModel.toEmailRequestJson());
                        }
                      } else {
                        registerReqModel.referral =
                            PreferenceManagerUtils.getDeepLinkReferral();
                        registerReqModel.countryCode = isoCountryCode;
                        if (isoCountryCode!.isEmpty || isoCountryCode == null) {
                          await authViewModel.registerViewModel(
                              registerReqModel.toWithEmailReferralOnlyJson());
                        } else {
                          await authViewModel.registerViewModel(
                              registerReqModel.toWithEmailReferralJson());
                        }
                      }
                      if (authViewModel.registerApiResponse.status ==
                          Status.COMPLETE) {
                        RegisterResModel response =
                            authViewModel.registerApiResponse.data;
                        if (response.status == 200) {
                          await PreferenceManagerUtils.setUserCountryCode(
                              isoCountryCode!);
                          showSnackBar(
                            message: response.message,
                            snackColor: ColorUtils.primaryColor,
                          );
                        } else {
                          showSnackBar(
                            message: response.message,
                            snackColor: ColorUtils.red,
                          );
                        }
                      }
                    }
                  }
                },
                child: Text(
                  VariableUtils.resentOtp,
                  style: FontTextStyle.poppinsOrangeF87A10Regular.copyWith(
                      fontSize: 11.sp,
                      color: ColorUtils.red1D,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),

          SizeConfig.sH1,
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Material(
              color: ColorUtils.blue14,
              child: InkWell(
                onTap: () async {
                  if (ConstUtils.otpController.isNotEmpty &&
                      ConstUtils.otpController.length <= 3) {
                    showSnackBar(
                      message: VariableUtils.invalidOtp,
                      snackColor: ColorUtils.red,
                    );
                  } else {
                    otpVerificationReqModel.verificationId =
                        authViewModel.getSignInSelected == true
                            ? ConstUtils.mobileEditingController
                            : ConstUtils.emailEditingController;
                    otpVerificationReqModel.otp = ConstUtils.otpController;
                    await authViewModel
                        .otpVerificationViewModel(otpVerificationReqModel);
                    if (authViewModel.otpVerificationApiResponse.status ==
                        Status.COMPLETE) {
                      OtpVerificationResModel response =
                          authViewModel.otpVerificationApiResponse.data;
                      if (response.status == 200) {
                        await PreferenceManagerUtils.setLoginToken(
                            response.data!.token!);
                        await PreferenceManagerUtils.setLoginId(
                            response.data!.user!.id!);
                        await PreferenceManagerUtils.setUserMobileNumber(
                            ConstUtils.mobileEditingController);
                        await PreferenceManagerUtils.setFlagUrl(
                            response.data!.user!.flagUrl!);
                        await PreferenceManagerUtils.setCountryName(
                            response.data!.user!.countryName!);
                        await PreferenceManagerUtils.setQrCodeUrl(
                            response.data!.user!.url);
                        await PreferenceManagerUtils.setReferralCode(
                            response.data!.user!.referral);
                        await PreferenceManagerUtils.setQrCodeUrlDeepLink(
                            response.data!.qrLink);
                        await PreferenceManagerUtils.setReferralCodeDeepLink(
                            response.data!.referralLink);
                        if (ConstUtils.isNewUser == false) {
                          await PreferenceManagerUtils.setUserAvatar(
                              response.data!.user!.avatar ?? "");
                          addressBookViewModel.setUserAvatar =
                              response.data!.user!.avatar;
                          await PreferenceManagerUtils.setAvatarUserName(
                              response.data!.user!.username!);
                          await PreferenceManagerUtils.setAvatarUserFullName(
                              response.data!.user!.fullName!);
                        }
                        showSnackBar(
                            message: response.message,
                            snackColor: ColorUtils.greenE8);
                        FocusScope.of(context).unfocus();
                        if (response.data!.user!.avatar == null ||
                            response.data!.user!.avatar!.isEmpty ||
                            ConstUtils.isNewUser == true ||
                            response.data!.user!.username!.isEmpty) {
                          isSuggest!.isEmpty || ConstUtils.isNewUser == true
                              ? Get.offAll(const SuggestionScreen())
                              : Get.offAll(const UserRegisterScreen());
                        } else {
                          fcmReqModel.fcm =
                              PreferenceManagerUtils.getFcmToken();
                          await authViewModel.fcmViewModel(fcmReqModel);

                          isSuggest!.isEmpty
                              ? Get.offAll(const SuggestionScreen())
                              : Get.offAll(const HomeScreen());
                          // Get.offAll(const HomeScreen());
                        }
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
                  // width: 80.w,
                  decoration: DecorationUtils.allBorderAndColorDecorationBox(
                    // colors: ColorUtils.blue14,
                    radius: 7,
                  ),
                  child: Center(
                    child: Text(
                      VariableUtils.continueOtp.toUpperCase(),
                      style: FontTextStyle.poppinsWhite10bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(
            VariableUtils.oR.toUpperCase(),
            style: FontTextStyle.poppinsBlack12bold,
          ),
          authViewModel.getSignInSelected == true
              ? InkWell(
                  onTap: () async {
                    await checkGps();

                    authViewModel.setSignSelected(false);
                    await PreferenceManagerUtils.setIsLoginVia(
                        VariableUtils.loginViaEmail);
                    authViewModel.pageController.previousPage(
                      duration: const Duration(microseconds: 1200),
                      curve: Curves.bounceInOut,
                    );
                  },
                  child: Text(
                    VariableUtils.signInWithEmail.toUpperCase(),
                    style: FontTextStyle.poppinsBlue14NormalNone,
                  ),
                )
              : InkWell(
                  onTap: () async {
                    /// OTP WIDGET

                    authViewModel.setSignSelected(true);
                    await PreferenceManagerUtils.setIsLoginVia(
                        VariableUtils.loginViaPHNumber);
                    authViewModel.pageController.previousPage(
                      duration: const Duration(microseconds: 1200),
                      curve: Curves.bounceInOut,
                    );
                  },
                  child: Text(
                    VariableUtils.signInWithPhoneNumber.toUpperCase(),
                    style: FontTextStyle.poppinsBlue14NormalNone,
                  ),
                ),
          SizeConfig.sH3,
        ],
      ),
    );
  }
}
