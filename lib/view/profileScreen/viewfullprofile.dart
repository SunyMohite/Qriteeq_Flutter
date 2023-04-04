import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:humanscoring/common/commonWidget/snackbar.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/font_style_utils.dart';
import 'package:humanscoring/utils/size_config_utils.dart';
import 'package:sizer/sizer.dart';
import '../../../common/commonWidget/custom_header.dart';
import '../../common/commonWidget/octo_image_widget.dart';
import '../../utils/const_utils.dart';
import '../../utils/decoration_utils.dart';
import '../../utils/shared_preference_utils.dart';

class ViewFullProfile extends StatefulWidget {
  final String id;
  final String name;
  final String imageurl;
  const ViewFullProfile(
      {Key? key, required this.id, required this.name, required this.imageurl})
      : super(key: key);

  @override
  State<ViewFullProfile> createState() => _ViewFullProfileState();
}

class _ViewFullProfileState extends State<ViewFullProfile> {
  String username = "",
      age = "",
      profession = "",
      city = "",
      school = "",
      college = "";
  var rating = [];
  var rating2 = [];
  var rating3 = [];
  var imagepath = [];
  double average = 0;
  var traitName = [];
  var traitName2 = [];
  @override
  void initState() {
    getData();
    rating = [];
    rating2 = [];
    rating3 = [];
    imagepath = [];
    traitName = [];
    traitName2 = [];
    average = 0;
    _fetchData();
    accessProfile();
    super.initState();
  }

