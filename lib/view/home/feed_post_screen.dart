import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../common/circular_progress_indicator.dart';
import '../../common/commonWidget/custom_button.dart';
import '../../common/commonWidget/custom_dialog.dart';
import '../../common/commonWidget/snackbar.dart';
import '../../common/my_clip_path.dart';
import '../../modal/apiModel/req_model/dash_boared_req_model.dart';
import '../../modal/apiModel/res_model/dash_boared_res_model.dart';
import '../../modal/apiModel/res_model/image_upload_res_model.dart';
import '../../modal/apis/api_response.dart';
import '../../service/video_player.dart';
import '../../utils/assets/icons_utils.dart';
import '../../utils/assets/images_utils.dart';
import '../../utils/assets/lotti_animation_json.dart';
import '../../utils/color_utils.dart';
import '../../utils/const_utils.dart';
import '../../utils/enum_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/shared_preference_utils.dart';
import '../../utils/variable_utils.dart';
import '../../viewmodel/dashboard_viewmodel.dart';
import '../../viewmodel/fileupload_viewmodel.dart';
import '../../viewmodel/notification_viewmodel.dart';
import 'home_screen.dart';

class FeedPostScreen extends StatefulWidget {
  const FeedPostScreen(
      {Key? key,
      this.id,
      this.mobile,
      this.userName,
      this.connect = true,
      this.email,
      this.campaignId,
      this.profileUrl})
      : super(key: key);

  final String? id;
  final String? mobile;
  final String? userName;
  final String? campaignId;
  final String? email;
  final String? profileUrl;
  final bool? connect;

  @override
  State<FeedPostScreen> createState() => _FeedPostScreenState();
}

