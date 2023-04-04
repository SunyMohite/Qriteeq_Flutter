import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:humanscoring/utils/color_utils.dart';
import 'package:humanscoring/utils/shared_preference_utils.dart';
import 'package:humanscoring/view/chatScreen/comps/styles.dart';

import 'animated-dialog.dart';
class ChatWidgets {
  static Widget card({title, time, subtitle,imagepath, onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Card(
        color: Color(0xfff6f6f6),
        elevation: 0,
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.all(5),
          leading:CircleAvatar(backgroundImage: NetworkImage(
              imagepath),),
          title: Text(title),
          subtitle:subtitle !=null? Text(subtitle,maxLines:2,): null,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(time),
          ),
        ),
      ),
    );
  }

  static Widget circleProfile({onTap,name}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 50,child: Center(child: Text(name,style: TextStyle(height: 1.5,fontSize: 12,color: Colors.white),overflow: TextOverflow.ellipsis,)))
          ],
        ),
      ),
    );
  }

  static Widget messagesCard(bool check, message, time,imagepath) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (check) const Spacer(),
          if (!check)
            CircleAvatar(backgroundImage: NetworkImage(
                imagepath),radius: 10,),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 250),
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(10),
              child: Column(
            children: [
              Text(
                '$message',
                style: TextStyle(color: check ? Colors.white : Colors.black),
              ),
              Text(
                '$time',textAlign: TextAlign.start,
                style: TextStyle(color: check ? Colors.white : Colors.black,fontSize:10),
              ),
            ],
    ),
              decoration: Styles.messagesCardStyle(check),
            ),
          ),
          if (check)
            CircleAvatar(backgroundImage: NetworkImage(
                PreferenceManagerUtils.getUserAvatar(),),radius: 10),
          if (!check) const Spacer(),
        ],
      ),
    );
  }

  static messageField({required onSubmit}) {
    final con = TextEditingController();
    return Container(
      margin: const EdgeInsets.all(5),
      child: TextField(
        controller: con,
        decoration: Styles.messageTextFieldStyle(onSubmit: () {
          onSubmit(con);
        }),
      ),
      decoration: Styles.messageFieldCardStyle(),
    );
  }

  static drawer(context) {
    return Drawer(
      backgroundColor: Colors.indigo.shade400,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20),
          child: Theme(
            data: ThemeData.dark(),
            child: Column(
              children:  [
                const CircleAvatar(
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                  radius: 60,
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.white,
                ),
                 ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: ()async=>await FirebaseAuth.instance.signOut(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static searchBar(bool open, ) {
    return AnimatedDialog(
      height: open ? 800 : 0,
      width: open ? 400 : 0,

    );
  }

  static searchField({Function(String)? onChange}) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextField(
       onChanged: onChange,
        decoration: Styles.searchTextFieldStyle(),
      ),
      decoration: Styles.messageFieldCardStyle(),
    );
  }
}
