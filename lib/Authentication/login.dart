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

  String email = '';
  String password = '';
  String error = '';
  String resetEmail = '';

  bool passState = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.only(
                        right: 100,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 100, 50, 0),
                  child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Email",
                        hintText: "Enter your email",
                      ),
                      onChanged: (value){
                        bool isValid = EmailValidator.validate(value);
                        if(isValid) {
                          setState(() {
                            error = "";
                            email = value;
                          });
                        }else{
                          setState(() {
                            error = "Invalid Email!";
                          });
                        }

                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 50, 0),
                  child: TextFormField(
                    obscureText: passState,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      suffixIcon: IconButton(
                        icon: passState ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                        onPressed: (){
                          setState(() {
                            passState = !passState;
                          });
                        },
                      ),
                    ),
                    onChanged: (value){
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                ),
                Text(
                    error,
                    style: const TextStyle(
                      color: Colors.red,
                    )
                ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 50, 0),
                  child: InkWell(
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                  ),
                ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(120, 10, 0, 10),
                        child: InkWell(
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ),
                        ),
                        onTap: () {
                          showDialog(context: context, builder: (BuildContext context){
                            return AlertDialog(
                              title: const Text("Enter your email"),
                              content: TextField(
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                  hintText: "Enter email",
                                ),
                                onChanged: (value){
                                  setState(() {
                                    resetEmail = value;
                                  });
                                },
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                  ),
                                  child: const Text('Send',style:TextStyle(color: Colors.black)),
                                  onPressed: () async{
                                    await _auth.resetPassword(resetEmail);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                  ),
                                  child: const Text('Close', style: TextStyle(
                                    color: Colors.black,
                                  )),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                        },
                    ),
                      ),

                    ],
                  ),

              ],
            )
          ),
        )
    );
  }
}
