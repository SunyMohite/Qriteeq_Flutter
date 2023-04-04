import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:humanscoring/common/commonWidget/snackbar.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';
import 'package:intl/intl.dart';
import 'package:simple_polls/models/poll_models.dart';
import 'package:simple_polls/widgets/polls_widget.dart';
import 'package:sizer/sizer.dart';
import '../../common/commonWidget/octo_image_widget.dart';
import '../../newwidget/text_and_style.dart';
import '../../utils/assets/icons_utils.dart';
import '../../utils/const_utils.dart';
import '../../utils/decoration_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/size_config_utils.dart';
import '../chatScreen/comps/styles.dart';

class PollScreen extends StatefulWidget {
  const PollScreen({Key? key}) : super(key: key);
  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  String quetion = "", option1 = "", option2 = "", option3 = "", id = "";
  bool isActive = false,
      hasVoted = false,
      pl1 = false,
      pl2 = false,
      pl3 = false;
  int count = 0, p1 = 0, p2 = 0, p3 = 0;
  TextEditingController commentController = TextEditingController();
  var name = [];
  var comment = [];
  var imagepath = [];
  var postedDate = [];
  var likeCount = [];
  var unlikeCount = [];
  @override
  void initState() {
    name = [];
    comment = [];
    imagepath = [];
    postedDate = [];
    likeCount = [];
    unlikeCount = [];
    getData();
    super.initState();
  }

  Future<void> getData() async {

    final firestore = FirebaseFirestore.instance;
    firestore.collection("Users").get().then((querySnapshot) {
      for (int i = 0; i < querySnapshot.size; i++) {
        FirebaseFirestore.instance
            .collection('poll_bank')
            .get()
            .then((QuerySnapshot querySnapshot2) {
          querySnapshot2.docs.forEach((doc) {
            quetion = doc["quetion"].toString();
            option1 = doc["option1"].toString();
            option2 = doc["option2"].toString();
            id = doc["id"].toString();
            option3 = doc["option3"].toString();
            isActive = doc["isActive"];

            setState(() {
              isActive;
            });

            firestore
                .collection('poll_result')
                .doc(doc["id"].toString())
                .collection(querySnapshot.docs[i].id)
                .get()
                .then((QuerySnapshot querySnapshot3) {
              querySnapshot3.docs.forEach((doc2) {
                count++;
                if ((doc2["user_id"].toString() ==
                    PreferenceManagerUtils.getLoginId())) {
                  hasVoted = true;
                  if ((doc2["polloption"].toString() == "1")) {
                    pl1 = true;
                  } else if ((doc2["polloption"].toString() == "2")) {
                    pl2 = true;
                  } else if ((doc2["polloption"].toString() == "3")) {
                    pl3 = true;
                  }
                }

                if ((doc2["polloption"].toString() == "1")) {
                  p1++;
                } else if ((doc2["polloption"].toString() == "2")) {
                  p2++;
                } else if ((doc2["polloption"].toString() == "3")) {
                  p3++;
                }

                setState(() {});
              });
            });

            firestore
                .collection('poll_comment')
                .doc(doc["id"].toString())
                .collection(querySnapshot.docs[i].id)
                .get()
                .then((QuerySnapshot querySnapshot4) {
              querySnapshot4.docs.forEach((doc3) {
                name.add(doc3["user_name"].toString());
                comment.add(doc3["comment"].toString());
                imagepath.add(doc3["user_avatar"].toString());
                postedDate.add(doc3["submitted"].toString());
                likeCount.add(doc3["likeCount"]);
                unlikeCount.add(doc3["unlikeCount"]);
                setState(() {});
              });
            });
          });
        });
      }
    }).catchError((onError) {
      logs("getCloudFirestoreUsers: ERROR");
      logs(onError);
    });
  }

  Future<void> refreshData() async {
    name = [];
    imagepath = [];
    comment = [];
    postedDate = [];
    likeCount = [];
    unlikeCount = [];
    final firestore = FirebaseFirestore.instance;
    firestore.collection("Users").get().then((querySnapshot) {
      for (int i = 0; i < querySnapshot.size; i++) {
        FirebaseFirestore.instance
            .collection('poll_bank')
            .get()
            .then((QuerySnapshot querySnapshot2) {
          querySnapshot2.docs.forEach((doc) {
            firestore
                .collection('poll_comment')
                .doc(doc["id"].toString())
                .collection(querySnapshot.docs[i].id)
                .get()
                .then((QuerySnapshot querySnapshot4) {
              querySnapshot4.docs.forEach((doc3) {
                name.add(doc3["user_name"].toString());
                comment.add(doc3["comment"].toString());
                imagepath.add(doc3["user_avatar"].toString());
                postedDate.add(doc3["submitted"].toString());
                likeCount.add(doc3["likeCount"]);
                unlikeCount.add(doc3["unlikeCount"]);
                setState(() {});
              });
            });
          });
        });
      }
    }).catchError((onError) {
      logs("getCloudFirestoreUsers: ERROR");
      logs(onError);
    });
  }

