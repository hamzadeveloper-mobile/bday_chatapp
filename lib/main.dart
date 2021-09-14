import 'package:birthday_displayer_app/screens/chat_screen.dart';
import 'package:birthday_displayer_app/screens/modification_screen.dart';
import 'package:flutter/material.dart';
import 'screens/signin_up_screen.dart';
import 'screens/information_form_screen.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SignInUpPage(),
        '/info': (context) => InformationScreen(),
        '/modify_screen': (context) => ModificationScreen(),
        '/chat_screen': (context) => ChatScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