  void accessProfile() {
    final firestore = FirebaseFirestore.instance;
    firestore
        .collection("ProfileDetails")
        .doc(widget.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        username = documentSnapshot['username'].toString();
        age = documentSnapshot['age'].toString();
        profession = documentSnapshot['profession'].toString();
        city = documentSnapshot['city'].toString();
        school = documentSnapshot['school_name'].toString();
        college = documentSnapshot['college_name'].toString();
        setState(() {});
      }
    });
  }

  Future<void> _fetchData() async {
    final firestore = FirebaseFirestore.instance;
    // Get all the documents under Ratings Collection
    firestore.collection("Users").get().then((querySnapshot) {
      for (int i = 0; i < querySnapshot.size; i++) {
        firestore
            .collection("Ratings")
            .doc(widget.id)
            .collection(querySnapshot.docs[i].id)
            .doc("data")
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            rating.add(documentSnapshot['rating'].toString());
            average =
                double.parse(documentSnapshot['rating'].toString()) + average;
            setState(() {});
          }
        });
      }
    }).catchError((onError) {
      logs("getCloudFirestoreUsers: ERROR");
      logs(onError);
    });
  }

  Future<void> getData() async {
    traitName = [];
    rating2 = [];
    rating3 = [];
    traitName2 = [];
    double a;
    FirebaseFirestore.instance
        .collection("profile_traits")
        .doc(widget.id)
        .collection("data")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        traitName.add(doc["trait_name"]);
      });
      for (int i = 0; i < traitName.length; i++) {
        a = 0.0;
        var b="";
        FirebaseFirestore.instance
            .collection("profile_traits_rating")
            .doc(widget.id)
            .collection(traitName[i])
            .get()
            .then((QuerySnapshot querySnapshot2) {
          querySnapshot2.docs.forEach((doc2) {
            a = doc2["rating"] + a;
            b=doc2["trait_name"].toString();
            if (doc2["rated_by"] == PreferenceManagerUtils.getLoginId()) {
              // rating2.add(doc2["rating"]);
              if(traitName[i]==doc2["trait_name"]){
                rating2.add(doc2["rating"]);
                traitName2.add(doc2["trait_name"]);
              }
              else{
                rating2.add(0.0);
              }
            }
          });
          if(traitName[i]==b){
            rating3.add(a / querySnapshot2.docs.length);
          }
          else{
            rating3.add(0.0);
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
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            backgroundColor: ColorUtils.primaryColor,
            centerTitle: false,
          ),
          body: ListView(
            children: [
              Container(
                child: Center(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Container(
                            width: 90.w,
                            decoration: BoxDecoration(
                                color: ColorUtils.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: ColorUtils.gray,
                                    blurRadius: 15,
                                    offset: Offset(1, 3),
                                  )
                                ]),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 7.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizeConfig.sH6,
                                      Text(
                                        widget.name,
                                        style: FontTextStyle.poppinsBlue14SemiB
                                            .copyWith(
                                                fontSize: 14.sp,
                                                color: ColorUtils.black),
                                      ),
                                      SizeConfig.sH1,
                                      Text(
                                        username,
                                        style: FontTextStyle.poppinsBlue14SemiB
                                            .copyWith(
                                                fontSize: 10.sp,
                                                color: ColorUtils.primaryColor),
                                      ),
                                      SizeConfig.sH1,
                                      RatingBar.builder(
                                        initialRating: rating.length > 0
                                            ? average / rating.length
                                            : 0,
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        ignoreGestures: true,
                                        tapOnlyMode: true,
                                        itemSize: 20,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (double value) {},
                                      ),
                                      SizeConfig.sH3,
                                    ],
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.hail,
                                            size: 25.0,
                                          ),
                                          Text(
                                            "    Age ",
                                          ),
                                          Text(
                                            age.length > 0
                                                ? age
                                                : "not mentioned",
                                            maxLines: 1,
                                            style: FontTextStyle
                                                .poppinsBlue14SemiB
                                                .copyWith(
                                                    fontSize: 10.sp,
                                                    color: ColorUtils.black),
                                          ),
                                        ],
                                      ),
                                    ))),
                                SizeConfig.sH2,
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.home,
                                            size: 25.0,
                                          ),
                                          Text(
                                            "    Lives in ",
                                          ),
                                          Text(
                                            city.length > 0
                                                ? city
                                                : "not mentioned",
                                            maxLines: 1,
                                            style: FontTextStyle
                                                .poppinsBlue14SemiB
                                                .copyWith(
                                                    fontSize: 10.sp,
                                                    color: ColorUtils.black),
                                          ),
                                        ],
                                      ),
                                    ))),
                                SizeConfig.sH2,
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.auto_stories,
                                            size: 25.0,
                                          ),
                                          Text(
                                            "    Went to school ",
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              school.length > 0
                                                  ? school
                                                  : "not mentioned",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: FontTextStyle
                                                  .poppinsBlue14SemiB
                                                  .copyWith(
                                                      fontSize: 10.sp,
                                                      color: ColorUtils.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))),
                                SizeConfig.sH2,
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.apartment,
                                            size: 25.0,
                                          ),
                                          Text(
                                            "    Studies at ",
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              college.length > 0
                                                  ? college
                                                  : "not mentioned",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: FontTextStyle
                                                  .poppinsBlue14SemiB
                                                  .copyWith(
                                                      fontSize: 10.sp,
                                                      color: ColorUtils.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))),
                                SizeConfig.sH2,
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.work,
                                            size: 25.0,
                                          ),
                                          Text(
                                            "    Profession ",
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              profession.length > 0
                                                  ? profession
                                                  : "not mentioned",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: FontTextStyle
                                                  .poppinsBlue14SemiB
                                                  .copyWith(
                                                      fontSize: 10.sp,
                                                      color: ColorUtils.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))),
                                SizeConfig.sH3,
                              ],
                            )),
                      ),
                      Positioned(
                        top: 10,
                        right: 0,
                        left: 0,
                        height: 100,
                        child: OctoImageWidget(
                          profileLink: widget.imageurl,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizeConfig.sH3,
              Container(
                  margin: EdgeInsets.only(
                      left: 20.0, top: 0.0, right: 0.0, bottom: 0.0),
                  child: Text(
                    "Profile Traits",
                    style: TextStyle(
                        color: ColorUtils.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold),
                  )),
              Expanded(
                  child: Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: ColorUtils.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: ColorUtils.gray,
                        blurRadius: 15,
                        offset: Offset(1, 3),
                      )
                    ]),
                child: SizedBox(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                            leading: Text(
                              traitName[index]+"    | "+rating3[index].toString()+"⭐ |",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w100),
                            ),
                            // (rating2.length<index+1 ?(double.parse(rating2[index].toString().substring(0,1))):(0)) :(0),
                            trailing: RatingBar.builder(
                              initialRating: rating2.length > 0
                                  ? (rating2.length >= index + 1
                                      ? (double.parse(rating2[index]
                                          .toString()
                                          .substring(0, 1)))
                                      : (0))
                                  : (0),
                              // initialRating: double.parse(rating2[index].toString().substring(0, 1)),
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemSize: 20,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                if (traitName2.contains(traitName[index])) {
                                  showSnackBar(message:"Already rated");
                                } else {
                                  Map<String, dynamic> data = {
                                    'rating': rating,
                                    'trait_name': traitName[index],
                                    'rated_by':
                                        PreferenceManagerUtils.getLoginId(),
                                  };

                                  FirebaseFirestore.instance
                                      .collection("profile_traits_rating")
                                      .doc(widget.id)
                                      .collection(traitName[index])
                                      .add(data)
                                      .then((value) => showSnackBar(
                                          message: "Rated Successfully"));
                                }
                              },
                            ));
                      },
                      separatorBuilder: (context, index) => Divider(
                            thickness: 1,
                            color: Colors.black12,
                          ),
                      itemCount: traitName.length),
                ),
              )),
            ],
          )),
    );
  }
}
