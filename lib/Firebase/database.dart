import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Database {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(name, email, gender, uid, token) {
    return _firestore.collection('users')
        .doc(uid).set({
      'name': name,
      'email': email,
      'uid': uid,
      'token': token,
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future checkForUserRegister(String email) async {
    bool returnValue = false;
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['email'] == email) {
          returnValue = true;
        }
      }
    });
    return returnValue;
  }



  Future checkIfUser(String name) async {
    bool returnValue = false;
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['name'] == name) {
          returnValue = true;
        }
      }
    });
    return returnValue;
  }

  Future currentUserName() async {
    String name = '';
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['uid'] == _auth.currentUser?.uid) {
          name = doc['name'];
        }
      }
    });
    return name;
  }

  Future getToken() async {
    String token = '';
    await _firestore.collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['token'] == _auth.currentUser?.uid) {
            token = doc['token'];
        }
      }
    });
    return token;
  }

}