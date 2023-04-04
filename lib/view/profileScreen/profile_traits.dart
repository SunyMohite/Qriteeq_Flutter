import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:sizer/sizer.dart';
import '../../common/commonWidget/snackbar.dart';
import '../../utils/color_utils.dart';
import '../../utils/const_utils.dart';
import '../../utils/decoration_utils.dart';
import '../../utils/font_style_utils.dart';
import '../../utils/shared_preference_utils.dart';
import '../chatScreen/comps/styles.dart';

class ProfileTraits extends StatefulWidget {
  const ProfileTraits({Key? key}) : super(key: key);
  @override
  State<ProfileTraits> createState() => _ProfileTraitsState();
}

class _ProfileTraitsState extends State<ProfileTraits> {
  TextEditingController traitController = TextEditingController();
  var traitName = [];
  var ratings = [];
  var id = [];
  @override
  void initState() {
    // TODO: implement initState
    traitName = [];
    ratings = [];
    id = [];
    getData();
    super.initState();
  }

  Future<void> getData() async {
    traitName = [];
    id = [];
    ratings = [];
    double a;
    FirebaseFirestore.instance
        .collection("profile_traits")
        .doc(PreferenceManagerUtils.getLoginId())
        .collection("data")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        id.add(doc.id);
        traitName.add(doc["trait_name"]);
        // setState(() {});
      });

      for (int i = 0; i < traitName.length; i++) {
        a = 0.0;
        var b="";
        FirebaseFirestore.instance
            .collection("profile_traits_rating")
            .doc(PreferenceManagerUtils.getLoginId())
            .collection(traitName[i])
            .get()
            .then((QuerySnapshot querySnapshot2) {
          querySnapshot2.docs.forEach((doc2) {
            a = doc2["rating"] + a;
            b=doc2["trait_name"].toString();
            setState(() {});
          });
          if(traitName[i]==b){
            ratings.add(a / querySnapshot2.docs.length);
          }
          else{
            ratings.add(0.0);
          }
          // logs("Rating: "+a.toString());
          a = 0.0;
          b="";
          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorUtils.primaryColor,
              centerTitle: false,
            ),
            body: Container(
              margin: EdgeInsets.only(
                  left: 15.0, top: 0.0, right: 15.0, bottom: 0.0),
              child: Column(
                children: [
                  SizeConfig.sH3,
                  TextField(
                    controller: traitController,
                    keyboardType: TextInputType.text,
                    style: FontTextStyle.poppinsBlack10Medium,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                      hintText: "Enter profile trait",
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Material(
                      color: ColorUtils.blue14,
                      child: InkWell(
                        onTap: () async {
                          Map<String, dynamic> data = {
                            'trait_name': traitController.text,
                          };

                          FirebaseFirestore.instance
                              .collection("profile_traits")
                              .doc(PreferenceManagerUtils.getLoginId())
                              .collection("data")
                              .add(data)
                              .then((value) => onSubmit());
                        },
                        child: Container(
                          height: 13.w,
                          decoration:
                              DecorationUtils.allBorderAndColorDecorationBox(
                            radius: 7,
                          ),
                          child: Center(
                            child: Text(
                              "ADD TRAIT",
                              style: FontTextStyle.poppinsWhite10bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizeConfig.sH5,
                  Text(
                    traitName.length > 0
                        ? "Profile Traits List"
                        : "No Profile Traits Found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.all(20),
                    child: SizedBox(
                      height: 300,
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    traitName[index],
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100),
                                  ),
                                  SizeConfig.sW2,
                                  Text(ratings[index].toString().substring(0, 3) +
                                      "⭐",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100),
                                  )
                                ],
                              ),
                              leading: Text(
                                "${index + 1}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w100),
                              ),
                              trailing:
                                  PopupMenuButton(
                                tooltip: '',
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.more_vert_rounded,
                                  color: Colors.black,
                                ),
                                onSelected: (val) async {
                                  FirebaseFirestore.instance
                                      .collection("profile_traits")
                                      .doc(PreferenceManagerUtils.getLoginId())
                                      .collection("data")
                                      .doc(id[index])
                                      .delete()
                                      .then((value) => onDelete(index));
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 0,
                                    child: Row(
                                      children: [
                                        Text(
                                          "Delete",
                                          style:
                                              FontTextStyle.poppinsBlackRegular,
                                        ),
                                        Icon(Icons.delete,
                                            size: 20, color: Colors.red),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                                thickness: 1,
                                color: Colors.black12,
                              ),
                          itemCount: traitName.length),
                    ),
                  )),
                ],
              ),
            )));
  }

  void onSubmit() {
    showSnackBar(
      message: traitController.text + " is added successfully",
      snackColor: ColorUtils.greenE8,
    );
    traitController.clear();
    getData();
  }

  void onDelete(int index) {
    showSnackBar(
      message: traitName[index] + " is delete successfully",
      snackColor: ColorUtils.greenE8,
    );
    getData();
  }
}
