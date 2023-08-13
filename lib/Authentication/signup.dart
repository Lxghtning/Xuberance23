import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:hackathonxcodexuberance/Authentication/login.dart';
import '../Firebase/auth.dart';
import '../Firebase/database.dart';
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
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const SignUp(),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUp> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  bool passState = true;

  final AuthService _auth = AuthService();

  final Database _firestoreDatabase = Database();

  String error = "";
  String email = "";
  String username = "";
  String password = "";
  String mtoken = "";

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
  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }
    else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    }
    else {
      print('User declined or has not accepted permission');
    }
  }
  @override
  Widget build(BuildContext context) {
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
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
                child: Text(
                  "Register all your fun with us!",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.yellow),
                onChanged: (value){
                  setState(() {
                    username = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Username",
                  labelStyle: TextStyle(color: Colors.yellow),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  prefixIcon: Icon(Icons.person_outline, color: Colors.yellow),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.yellow),
                onChanged: (value){
                  bool isValid = EmailValidator.validate(value);
                  if(isValid) {
                    setState(() {
                      error = "";
                      email = value;
                    });
                  }else {
                    setState(() {
                      error = "Invalid Email!";
                    });
                    return;
                  }
                  setState(() {
                    email = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.yellow),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.yellow),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: passState ? true : false,
                style: const TextStyle(color: Colors.yellow),
                onChanged: (value) {
                  if (value.length > 6) {
                    setState(() {
                      error = "";
                      password = value;
                    });
                  }
                  else {
                    setState(() {
                      error = "Password should be of at least 6 characters!";
                    });
                    return;
                  }


                  setState(() {
                    password = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.yellow),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.yellow),
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
              ),
              Text(error, style: const TextStyle(color: Colors.red),),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  bool state = await _firestoreDatabase.checkForUserRegister(email);

                  if (!state) {
                    setState(() {
                      error = "";
                    });

                    User? user = await _auth
                        .registerUserwithEmailAndPassword(
                        email, password);

                    await FirebaseMessaging.instance.getToken().then((token){
                      setState(() {
                        mtoken = token!;
                      });
                    });

                    String? uid = user?.uid;
                    _firestoreDatabase.addUser(
                        username, email, uid, mtoken);

                    print("done");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const Friends()),
                    );
                  } else {
                    setState(() {
                      error = "User already exists! Try Logging In.";
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.yellow, padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Sign Up"),
              ),
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
                      "Already have an account?",
                      style: TextStyle(color: Colors.yellow),
                    ),
                  ),
                  TextButton(
                    child: const Text(
                      "Log In",
                      style: TextStyle(color: Colors.yellow),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const Login()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
  @override
  void dispose() {
    super.dispose();
    _animationController?.dispose();
  }
}
