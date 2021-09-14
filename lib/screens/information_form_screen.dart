import 'package:birthday_displayer_app/firebase/data_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:birthday_displayer_app/Animation/elasticinoutAnimation.dart';
import 'package:birthday_displayer_app/screens/home_screen.dart';

class InformationScreen extends StatefulWidget {
  @override
  _InformationScreenState createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  File _image;
  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _image = File(pickedFile.path);
      });
    }

    Future uploadPic(BuildContext context) async {
      String fileName = basename(FirebaseAuth.instance.currentUser.uid);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference reference = storage.ref().child(fileName);
      UploadTask uploadTask = reference.putFile(_image);
      uploadTask.then((res) => res.ref.getDownloadURL());
    }

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 100.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 75.0,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: SizedBox(
                      width: 180.0,
                      height: 180.0,
                      child: (_image != null)
                          ? Image.file(
                              _image,
                              fit: BoxFit.fill,
                            )
                          : Image.network(
                              "https://simpleicon.com/wp-content/uploads/user1.png",
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.add_a_photo,
                      size: 30.0,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      getImage();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              child: TextFormField(
                controller: _nameController,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    hintText: 'John Snow',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    labelText: 'Enter your name',
                    labelStyle:
                        TextStyle(color: Colors.white, letterSpacing: 2.0)),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              child: TextFormField(
                controller: _dobController,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    hintText: 'dd/mm/yyyy',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    labelText: 'Enter Your Date of Birth',
                    labelStyle:
                        TextStyle(color: Colors.white, letterSpacing: 2.0)),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white),
              child: MaterialButton(
                child: Text('Submit'),
                onPressed: () async {
                  DataManagement instance = DataManagement();
                  await instance.createUserData(
                      _nameController.text, _dobController.text);
                  uploadPic(context);
                  Navigator.pushReplacement(context,
                      ElasticInOutAnimation(widgets: HomeScreen(), secs: 1));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
