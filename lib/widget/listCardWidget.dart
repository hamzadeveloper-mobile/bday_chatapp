import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget buildListCard(
    BuildContext context, DocumentSnapshot document, var currentUid) {
  String chatroomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  String name = (document.data() as dynamic)['name'];

  String uid = (document.data() as dynamic)['uid'];
  return MaterialButton(
    onPressed: () {
      try {
        String cUid = currentUid;
        String roomId = chatroomId(cUid, uid);
        print(roomId);
        Navigator.pushNamed(
          context,
          '/chat_screen',
          arguments: {
            'name': name,
            'uid': uid,
            'roomId': roomId,
          },
        );
      } catch (e) {
        print(e);
      }
    },
    child: TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.bounceInOut,
      duration: Duration(seconds: 4),
      child: Container(
        child: Card(
          color: Colors.deepPurpleAccent[200],
          child: ListTile(
            title: Hero(
              tag: name,
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
            subtitle: Text(
              "DOB: ${(document.data() as dynamic)['dob']}",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0,
                  color: Colors.white70),
            ),
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/birthday-displayer-app.appspot.com/o/${(document.data() as dynamic)['uid']}?alt=media&token=1fe3c109-5c80-4d71-8ae9-019eb402a9ac'),
            ),
          ),
        ),
      ),
      builder: (BuildContext context, double _val, Widget child) {
        return Opacity(
          opacity: _val,
          child: Padding(
            padding: EdgeInsets.only(top: _val * 20),
            child: child,
          ),
        );
      },
    ),
  );
}
