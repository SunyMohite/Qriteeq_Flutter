import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:humanscoring/utils/color_utils.dart';
import '../../utils/const_utils.dart';
import '../../utils/shared_preference_utils.dart';

class DpRating extends StatefulWidget {
  const DpRating({Key? key}) : super(key: key);
  @override
  State<DpRating> createState() => _DpRatingState();
}
var name = [];
var rating = [];
var imagepath= [];
double average=0;
class _DpRatingState extends State<DpRating> {
  @override
  void initState() {

    name=[];
    rating=[];
    imagepath=[];
    average=0;
    _fetchData();

    super.initState();
  }
  Future<void> _fetchData() async {
    final firestore = FirebaseFirestore.instance;
    // Get all the documents under Ratings Collection
    firestore.collection("Users").get().then((querySnapshot) {
      for(int i=0;i<querySnapshot.size;i++)
      {
        firestore.collection("Ratings").
        doc(PreferenceManagerUtils.getLoginId())
            .collection(querySnapshot.docs[i].id)
            .doc("data").get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            name.add(documentSnapshot['name'].toString());
            rating.add(documentSnapshot['rating'].toString());
            average=double.parse(documentSnapshot['rating'].toString())+average;
            imagepath.add(documentSnapshot['imagepath'].toString());
            setState(() {
              name;
              rating;
              average;
            });
          }
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
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10),
                height: 180,
                width: 180,
                decoration: BoxDecoration(color: ColorUtils.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 1, blurRadius:5,
                        color: Colors.black45,
                        offset: Offset(5,5,)
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Center(
                      child: Stack(),
                    ),
                    CircleAvatar(backgroundImage: CachedNetworkImageProvider(
                        PreferenceManagerUtils
                            .getUserAvatar()),
                      radius: 30,),
                    SizedBox(
                      height: 10,
                    ),
                    Text( PreferenceManagerUtils
                        .getAvatarUserFullName(), style: TextStyle(fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),),
                    SizedBox(
                      height: 5,
                    ),
                    Text(PreferenceManagerUtils
                        .getAvatarUserName(), style: TextStyle(fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RatingBar.builder(
                          initialRating: name.length>0? average/name.length : 0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ignoreGestures: true,
                          tapOnlyMode: true,
                          itemSize:20,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ), onRatingUpdate: (double value) { },
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Text(name.length>0? "Rating List": "No Ratings Found",
                style: TextStyle(fontSize:20, fontWeight: FontWeight.w300),),
        Expanded(
          child: Container(
                margin: EdgeInsets.all(20),
                child: SizedBox(
                  height: 380,
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Row(
                            children: [
                              CircleAvatar(backgroundImage: NetworkImage(
                                  imagepath[index]),),
                              SizedBox(width: 10,),
                              Text(name[index], style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w100),)
                            ],),
                          leading: Text("${index + 1}", style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w100),),
                          trailing: Text(rating[index].toString().substring(0,1)+"⭐",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          Divider(thickness: 1, color: Colors.black12,),
                      itemCount:name.length),
                ),
              )
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPressed() {
  }
}