  final firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryColor,
        centerTitle: false,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            SimplePollsWidget(
              onSelection:
                  (PollFrameModel model, PollOptions selectedOptionModel) {
                print('Now total polls are : ' + model.totalPolls.toString());
                print(
                    'Selected option has label : ' + selectedOptionModel.label);

                Map<String, dynamic> data = {
                  'poll_id': id,
                  'user_id': PreferenceManagerUtils.getLoginId(),
                  'user_name': PreferenceManagerUtils.getAvatarUserFullName(),
                  'quetion': quetion,
                  'answer': selectedOptionModel.label,
                  'submitted': DateTime.now(),
                  'polloption': selectedOptionModel.id
                };

                FirebaseFirestore.instance
                    .collection('poll_result')
                    .doc(id)
                    .collection(PreferenceManagerUtils.getLoginId())
                    .add(data)
                    .then((value) =>
                        showSnackBar(message: "Poll option submitted"));
              },
              onReset: (PollFrameModel model) {
                print(
                    'Poll has been reset, this happens only in case of editable polls');
              },
              optionsBorderShape:
                  StadiumBorder(), //Its Default so its not necessary to write this line
              model: PollFrameModel(
                title: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    quetion,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                totalPolls: count,
                endTime: DateTime.now().toUtc().add(Duration(hours: 12)),
                hasVoted: hasVoted,
                editablePoll: false,
                options: <PollOptions>[
                  PollOptions(
                    label: option1,
                    pollsCount: p1,
                    isSelected: pl1,
                    id: 1,
                  ),
                  PollOptions(
                    label: option2,
                    pollsCount: p2,
                    isSelected: pl2,
                    id: 2,
                  ),
                  PollOptions(
                    label: option3,
                    pollsCount: p3,
                    isSelected: pl3,
                    id: 3,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 15.0, top: 20.0, right: 15.0, bottom: 0.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 13.w,
                      width: 80.w,
                      child: TextField(
                        scrollPadding: EdgeInsets.symmetric(horizontal: 2.w),
                        controller: commentController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 3.w),
                          focusedBorder: DecorationUtils.outLineBorderR20,
                          border: DecorationUtils.outLineBorderR20,
                          enabledBorder: DecorationUtils.outLineBorderR20,
                          disabledBorder: DecorationUtils.outLineBorderR20,
                          hintText: 'Write your Comment..',
                          hintStyle: FontTextStyle.poppins12RegularGray,
                        ),
                      ),
                    ),
                  ),
                  SizeConfig.sW2,
                  InkWell(
                    onTap: () async {
                      String cdate =
                          DateFormat("yyyy-MM-dd").format(DateTime.now());
                      String tdate =
                          DateFormat("hh:mm:ss a").format(DateTime.now());
                      Map<String, dynamic> data = {
                        'poll_id': id,
                        'user_id': PreferenceManagerUtils.getLoginId(),
                        'user_name':
                            PreferenceManagerUtils.getAvatarUserFullName(),
                        'user_avatar': PreferenceManagerUtils.getUserAvatar(),
                        'submitted': tdate + " on " + cdate,
                        'quetion': quetion,
                        'comment': commentController.text,
                        'likeCount': 0,
                        'unlikeCount':0
                      };
                      FirebaseFirestore.instance
                          .collection('poll_comment')
                          .doc(id)
                          .collection(PreferenceManagerUtils.getLoginId())
                          .add(data)
                          .then((value) => showSnackBar(
                              message: "Comment posted successfully"));

                      commentController.clear();
                      refreshData();
                    },
                    child: CircleAvatar(
                      radius: 6.w,
                      backgroundColor: ColorUtils.blue14,
                      child: Center(
                        child: IconsWidgets.send,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizeConfig.sH3,
            Container(
                margin: EdgeInsets.only(
                    left: 20.0, top: 0.0, right: 0.0, bottom: 0.0),
                child: Text(
                  "Comments",
                  style: TextStyle(
                      color: ColorUtils.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold),
                )),
            SizeConfig.sH1,
            Column(
              children: List.generate(name.length, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OctoImageWidget(
                        profileLink: imagepath[index],
                        radius: 5.w,
                      ),
                      SizeConfig.sW3,
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                  color: ColorUtils.lightGreyE9,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizeConfig.sH1,
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              name[index],
                                              style:
                                                  FontTextStyle.poppins11SemiB,
                                            ),
                                          ),
                                        ]),
                                    Row(
                                      children: [
                                        SizedBox(
                                          child: SvgPicture.asset(
                                            earthImg,
                                            height: 5.w,
                                            width: 5.w,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizeConfig.sW2,
                                        textBox(
                                            text: postedDate[index],
                                            fontWeight: FontWeight.w400,
                                            color: ColorUtils.blacklight,
                                            fontSize: 10.sp),
                                      ],
                                    ),
                                    SizeConfig.sH1,
                                    Text(
                                      comment[index],
                                      style: FontTextStyle
                                          .poppinsBlackLightTextFieldRegular,
                                    ),
                                    SizeConfig.sH1,
                                    Row(
                                      children: [
                                        InkResponse(
                                          radius: 40,
                                          onTap: () async {},
                                          child: interactionWidgetSvg(
                                              svg: SvgPicture.asset(
                                                likeImg,
                                              ),
                                              value: likeCount[index]),
                                        ),
                                        SizeConfig.sW5,
                                        ///dislike
                                        InkResponse(
                                            radius: 40,
                                            onTap: () async {},
                                            child: interactionWidgetSvg(
                                                svg: SvgPicture.asset(
                                                  dislikeImg,
                                                ),
                                                value: unlikeCount[index])),
                                      ],
                                    ),
                                    SizeConfig.sH1,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Row interactionWidgetSvg({String? iconPath, int? value, SvgPicture? svg}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        svg!,
        const SizedBox(
          width: 5,
        ),
        value == null
            ? const SizedBox()
            : Text(
                value.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColorUtils.grey,
                    fontSize: 10.sp),
              ),
      ],
    );
  }
}
