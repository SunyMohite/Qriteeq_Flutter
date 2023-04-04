import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/const_utils.dart';
import '../../utils/shared_preference_utils.dart';
import 'Logics/functions.dart';
import 'chatpage.dart';
import 'comps/styles.dart';
import 'comps/widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {

    final firestore = FirebaseFirestore.instance;
    Map<String, dynamic> data2 = {
      'message_seen':true
    };
    firestore.collection("MessageNotif").doc(PreferenceManagerUtils.getLoginId()).set(data2);

    super.initState();
  }

  final firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2965FF),
      appBar: AppBar(
        backgroundColor: Color(0xff2965FF),
        title: Text('Qriteeq Chat',style: Styles.h1()),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: Styles.friendsBox(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'Recents',
                            style: Styles.h1().copyWith(color: Color(0xff2965FF)),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 12.0),

                            child: StreamBuilder(
                                stream:
                                firestore.collection('Rooms').snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  List data = !snapshot.hasData ? [] : snapshot.data!.docs.where((element) => element['users'].toString().contains(PreferenceManagerUtils.getLoginId())).toList();
                                  return ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, i) {
                                      List users = data[i]['users'];
                                      logs("Data:"+users.toString());
                                      var friend = users.where((element) => element != PreferenceManagerUtils.getLoginId());
                                      var user = friend.isNotEmpty ? friend.first : users .where((element) => element == PreferenceManagerUtils.getLoginId()).first;
                                      return FutureBuilder(
                                          future: firestore.collection('Users').doc(user).get(),
                                          builder: (context,AsyncSnapshot snap) {
                                            return !snap.hasData? Container(): ChatWidgets.card(
                                              title: snap.data['name'],
                                              subtitle:data[i]['last_message'],
                                              time: DateFormat('hh:mm a').format(data[i]['last_message_time'].toDate()),
                                              imagepath: snap.data['imagepath'],
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return ChatPage(
                                                        id: user,
                                                        name: snap.data['name'],
                                                        imagepath: snap.data['imagepath'],
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                      );
                                    },
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
