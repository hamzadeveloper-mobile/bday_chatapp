import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

final _fireStore = FirebaseFirestore.instance;
final _firebaseAuth = auth.FirebaseAuth.instance;
auth.User loggedInUser;
Map data = {};

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  String messageText;

  @override
  void initState() {
    getCurrentUser();

    super.initState();
  }

  void getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        loggedInUser = user;
        print(loggedInUser.uid);
      } catch (e) {
        print(e);
      }
    }
  }

  void messagesStream() async {
    await for (var snapshot in _fireStore
        .collection('messages')
        .doc(data['uid'])
        .collection(loggedInUser.uid)
        .snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Hero(
          tag: data['name'],
          child: Text(
            data['name'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MessagesStream(),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.purpleAccent, width: 2.0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: messageTextController,
                    onChanged: (value) {
                      messageText = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      hintText: 'Type your message here...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    messageTextController.clear();
                    DocumentReference documentReference = _fireStore
                        .collection('messages')
                        .doc(data['roomId'])
                        .collection('chats')
                        .doc();

                    if (messageText.isNotEmpty) {
                      return _fireStore
                          .runTransaction((transaction) async {
                            DocumentSnapshot snapshot =
                                await transaction.get(documentReference);
                            transaction.set(documentReference, {
                              'message': messageText,
                              'time': FieldValue.serverTimestamp(),
                              'sender': loggedInUser.email,
                            });
                          })
                          .then((value) => print("Print $value"))
                          .catchError((error) => print("Error: $error"));
                    } else {
                      print('Enter Something');
                    }
                  },
                  child: Text('Send',
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('messages')
          .doc(data['roomId'])
          .collection('chats')
          .orderBy("time", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        List<MessageBubble> messageBubbles = [];
        if (!snapshot.hasData) {
          return Center(
            child: Text(''),
          );
        }
        final messages = snapshot.data.docs.reversed;

        for (var message in messages) {
          final messageData = message.data() as dynamic;
          final messageText = messageData['message'];
          final messageSender = messageData['sender'];

          final currentUser = loggedInUser.email;
          if (currentUser == messageSender) {}

          final messageBubble = MessageBubble(
            text: messageText,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.isMe});

  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.purpleAccent : Colors.purple,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
