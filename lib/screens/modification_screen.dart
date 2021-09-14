import 'package:birthday_displayer_app/firebase/data_management.dart';
import 'package:flutter/material.dart';

class ModificationScreen extends StatefulWidget {
  const ModificationScreen({Key key}) : super(key: key);

  @override
  _ModificationScreenState createState() => _ModificationScreenState();
}

class _ModificationScreenState extends State<ModificationScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.purple[200]),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    hintText: 'John Snow',
                    labelText: 'Enter your name:',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    )),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                    hintText: 'dd/mm/yyyy',
                    labelText: 'Enter your DOB:',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    )),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white),
              child: MaterialButton(
                child: Text('Update'),
                onPressed: () async {
                  DataManagement instance = DataManagement();
                  instance.updateUserData(
                      _nameController.text, _dobController.text);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
