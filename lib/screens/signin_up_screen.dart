import 'package:birthday_displayer_app/screens/home_screen.dart';
import 'package:birthday_displayer_app/screens/information_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:birthday_displayer_app/firebase/data_management.dart';
import 'package:birthday_displayer_app/Animation/elasticinoutAnimation.dart';

class SignInUpPage extends StatefulWidget {
  const SignInUpPage({Key key}) : super(key: key);

  @override
  _SignInUpPageState createState() => _SignInUpPageState();
}

class _SignInUpPageState extends State<SignInUpPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 180.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              child: TextFormField(
                controller: _emailController,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    hintText: 'abc@email.com',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    labelText: 'Email',
                    labelStyle:
                        TextStyle(color: Colors.white, letterSpacing: 2.0)),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    hintText: 'Enter Your password',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    labelText: 'Password',
                    labelStyle:
                        TextStyle(color: Colors.white, letterSpacing: 2.0)),
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
                child: Text('Sign Up'),
                onPressed: () async {
                  DataManagement instance = DataManagement();
                  bool navigate = await instance.register(
                      _emailController.text, _passwordController.text);
                  if (navigate) {
                    Navigator.push(
                      context,
                      ElasticInOutAnimation(
                          widgets: InformationScreen(), secs: 1),
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white),
              child: MaterialButton(
                child: Text('Sign In'),
                onPressed: () async {
                  DataManagement instance = DataManagement();
                  bool navigate = await instance.signIn(
                      _emailController.text, _passwordController.text);
                  if (navigate) {
                    Navigator.push(
                      context,
                      ElasticInOutAnimation(widgets: HomeScreen(), secs: 1),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