class _FeedPostScreenState extends State<FeedPostScreen> {
  String? selectType = "Type Of Feedback",
      reviewKey = "",
      selectMediaType = '',
      url,
      ext;
  int? _key, selector = 0;
  AppState? state;
  TextEditingController feedbackController = TextEditingController();
  DashBoardReqModel dashBoardReqModel = DashBoardReqModel();
  DashBoardViewModel dashBoardViewModel = Get.find();
  File? file, uploadFile;
  bool anonymous = false;
  @override
  void initState() {
    // TODO: implement initState
    dashBoardViewModel.initAnonymous = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.only(
                left: 2.w,
              ),
              child: SizedBox(
                width: Get.width,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                        )),
                    Text(
                      VariableUtils.you,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                    PreferenceManagerUtils.getLoginId() == widget.id
                        ? SizedBox(
                            width: Get.width / 1.8,
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizeConfig.sW1,
                              IconsWidgets.arrowIcon,
                              SizeConfig.sW1,
                              SizedBox(
                                width: Get.width / 2,
                                child: Text(
                                  widget.userName!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                      overflow: TextOverflow.ellipsis),
                                  maxLines: 1,
                                ),
                              ),
                              // SizeConfig.sW5,
                            ],
                          ),
                    InkWell(
                      onTap: () async {
                        if (feedbackController.text.isBlank!) {
                          showSnackBar(
                              message: "Your feedback input is required....");
                          return;
                        } else if (selectType!.contains("Type Of Feedback")) {
                          showSnackBar(message: "Select type of feedback...");
                          return;
                        } else {
                          if (widget.id ==
                              PreferenceManagerUtils.getLoginId()) {
                            showSnackBar(
                                message: VariableUtils.tryReviewingOthers,
                                snackColor: Colors.red);

                            return;
                          }
                          FocusScope.of(context).unfocus();
                          Get.bottomSheet(feedbackBottomSheet(context),
                              isScrollControlled: true);
                        }
                      },
                      child: Container(
                        width: 60,
                        height: 30,
                        padding: const EdgeInsets.all(5),
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: const BoxDecoration(
                            color: ColorUtils.primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Center(
                          child: Text(
                            VariableUtils.post,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto'),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 7.h),
                          Divider(
                            height: 1.h,
                            color: Colors.black,
                          ),
                          TextFormField(
                            controller: feedbackController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 15,
                            textCapitalization: TextCapitalization.sentences,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(500),
                            ],
                            textInputAction: TextInputAction.newline,
                            style: TextStyle(
                                fontSize: 12.sp,
                                height: 1.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              hintText: VariableUtils.writeYourFeedback +
                                  '\n(minimum 50 character required)',
                              border: InputBorder.none,
                            ),
                          ),

                          ///Upload IMAGE
                          uploadFile == null
                              ? const SizedBox()
                              : selectMediaType == 'gallery' ||
                                      selectMediaType == 'camera'
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 70.w,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.black,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(
                                                uploadFile!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: InkWell(
                                                onTap: () {
                                                  clearFileObj();
                                                  setState(() {});
                                                },
                                                child:
                                                    const Icon(Icons.cancel)),
                                          ),
                                        ],
                                      ),
                                    )
                                  : selectMediaType == 'video'
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: VideoPlayerService(
                                                    // key: UniqueKey(),
                                                    key: ValueKey(
                                                      uploadFile!.path,
                                                    ),
                                                    url: uploadFile!.path,
                                                    isLocal: true),
                                              ),
                                              Positioned(
                                                right: 0,
                                                child: InkWell(
                                                    onTap: () {
                                                      clearFileObj();
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                        Icons.cancel)),
                                              ),
                                            ],
                                          ),
                                        )
                                      : selectMediaType == 'document'
                                          ? Container(
                                              width: Get.width,
                                              // height: 15.w,
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 2.h),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: ColorUtils.grey
                                                    .withOpacity(0.2),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      height: 6.w,
                                                      width: 6.w,
                                                      child: const Icon(Icons
                                                          .assignment_outlined)),
                                                  SizedBox(
                                                    width: 1.w,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      uploadFile!.path
                                                          .split('/')
                                                          .last
                                                          .capitalizeFirst
                                                          .toString(),
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      clearFileObj();
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                        Icons.cancel),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),

                          SizeConfig.sH1,
                        ],
                      ),
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 2.5.h),
                              child: SizedBox(
                                width: 5.w,
                                height: 5.w,
                                child: Image.asset(messageImg),
                              ),
                            ),
                            Expanded(
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  key: Key(_key.toString()),
                                  onExpansionChanged: (b) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  title: Text(
                                    selectType!,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Material(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        elevation: 4,
                                        child: Container(
                                          width: 80.w,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 20.h,
                                                  width: 80.w,
                                                  child: ListView.builder(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      itemCount: VariableUtils
                                                          .typeReview.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        var reviewTypeKey =
                                                            VariableUtils
                                                                .typeReview[
                                                                    index]
                                                                    ['key']
                                                                .toString();
                                                        return InkWell(
                                                          onTap: () {
                                                            selectType =
                                                                VariableUtils
                                                                    .typeReview[
                                                                        index]
                                                                        ['key']
                                                                    .toString();
                                                            reviewKey =
                                                                VariableUtils
                                                                    .typeReview[
                                                                        index][
                                                                        'value']
                                                                    .toString();
                                                            _collapse();
                                                            setState(() {});
                                                          },
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                reviewTypeKey,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 5.h,
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        _cameraShowPicker(context);
                      },
                      child: SizedBox(
                        width: 8.w,
                        height: 8.w,
                        child: Image.asset(
                          purpleCamera,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizeConfig.sW8,
                    InkWell(
                      onTap: () {
                        _galleryShowPicker(context);
                      },
                      child: SizedBox(
                        width: 8.w,
                        height: 8.w,
                        child: Image.asset(
                          gallaryImg,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizeConfig.sW8,
                    InkWell(
                      onTap: () {
                        clearFileObj();
                        VariableUtils.isMediaPost = "true";
                        selectMediaType = "document";
                        pickFile(type: FileType.custom, extensionsList: [
                          'pdf',
                          'doc',
                          'docx',
                          'xls',
                          'xlsx',
                          'ppt'
                        ]);
                      },
                      child: SizedBox(
                        width: 8.w,
                        height: 8.w,
                        child: Image.asset(
                          pdfImg,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizeConfig.sW8,
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _collapse() {
    int? newKey;
    do {
      _key = math.Random().nextInt(10000);
    } while (newKey == _key);
  }

  void clearFileObj() {
    uploadFile = null;
    VariableUtils.isMediaPost = "";
  }

  Future pickFile(
      {required FileType type, List<String>? extensionsList}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: type, allowCompression: true, allowedExtensions: extensionsList);
    if (result != null) {
      setState(() {
        uploadFile = File(result.files.single.path!);
      });
    }
    return uploadFile;
  }

  ///================IMAGE UPLOAD====================

  /// get Image from camera

  Future imageFromCamera() async {
    try {
      ImagePicker pickImage = ImagePicker();
      final result = await pickImage.pickImage(
        source: ImageSource.camera,
      );

      if (result != null) {
        // uploadFile = File(result.path);
        setState(() {});
        uploadFile = await _cropImage(File(result.path));
        state = AppState.picked;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('error $e');
      }
    }

    return uploadFile;
  }

  /// get Image from gallery

  Future imgFromGallery() async {
    try {
      ImagePicker picker = ImagePicker();
      final result = await picker.pickImage(source: ImageSource.gallery);

      if (result != null) {
        setState(() {});
        uploadFile = await _cropImage(File(result.path));
        state = AppState.picked;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('error $e');
      }
    }
    return uploadFile;
  }

  /// get Video from gallery

  Future _getVideoFromGallery() async {
    try {
      ImagePicker picker = ImagePicker();
      final result = await picker.pickVideo(
        source: ImageSource.gallery,
      );

      if (result != null) {
        final size = await getFileSize(File(result.path));
        if (size > 150) {
          snackBarValidation();
          // showSnackBar(message: 'You select maximum 150mb video size',);
          return;
        }
        uploadFile = File(result.path);

        state = AppState.picked;
        setState(() {});
      }
    } on Exception catch (e) {
      snackBarValidation();

      if (kDebugMode) {
        print('error $e');
      }
    }
  }

  void snackBarValidation() {
    Get.showSnackbar(
      const GetSnackBar(
        message: VariableUtils.videoSizeValidationMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorUtils.primaryColor,
        duration: Duration(seconds: 5),
      ),
    );
  }

  Future<double> getFileSize(
    File filepath,
  ) async {
    try {
      final bytes = filepath.lengthSync();

      final kb = bytes / 1024;

      final mb = kb / 1024;
      // print('MAX VIDEO************ SIZE :$mb');

      return mb;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('MAX VIDEO SIZE :$e');
      }
      return 500.0;
    }
  }

  Future _cropImage(File? pickFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickFile!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 50,
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
      getFileSize(croppedFile);
      setState(() {
        state = AppState.cropped;
      });
    }
    return croppedFile!;
  }

  /// _cameraShowPicker

  void _cameraShowPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: SizedBox(
                    height: 6.w,
                    width: 6.w,
                    child: Image.asset(
                      purpleCamera,
                      fit: BoxFit.fill,
                    ),
                  ),
                  title: Text(VariableUtils.cameraPhoto),
                  onTap: () {
                    clearFileObj();
                    VariableUtils.isMediaPost = "true";
                    selectMediaType = "camera";
                    imageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                    leading: SizedBox(
                      height: 6.w,
                      width: 6.w,
                      child: Image.asset(
                        viedocallImg,
                        color: Colors.red,
                      ),
                    ),
                    title: Text(VariableUtils.cameraVideo),
                    onTap: () async {
                      clearFileObj();
                      VariableUtils.isMediaPost = "true";
                      selectMediaType = "video";
                      final ImagePicker _picker = ImagePicker();

                      final XFile? file = await _picker.pickVideo(
                          source: ImageSource.camera,
                          maxDuration: const Duration(seconds: 30));

                      setState(() {
                        uploadFile = File(file!.path);
                      });
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          );
        });
  }

  /// _gallaryShowPicker

  void _galleryShowPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: SizedBox(
                    height: 6.w,
                    width: 6.w,
                    child: Image.asset(
                      gallaryImg,
                      fit: BoxFit.fill,
                    ),
                  ),
                  title: Text(VariableUtils.galleryPhoto),
                  onTap: () {
                    clearFileObj();
                    VariableUtils.isMediaPost = "true";
                    selectMediaType = "gallery";

                    imgFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                    leading: SizedBox(
                      height: 6.w,
                      width: 6.w,
                      child: Image.asset(
                        viedocallImg,
                        color: Colors.red,
                      ),
                    ),
                    title: Text(VariableUtils.galleryVideo),
                    onTap: () {
                      clearFileObj();
                      VariableUtils.isMediaPost = "true";
                      selectMediaType = "video";

                      _getVideoFromGallery();
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          );
        });
  }

  /// =================FEEDBACK BOTTOM SHEET================

  Widget feedbackBottomSheet(BuildContext context) {
    dashBoardReqModel.relation =
        VariableUtils.relationShip[0]['value'].toString();

    return StatefulBuilder(
      builder: (context, setState) {
        return GetBuilder<DashBoardViewModel>(
          builder: (dashBoardViewModel) {
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(
                        18.0,
                      )),
                      child: Container(
                        color: ColorUtils.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipPath(
                                  clipper: MyClipPath(),
                                  child: Container(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      color: ColorUtils.lightCyan,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 2.h, right: 2.8.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: IconsWidgets.close),
                                              ],
                                            ),
                                          ),
                                          ImagesWidgets.undrawMailSent
                                        ],
                                      )),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Text(
                                    VariableUtils.thankYou,
                                    style:
                                        FontTextStyle.poppins14semiB.copyWith(
                                      color: ColorUtils.darkBlue,
                                      fontSize: 15.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                            SizeConfig.sH2,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Center(
                                child: Text(
                                  VariableUtils.feedbackSuccessText,
                                  textAlign: TextAlign.center,
                                  style: FontTextStyle
                                      .poppins14RegularBlackLightColor
                                      .copyWith(color: ColorUtils.lightGrey83),
                                ),
                              ),
                            ),
                            SizeConfig.sH3,
                            Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: Text(
                                VariableUtils.howWellknow,
                                style: FontTextStyle.poppins14SemiBDarkBlack,
                              ),
                            ),
                            SizeConfig.sH2,

                            ///RELATIONSHIP SELECTION LIST
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(right: 2.w),
                                child: Row(
                                  children: List.generate(
                                    VariableUtils.relationShip.length,
                                    (index) {
                                      var relationKey = VariableUtils
                                          .relationShip[index]['key']
                                          .toString();

                                      var relationValue = VariableUtils
                                          .relationShip[index]['value']
                                          .toString();

                                      return Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            dashBoardViewModel
                                                .relationSelector = index;

                                            setState(() {});

                                            dashBoardReqModel.relation =
                                                relationValue;
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              left: 5.w,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 2.w),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: dashBoardViewModel
                                                          .relationSelector ==
                                                      index
                                                  ? const Color(0xFFEAF7FF)
                                                  : const Color(0xFFF1F1F1),
                                              border: Border.all(
                                                color: dashBoardViewModel
                                                            .relationSelector ==
                                                        index
                                                    ? const Color(0xFF1484CD)
                                                    : const Color(0xFFCFCFCF),
                                              ),
                                            ),
                                            child: Text(
                                              relationKey,
                                              style: FontTextStyle
                                                  .poppins10NormalDarkBlack
                                                  .copyWith(
                                                      color: dashBoardViewModel
                                                                  .relationSelector ==
                                                              index
                                                          ? const Color(
                                                              0xFF1484CD)
                                                          : ColorUtils
                                                              .darkBlue),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizeConfig.sH2,
                            Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: Text(
                                VariableUtils.scoreYouGive,
                                style: FontTextStyle.poppins14SemiBDarkBlack,
                              ),
                            ),
                            SizeConfig.sH2,

                            ///USER EMOJI SELECTION LIST
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                ConstUtils.emojiIcon.length,
                                (index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selector = index;
                                      });
                                    },
                                    child: Opacity(
                                      opacity: selector == index ? 1 : 0.3,
                                      child: Image.asset(
                                        '${ConstUtils.emojiIcon[index].icon}',
                                        height: 4.h,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizeConfig.sH1,
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                ConstUtils.emojiIcon[selector!].title!,
                                style: FontTextStyle.poppins12Orange,
                              ),
                            ),
                            SizeConfig.sH3,
                            Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: Text(
                                VariableUtils.postAsAnonymous,
                                style: FontTextStyle.poppins14SemiBDarkBlack,
                              ),
                            ),
                            SizeConfig.sH1,
                            Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: Row(
                                children: [
                                  FlutterSwitch(
                                    showOnOff: true,
                                    width: 55.0,
                                    height: 25.0,
                                    valueFontSize: 12.0,
                                    toggleSize: 18.0,
                                    activeTextColor: ColorUtils.white,
                                    inactiveTextColor: Colors.white,
                                    activeText: "Yes",
                                    inactiveText: "No",
                                    activeColor: ColorUtils.blue14,
                                    activeTextFontWeight: FontWeight.normal,
                                    inactiveTextFontWeight: FontWeight.normal,
                                    value: dashBoardViewModel.anonymous,
                                    onToggle: (val) {
                                      dashBoardViewModel.anonymous = val;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizeConfig.sH3,
                            GetBuilder<FileUploadViewModel>(
                              builder: (fileUploadViewModel) {
                                return Center(
                                  child: CustomButtons(
                                    buttonName: VariableUtils.submit,
                                    onTap: () async {
                                      NotificationViewModel
                                          notificationController = Get.find();

                                      if (VariableUtils.isMediaPost == "") {
                                        await postUpload(dashBoardViewModel,
                                            notificationController);
                                      } else if (VariableUtils.isMediaPost ==
                                              "true" &&
                                          uploadFile != null) {
                                        await fileUploadViewModel.uploadProfile(
                                            query: uploadFile!);

                                        if (fileUploadViewModel
                                                .uploadProfileApiResponse
                                                .status ==
                                            Status.COMPLETE) {
                                          ImageUploadResModel response =
                                              fileUploadViewModel
                                                  .uploadProfileApiResponse
                                                  .data;
                                          if (response.status == 200) {
                                            VariableUtils.isMediaPost = "true";

                                            url = response.data;
                                            ext = response.ext;
                                            await postUpload(dashBoardViewModel,
                                                notificationController);
                                          }
                                        } else {
                                          showSnackBar(
                                              message:
                                                  'Media file is not upload');
                                          return;
                                        }
                                      } else {
                                        await postUpload(dashBoardViewModel,
                                            notificationController);
                                      }
                                      VariableUtils.isMediaPost = '';
                                    },
                                  ),
                                );
                              },
                            ),
                            SizeConfig.sH2,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                GetBuilder<FileUploadViewModel>(
                  builder: (fileUploadViewModel) {
                    return (fileUploadViewModel
                                    .uploadProfileApiResponse.status ==
                                Status.LOADING ||
                            dashBoardViewModel.dashBoardApiResponse.status ==
                                Status.LOADING)
                        ? const CircularIndicator()
                        : const SizedBox();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> postUpload(DashBoardViewModel dashBoardViewModel,
      NotificationViewModel notificationController) async {
    logs(
        "PreferenceManagerUtils.getLoginId() ${PreferenceManagerUtils.getLoginId()}");
    if (widget.id!.isNotEmpty) {
      dashBoardReqModel.user = widget.id;
      dashBoardReqModel.sender = PreferenceManagerUtils.getLoginId();
      dashBoardReqModel.fullName = widget.userName;
      dashBoardReqModel.score =
          ConstUtils.emojiIcon[selector!].title!.toLowerCase();
      dashBoardReqModel.reviewType = reviewKey;
      dashBoardReqModel.text = feedbackController.text.trimLeft();
      dashBoardReqModel.document = [DashBoardDocument(ext: ext, url: url)];
      dashBoardReqModel.shared = VariableUtils.qriteeq;
      dashBoardReqModel.anonymous = dashBoardViewModel.anonymous;
      if (widget.campaignId != null && widget.campaignId!.isNotEmpty) {
        dashBoardReqModel.campaignId = widget.campaignId!;
        await dashBoardViewModel.dashBoardViewModel(
            dashBoardReqModel.toJsonDoesExistWithCampaignId());
      } else {
        await dashBoardViewModel
            .dashBoardViewModel(dashBoardReqModel.toJsonDoesExist());
      }
      if (dashBoardViewModel.dashBoardApiResponse.status == Status.COMPLETE) {
        DashBoardResModel response =
            dashBoardViewModel.dashBoardApiResponse.data;
        dashBoardViewModel.relationSelector = 0;
        if (response.status == 200) {
          Get.back();
          showDialog(message: response.data!.transaction!.message);

          dashBoardViewModel.selectedReview = "";
          await Future.delayed(const Duration(seconds: 2));
          notificationController.indexChange = 0;
          dashBoardViewModel.relationSelector = 0;
          dashBoardReqModel.relation =
              VariableUtils.relationShip[0]['value'].toString();
          selector = 0;
          Get.offAll(() => const HomeScreen());
        } else {
          showSnackBar(message: response.message ?? 'Something went to wrong');
        }
      }
    } else if (widget.mobile!.isNotEmpty) {
      var mobileNo = widget.mobile!
          .toString()
          .replaceAll(' ', '')
          .replaceAll('-', '')
          .replaceAll('(', '')
          .replaceAll(')', '');
      if (mobileNo[0] != '+') {
        mobileNo =
            "${PreferenceManagerUtils.getUserCountryCodeNumber()}$mobileNo";
      }
      dashBoardReqModel.url = mobileNo;
      dashBoardReqModel.fullName = widget.userName;
      dashBoardReqModel.sender = PreferenceManagerUtils.getLoginId();
      dashBoardReqModel.score =
          ConstUtils.emojiIcon[selector!].title!.toLowerCase();
      dashBoardReqModel.reviewType = reviewKey;

      dashBoardReqModel.text = feedbackController.text.trimLeft();
      dashBoardReqModel.document = [DashBoardDocument(ext: ext, url: url)];
      dashBoardReqModel.shared = VariableUtils.qriteeq;
      dashBoardReqModel.anonymous = dashBoardViewModel.anonymous;

      await dashBoardViewModel
          .dashBoardViewModel(dashBoardReqModel.toJsonUserDoesNotExist());
      if (dashBoardViewModel.dashBoardApiResponse.status == Status.COMPLETE) {
        DashBoardResModel response =
            dashBoardViewModel.dashBoardApiResponse.data;
        dashBoardViewModel.relationSelector = 0;
        if (response.status == 200) {
          Get.back();
          showDialog(message: response.data!.transaction!.message!);
          dashBoardViewModel.selectedReview = "";
          await Future.delayed(const Duration(seconds: 2));
          notificationController.indexChange = 0;
          dashBoardViewModel.relationSelector = 0;
          dashBoardReqModel.relation =
              VariableUtils.relationShip[0]['value'].toString();
          selector = 0;
          Get.offAll(() => const HomeScreen());
        } else {
          showSnackBar(message: response.message);
        }
      }
    } else if (widget.email!.isNotEmpty) {
      dashBoardReqModel.email = widget.email;
      dashBoardReqModel.sender = PreferenceManagerUtils.getLoginId();
      dashBoardReqModel.fullName = widget.userName;

      dashBoardReqModel.score =
          ConstUtils.emojiIcon[selector!].title!.toLowerCase();
      dashBoardReqModel.reviewType = reviewKey;
      dashBoardReqModel.text = feedbackController.text.trimLeft();
      dashBoardReqModel.document = [DashBoardDocument(ext: ext, url: url)];
      dashBoardReqModel.shared = VariableUtils.qriteeq;
      dashBoardReqModel.anonymous = dashBoardViewModel.anonymous;

      await dashBoardViewModel
          .dashBoardViewModel(dashBoardReqModel.toJsonEmailExist());
      if (dashBoardViewModel.dashBoardApiResponse.status == Status.COMPLETE) {
        DashBoardResModel response =
            dashBoardViewModel.dashBoardApiResponse.data;
        dashBoardViewModel.relationSelector = 0;
        if (response.status == 200) {
          Get.back();
          showDialog(message: response.data!.transaction!.message);

          dashBoardViewModel.selectedReview = "";
          await Future.delayed(const Duration(seconds: 2));
          notificationController.indexChange = 0;
          dashBoardViewModel.relationSelector = 0;
          dashBoardReqModel.relation =
              VariableUtils.relationShip[0]['value'].toString();
          selector = 0;
          Get.offAll(() => const HomeScreen());
        } else {
          showSnackBar(message: response.message);
        }
      }
    } else if (widget.profileUrl!.isNotEmpty) {
      dashBoardReqModel.profileUrl = widget.profileUrl;
      dashBoardReqModel.sender = PreferenceManagerUtils.getLoginId();
      dashBoardReqModel.fullName = widget.userName;
      dashBoardReqModel.score =
          ConstUtils.emojiIcon[selector!].title!.toLowerCase();
      dashBoardReqModel.reviewType = reviewKey;
      dashBoardReqModel.text = feedbackController.text.trimLeft();
      dashBoardReqModel.document = [DashBoardDocument(ext: ext, url: url)];
      dashBoardReqModel.shared = VariableUtils.qriteeq;
      dashBoardReqModel.anonymous = dashBoardViewModel.anonymous;
      await dashBoardViewModel
          .dashBoardViewModel(dashBoardReqModel.toJsonProfileUrlExist());
      if (dashBoardViewModel.dashBoardApiResponse.status == Status.COMPLETE) {
        DashBoardResModel response =
            dashBoardViewModel.dashBoardApiResponse.data;
        dashBoardViewModel.relationSelector = 0;
        if (response.status == 200) {
          Get.back();
          showDialog(message: response.data!.transaction!.message);

          dashBoardViewModel.selectedReview = "";
          await Future.delayed(const Duration(seconds: 2));
          notificationController.indexChange = 0;
          dashBoardViewModel.relationSelector = 0;
          dashBoardReqModel.relation =
              VariableUtils.relationShip[0]['value'].toString();
          selector = 0;
          Get.offAll(() => const HomeScreen());
        } else {
          showSnackBar(message: response.message);
        }
      }
    } else {
      showSnackBar(message: 'Something went to wrong', snackColor: Colors.red);
      return;
    }
  }

  void showDialog({required String? message}) {
    openDialog(
        animation: successfulPaperPlaneAnimation,
        title: VariableUtils.sendFeedBackMsg,
        message: '$message');
  }
}
