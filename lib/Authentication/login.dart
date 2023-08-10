import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../Firebase/auth.dart';
import '../Firebase/database.dart';

class Login extends StatefulWidget{
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>{

  final AuthService _auth = AuthService();
  // final Database _firestoreDatabase = Database();

  String email = '';
  String password = '';
  String error = '';
  String resetEmail = '';

  bool passState = true;

  var items = [
    'Male',
    'Female',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            child: const Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        left: 25,
                        top: 150,
                    ),
                    child: Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,

                    ),
                  ),

              ],
            )
          ),
        )
    );
  }
}
