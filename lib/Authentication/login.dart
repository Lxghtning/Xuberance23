import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathonxcodexuberance/Authentication/signup.dart';

import '../Firebase/auth.dart';
import '../screens/friends.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  final AuthService _auth = AuthService();

  String email = "";
  String error = "";
  String password = "";
  String resetEmail = "";

  bool passState = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!);
    _animationController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    int hours = DateTime.now().hour;

    String greeting = "Hello!";

    if (hours >= 6 && hours < 12) {
      greeting = "Good Morning!";
    } else if (hours >= 12 && hours < 18) {
      greeting = "Good Afternoon!";
    } else if (hours >= 18 && hours < 24) {
      greeting = "Good Evening!";
    }
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _fadeAnimation!,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
                  child: Text(
                    greeting,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 48),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.yellow),
                  decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.yellow),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.yellow),
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
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: passState? true: false,
                  style: const TextStyle(color: Colors.yellow),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.yellow),
                    border:const  OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const  BorderSide(color: Colors.yellow),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.yellow),
                      suffixIcon: IconButton(
                        color: Colors.yellow,
                        icon: passState ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                        onPressed: (){
                          setState(() {
                            passState = !passState;
                          });
                        },
                      )
                  ),
                  onChanged: (value){
                    setState(() {
                      password = value;
                    });
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.yellow),
                    ),
                    onPressed: () {
                      _showForgotPasswordDialog(context);
                    },
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await _auth
                          .signInUserwithEmailAndPassword(email,
                          password);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const Friends()),
                      );

                    }catch(e){
                      if (e is FirebaseAuthException && e.code == 'user-not-found') {
                        setState(() {
                          error = "User not found! Try registering.";
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.yellow, padding: const EdgeInsets.all(16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text("Log In"),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: (){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const SignUp()),
                        );
                      },
                      child: const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.yellow),
                      ),
                    ),
                    TextButton(
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.yellow),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/signup");

                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    TextEditingController _resetEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Forgot Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter your email to reset password."),
              const SizedBox(height: 16),
              TextField(
                controller: _resetEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: (value){
                  setState(() {
                    resetEmail = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Submit"),
              onPressed: () async{
                await _auth.resetPassword(resetEmail);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController?.dispose();
  }
}
