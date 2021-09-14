import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataManagement {
  final CollectionReference profileList =
      FirebaseFirestore.instance.collection('profileinfo');
  String userId = FirebaseAuth.instance.currentUser.uid;

  Future<bool> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> createUserData(String name, String dob) async {
    try {
      return await profileList.doc(userId).set({
        'name': name,
        'dob': dob,
        'uid': userId,
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateUserData(String name, String dob) async {
    try {
      return profileList.doc(userId).update({
        'name': name,
        'dob': dob,
      });
    } catch (e) {
      print(e);
      return null;
    }
  }
}
